#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ruyituner: 一键完成训练(train.py)与优化(run.py)两个阶段.

默认流程:
  1. 训练:  运行 scripts/train.py, 输出 Step1_FindSynerPairs.csv 与 Step2_EnumeratedPairs.csv;
  2. 优化:  用训练得到的协同 pass 对运行 scripts/run.py 进行 GA 优化.

用法示例:
  # 完整流程 (训练 + 优化)
  python3 ruyituner.py --dataset datasets/x86 --llvm_tools_path ../llvm_dir/build/bin

  # 仅训练 (不优化)
  python3 ruyituner.py --dataset datasets/x86 --llvm_tools_path ../llvm_dir/build/bin --only_train

  # 仅优化 (需要已有 Step2_EnumeratedPairs.csv)
  python3 ruyituner.py --dataset datasets/x86 --llvm_tools_path ../llvm_dir/build/bin --only_run \
      --paircsv output/Step2_EnumeratedPairs.csv
"""

import argparse
import os
import subprocess
import sys

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
TRAIN_SCRIPT = os.path.join(PROJECT_ROOT, 'scripts', 'train.py')
RUN_SCRIPT = os.path.join(PROJECT_ROOT, 'scripts', 'run.py')
DEFAULT_OUTPUT_DIR = os.path.join(PROJECT_ROOT, 'output')


def build_train_cmd(args):
    """根据命令行参数构造 train.py 的命令."""
    cmd = [sys.executable, TRAIN_SCRIPT,
           '--dataset', args.dataset,
           '--llvm_tools_path', args.llvm_tools_path,
           '--num_workers', str(args.num_workers)]
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


def main():
    parser = argparse.ArgumentParser(
        description='ruyituner: 一键完成训练(train.py)与优化(run.py)',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--dataset', type=str, required=True,
                        help='包含 .ll 文件的数据集目录 (训练与优化共用)')
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
    args = parser.parse_args()

    if args.only_train and args.only_run:
        parser.error('--only_train 与 --only_run 不能同时使用')

    out_dir = args.output_dir or DEFAULT_OUTPUT_DIR

    if not args.only_run:
        os.makedirs(out_dir, exist_ok=True)
        print('=' * 60)
        print(f'[ruyituner] 阶段 1/2: 训练 (输出目录: {out_dir})')
        print('=' * 60)
        rc = subprocess.run(build_train_cmd(args)).returncode
        if rc != 0:
            print(f'[ruyituner] 训练失败 (exit={rc}), 终止.')
            sys.exit(rc)

    if not args.only_train:
        paircsv = args.paircsv or os.path.join(out_dir, 'Step2_EnumeratedPairs.csv')
        if not os.path.isfile(paircsv):
            print(f'[ruyituner] 找不到协同对文件: {paircsv}, 请先完成训练.')
            sys.exit(1)
        run_cmd = [sys.executable, RUN_SCRIPT,
                   '--dataset', args.dataset,
                   '--llvm_tools_path', args.llvm_tools_path,
                   '--paircsv', paircsv,
                   '--opt-level', args.opt_level]
        print('=' * 60)
        print(f'[ruyituner] 阶段 2/2: GA 优化 (协同对: {paircsv})')
        print('=' * 60)
        rc = subprocess.run(run_cmd).returncode
        if rc != 0:
            print(f'[ruyituner] 优化失败 (exit={rc}).')
            sys.exit(rc)

    print('[ruyituner] 全部完成.')


if __name__ == '__main__':
    main()
