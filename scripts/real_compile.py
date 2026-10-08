#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
实际编译对比脚本: 用 GA 找到的最优 pass 序列实际编译 C 源码, 输出实际代码体积缩减率.

由 ruyituner.py 在 --input_type c 且 --search_scope project 时作为阶段 3 调用
(序列读前一步 GA 优化写出的 Pass 列表 CSV, 基线复用其 Result.json).

用法:
  python3 scripts/real_compile.py --project_name <项目名> --output_dir <目录> \
      --cache_dir <IR缓存目录> --llvm_tools_path <目录> --opt_level Os --ir_opt_level Oz \
      [--c_std gnu89] [--c_flags '-DHAVE_CONFIG_H'] [--num_workers 16] [--total_stages 3]
"""

import argparse
import csv
import json
import os
import shlex
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

# 保证从任意工作目录运行时都能 import utils
current_file_path = os.path.abspath(__file__)
project_root = os.path.dirname(os.path.dirname(current_file_path))
sys.path.insert(0, os.path.dirname(current_file_path))
sys.path.append(project_root)

from utils.common import find_clang, fix_loop_nesting, get_object_file_text_size


def real_compile_with_seq(src_root, ll_items, obj_dir, clang, llvm_tools_path,
                          seq, ir_opt_level, c_std=None, c_flags=None, num_workers=16):
    """把 GA 找到的最优 pass 序列实际应用到源码编译, 生成 .o 到 obj_dir 下.

    ll_items: [(相对路径, .ll 缓存文件, 源文件), ...]; 前端 IR 直接复用 C→IR
    阶段生成的 .ll, 不再重复运行 clang 前端; 后续管线与评分口径一致:
    opt -S -passes=<序列> -> llc -relocation-model=pic -filetype=obj;
    任一环节失败时回退 clang -<ir_opt_level> -c 直通编译 (ir_opt_level 为
    C→IR 转换的优化等级, 与缓存 IR 的前端等级一致, 而非基线优化等级);
    返回 (总 .text 字节数, 回退直通编译的文件数, 编译失败列表)."""
    bin_dir = llvm_tools_path or ''
    opt_path = os.path.join(bin_dir, 'opt') if bin_dir else 'opt'
    llc_path = os.path.join(bin_dir, 'llc') if bin_dir else 'llc'
    # loop(...) 元素按评分口径嵌套进最近的 function(...) 后才能交给 opt
    seq_fixed = fix_loop_nesting(','.join(seq))
    tmpdir = tempfile.mkdtemp(prefix='ruyituner_realcc_')

    def _work(item):
        rel, ll_path, src = item
        dst = os.path.join(obj_dir, os.path.splitext(rel)[0] + '.o')
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        work = tempfile.mkdtemp(dir=tmpdir)
        try:
            opt_ll = os.path.join(work, 'opt.ll')
            proc = subprocess.run([opt_path, '-S', f'-passes={seq_fixed}',
                                   ll_path, '-o', opt_ll],
                                  capture_output=True, text=True)
            if proc.returncode == 0:
                proc = subprocess.run([llc_path, '-relocation-model=pic',
                                       '-filetype=obj', opt_ll, '-o', dst],
                                      capture_output=True, text=True)
                if proc.returncode == 0:
                    size = get_object_file_text_size(dst, llvm_tools_path)
                    if size is not None:
                        return rel, size, ''
            # 序列管线失败: 回退 clang 直通编译 (用 C→IR 转换的优化等级, 保证构建产物完整)
            fb = [clang, f'-{ir_opt_level}', '-c']
            if c_flags:
                fb += shlex.split(c_flags)
            if c_std is not None:
                fb.append(f'-std={c_std}')
            fb += [src, '-o', dst]
            # 在数据集根目录下执行, 使 c_flags 中的相对路径以数据集根目录为基准解析
            proc = subprocess.run(fb, capture_output=True, text=True, cwd=src_root)
            if proc.returncode != 0:
                lines = [line for line in proc.stderr.splitlines() if line.strip()]
                return rel, None, lines[-1] if lines else f'exit={proc.returncode}'
            size = get_object_file_text_size(dst, llvm_tools_path)
            if size is None:
                return rel, None, 'llvm-size 解析失败'
            return rel, size, '回退直通编译'
        finally:
            shutil.rmtree(work, ignore_errors=True)

    total_text = 0
    fallback = 0
    failures = []
    with ThreadPoolExecutor(max_workers=num_workers) as ex:
        for rel, size, note in ex.map(_work, ll_items):
            if size is None:
                failures.append(f'{rel}: {note}')
            else:
                total_text += size
                if note:
                    fallback += 1
    shutil.rmtree(tmpdir, ignore_errors=True)
    return total_text, fallback, failures


def main():
    parser = argparse.ArgumentParser(
        description='实际编译对比: 用 GA 找到的最优 pass 序列实际编译源码, 输出实际代码体积缩减率')
    parser.add_argument('--project_name', type=str, required=True,
                        help='项目名 (用于 PassList/Result 文件与 .o 输出目录命名)')
    parser.add_argument('--output_dir', type=str, required=True,
                        help='输出目录 (含前一步写出的 PassList 与 Result 文件)')
    parser.add_argument('--cache_dir', type=str, required=True,
                        help='C→IR 阶段的 IR 缓存目录 (含 baseline_manifest.json)')
    parser.add_argument('--llvm_tools_path', type=str, required=True,
                        help='LLVM 工具链路径')
    parser.add_argument('--opt_level', type=str, default='Oz',
                        help='基线编译的优化等级 (仅用于输出标签, 说明基线来源), 默认 Oz')
    parser.add_argument('--ir_opt_level', type=str, default='Oz',
                        help='序列编译失败时直通编译回退用的优化等级 (与 C→IR 转换一致), 默认 Oz')
    parser.add_argument('--c_std', type=str, default=None,
                        help='传给 clang 的 C 语言标准, 如 gnu89 (可选)')
    parser.add_argument('--c_flags', type=str, default=None,
                        help='传给 clang 的额外编译参数, 如 -DHAVE_CONFIG_H (可选)')
    parser.add_argument('--num_workers', type=int, default=16,
                        help='并行工作线程数, 默认 16')
    parser.add_argument('--total_stages', type=int, default=3,
                        help='阶段总数 (用于打印阶段标题), 默认 3')
    # --c_flags 的值常以 - 开头, 解析前把 "--c_flags <值>" 合并为 "--c_flags=<值>"
    argv = list(sys.argv[1:])
    merged_argv = []
    i = 0
    while i < len(argv):
        if argv[i] == '--c_flags' and i + 1 < len(argv) \
                and argv[i + 1].startswith('-') and argv[i + 1] != '-':
            merged_argv.append(f'--c_flags={argv[i + 1]}')
            i += 2
        else:
            merged_argv.append(argv[i])
            i += 1
    args = parser.parse_args(merged_argv)

    project = args.project_name
    csv_path = os.path.join(args.output_dir, f'Step2_{project}_PassList.csv')
    json_path = os.path.join(args.output_dir, f'Step2_{project}_Result.json')
    if not os.path.isfile(csv_path):
        print(f'[ruyituner] 未找到 {csv_path}, 跳过实际编译对比.')
        return
    with open(csv_path, encoding='utf-8') as fh:
        seq = [row[0].strip() for row in csv.reader(fh)
               if row and row[0].strip() and row[0].strip() != 'pass']
    if not seq:
        print('[ruyituner] Pass 列表为空, 跳过实际编译对比.')
        return
    baseline = None
    if os.path.isfile(json_path):
        with open(json_path, encoding='utf-8') as fh:
            baseline = json.load(fh).get('total_baseline')
    if baseline is None:
        print('[ruyituner] 未找到前一步的基线结果, 跳过实际编译对比.')
        return
    manifest_path = os.path.join(args.cache_dir, 'baseline_manifest.json')
    try:
        with open(manifest_path, encoding='utf-8') as fh:
            manifest = json.load(fh)
        src_root = manifest.get('src_root')
        files_map = manifest.get('files') or {}
    except (OSError, ValueError):
        print('[ruyituner] 无法读取基线清单, 跳过实际编译对比.')
        return
    if src_root is None:
        print('[ruyituner] 基线清单缺少 src_root, 跳过实际编译对比.')
        return
    # 前端 IR 复用 C→IR 阶段生成的 .ll, 不再重复运行 clang 前端
    ll_items = []
    for rel, src in files_map.items():
        ll_path = os.path.join(args.cache_dir, rel)
        if os.path.isfile(ll_path):
            ll_items.append((rel, ll_path, src))
    if not ll_items:
        print('[ruyituner] 缓存目录中没有可用的 .ll 文件, 跳过实际编译对比.')
        return
    clang = find_clang(args.llvm_tools_path)
    if clang is None:
        print('[ruyituner] 未找到 clang, 跳过实际编译对比.')
        return
    obj_dir = os.path.join(args.output_dir, project)
    print('=' * 60)
    print(f'[ruyituner] 阶段 3/{args.total_stages}: 实际编译对比 (项目: {project}, 序列 {len(seq)} 个 pass)')
    print(f'[ruyituner] .o 输出目录: {obj_dir}')
    print('=' * 60)
    total_text, fallback, failures = real_compile_with_seq(
        src_root, ll_items, obj_dir, clang, args.llvm_tools_path, seq,
        args.ir_opt_level, args.c_std, args.c_flags, args.num_workers)
    print(f'[ruyituner] clang -{args.opt_level} 基线大小 (来自前一步 GA 输出): {int(baseline)}')
    print(f'[ruyituner] 按优化序列实际编译后总大小: {total_text}')
    rate = (baseline - total_text) / baseline if baseline else 0.0
    print(f'[ruyituner] 实际代码体积缩减率: {rate * 100:.2f}%')
    if fallback:
        print(f'[ruyituner] {fallback} 个文件序列编译失败, 回退直通编译.')
    if failures:
        print('[ruyituner] 编译失败的文件 (最多显示20个):')
        for msg in failures[:20]:
            print(f'  - {msg}')
        if len(failures) > 20:
            print(f'  ... 其余 {len(failures) - 20} 个省略')


if __name__ == '__main__':
    main()
