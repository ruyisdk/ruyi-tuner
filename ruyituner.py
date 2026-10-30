#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ruyituner: 一键完成训练(train.py)与优化(run.py), 以及 C 输入项目模式下的实际编译对比.

默认流程:
  1. 训练:  运行 scripts/train.py, 输出 Step1_<项目名>_<架构>_EnumeratedPairs.csv;
  2. 优化:  用训练得到的协同 pass 对运行 scripts/run.py 进行 GA 优化;
  3. 实际编译对比 (仅 --input_type c 且 --search_scope project): 运行
     scripts/real_compile.py, 用 GA 找到的最优序列
     (output/Step2_<项目名>_<架构>_PassList.csv) 实际编译源码, .o 输出到
     output/<项目名>_<架构>/, 基线复用优化阶段写出的
     Step2_<项目名>_<架构>_Result.json, 最终输出实际代码体积缩减率 (与评分口径一致).

各输出名中的 <架构> (x86/riscv/aarch64) 取自数据集 .ll 内嵌 target triple;
项目名本身已含架构名或取不到架构时不追加, 保证多架构的数据互不覆盖.

两个工具链: --baseline_tools_path 为基线工具链, 用于基线的直接编译/统计
(obj-size 口径下 clang -O<level> -c 编译源码成 .o, 其余口径用其 opt 计算基线);
--opt_tools_path 为优化工具链, 用于 clang/opt/llc 三段过程 (C→IR 转换、训练、
GA 评分与实际编译对比), 缺省与基线工具链相同.

CSiBE 等自带 Makefile.in 的 C 项目无需手工维护编译参数: ruyituner 自动解析
其中 CFLAGS 的 -D/-U/-I 并透传给 clang, 未显式提供 --c_std 时自动默认 gnu89;
--c_std/--c_flags 仍可显式提供, 追加/覆盖于自动解析结果.

用法示例:
  # 完整流程 (训练 + 优化)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --baseline_tools_path ../llvm_dir/build/bin

  # 仅训练 (不优化)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --baseline_tools_path ../llvm_dir/build/bin --only_train

  # 仅优化 (需要已有 Step1_<项目名>_<架构>_EnumeratedPairs.csv, 如 x86 数据集对应 Step1_x86_EnumeratedPairs.csv)
  python3 ruyituner.py --dataset datasets/ll_files/x86 --input_type ll --baseline_tools_path ../llvm_dir/build/bin --only_run \
      --paircsv output/Step1_x86_EnumeratedPairs.csv

  # 输入 C 源码数据集 (.c 或预处理后的 .i, 先用clang以--ir-opt-level优化等级生成.ll到缓存目录,
  # 缺省与基线优化等级--opt-level一致; 流程结束自动清理)
  python3 ruyituner.py --dataset datasets/c_files --input_type c --baseline_tools_path ../llvm_dir/build/bin

  # --input_type c 搭配 --count_mode obj-size 时, 评分基线直接用 clang -O<level> -c
  # 编译源码统计 .o 大小 (真实编译口径), 不再经过 C→IR→opt 中间过程

  # 预处理后的 C 源码 (.i) 数据集, 如 CSiBE 的 lwip-0.5.3.preproc (旧式代码需 --c_std gnu89)
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc --input_type c \
      --baseline_tools_path ../llvm_dir/build/bin --c_std gnu89

  # 旧式 C 代码 (K&R/C89, 如 CSiBE 的 compiler 基准) 需通过 --c_std 指定 C 标准, 否则隐式函数声明报错
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler --input_type c \
      --baseline_tools_path ../llvm_dir/build/bin --c_std gnu89

  # 依赖自定义编译宏的项目 (如 flex 需 -DHAVE_CONFIG_H) 可通过 --c_flags 追加 clang 参数
  python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31 --input_type c \
      --baseline_tools_path ../llvm_dir/build/bin --c_std gnu89 --c_flags '-DHAVE_CONFIG_H'

  # 基线工具链与优化工具链分开: 基线 .o 用默认构建编译, clang/opt/llc 三段过程用统计构建
  python3 ruyituner.py --dataset datasets/c_files --input_type c \
      --baseline_tools_path ../llvm_dir/build/bin --opt_tools_path ../llvm_dir/build-stat/bin
"""

import argparse
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
REAL_COMPILE_SCRIPT = os.path.join(PROJECT_ROOT, 'scripts', 'real_compile.py')
DEFAULT_OUTPUT_DIR = os.path.join(PROJECT_ROOT, 'output')

# scripts/ 目录加入模块搜索路径, 复用公共函数 (dataset_output_name 等)
sys.path.insert(0, os.path.join(PROJECT_ROOT, 'scripts'))
from utils.common import find_clang, dataset_output_name, dataset_arch_name  # type: ignore  # 依赖上面的 sys.path 运行时解析


# ---- CSiBE 等项目的编译参数自动解析 (Makefile.in) ----
# 移植自 scripts/run_csibe_build.py: 解析项目自带的 Makefile.in 中的 CFLAGS,
# 提取 -D/-U/-I 参数供 clang 使用, 免去 C 输入时手工维护 --c_std/--c_flags

# Makefile 变量定义与 $(VAR) 引用
VAR_ASSIGN_RE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s*(:=|=)\s*(.*)$')
VAR_REF_RE = re.compile(r'\$\(([A-Za-z_][A-Za-z0-9_]*)\)')


def read_makefile_variables(mk_path, vpath_dir):
    """读取一个 Makefile.in 的变量定义, 返回变量字典.

    行尾 \\ 续行先合并成逻辑行, 规则行 (缩进开头) 与注释行跳过;
    CCOPT 强制置空、VPATH 强制置为 vpath_dir (该 Makefile.in 所在目录),
    不取文件里 @CSiBE-CCOPT@ / @CSiBE-SRCDIR@ 占位符的值."""
    logical_lines = []
    buf = None
    with open(mk_path, encoding='utf-8', errors='ignore') as fh:
        for raw in fh:
            line = raw.rstrip('\n')
            if buf is not None:
                line = buf + line.lstrip()
                buf = None
            if line.rstrip().endswith('\\'):
                buf = line.rstrip()[:-1] + ' '
                continue
            logical_lines.append(line)
        if buf is not None:
            logical_lines.append(buf)

    variables = {}
    for line in logical_lines:
        if not line.strip() or line.strip().startswith('#'):
            continue
        m = VAR_ASSIGN_RE.match(line)
        if not m:
            continue
        name, value = m.group(1), m.group(3).strip()
        if name in ('CCOPT', 'VPATH'):
            continue
        variables[name] = value
    variables['CCOPT'] = ''
    variables['VPATH'] = vpath_dir
    return variables


def expand_make_variables(text, variables):
    """递归展开 $(VAR) 引用, 未定义的变量展开为空, 最多迭代 16 次防循环."""
    for _ in range(16):
        expanded = VAR_REF_RE.sub(lambda m: variables.get(m.group(1), ''), text)
        if expanded == text:
            return expanded
        text = expanded
    return text


def extract_project_flags(project_dir):
    """解析 project_dir 目录树下所有 Makefile.in 的 CFLAGS, 提取 -D/-U/-I 参数.

    -I 相对路径按该 Makefile.in 所在目录解析为绝对路径 (clang 在数据集根目录下
    执行也成立); 不存在的头文件目录丢弃并提示; 返回保序去重的参数列表;
    目录下没有 Makefile.in 时返回空列表."""
    flags = []
    seen = set()
    makefiles = []
    for root, _dirs, files in os.walk(project_dir):
        for name in files:
            if name == 'Makefile.in':
                makefiles.append(os.path.join(root, name))
    for mk_path in sorted(makefiles):
        mk_dir = os.path.dirname(mk_path)
        variables = read_makefile_variables(mk_path, mk_dir)
        cflags = expand_make_variables(variables.get('CFLAGS', ''), variables)
        if not cflags.strip():
            continue
        for token in cflags.split():
            if token.startswith('-I') and len(token) > 2:
                path = token[2:]
                if not os.path.isabs(path):
                    path = os.path.join(mk_dir, path)
                path = os.path.abspath(path)
                if not os.path.isdir(path):
                    print(f'[ruyituner] 丢弃不存在的头文件目录 {token} '
                          f'(来自 {os.path.relpath(mk_path, project_dir)})')
                    continue
                item = '-I' + path
            elif token.startswith(('-D', '-U')):
                item = token
            else:
                # -w/-ansi/-fno-builtin 等不传给 clang (-ansi 由自动默认的 gnu89 代替)
                continue
            if item not in seen:
                seen.add(item)
                flags.append(item)
    return flags


def build_train_cmd(args, dataset, project_name):
    """根据命令行参数构造 train.py 的命令."""
    cmd = [sys.executable, TRAIN_SCRIPT,
           '--dataset', dataset,
           # 训练 (pass 枚举) 属于优化过程, 用优化工具链
           '--opt_tools_path', args.opt_tools_path,
           '--num_workers', str(args.num_workers),
           '--count_mode', args.count_mode,
           '--project_name', project_name]
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


def compile_c_dataset_to_ir(src_root, cache_dir, clang, num_workers, c_std=None, c_flags=None, manifest_path=None, opt_level='Oz'):
    """用clang把src_root下所有.c/.i文件编译为.ll并放入cache_dir(保持相对目录结构).

    src_root 也可以是单个 .c/.i 文件: 此时以其所在目录为数据集根, 只编译该文件;
    .c 为 C 源码; .i 为预处理后的 C 源码 (cc -E 输出), clang 直接按预处理输入编译;
    同名 .c 与 .i 并存时优先 .c;
    被其他源文件 #include 的 .i 片段 (如 jikespg 的 lpgact.i) 不单独编译, 跳过并提示;
    编译在数据集根目录 (src_root) 下执行, c_flags 中的相对路径 (如 -Iinclude)
    以数据集根目录为基准解析;
    opt_level 为 IR 生成时的优化等级 (由 --ir-opt-level 控制, 默认 Oz,
    缺省与基线优化等级 --opt-level 一致), 以 clang -<opt_level> -S -emit-llvm
    编译; 仅 -O0 附加 -Xclang -disable-O0-optnone;
    c_std 非 None 时以 -std=<c_std> 传给 clang (如 gnu89, 用于旧式 C 代码);
    c_flags 非 None 时按空白拆分后原样传给 clang (如 -DHAVE_CONFIG_H);
    manifest_path 非 None 时把 .ll 相对路径 -> 原始源文件 的映射连同 src_root/
    c_std/c_flags 写入该 JSON 文件, 供优化阶段用 clang 直接编译源码统计基线;
    编译失败的源文件告警跳过; 返回 (成功数, 失败数).
    """
    src_root = os.path.abspath(src_root)
    single_file = os.path.isfile(src_root)
    if single_file:
        # 单个源文件: 以其所在目录为数据集根, 只编译该文件
        if not src_root.endswith(('.c', '.i')):
            print(f'[ruyituner] 数据集文件类型不支持: {src_root} (仅支持 .c / .i)')
            return 0, 0
        src_files = [src_root]
        src_root = os.path.dirname(src_root)
        num_c, num_i = (1, 0) if src_files[0].endswith('.c') else (0, 1)
    else:
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
    if num_i and not single_file:
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


def build_real_compile_cmd(args, out_dir, cache_dir, total_stages, project_name):
    """构造实际编译对比脚本 (scripts/real_compile.py) 的命令."""
    cmd = [sys.executable, REAL_COMPILE_SCRIPT,
           '--project_name', project_name,
           '--output_dir', out_dir,
           '--cache_dir', cache_dir,
           # 实际编译对比 (clang/opt/llc 三段过程) 用优化工具链
           '--opt_tools_path', args.opt_tools_path,
           '--opt_level', args.opt_level,
           # 回退直通编译用 C→IR 转换的优化等级 (缺省与 --opt-level 一致)
           '--ir_opt_level', args.ir_opt_level or args.opt_level,
           '--num_workers', str(args.num_workers),
           '--total_stages', str(total_stages)]
    if args.c_std is not None:
        cmd += ['--c_std', args.c_std]
    if args.c_flags is not None:
        # --c_flags 的值常以 - 开头, 用 --c_flags=<值> 形式避免子脚本解析失败
        cmd += [f'--c_flags={args.c_flags}']
    return cmd


def main():
    # print 接入管道时默认块缓冲, 会让自身横幅/阶段标题排在子脚本
    # (train.py/run.py/real_compile.py) 输出之后, 重定向日志时顺序错乱;
    # 改为行缓冲保证输出顺序一致
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(line_buffering=True)
    parser = argparse.ArgumentParser(
        description='ruyituner: 一键完成训练(train.py)与优化(run.py)',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--dataset', type=str, required=True,
                        help='数据集目录或单个 .c/.i 源文件 (训练与优化共用)')
    parser.add_argument('--input_type', type=str, required=True,
                        choices=['ll', 'c'],
                        help='输入文件类型 (必选): ll=LLVM IR (原处理路径), c=C 源码 (.c 或预处理后的 .i, 先用clang以--ir-opt-level优化等级生成.ll再走原路径)')
    parser.add_argument('--c_std', type=str, default=None,
                        help='传给 clang 的 C 语言标准, 如 gnu89 (可选, 仅 --input_type c 生效; 不提供时数据集含 Makefile.in 自动默认 gnu89, 否则不传 -std)')
    parser.add_argument('--c_flags', type=str, default=None,
                        help='传给 clang 的额外编译参数, 如 -DHAVE_CONFIG_H (可选, 仅 --input_type c 生效; 支持空格分隔多个; 数据集含 Makefile.in 时自动解析其 -D/-U/-I, 显式提供时追加在自动参数之后可覆盖)')
    parser.add_argument('--baseline_tools_path', type=str, default=None,
                        help='基线工具链路径: 用于基线的直接编译/统计 (obj-size 口径下 clang -O<level> -c 编译源码成 .o, 其余口径用其 opt 计算基线); 缺省同时作为优化工具链')
    parser.add_argument('--llvm_tools_path', type=str, default=None,
                        help=argparse.SUPPRESS)  # 旧名, 兼容保留 (RunCSiBE.md 等旧命令仍可用)
    parser.add_argument('--opt_tools_path', type=str, default=None,
                        help='优化工具链路径: 用于 clang/opt/llc 三段过程 (C→IR 转换、训练、GA 评分与实际编译对比), 缺省与 --baseline_tools_path (基线工具链) 相同')
    parser.add_argument('--output_dir', type=str, default=None,
                        help='训练输出目录, 默认 <项目根目录>/output')
    parser.add_argument('--passfile', type=str, default=None,
                        help='训练用的 pass 列表文件; 不提供时 train.py 自动生成')
    parser.add_argument('--num_workers', type=int, default=16,
                        help='训练并行工作线程数, 默认16')
    parser.add_argument('--opt-level', type=str, default='Oz',
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='GA 基线评分的优化等级, 默认 Oz (传给 run.py)')
    parser.add_argument('--ir-opt-level', type=str, default=None,
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='C→IR 转换时 clang 的优化等级, 缺省与 --opt-level 一致 (可选, 仅 --input_type c 生效)')
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
                        help='优化阶段使用的协同对 CSV, 默认 <output_dir>/Step1_<项目名>_<架构>_EnumeratedPairs.csv')
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

    # --llvm_tools_path 为旧名, 兼容保留 (RunCSiBE.md 等旧命令仍可用)
    if args.baseline_tools_path is None:
        if args.llvm_tools_path is None:
            parser.error('缺少 --baseline_tools_path (旧名 --llvm_tools_path 已更名)')
        args.baseline_tools_path = args.llvm_tools_path

    # 优化工具链缺省与基线工具链相同
    args.opt_tools_path = args.opt_tools_path or args.baseline_tools_path

    print('=' * 60)
    print(f'[ruyituner] 输入文件类型: {args.input_type}')
    print(f'[ruyituner] 计数方式: {args.count_mode}')
    print(f'[ruyituner] 寻找优化序列的范围: {args.search_scope}')
    if args.opt_tools_path != args.baseline_tools_path:
        print(f'[ruyituner] 工具链: 基线 {args.baseline_tools_path} / 优化 {args.opt_tools_path}')
    print('=' * 60)

    # C 输入 + 项目模式时, GA 优化之后还有实际编译对比阶段
    do_real_compile = (args.input_type == 'c' and args.search_scope == 'project'
                       and not args.only_train)
    total_stages = 3 if do_real_compile else 2

    cache_dir = None
    if args.input_type == 'c':
        # C→IR 转换是 clang/opt/llc 三段过程的第一段, 用优化工具链的 clang
        clang = find_clang(args.opt_tools_path)
        if clang is None:
            print('[ruyituner] 未找到 clang: 优化工具链 (--opt_tools_path) 与系统 PATH 中均无可用 clang, 终止.')
            sys.exit(1)
        # CSiBE 等自带 Makefile.in 的数据集: 自动解析编译参数 (-D/-U/-I) 并
        # 透传给 clang, 免去手工维护 --c_flags; 用户显式传 --c_flags 时追加在
        # 自动参数之后 (可覆盖自动抽取的同类参数)
        if os.path.isdir(args.dataset) and any(
                name == 'Makefile.in'
                for _root, _dirs, names in os.walk(args.dataset) for name in names):
            auto_flags = extract_project_flags(args.dataset)
            if auto_flags:
                extra = ' '.join(auto_flags)
                args.c_flags = f'{extra} {args.c_flags}' if args.c_flags else extra
                print(f'[ruyituner] 从 Makefile.in 自动解析编译参数: {extra}')
            if args.c_std is None:
                # 老式 C 项目默认按 gnu89 编译 (与 CSiBE 官方构建的 -ansi 口径一致)
                args.c_std = 'gnu89'
                print('[ruyituner] 检测到 Makefile.in, C 标准自动默认为 gnu89 (可用 --c_std 覆盖)')
        # C→IR 转换的优化等级: --ir-opt-level 缺省时与基线优化等级 --opt-level 一致
        ir_opt_level = args.ir_opt_level or args.opt_level
        std_info = f', C 标准: {args.c_std}' if args.c_std else ''
        flags_info = f', 额外参数: {args.c_flags}' if args.c_flags else ''
        print(f'[ruyituner] 输入为 c: 使用 clang 以 -{ir_opt_level} 把 .c/.i 编译为 .ll ({clang}{std_info}{flags_info})')
        cache_dir = tempfile.mkdtemp(prefix='ruyituner_ir_')
        print(f'[ruyituner] IR 缓存目录: {cache_dir}')
        manifest_path = os.path.join(cache_dir, 'baseline_manifest.json')
        ok, _failed = compile_c_dataset_to_ir(args.dataset, cache_dir, clang, args.num_workers, args.c_std, args.c_flags, manifest_path=manifest_path, opt_level=ir_opt_level)
        if ok == 0:
            print('[ruyituner] 未能从任何 .c/.i 文件生成 .ll, 终止.')
            shutil.rmtree(cache_dir, ignore_errors=True)
            sys.exit(1)
        dataset = cache_dir
    else:
        dataset = args.dataset

    # 项目输出名: 数据集名后追加架构名 (取自数据集 .ll 内嵌 target triple), 使
    # x86/riscv/aarch64 的 Step1/Step2/.o 产物互不覆盖; 项目名已含架构名或
    # 数据集缺少 triple 时保持原名
    project_base = dataset_output_name(args.dataset)
    arch = dataset_arch_name(dataset)
    if arch and arch.lower() not in project_base.lower():
        project_name = f'{project_base}_{arch}'
    else:
        project_name = project_base
    print(f'[ruyituner] 项目输出名: {project_name}' +
          (f' (架构: {arch})' if arch else ''))

    try:
        out_dir = args.output_dir or DEFAULT_OUTPUT_DIR

        if not args.only_run:
            os.makedirs(out_dir, exist_ok=True)
            print('=' * 60)
            print(f'[ruyituner] 阶段 1/{total_stages}: 训练 (数据集: {dataset}, 输出目录: {out_dir})')
            print('=' * 60)
            rc = subprocess.run(build_train_cmd(args, dataset, project_name)).returncode
            if rc != 0:
                print(f'[ruyituner] 训练失败 (exit={rc}), 终止.')
                sys.exit(rc)

        if not args.only_train:
            paircsv = args.paircsv or os.path.join(out_dir, f'Step1_{project_name}_EnumeratedPairs.csv')
            if not os.path.isfile(paircsv):
                print(f'[ruyituner] 找不到协同对文件: {paircsv}, 请先完成训练.')
                sys.exit(1)
            run_cmd = [sys.executable, RUN_SCRIPT,
                       '--dataset', dataset,
                       # 基线计算用基线工具链, 序列评分 (opt/llc) 用优化工具链
                       '--baseline_tools_path', args.baseline_tools_path,
                       '--opt_tools_path', args.opt_tools_path,
                       '--paircsv', paircsv,
                       '--opt-level', args.opt_level,
                       '--count_mode', args.count_mode,
                       '--search_scope', args.search_scope,
                       '--max-path-length', str(args.max_path_length),
                       '--output_dir', out_dir,
                       '--project_name', project_name]
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
                rc = subprocess.run(build_real_compile_cmd(args, out_dir, cache_dir, total_stages, project_name)).returncode
                if rc != 0:
                    print(f'[ruyituner] 实际编译对比失败 (exit={rc}).')
                    sys.exit(rc)

        print('[ruyituner] 全部完成.')
    finally:
        if cache_dir is not None:
            shutil.rmtree(cache_dir, ignore_errors=True)
            print(f'[ruyituner] 已清理 IR 缓存目录: {cache_dir}')


if __name__ == '__main__':
    main()
