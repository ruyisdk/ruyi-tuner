#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
根据 opt 二进制自动生成可被 scripts/train.py 和 scripts/run.py 使用的 pass 列表文件.

工作原理:
  1. 用 `opt --version` 获取 LLVM 版本号
  2. 用 `opt --print-passes` 读取该版本注册的全部 module/cgscc/function/loop pass
  3. 用一个包含函数/循环/内存操作的测试 IR 逐个运行验证, 剔除运行失败的 pass
     (unknown pass、requires TargetMachine、段错误、必然失败的调试 pass 等)
  4. 若 libAutophase 可用, 再剔除输出 IR 无法被它解析的 pass
  5. 输出自定义的名字的pass列表文件

用法:
  python3 gen_passlist.py --llvm_tools_path <opt所在目录>  --output passes_XXX.txt
"""

import argparse
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, PROJECT_ROOT)

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


def try_autophase_loader():
    """尝试加载 libAutophase; 成功返回 get_inst_count, 失败返回 None"""
    try:
        from utils.common import get_inst_count
        get_inst_count(TEST_IR)
        return get_inst_count
    except (OSError, ImportError, RuntimeError) as e:
        print(f'[warning] libAutophase 不可用 ({type(e).__name__}), 跳过解析检查; '
              f'如需完整检查请用 ./run_python239.sh 运行本脚本', file=sys.stderr)
        return None


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--llvm_tools_path', type=str, required=True,
                        help='opt 所在目录 (与 train.py/run.py 的 --llvm_tools_path 相同)')
    parser.add_argument('--output', type=str, default=None,
                        help='输出文件路径, 默认输出到当前目录下 passes_<版本号>.txt')
    parser.add_argument('--no-autophase-check', action='store_true',
                        help='不做 libAutophase 解析检查 (只做 opt 运行检查)')
    parser.add_argument('--keep-instrumentation', action='store_true',
                        help='保留插桩类 pass (asan/tsan/pgo-* 等, 默认剔除)')
    parser.add_argument('--extra-exclude', type=str, default=None,
                        help='额外的排除规则 (正则表达式, 匹配 pass 名即剔除)')
    parser.add_argument('--workers', type=int, default=16,
                        help='并行检查的线程数, 默认 16')
    args = parser.parse_args()

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
            raise SystemExit(f'--extra-exclude 正则无效: {e}')

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
    with ThreadPoolExecutor(max_workers=args.workers) as ex:
        results = ex.map(lambda t: check_runtime(opt_path, t), tasks)
        for cat, name, ok, reason, ir in results:
            if ok:
                kept.append((cat, name, ir))
            else:
                dropped.append((name, reason))

    # Step 2: libAutophase 解析验证
    autophase_dropped = []
    if not args.no_autophase_check:
        get_inst_count = try_autophase_loader()
        if get_inst_count is not None:
            print('正在进行 libAutophase 解析验证...')

            def check_parse(item):
                cat, name, ir = item
                try:
                    get_inst_count(ir)
                    return name, True, None
                except RuntimeError:
                    return name, False, 'libAutophase 无法解析输出 IR'

            with ThreadPoolExecutor(max_workers=args.workers) as ex:
                results = ex.map(check_parse, kept)
                kept_names = []
                for name, ok, reason in results:
                    if ok:
                        kept_names.append(name)
                    else:
                        autophase_dropped.append((name, reason))
                kept = [item for item in kept if item[1] in kept_names]

    kept_names = {name for _, name, _ in kept}
    out_path = args.output or f'passes_{re.sub(r"[^A-Za-z0-9._-]", "_", version)}.txt'
    line_count = 0
    with open(out_path, 'w') as f:
        for cat in ('module', 'cgscc', 'function', 'loop'):
            for name in registered.get(cat, []):
                if name in kept_names:
                    f.write(f'{cat}({name})\n')
                    line_count += 1

    print(f'\n生成完成: {out_path} (共 {line_count} 个 pass)')
    if dropped:
        print(f'\n因 opt 运行失败剔除 {len(dropped)} 个:')
        for name, reason in dropped:
            print(f'  - {name}: {reason}')
    if autophase_dropped:
        print(f'\n因 libAutophase 解析失败剔除 {len(autophase_dropped)} 个:')
        for name, reason in autophase_dropped:
            print(f'  - {name}: {reason}')
    print('\n成功生成pass列表文件！')

if __name__ == '__main__':
    main()
