#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量运行 RunCSiBE.md 中列出的各 CSiBE 项目 (x86 与 RISC-V 两套工具链).

从 RunCSiBE.md 解析每个项目的命令: 以 "## N.项目名" 标题确定项目名, 以紧邻的
"x86:" / "riscv:" 行确定架构, 以 "python3 ruyituner.py" 开头的行作为命令.
把命令中的占位工具链路径 (/home/XXX/llvm-project/build-x86|riscv/bin) 替换为
实际路径, /home/XXX/ruyi-tuner 替换为本项目根目录, 并在末尾追加
--search_scope project 后逐个运行; 每个项目跑完后, 从输出中截取实际编译对比
阶段 (阶段 3/3) 的部分, 按 "项目名：架构名：输出信息" 格式写入汇总文件.

用法示例:
  python3 scripts/run_csibe.py --x86_path /home/xxx/llvm-project/build-x86/bin \
      --riscv_path /home/xxx/llvm-project/build-riscv/bin

  只跑 x86:          追加 --only_arch x86
  只跑指定项目:      追加 --projects compiler,jpeg-6b
  只看将执行的命令:  追加 --dry_run
  统一透传优化等级:  追加 --opt-level Os --ir-opt-level Oz (追加到每条 ruyituner
                     命令末尾; md 命令中已带同名参数时不重复追加)

注意: 需在项目根目录 (ruyi-tuner 主目录) 下运行; RunCSiBE.md 中的命令按项目根
目录组织相对路径 (datasets/、--c_flags 的 -Ixxx 等), 从其它目录运行会解析错误.
"""

import argparse
import os
import re
import shlex
import subprocess
import sys
import time
from collections import namedtuple

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUYITUNER_PY = os.path.join(PROJECT_ROOT, 'ruyituner.py')
DEFAULT_MD = os.path.join(PROJECT_ROOT, 'RunCSiBE.md')
DEFAULT_OUTPUT = os.path.join(PROJECT_ROOT, 'output', 'CSiBE_Step3_summary.txt')

# md 中的占位路径 -> 实际路径
X86_PLACEHOLDER = '/home/XXX/llvm-project/build-x86/bin'
RISCV_PLACEHOLDER = '/home/XXX/llvm-project/build-riscv/bin'
RUYITUNER_PLACEHOLDER = '/home/XXX/ruyi-tuner'

HEADING_RE = re.compile(r'^##\s*\d+\.\s*(\S+)')
ARCH_RE = re.compile(r'^(x86|riscv)\s*[:：]\s*$')
CMD_RE = re.compile(r'^python3\s+ruyituner\.py\b')

Task = namedtuple('Task', ['project', 'arch', 'cmd_line'])


def parse_md(md_file):
    """解析 RunCSiBE.md, 返回 [(项目名, 架构, 命令行), ...], 顺序与文档一致."""
    tasks = []
    project = None
    arch = None
    with open(md_file, encoding='utf-8') as fh:
        for line in fh:
            line = line.rstrip('\n').rstrip()
            m = HEADING_RE.match(line)
            if m:
                project = m.group(1)
                arch = None
                continue
            m = ARCH_RE.match(line)
            if m:
                arch = m.group(1)
                continue
            if CMD_RE.match(line) and project and arch:
                tasks.append(Task(project, arch, line))
    return tasks


def _has_flag(argv, name):
    """argv 中是否已包含某命令行开关 (支持 "--name value" 与 "--name=value" 两种写法)."""
    return any(a == name or a.startswith(name + '=') for a in argv)


def build_command(task, paths, extra_args=None):
    """把 md 中的命令替换为实际路径, 并追加 --search_scope project.

    extra_args: [(开关名, 值), ...], 如 [('--opt-level', 'Os')]; 统一追加到
    命令末尾透传给 ruyituner, md 命令中已带同名开关 (含 = 写法) 时不重复追加."""
    line = task.cmd_line
    line = line.replace(RISCV_PLACEHOLDER, paths['riscv'])
    line = line.replace(X86_PLACEHOLDER, paths['x86'])
    line = line.replace(RUYITUNER_PLACEHOLDER, PROJECT_ROOT)
    argv = shlex.split(line)
    # md 命令头固定是 "python3 ruyituner.py", 换成当前解释器与脚本绝对路径;
    # -u 使 ruyituner 自身的 print 不缓冲: 其 stdout 接入管道时默认块缓冲,
    # 横幅/阶段标题会积到退出才冲出, 与子脚本输出错位, 必须去掉
    argv = [sys.executable, '-u', RUYITUNER_PY] + argv[2:]
    if '--search_scope' not in argv:
        argv += ['--search_scope', 'project']
    if extra_args:
        for flag, value in extra_args:
            if not _has_flag(argv, flag):
                argv += [flag, value]
    return argv


def extract_stage3(lines):
    """从输出行中截取实际编译对比阶段 (阶段 3/3): 自标题(含紧邻分隔线)起,
    到 [ruyituner] 全部完成. 为止; 找不到标题时返回 None."""
    start = None
    for i, line in enumerate(lines):
        if '阶段 3/3' in line:
            start = i
            break
    if start is None:
        return None
    # 带上紧邻在前的 "===...===" 分隔线
    if start > 0 and set(lines[start - 1].strip()) == {'='}:
        start -= 1
    # 收尾信息 (全部完成/已清理) 不属于阶段 3/3, 截断在 全部完成 之前
    end = len(lines)
    for j in range(start, len(lines)):
        if lines[j] == '[ruyituner] 全部完成.':
            end = j
            break
    return '\n'.join(lines[start:end]).rstrip()


def run_task(task, argv, out_fh):
    """运行一条命令, 实时回显输出, 并把阶段 3/3 内容写入汇总文件."""
    print(f'[run_csibe] ============ {task.project} ({task.arch}) ============')
    print('[run_csibe] 命令:', ' '.join(shlex.quote(a) for a in argv))
    proc = subprocess.Popen(argv, cwd=PROJECT_ROOT, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, bufsize=1)
    lines = []
    for line in proc.stdout:
        sys.stdout.write(line)
        sys.stdout.flush()
        lines.append(line.rstrip('\n'))
    rc = proc.wait()

    stage3 = extract_stage3(lines)
    if stage3 is None:
        tail = '\n'.join(lines[-8:]) if lines else '(无输出)'
        stage3 = (f'[run_csibe] 未输出阶段3/3 (exit={rc}), 输出末尾:\n{tail}')
    print('[run_csibe] ------------ 阶段 3/3 输出 ------------')
    print(stage3)
    print()

    out_fh.write(f'{task.project}：{task.arch}：\n')
    out_fh.write(stage3 + '\n\n')
    out_fh.flush()
    return rc


def main():
    parser = argparse.ArgumentParser(
        description='批量运行 RunCSiBE.md 中各 CSiBE 项目并汇总阶段 3/3 输出',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--x86_path', type=str, default=None,
                        help='x86 工具链目录 (替换 md 中的 build-x86 路径)')
    parser.add_argument('--riscv_path', type=str, default=None,
                        help='RISC-V 工具链目录 (替换 md 中的 build-riscv 路径)')
    parser.add_argument('--md_file', type=str, default=DEFAULT_MD,
                        help=f'RunCSiBE.md 路径 (默认: {DEFAULT_MD})')
    parser.add_argument('--output', type=str, default=DEFAULT_OUTPUT,
                        help=f'汇总输出文件 (默认: {DEFAULT_OUTPUT})')
    parser.add_argument('--only_arch', type=str, default=None,
                        choices=['x86', 'riscv'], help='只跑一个架构')
    parser.add_argument('--projects', type=str, default=None,
                        help='只跑指定项目, 逗号分隔 (如 compiler,jpeg-6b)')
    parser.add_argument('--opt-level', type=str, default=None,
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='追加到每条 ruyituner.py 命令的基线优化等级 (缺省不追加, 用 md 命令自带值)')
    parser.add_argument('--ir-opt-level', type=str, default=None,
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='追加到每条 ruyituner.py 命令的 C→IR 转换优化等级 (缺省不追加, 由 ruyituner 缺省规则决定)')
    parser.add_argument('--dry_run', action='store_true',
                        help='只解析并打印将执行的命令, 不实际运行')
    args = parser.parse_args()

    archs = [args.only_arch] if args.only_arch else ['x86', 'riscv']
    paths = {'x86': args.x86_path, 'riscv': args.riscv_path}
    for arch in archs:
        if not paths[arch]:
            parser.error(f'缺少 {arch} 工具链路径 (--{arch}_path)')
        if not os.path.isdir(paths[arch]):
            print(f'[run_csibe] 警告: {arch} 工具链目录不存在: {paths[arch]}')

    tasks = parse_md(args.md_file)
    if not tasks:
        print(f'[run_csibe] 未从 {args.md_file} 解析到任何命令, 终止.')
        sys.exit(1)
    tasks = [t for t in tasks if t.arch in archs]
    if args.projects:
        wanted = {p.strip() for p in args.projects.split(',') if p.strip()}
        tasks = [t for t in tasks if t.project in wanted]
    if not tasks:
        print('[run_csibe] 过滤后没有要运行的项目, 终止.')
        sys.exit(1)

    # 透传给每条 ruyituner.py 命令的优化等级参数 (md 命令中已有同名参数时不重复追加)
    extra_args = []
    if args.opt_level is not None:
        extra_args.append(('--opt-level', args.opt_level))
    if args.ir_opt_level is not None:
        extra_args.append(('--ir-opt-level', args.ir_opt_level))

    print(f'[run_csibe] 共 {len(tasks)} 条命令 (项目数: {len({t.project for t in tasks})})')
    if args.dry_run:
        for t in tasks:
            print(f'  {t.project} ({t.arch}):',
                  ' '.join(shlex.quote(a) for a in build_command(t, paths, extra_args)))
        print(f'[run_csibe] 汇总将写入: {args.output}')
        sys.exit(0)

    out_dir = os.path.dirname(args.output)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with open(args.output, 'w', encoding='utf-8') as out_fh:
        out_fh.write('# CSiBE 各项目 ruyituner 输出 阶段 3/3 (实际编译对比) 汇总\n')
        out_fh.write(f'# 生成时间: {time.strftime("%Y-%m-%d %H:%M:%S")}\n')
        out_fh.write(f'# x86 工具链: {args.x86_path}\n')
        out_fh.write(f'# riscv 工具链: {args.riscv_path}\n\n')
        out_fh.flush()
        for t in tasks:
            run_task(t, build_command(t, paths, extra_args), out_fh)
    print(f'[run_csibe] 全部完成, 汇总已写入: {args.output}')


if __name__ == '__main__':
    main()
