#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ruyituner: 一键完成训练(train.py)与优化(run.py), 以及 C 输入项目模式下的实际编译对比.

默认流程:
  1. 训练:  运行 scripts/train.py, 输出 Step1_FindSynerPairs.csv 与 Step2_EnumeratedPairs.csv;
  2. 优化:  用训练得到的协同 pass 对运行 scripts/run.py 进行 GA 优化;
  3. 实际编译对比 (仅 --input_type c 且 --search_scope project): 用 GA 找到的最优
     序列 (output/Step3_<项目名>_PassList.csv) 实际编译源码, .o 输出到
     output/<项目名>/, 基线复用优化阶段写出的 Step3_<项目名>_Result.json,
     最终输出实际代码体积缩减率 (与 ruyi-cc.sh 的编译管线一致).

用法示例:
  # 完整流程 (训练 + 优化)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin

  # 仅训练 (不优化)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin --only_train

  # 仅优化 (需要已有 Step2_EnumeratedPairs.csv)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin --only_run \
      --paircsv output/Step2_EnumeratedPairs.csv

  # 输入 C 源码数据集 (.c 或预处理后的 .i, 先用clang以--opt-level优化等级(默认Oz)生成.ll到缓存目录, 流程结束自动清理)
  python3 ruyituner.py --dataset datasets/c_files --input_type c --llvm_tools_path ../llvm_dir/build/bin

  # --input_type c 搭配 --count_mode obj-size 时, 评分基线直接用 clang -O<level> -c
  # 编译源码统计 .o 大小 (真实编译口径), 不再经过 C→IR→opt 中间过程

  # 预处理后的 C 源码 (.i) 数据集, 如 CSiBE 的 lwip-0.5.3.preproc (旧式代码需 --c_std gnu89)
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc --input_type c \
      --llvm_tools_path ../llvm_dir/build/bin --c_std gnu89

  # 旧式 C 代码 (K&R/C89, 如 CSiBE 的 compiler 基准) 需通过 --c_std 指定 C 标准, 否则隐式函数声明报错
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler --input_type c \
      --llvm_tools_path ../llvm_dir/build/bin --c_std gnu89

  # 依赖自定义编译宏的项目 (如 flex 需 -DHAVE_CONFIG_H) 可通过 --c_flags 追加 clang 参数
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31 --input_type c \
      --llvm_tools_path ../llvm_dir/build/bin --c_std gnu89 --c_flags '-DHAVE_CONFIG_H'
"""

import argparse
import csv
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
TRAIN_SCRIPT = os.path.join(PROJECT_ROOT, 'scripts', 'train.py')
RUN_SCRIPT = os.path.join(PROJECT_ROOT, 'scripts', 'run.py')
DEFAULT_OUTPUT_DIR = os.path.join(PROJECT_ROOT, 'output')

# scripts/ 目录加入模块搜索路径, 复用评分口径的公共函数 (fix_loop_nesting 等)
sys.path.insert(0, os.path.join(PROJECT_ROOT, 'scripts'))
from utils.common import fix_loop_nesting, get_object_file_text_size  # type: ignore  # 依赖上面的 sys.path 运行时解析


def build_train_cmd(args, dataset):
    """根据命令行参数构造 train.py 的命令."""
    cmd = [sys.executable, TRAIN_SCRIPT,
           '--dataset', dataset,
           '--llvm_tools_path', args.llvm_tools_path,
           '--num_workers', str(args.num_workers),
           '--count_mode', args.count_mode]
    if args.output_dir is not None:
        cmd += ['--output_dir', args.output_dir]
    if args.passfile is not None:
        cmd += ['--passfile', args.passfile]
    if args.passlist_output is not None:
        cmd += ['--passlist_output', args.passlist_output]
    if args.no_parse_check:
        cmd += ['--no_parse_check']
    if args.keep_instrumentation:
        cmd += ['--keep_instrumentation']
    if args.extra_exclude is not None:
        cmd += ['--extra_exclude', args.extra_exclude]
    return cmd


def find_clang(llvm_tools_path):
    """查找clang: 优先使用 --llvm_tools_path 下的clang, 否则回退到系统PATH."""
    if llvm_tools_path:
        cand = os.path.join(llvm_tools_path, 'clang')
        if os.path.isfile(cand) and os.access(cand, os.X_OK):
            return cand
    return shutil.which('clang')


def compile_c_dataset_to_ir(src_root, cache_dir, clang, num_workers, c_std=None, c_flags=None, manifest_path=None, opt_level='Oz'):
    """用clang把src_root下所有.c/.i文件编译为.ll并放入cache_dir(保持相对目录结构).

    .c 为 C 源码; .i 为预处理后的 C 源码 (cc -E 输出), clang 直接按预处理输入编译;
    同名 .c 与 .i 并存时优先 .c;
    被其他源文件 #include 的 .i 片段 (如 jikespg 的 lpgact.i) 不单独编译, 跳过并提示;
    编译在数据集根目录 (src_root) 下执行, c_flags 中的相对路径 (如 -Iinclude)
    以数据集根目录为基准解析;
    opt_level 为 IR 生成时的优化等级 (默认 Oz, 与 --opt-level 一致), 以
    clang -<opt_level> -S -emit-llvm 编译; 仅 -O0 附加 -Xclang -disable-O0-optnone;
    c_std 非 None 时以 -std=<c_std> 传给 clang (如 gnu89, 用于旧式 C 代码);
    c_flags 非 None 时按空白拆分后原样传给 clang (如 -DHAVE_CONFIG_H);
    manifest_path 非 None 时把 .ll 相对路径 -> 原始源文件 的映射连同 src_root/
    c_std/c_flags 写入该 JSON 文件, 供优化阶段用 clang 直接编译源码统计基线;
    编译失败的源文件告警跳过; 返回 (成功数, 失败数).
    """
    src_root = os.path.abspath(src_root)
    if not os.path.isdir(src_root):
        print(f'[ruyituner] 数据集目录不存在: {src_root}')
        return 0, 0
    src_files = []
    claimed = set()
    num_c = 0
    num_i = 0
    for ext in ('.c', '.i'):
        for root, _dirs, files in os.walk(src_root):
            for name in sorted(files):
                if not name.endswith(ext):
                    continue
                src = os.path.join(root, name)
                stem = os.path.splitext(os.path.relpath(src, src_root))[0]
                if stem in claimed:
                    continue
                claimed.add(stem)
                src_files.append(src)
                if ext == '.c':
                    num_c += 1
                else:
                    num_i += 1
    if not src_files:
        print(f'[ruyituner] {src_root} 下未找到任何 .c 或 .i 文件.')
        return 0, 0

    parts = []
    if num_c:
        parts.append(f'{num_c} 个 .c')
    if num_i:
        parts.append(f'{num_i} 个 .i')
    print(f"[ruyituner] 找到 {' 与 '.join(parts)} 文件, 并行生成 IR ...")

    # 部分 .i 文件并非可独立编译的预处理源码, 而是被其他源文件 #include 的
    # 代码片段 (如 jikespg 的 lpgact.i 被 lpgparse.c 包含, 片段引用的全局变量
    # 定义在包含方); 单独编译必然失败且无必要, 找出这类片段并跳过
    include_re = re.compile(r'^\s*#\s*include\s*[<"]([^>"]+)[>"]')
    if num_i:
        i_names = {os.path.basename(s) for s in src_files if s.endswith('.i')}
        i_frag = {}
        scan_done = False
        for root, _dirs, files in os.walk(src_root):
            if scan_done:
                break
            for name in files:
                if scan_done:
                    break
                if not name.endswith(('.c', '.h', '.i')):
                    continue
                path = os.path.join(root, name)
                try:
                    with open(path, 'r', errors='ignore') as fh:
                        for line in fh:
                            m = include_re.match(line)
                            if m:
                                base = os.path.basename(m.group(1))
                                if base in i_names and base not in i_frag:
                                    i_frag[base] = path
                                    if len(i_frag) == len(i_names):
                                        scan_done = True
                                        break
                except OSError:
                    pass
        if i_frag:
            frag_set = set(i_frag)
            print(f'[ruyituner] 跳过 {len(i_frag)} 个被其他文件 #include 的 .i 代码片段, 不单独编译:')
            for s in [s for s in src_files if os.path.basename(s) in frag_set]:
                inc_by = os.path.relpath(i_frag[os.path.basename(s)], src_root)
                print(f'  - {os.path.relpath(s, src_root)} (被 {inc_by} #include)')
            src_files = [s for s in src_files if os.path.basename(s) not in frag_set]

    def _work(src):
        rel = os.path.relpath(src, src_root)
        dst = os.path.join(cache_dir, os.path.splitext(rel)[0] + '.ll')
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        cmd = [clang, f'-{opt_level}', '-S', '-emit-llvm']
        # 仅 -O0 需要附加 -disable-O0-optnone, 其余优化等级前端不会产生 optnone 属性
        if opt_level == 'O0':
            cmd += ['-Xclang', '-disable-O0-optnone']
        if c_flags:
            cmd += shlex.split(c_flags)
        if c_std is not None:
            cmd.append(f'-std={c_std}')
        cmd += [src, '-o', dst]
        # 在数据集根目录下执行, 使 c_flags 中的相对路径 (如 -Iinclude) 以数据集根目录为基准解析
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=src_root)
        if proc.returncode != 0:
            lines = [line for line in proc.stderr.splitlines() if line.strip()]
            reason = lines[-1] if lines else f'exit={proc.returncode}'
            return False, f'{rel}: {reason}'
        return True, None

    ok = 0
    failures = []
    with ThreadPoolExecutor(max_workers=num_workers) as ex:
        for success, reason in ex.map(_work, src_files):
            if success:
                ok += 1
            else:
                failures.append(reason)

    print(f'[ruyituner] C→IR 编译完成: 成功 {ok} 个, 失败 {len(failures)} 个.')
    if failures:
        print('[ruyituner] 编译失败的文件 (最多显示20个):')
        for msg in failures[:20]:
            print(f'  - {msg}')
        if len(failures) > 20:
            print(f'  ... 其余 {len(failures) - 20} 个省略')

    # 基线清单: 优化阶段据此用 clang -O<level> -c 直接编译源文件统计基线,
    # 跳过 "C→IR→opt" 的中间过程, 更贴近真实编译; 只收录实际生成出 .ll 的
    # 源文件, 编译失败(无 .ll)的源文件优化阶段本来也不会处理
    if manifest_path is not None:
        files_map = {}
        for src in src_files:
            rel = os.path.relpath(src, src_root)
            ir_rel = os.path.splitext(rel)[0] + '.ll'
            if os.path.isfile(os.path.join(cache_dir, ir_rel)):
                files_map[ir_rel] = os.path.abspath(src)
        manifest = {
            'src_root': src_root,
            'c_std': c_std,
            'c_flags': c_flags,
            'files': files_map,
        }
        with open(manifest_path, 'w', encoding='utf-8') as fh:
            json.dump(manifest, fh, ensure_ascii=False, indent=2)
    return ok, len(failures)


def real_compile_with_seq(src_root, ll_items, obj_dir, clang, llvm_tools_path,
                          seq, opt_level, c_std=None, c_flags=None, num_workers=16):
    """把 GA 找到的最优 pass 序列实际应用到源码编译, 生成 .o 到 obj_dir 下.

    ll_items: [(相对路径, .ll 缓存文件, 源文件), ...]; 前端 IR 直接复用 C→IR
    阶段生成的 .ll, 不再重复运行 clang 前端; 后续管线与评分口径一致:
    opt -S -passes=<序列> -> llc -relocation-model=pic -filetype=obj;
    任一环节失败时回退 clang -<level> -c 直通编译 (与 ruyi-cc.sh 的回退行为
    一致); 返回 (总 .text 字节数, 回退直通编译的文件数, 编译失败列表)."""
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
            # 序列管线失败: 回退 clang 直通编译, 保证构建产物完整
            fb = [clang, f'-{opt_level}', '-c']
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


def run_real_compile_stage(args, out_dir, cache_dir):
    """实际编译对比: 序列读 Step3 Pass 列表 CSV, 基线复用前一步的 Result.json.

    序列与基线均来自前一步 GA 优化 (ruyituner.py 已计算), 不重新计算;
    前端 IR 复用 C→IR 阶段生成的 .ll (不重复运行 clang 前端), 源文件与编译
    参数取 C→IR 阶段的基线清单; .o 输出到 output/<项目名>/ 目录; 最后输出
    实际编译后的代码体积缩减率."""
    project = os.path.basename(os.path.normpath(args.dataset)) or 'dataset'
    csv_path = os.path.join(out_dir, f'Step3_{project}_PassList.csv')
    json_path = os.path.join(out_dir, f'Step3_{project}_Result.json')
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
    manifest_path = os.path.join(cache_dir, 'baseline_manifest.json')
    try:
        with open(manifest_path, encoding='utf-8') as fh:
            manifest = json.load(fh)
        src_root = manifest.get('src_root') or args.dataset
        files_map = manifest.get('files') or {}
    except (OSError, ValueError):
        print('[ruyituner] 无法读取基线清单, 跳过实际编译对比.')
        return
    # 前端 IR 复用 C→IR 阶段生成的 .ll, 不再重复运行 clang 前端
    ll_items = []
    for rel, src in files_map.items():
        ll_path = os.path.join(cache_dir, rel)
        if os.path.isfile(ll_path):
            ll_items.append((rel, ll_path, src))
    if not ll_items:
        print('[ruyituner] 缓存目录中没有可用的 .ll 文件, 跳过实际编译对比.')
        return
    clang = find_clang(args.llvm_tools_path)
    if clang is None:
        print('[ruyituner] 未找到 clang, 跳过实际编译对比.')
        return
    obj_dir = os.path.join(out_dir, project)
    print('=' * 60)
    print(f'[ruyituner] 实际编译对比 (项目: {project}, 序列 {len(seq)} 个 pass)')
    print(f'[ruyituner] .o 输出目录: {obj_dir}')
    print('=' * 60)
    total_text, fallback, failures = real_compile_with_seq(
        src_root, ll_items, obj_dir, clang, args.llvm_tools_path, seq,
        args.opt_level, args.c_std, args.c_flags, args.num_workers)
    print(f'[ruyituner] 基线大小 (来自前一步 GA 输出): {int(baseline)}')
    print(f'[ruyituner] 实际编译后总大小: {total_text}')
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


def main():
    parser = argparse.ArgumentParser(
        description='ruyituner: 一键完成训练(train.py)与优化(run.py)',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--dataset', type=str, required=True,
                        help='数据集目录 (训练与优化共用)')
    parser.add_argument('--input_type', type=str, required=True,
                        choices=['ll', 'c'],
                        help='输入文件类型 (必选): ll=LLVM IR (原处理路径), c=C 源码 (.c 或预处理后的 .i, 先用clang以--opt-level优化等级生成.ll再走原路径)')
    parser.add_argument('--c_std', type=str, default=None,
                        help='传给 clang 的 C 语言标准, 如 gnu89 (可选, 仅 --input_type c 生效; 不提供时不传 -std)')
    parser.add_argument('--c_flags', type=str, default=None,
                        help='传给 clang 的额外编译参数, 如 -DHAVE_CONFIG_H (可选, 仅 --input_type c 生效; 支持空格分隔多个)')
    parser.add_argument('--llvm_tools_path', type=str, required=True,
                        help='LLVM工具链路径，包含opt')
    parser.add_argument('--output_dir', type=str, default=None,
                        help='训练输出目录, 默认 <项目根目录>/output')
    parser.add_argument('--passfile', type=str, default=None,
                        help='训练用的 pass 列表文件; 不提供时 train.py 自动生成')
    parser.add_argument('--num_workers', type=int, default=16,
                        help='训练并行工作线程数, 默认16')
    parser.add_argument('--opt-level', type=str, default='Oz',
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='GA 基线评分的优化等级, 默认 Oz (传给 run.py)')
    parser.add_argument('--count_mode', type=str, default='auto',
                        choices=['auto', 'opt-stats', 'text', 'obj-size'],
                        help='指令计数方式开关 (传给 train.py 与 run.py): auto(默认) | opt-stats | text | obj-size')
    parser.add_argument('--search_scope', type=str, default='file',
                        choices=['file', 'project'],
                        help='最优 pass 序列的搜索范围: file=为每个文件各找一个 (默认), project=为整个项目找一条公共序列 (聚合适应度 GA)')
    parser.add_argument('--max-path-length', type=int, default=2,
                        help='GA 初始种群中 pass 序列的最大长度, 默认 2 (传给 run.py)')
    parser.add_argument('--passlist_output', type=str, default=None,
                        help='把自动生成的 pass 列表写入该文件 (传给 train.py)')
    parser.add_argument('--no_parse_check', action='store_true',
                        help='跳过输出 IR 的 opt 解析检查 (传给 train.py)')
    parser.add_argument('--keep_instrumentation', action='store_true',
                        help='保留插桩类 pass (传给 train.py)')
    parser.add_argument('--extra_exclude', type=str, default=None,
                        help='额外的 pass 排除规则, 正则表达式 (传给 train.py)')
    parser.add_argument('--only_train', action='store_true',
                        help='仅执行训练阶段, 不进行优化')
    parser.add_argument('--only_run', action='store_true',
                        help='仅执行优化阶段, 不进行训练 (需要已有协同对 CSV)')
    parser.add_argument('--paircsv', type=str, default=None,
                        help='优化阶段使用的协同对 CSV, 默认 <output_dir>/Step2_EnumeratedPairs.csv')
    # --c_flags 的值常以 - 开头 (如 -DHAVE_CONFIG_H), argparse 会误当成选项报
    # "expected one argument"; 解析前把 "--c_flags <值>" 合并为 "--c_flags=<值>"
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

    if args.only_train and args.only_run:
        parser.error('--only_train 与 --only_run 不能同时使用')

    print('=' * 60)
    print(f'[ruyituner] 输入文件类型: {args.input_type}')
    print(f'[ruyituner] 计数方式: {args.count_mode}')
    print(f'[ruyituner] 寻找优化序列的范围: {args.search_scope}')
    print('=' * 60)

    # C 输入 + 项目模式时, GA 优化之后还有实际编译对比阶段
    do_real_compile = (args.input_type == 'c' and args.search_scope == 'project'
                       and not args.only_train)
    total_stages = 3 if do_real_compile else 2

    cache_dir = None
    if args.input_type == 'c':
        clang = find_clang(args.llvm_tools_path)
        if clang is None:
            print('[ruyituner] 未找到 clang: --llvm_tools_path 与系统 PATH 中均无可用 clang, 终止.')
            sys.exit(1)
        std_info = f', C 标准: {args.c_std}' if args.c_std else ''
        flags_info = f', 额外参数: {args.c_flags}' if args.c_flags else ''
        print(f'[ruyituner] 输入为 c: 使用 clang 以 -{args.opt_level} 把 .c/.i 编译为 .ll ({clang}{std_info}{flags_info})')
        cache_dir = tempfile.mkdtemp(prefix='ruyituner_ir_')
        print(f'[ruyituner] IR 缓存目录: {cache_dir}')
        manifest_path = os.path.join(cache_dir, 'baseline_manifest.json')
        ok, _failed = compile_c_dataset_to_ir(args.dataset, cache_dir, clang, args.num_workers, args.c_std, args.c_flags, manifest_path=manifest_path, opt_level=args.opt_level)
        if ok == 0:
            print('[ruyituner] 未能从任何 .c/.i 文件生成 .ll, 终止.')
            shutil.rmtree(cache_dir, ignore_errors=True)
            sys.exit(1)
        dataset = cache_dir
    else:
        dataset = args.dataset

    try:
        out_dir = args.output_dir or DEFAULT_OUTPUT_DIR

        if not args.only_run:
            os.makedirs(out_dir, exist_ok=True)
            print('=' * 60)
            print(f'[ruyituner] 阶段 1/{total_stages}: 训练 (数据集: {dataset}, 输出目录: {out_dir})')
            print('=' * 60)
            rc = subprocess.run(build_train_cmd(args, dataset)).returncode
            if rc != 0:
                print(f'[ruyituner] 训练失败 (exit={rc}), 终止.')
                sys.exit(rc)

        if not args.only_train:
            paircsv = args.paircsv or os.path.join(out_dir, 'Step2_EnumeratedPairs.csv')
            if not os.path.isfile(paircsv):
                print(f'[ruyituner] 找不到协同对文件: {paircsv}, 请先完成训练.')
                sys.exit(1)
            run_cmd = [sys.executable, RUN_SCRIPT,
                       '--dataset', dataset,
                       '--llvm_tools_path', args.llvm_tools_path,
                       '--paircsv', paircsv,
                       '--opt-level', args.opt_level,
                       '--count_mode', args.count_mode,
                       '--search_scope', args.search_scope,
                       '--max-path-length', str(args.max_path_length),
                       '--output_dir', out_dir,
                       '--project_name', os.path.basename(os.path.normpath(args.dataset)) or 'dataset']
            if args.input_type == 'c':
                # C 输入: 把基线清单传给 run.py, obj-size 计数方式下基线改用
                # clang -O<level> -c 直接编译源码生成 .o 统计
                run_cmd += ['--baseline_manifest', manifest_path]
            print('=' * 60)
            print(f'[ruyituner] 阶段 2/{total_stages}: GA 优化 (数据集: {dataset}, 协同对: {paircsv})')
            print('=' * 60)
            rc = subprocess.run(run_cmd).returncode
            if rc != 0:
                print(f'[ruyituner] 优化失败 (exit={rc}).')
                sys.exit(rc)
            if do_real_compile:
                run_real_compile_stage(args, out_dir, cache_dir)

        print('[ruyituner] 全部完成.')
    finally:
        if cache_dir is not None:
            shutil.rmtree(cache_dir, ignore_errors=True)
            print(f'[ruyituner] 已清理 IR 缓存目录: {cache_dir}')


if __name__ == '__main__':
    main()
