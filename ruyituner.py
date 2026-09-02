#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ruyituner: 一键完成训练(train.py)与优化(run.py)两个阶段.

默认流程:
  1. 训练:  运行 scripts/train.py, 输出 Step1_FindSynerPairs.csv 与 Step2_EnumeratedPairs.csv;
  2. 优化:  用训练得到的协同 pass 对运行 scripts/run.py 进行 GA 优化.

用法示例:
  # 完整流程 (训练 + 优化)
  python3 ruyituner.py --dataset datasets/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin

  # 仅训练 (不优化)
  python3 ruyituner.py --dataset datasets/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin --only_train

  # 仅优化 (需要已有 Step2_EnumeratedPairs.csv)
  python3 ruyituner.py --dataset datasets/x86 --input_type ll --llvm_tools_path ../llvm_dir/build/bin --only_run \
      --paircsv output/Step2_EnumeratedPairs.csv

  # 输入 C 源码数据集 (先用clang生成.ll到缓存目录, 流程结束自动清理)
  python3 ruyituner.py --dataset datasets/x86/c_files --input_type c --llvm_tools_path ../llvm_dir/build/bin

  # 旧式 C 代码 (K&R/C89, 如 CSiBE 的 compiler 基准) 需通过 --c_std 指定 C 标准, 否则隐式函数声明报错
  python3 ruyituner.py --dataset datasets/x86/c_files/csibe-v2.1.1/compiler --input_type c \
      --llvm_tools_path ../llvm_dir/build/bin --c_std gnu89

  # 依赖自定义编译宏的项目 (如 flex 需 -DHAVE_CONFIG_H) 可通过 --c_flags 追加 clang 参数
  python3 ruyituner.py --dataset datasets/x86/c_files/csibe-v2.1.1/flex-2.5.31 --input_type c \
      --llvm_tools_path ../llvm_dir/build/bin --c_std gnu89 --c_flags '-DHAVE_CONFIG_H'
"""

import argparse
import os
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


def compile_c_dataset_to_ir(src_root, cache_dir, clang, num_workers, c_std=None, c_flags=None):
    """用clang把src_root下所有.c文件编译为.ll并放入cache_dir(保持相对目录结构).

    c_std 非 None 时以 -std=<c_std> 传给 clang (如 gnu89, 用于旧式 C 代码);
    c_flags 非 None 时按空白拆分后原样传给 clang (如 -DHAVE_CONFIG_H);
    编译失败的.c文件告警跳过; 返回 (成功数, 失败数).
    """
    c_files = []
    for root, _dirs, files in os.walk(src_root):
        for name in files:
            if name.endswith('.c'):
                c_files.append(os.path.join(root, name))
    if not c_files:
        print(f'[ruyituner] {src_root} 下未找到任何 .c 文件.')
        return 0, 0

    print(f'[ruyituner] 找到 {len(c_files)} 个 .c 文件, 并行生成 IR ...')

    def _work(src):
        rel = os.path.relpath(src, src_root)
        dst = os.path.join(cache_dir, os.path.splitext(rel)[0] + '.ll')
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        cmd = [clang, '-O0', '-S', '-emit-llvm',
               '-Xclang', '-disable-O0-optnone']
        if c_flags:
            cmd += shlex.split(c_flags)
        if c_std is not None:
            cmd.append(f'-std={c_std}')
        cmd += [src, '-o', dst]
        proc = subprocess.run(cmd, capture_output=True, text=True)
        if proc.returncode != 0:
            lines = [line for line in proc.stderr.splitlines() if line.strip()]
            reason = lines[-1] if lines else f'exit={proc.returncode}'
            return False, f'{rel}: {reason}'
        return True, None

    ok = 0
    failures = []
    with ThreadPoolExecutor(max_workers=num_workers) as ex:
        for success, reason in ex.map(_work, c_files):
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
    return ok, len(failures)


def main():
    parser = argparse.ArgumentParser(
        description='ruyituner: 一键完成训练(train.py)与优化(run.py)',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--dataset', type=str, required=True,
                        help='数据集目录 (训练与优化共用)')
    parser.add_argument('--input_type', type=str, required=True,
                        choices=['ll', 'c'],
                        help='输入文件类型 (必选): ll=LLVM IR (原处理路径), c=C 源码 (先用clang生成.ll再走原路径)')
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
    print('=' * 60)

    cache_dir = None
    if args.input_type == 'c':
        clang = find_clang(args.llvm_tools_path)
        if clang is None:
            print('[ruyituner] 未找到 clang: --llvm_tools_path 与系统 PATH 中均无可用 clang, 终止.')
            sys.exit(1)
        std_info = f', C 标准: {args.c_std}' if args.c_std else ''
        flags_info = f', 额外参数: {args.c_flags}' if args.c_flags else ''
        print(f'[ruyituner] 输入为 c: 使用 clang 生成 .ll ({clang}{std_info}{flags_info})')
        cache_dir = tempfile.mkdtemp(prefix='ruyituner_ir_')
        print(f'[ruyituner] IR 缓存目录: {cache_dir}')
        ok, _failed = compile_c_dataset_to_ir(args.dataset, cache_dir, clang, args.num_workers, args.c_std, args.c_flags)
        if ok == 0:
            print('[ruyituner] 未能从任何 .c 文件生成 .ll, 终止.')
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
            print(f'[ruyituner] 阶段 1/2: 训练 (数据集: {dataset}, 输出目录: {out_dir})')
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
                       '--count_mode', args.count_mode]
            print('=' * 60)
            print(f'[ruyituner] 阶段 2/2: GA 优化 (数据集: {dataset}, 协同对: {paircsv})')
            print('=' * 60)
            rc = subprocess.run(run_cmd).returncode
            if rc != 0:
                print(f'[ruyituner] 优化失败 (exit={rc}).')
                sys.exit(rc)

        print('[ruyituner] 全部完成.')
    finally:
        if cache_dir is not None:
            shutil.rmtree(cache_dir, ignore_errors=True)
            print(f'[ruyituner] 已清理 IR 缓存目录: {cache_dir}')


if __name__ == '__main__':
    main()
