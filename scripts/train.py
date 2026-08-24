
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
训练脚本 (含 pass 列表自动生成).

用法:
  # 训练流程 (--dataset 必选; --output_dir 可选, 缺省为项目根目录下的 output/)
  python3 scripts/train.py --dataset <dir> --llvm_tools_path <dir> [--output_dir <dir>] --passfile <file>

  # 未提供 --passfile 时自动生成 pass 列表后开始训练 (默认不写txt文件, 除非指定 --passlist_output)
  python3 scripts/train.py --dataset <dir> --llvm_tools_path <dir> --output_dir <dir>

  # 仅生成 pass 列表, 不训练 (此时 --dataset/--output_dir 可不提供)
  python3 scripts/train.py --gen_passlist_only --llvm_tools_path <dir> [--passlist_output <文件>]
"""

import sys
import os
import re
import subprocess
import argparse as ap
import csv
import ast
from concurrent.futures import ThreadPoolExecutor

# Get the absolute path of the current file
current_file_path = os.path.abspath(__file__)
# Get the parent directory of the current file
project_root = os.path.dirname(os.path.dirname(current_file_path))
sys.path.append(project_root)
# scripts/ 目录, 保证从任意工作目录运行时都能 import utils
sys.path.insert(0, os.path.dirname(current_file_path))

from utils.PassSyner import PassSyner
from utils.common import get_inst_count, get_inst_count_method

# ============================================================================
# pass 列表生成
# ============================================================================

# 用于运行时验证的测试 IR: 包含函数、调用、循环、内存读写, 能覆盖绝大多数 pass 的使用场景
TEST_IR = """\
declare void @f(i32)

define i32 @main(i32 %argc) {
entry:
  %arr = alloca [16 x i32], align 4
  call void @f(i32 %argc)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %idx = getelementptr inbounds [16 x i32], ptr %arr, i32 0, i32 %i
  %v = load i32, ptr %idx, align 4
  %v2 = add i32 %v, 1
  store i32 %v2, ptr %idx, align 4
  %c = icmp slt i32 %v2, 100
  %i.next = add i32 %i, 1
  br i1 %c, label %loop, label %exit

exit:
  ret i32 %v2
}
"""

# 需要解析的分类标题 -> (passfile 前缀, 是否为带参数分类)
# 带参数分类只取基名(去掉 <...>), 由后面的运行时验证决定无参数形式是否可用
# LoopNest 分类的 pass 在项目中以 loop(...) 形式使用 (经验证可用)
SECTION_HEADERS = {
    'Module passes:': ('module', False),
    'Module passes with params:': ('module', True),
    'CGSCC passes:': ('cgscc', False),
    'CGSCC passes with params:': ('cgscc', True),
    'Function passes:': ('function', False),
    'Function passes with params:': ('function', True),
    'LoopNest passes:': ('loop', False),
    'LoopNest passes with params:': ('loop', True),
    'Loop passes:': ('loop', False),
    'Loop passes with params:': ('loop', True),
}

# 纯观察/调试类 pass, 对代码大小优化无意义, 直接排除
OBSERVER_PATTERN = re.compile(r'^(print($|-|<)|dot-|view-|debugify|check-debugify)')

# 插桩类 pass (sanitizer/profiling/coverage), 只会增大代码体积, 默认排除
INSTRUMENTATION_PATTERN = re.compile(
    r'^(asan|hwasan|msan|tsan|dfsan|nsan|rtsan|tysan|sanmd|sancov'
    r'|pgo-|instrprof|insert-gcov-profiling|sample-profile|memprof|ctx-prof|ctx-instr)')


def get_opt_version(opt_path):
    r = subprocess.run([opt_path, '--version'], capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f'{opt_path} --version 执行失败')
    m = re.search(r'LLVM version\s+(\S+)', r.stdout + r.stderr)
    return m.group(1) if m else 'unknown'


def get_registered_passes(opt_path, exclude_patterns):
    """从 `opt --print-passes` 解析出 {category: [pass names]}

    exclude_patterns: [(标签, 正则)] 列表, 命中的 pass 名会被剔除;
    返回 (found, excluded), excluded 为 {标签: [被剔除的 pass 名]}"""
    r = subprocess.run([opt_path, '--print-passes'], capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f'{opt_path} --print-passes 执行失败:\n{r.stderr[:500]}')
    found = {}
    seen = {}
    excluded = {}
    current = None
    for raw in r.stdout.splitlines():
        if not raw.strip():
            continue
        if raw[0] in ' \t':
            # 缩进的行是 pass 名, 只收集当前分类属于 module/cgscc/function/loop 的
            if current is None:
                continue
            category, has_params = current
            name = raw.strip()
            if has_params:
                name = name.split('<', 1)[0]  # 带参数分类只取基名
            for label, pat in exclude_patterns:
                if pat.match(name):
                    excluded.setdefault(label, []).append(name)
                    break
            else:
                if name not in seen.setdefault(category, set()):
                    seen[category].add(name)
                    found.setdefault(category, []).append(name)
        else:
            # 未缩进的行是分类标题; 不在映射表里的标题(如 analyses/Machine)视为跳过
            current = SECTION_HEADERS.get(raw.strip(), None)
    return found, excluded


def check_runtime(opt_path, task):
    """用测试 IR 实际运行一次 pass, 返回 (category, name, ok, reason, output_ir)"""
    category, name = task
    pass_str = f'{category}({name})'
    r = subprocess.run([opt_path, '-S', f'-passes={pass_str}'],
                       input=TEST_IR, capture_output=True, text=True)
    if r.returncode != 0:
        reason = extract_error_reason(r.stderr) or f'exit code {r.returncode}'
        return category, name, False, reason, None
    return category, name, True, None, r.stdout


def extract_error_reason(stderr_text):
    """从 opt 的 stderr 中提取最关键的一行报错(跳过崩溃回溯等噪声)"""
    noise = re.compile(r'^\s*(#\d+\s+0x|Stack dump:|PLEASE submit|Aborted|\d+\.\s+Program arguments:)')
    for line in (stderr_text or '').splitlines():
        s = line.strip()
        if not s or noise.match(s):
            continue
        return s[:120]
    if 'Stack dump:' in (stderr_text or ''):
        return '运行时崩溃 (crash)'
    return None


def parse_check(opt_path, ir):
    """用 opt 重新解析 IR, 返回 (ok, reason).

    替代原来的 libAutophase 解析检查: 训练/优化时输出 IR 会被同版本的 opt
    再次处理, 因此只需保证输出 IR 能被 opt 解析即可. """
    r = subprocess.run([opt_path, '-disable-output', '-'],
                       input=ir, capture_output=True, text=True)
    if r.returncode == 0:
        return True, None
    reason = extract_error_reason(r.stderr) or f'exit code {r.returncode}'
    return False, reason


def generate_passlist(args, write_default=True):
    """生成 pass 列表, 返回 pass 行列表.

    - --passlist_output 指定时写入该文件;
    - 未指定时: write_default=True(仅生成模式)写入默认文件 passes_<版本>.txt,
      write_default=False(训练模式)不写文件, 直接返回列表供训练使用."""
    opt_path = os.path.join(args.llvm_tools_path, 'opt')
    if not os.path.isfile(opt_path):
        raise SystemExit(f'找不到 opt 二进制: {opt_path}')

    version = get_opt_version(opt_path)
    print(f'opt 版本: {version} ({opt_path})')

    exclude_patterns = [('观察/调试类', OBSERVER_PATTERN)]
    if not args.keep_instrumentation:
        exclude_patterns.append(('插桩类', INSTRUMENTATION_PATTERN))
    if args.extra_exclude:
        try:
            exclude_patterns.append(('额外排除', re.compile(args.extra_exclude)))
        except re.error as e:
            raise SystemExit(f'--extra_exclude 正则无效: {e}')

    registered, excluded = get_registered_passes(opt_path, exclude_patterns)
    for label, names in excluded.items():
        print(f'按规则剔除 ({label}): {len(names)} 个')
    total = sum(len(v) for v in registered.values())
    if total == 0:
        raise SystemExit('未从 --print-passes 解析到任何 pass, 请检查 opt 版本')
    print(f'注册表中候选 pass: {total} 个')

    # Step 1: 运行时验证
    print('正在进行 opt 运行验证...')
    tasks = [(cat, name) for cat, names in registered.items() for name in names]
    kept, dropped = [], []  # kept: (category, name, output_ir); dropped: (name, reason)
    with ThreadPoolExecutor(max_workers=args.num_workers) as ex:
        results = ex.map(lambda t: check_runtime(opt_path, t), tasks)
        for cat, name, ok, reason, ir in results:
            if ok:
                kept.append((cat, name, ir))
            else:
                dropped.append((name, reason))

    # Step 2: 输出 IR 可解析性验证 (原 libAutophase 解析检查的替代)
    parse_dropped = []
    if not args.no_parse_check:
        print('正在进行输出 IR 可解析性验证...')

        def check_parse(item):
            cat, name, ir = item
            ok, reason = parse_check(opt_path, ir)
            if not ok:
                return name, False, reason
            # 剔除把整个模块清空的 pass: 它们会让 GA 得到 0 指令的"满分"而被滥用
            if get_inst_count(ir) == 0:
                return name, False, '输出 IR 为空模块 (0 条指令)'
            return name, True, None

        with ThreadPoolExecutor(max_workers=args.num_workers) as ex:
            results = ex.map(check_parse, kept)
            kept_names = []
            for name, ok, reason in results:
                if ok:
                    kept_names.append(name)
                else:
                    parse_dropped.append((name, reason))
            kept = [item for item in kept if item[1] in kept_names]

    kept_names = {name for _, name, _ in kept}
    if args.passlist_output is not None:
        out_path = args.passlist_output
    elif write_default:
        out_path = f'passes_{re.sub(r"[^A-Za-z0-9._-]", "_", version)}.txt'
    else:
        out_path = None

    lines = []
    for cat in ('module', 'cgscc', 'function', 'loop'):
        for name in registered.get(cat, []):
            if name in kept_names:
                lines.append(f'{cat}({name})')

    if out_path is not None:
        with open(out_path, 'w') as f:
            f.write('\n'.join(lines) + ('\n' if lines else ''))

    if out_path is not None:
        print(f'\n生成完成: {out_path} (共 {len(lines)} 个 pass)')
    else:
        print(f'\n生成完成: 共 {len(lines)} 个 pass (未写文件, 仅用于本次训练)')
    if dropped:
        print(f'\n因 opt 运行失败剔除 {len(dropped)} 个:')
        for name, reason in dropped:
            print(f'  - {name}: {reason}')
    if parse_dropped:
        print(f'\n因输出 IR 检查失败剔除 {len(parse_dropped)} 个:')
        for name, reason in parse_dropped:
            print(f'  - {name}: {reason}')
    print('\n成功生成pass列表！')
    return lines


# 仅生成 pass 列表时不做训练, 此时 --dataset 不要求必选
# (训练模式下 --dataset 仍为必选项)
gen_only = '--gen_passlist_only' in sys.argv

args = ap.ArgumentParser()
args.add_argument("--dataset", type=str, required=not gen_only, help="Dataset path for training containing .ll files (required for training)")
args.add_argument("--llvm_tools_path", type=str, required=True, help="Path to a specific version LLVM binary files")
args.add_argument("--output_dir", type=str, default=None, help="output file path; if not provided, defaults to <project_root>/output and is created automatically")
args.add_argument("--num_workers", type=int, default=16, help="number of workers for parallel processing")
args.add_argument("--passfile", type=str, default=None, help="the pass list to be used for synergistic pair finding, e.g., llvm21_1_8 or llvm18_1_6; if not provided, it will be automatically generated")
args.add_argument("--gen_passlist_only", action='store_true', help="only generate a pass list and exit, without training")
args.add_argument("--passlist_output", type=str, default=None, help="output path for the generated pass list, defaults to passes_<llvm_version>.txt")
args.add_argument("--no_parse_check", action='store_true', help="skip opt re-parse verification of pass output IR")
args.add_argument("--keep_instrumentation", action='store_true', help="keep instrumentation passes (asan/tsan/pgo-* etc., excluded by default)")
args.add_argument("--extra_exclude", type=str, default=None, help="extra exclude rules for the generated pass list (regex)")
args = args.parse_args()

if args.gen_passlist_only:
    # 仅生成 pass 列表, 不训练
    generate_passlist(args)
    sys.exit(0)

if args.output_dir is None:
    # 未指定 --output_dir 时, 使用并自动创建项目根目录下的 output 目录
    args.output_dir = os.path.join(project_root, 'output')
    os.makedirs(args.output_dir, exist_ok=True)
    print(f'未指定 --output_dir, 使用默认输出目录: {args.output_dir}')

print("Instruction counting method:", get_inst_count_method(args.llvm_tools_path))

"""
Step 1. Find synergistic pairs and save to Step1 CSV
(空列表行在写入时直接跳过)
"""

if args.passfile:
    if not os.path.exists(args.passfile):
        raise FileNotFoundError(f"Pass file {args.passfile} does not exist.")
    with open(args.passfile, 'r') as f:
        passlist = [line.strip() for line in f if line.strip()]
else:
    # 未提供 --passfile 时自动生成 pass 列表(默认不写文件), 然后继续训练
    passlist = generate_passlist(args, write_default=False)

syner = PassSyner(args.dataset, args.llvm_tools_path, passlist=passlist, num_works=args.num_workers)
output_file = os.path.join(args.output_dir, 'Step1_FindSynerPairs.csv')
syner.FindSynerPasses(output_file)
print("Step1 Completed: Synergistic pairs have been found and saved to Step1_FindSynerPairs.csv (rows with empty lists are skipped)")

"""
Step 2. Enumerate synergistic pairs and save to a new CSV
"""
input_path = os.path.join(args.output_dir, 'Step1_FindSynerPairs.csv')
output_path = os.path.join(args.output_dir, 'Step2_EnumeratedPairs.csv')

syner_list = []
# Open the original CSV file
with open(input_path, mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    
    # Open the new CSV file for writing enumerated results
    with open(output_path, mode='w', encoding='utf-8', newline='') as outfile:
        writer = csv.writer(outfile)
        
        # Write the header
        writer.writerow(['index', 'synerpair'])
        
        # Enumerate all list values in the rows and write to the new file
        index_counter = 0
        seen_elements = set()
        for row in reader:
            # Get the value from the 'Synerpairlist' column and parse it as a list
            value_str = row['Synerpairlist']
            value_list = ast.literal_eval(value_str)
            
            # Enumerate the values in the list and skip duplicates
            for element in value_list:
                if element not in seen_elements:
                    writer.writerow([index_counter, element])
                    syner_list.append(element)
                    seen_elements.add(element)
                    index_counter += 1
    
print("Step2 Completed: Enumeration completed and saved to Step2_EnumeratedPairs.csv")