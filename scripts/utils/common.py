import os
import io,sys
import re
import shutil
import subprocess
import tempfile


# 项目根目录 (scripts/utils/common.py -> scripts -> 项目根), 供外部脚本/历史依赖使用
project_directory = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(project_directory)

# LLVM IR 文本排版规律: 标签在 0 列, 指令行固定缩进 2 列, switch 等续行缩进 4 列
_INST_INDENT = 2

# 预编译匹配`opt -passes=instcount -stats` 输出中的总指令数条目（例如:
#   6 instcount - Number of instructions (of all types)）的正则表达式
_STATS_TOTAL_INSTS_RE = re.compile(
    r'^\s*(\d+)\s+instcount\s*-\s*Number of instructions \(of all types\)\s*$',
    re.MULTILINE)

# 已探测过的 opt 路径 -> 是否支持 -stats (None 不在缓存里表示未探测)
_opt_stats_support = {}


def _opt_supports_stats(opt_path):
    '''探测 opt 是否支持 `-passes=instcount -stats` (需要 LLVM_FORCE_ENABLE_STATS=ON 构建).

    结果按 opt 路径缓存, 每个路径只探测一次; 普通 release 构建 (ASSERTIONS=OFF
    且未开 LLVM_FORCE_ENABLE_STATS) 不会打印统计, 探测失败后永久走文本统计.'''
    if opt_path in _opt_stats_support:
        return _opt_stats_support[opt_path]
    probe_ir = 'define i32 @__stats_probe() {\n  ret i32 0\n}\n'
    r = subprocess.run([opt_path, '-passes=instcount', '-stats', '-disable-output', '-'],
                       input=probe_ir, capture_output=True, text=True)
    ok = (r.returncode == 0 and
          _STATS_TOTAL_INSTS_RE.search(r.stdout + r.stderr) is not None)
    _opt_stats_support[opt_path] = ok
    return ok


def _count_via_opt_stats(ir_code, opt_path):
    '''用 `opt -passes=instcount -stats` 统计指令数; 失败(退出码非 0 或输出无统计行)返回 None.'''
    r = subprocess.run([opt_path, '-passes=instcount', '-stats', '-disable-output', '-'],
                       input=ir_code, capture_output=True, text=True)
    if r.returncode != 0:
        return None
    m = _STATS_TOTAL_INSTS_RE.search(r.stdout + r.stderr)
    return int(m.group(1)) if m else None


def _count_text(ir_code):
    '''文本统计: 按 IR 缩进规律统计指令行, 空模块返回 0.'''
    count = 0
    for line in ir_code.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith((';', '!')):
            continue
        if len(line) - len(line.lstrip()) == _INST_INDENT:
            count += 1
    return count

def get_object_size(ir_code, llvm_tools_path=None):
    '''用 llc 将 LLVM IR 编译为 .o 目标文件, 并返回 .o 中 .text 段的大小(字节).

    目标架构由 IR 内嵌的 target triple 决定 (与 get_instrcount 一致); .text
    段大小由 llvm-size 从 .o 中解析, 不含符号表/重定位等 ELF 结构开销; llc 或
    llvm-size 不存在、编译/解析失败时返回 None, 由调用方决定回退策略.
    '''
    if not isinstance(ir_code, str):
        raise RuntimeError('输入不是字符串, 无法编译为 .o')
    bin_dir = llvm_tools_path or ''
    llc_path = os.path.join(bin_dir, 'llc') if bin_dir else 'llc'
    llvm_size_path = os.path.join(bin_dir, 'llvm-size') if bin_dir else 'llvm-size'
    tmpdir = tempfile.mkdtemp(prefix='ruyituner_')
    obj_path = os.path.join(tmpdir, 'output.o')
    try:
        r = subprocess.run([llc_path, '-filetype=obj', '-o', obj_path, '-'],
                           input=ir_code, capture_output=True, text=True)
        if r.returncode != 0:
            _report_opt_failure('llc:filetype=obj', r.stderr)
            return None
        if not os.path.isfile(obj_path) or os.path.getsize(obj_path) == 0:
            return 0
        r2 = subprocess.run([llvm_size_path, obj_path],
                            capture_output=True, text=True)
        if r2.returncode != 0:
            _report_opt_failure('llvm-size', r2.stderr)
            return None
        # llvm-size (Berkeley 格式) 数据行: text data bss dec hex filename
        m = re.search(r'^\s*(\d+)\s+\d+\s+\d+', r2.stdout, re.MULTILINE)
        return int(m.group(1)) if m else None
    except FileNotFoundError:
        return None
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)


# 支持的计数方式开关: auto(自动选择), opt-stats, text, obj-size
_COUNT_MODES = ('auto', 'opt-stats', 'text', 'obj-size')


def get_inst_count(ir_code, llvm_tools_path=None, count_mode='auto'):
    '''统计 LLVM IR 的总指令数, 等价于 LLVM InstCount/instcount pass 的 TotalInsts.

    count_mode 参数开关控制使用哪种统计方式:
      - 'auto'      默认; opt-stats 可用时优先使用, 否则回退到文本统计
      - 'opt-stats' 强制使用 `opt -passes=instcount -stats` (需要 LLVM_FORCE_ENABLE_STATS=ON 构建), 不可用时抛 RuntimeError
      - 'text'      强制按 IR 文本缩进规律统计指令行
      - 'obj-size'  调用 llc 把 IR 编译为 .o, 再用 llvm-size 解析并返回 .text 段的字节大小, 失败时抛 RuntimeError

    'auto' 回退链: opt 不存在/不支持 stats/运行失败或输出无统计行时回退到文本统计;
    被 module pass 清空的合法空模块(无 define/declare)统计为 0.
    '''
    if not isinstance(ir_code, str):
        raise RuntimeError('输入不是字符串, 无法统计指令数')
    if count_mode not in _COUNT_MODES:
        raise RuntimeError(f'未知的计数方式 {count_mode!r}, 可选值: {_COUNT_MODES}')

    if count_mode == 'obj-size':
        size = get_object_size(ir_code, llvm_tools_path)
        if size is None:
            raise RuntimeError('obj-size 计数方式不可用: llc/llvm-size 不存在或编译/解析失败')
        return size

    if count_mode == 'text':
        return _count_text(ir_code)

    # 'auto' 与 'opt-stats' 都优先尝试 opt 统计 (需要显式指定 llvm_tools_path)
    opt_path = None
    if llvm_tools_path:
        opt_path = os.path.join(llvm_tools_path, 'opt')
        if not os.path.isfile(opt_path):
            opt_path = None
    if opt_path and _opt_supports_stats(opt_path):
        count = _count_via_opt_stats(ir_code, opt_path)
        if count is not None:
            return count
    if count_mode == 'opt-stats':
        raise RuntimeError('opt-stats 计数方式不可用: opt 不存在、不支持 -stats 或统计失败')
    return _count_text(ir_code)


def get_inst_count_method(llvm_tools_path=None, count_mode='auto'):
    '''返回当前会使用的指令计数方式: 'opt-stats'、'text' 或 'obj-size'.

    与 get_inst_count 的决策逻辑一致, 供脚本在输出信息中展示计数方式.'''
    if count_mode in ('opt-stats', 'text', 'obj-size'):
        return count_mode
    # 'auto': 与 get_inst_count 相同的可用性判断
    if llvm_tools_path:
        opt_path = os.path.join(llvm_tools_path, 'opt')
        if os.path.isfile(opt_path) and _opt_supports_stats(opt_path):
            return 'opt-stats'
    return 'text'


def get_opt_default_arch(opt_path):
    '''从 `opt --version` 输出中提取默认目标架构 (target triple 的第一段).

    构建时未设置默认目标 (如通用构建) 时返回 None.'''
    r = subprocess.run([opt_path, '--version'], capture_output=True, text=True)
    if r.returncode != 0:
        return None
    m = re.search(r'Default target:\s*(\S*)', r.stdout + r.stderr)
    if not m or not m.group(1):
        return None
    return m.group(1).split('-', 1)[0]


def check_dataset_arch_matches_opt(ll_files, opt_path):
    '''校验数据集 .ll 文件内嵌 target triple 的架构与 opt 默认目标架构一致.

    防止用 x86 目标架构的 opt 处理 riscv 的 .ll 数据 (反之亦然); 任一文件缺失
    target triple 或架构不匹配时直接退出. opt 未设置默认目标时无法校验, 跳过.'''
    opt_arch = get_opt_default_arch(opt_path)
    for path in ll_files:
        with open(path, 'r') as f:
            text = f.read()
        m = re.search(r'target triple\s*=\s*"([^"]+)"', text)
        if not m:
            raise SystemExit(f'{path}: 缺少内嵌的 target triple, 请重新生成数据集文件 (见 Readme 注意事项).')
        ir_arch = m.group(1).split('-', 1)[0]
        if opt_arch is None:
            continue
        if ir_arch.lower() != opt_arch.lower():
            raise SystemExit(
                f'{path}: IR 目标架构 {ir_arch} 与 opt 默认目标 {opt_arch} 不一致, '
                f'请使用与数据集架构匹配的工具链 opt (--llvm_tools_path).')

def fix_loop_nesting(pipeline: str) -> str:
    '''
        把loop pass嵌套进离他最近的前面的function pass中，因为loop pass不能单独使用
    '''
    # 把pipeline按逗号分割成list
    passes = [p.strip() for p in pipeline.split(',')]
    
    # 记录处理后pass
    fixed_passes = []
    # 最近的 function(...) 索引
    last_function_index = -1
    # 暂存需要嵌套到 function 的 loop pass
    loop_passes_to_nest = []
    
    # 先遍历找有没有function pass
    has_function = any(p.startswith('function(') for p in passes)
    if not has_function:
        # 没有function，直接删掉所有loop
        passes = [p for p in passes if not p.startswith('loop(')]
        return ','.join(passes)
    
    for p in passes:
        if p.startswith('function('):
            # 遇到新的function，先把上次暂存的loop嵌套进上个function
            if last_function_index != -1 and loop_passes_to_nest:
                # 拼接loop pass，中间用逗号隔开
                inside = ','.join(loop_passes_to_nest)
                # 去掉 function( 和 最后 )，把loop pass加入
                original_func_body = fixed_passes[last_function_index][9:-1]
                new_func_body = original_func_body
                if original_func_body:
                    new_func_body += ',' + inside
                else:
                    new_func_body = inside
                fixed_passes[last_function_index] = f'function({new_func_body})'
                loop_passes_to_nest = []
            # 记录当前function位置
            fixed_passes.append(p)
            last_function_index = len(fixed_passes) - 1
        elif p.startswith('loop('):
            # 遇到loop，暂存起来，等遇到下一个function一起合并
            loop_passes_to_nest.append(p)
        else:
            # 普通pass，先把上次暂存的loop嵌套进上个function
            if last_function_index != -1 and loop_passes_to_nest:
                inside = ','.join(loop_passes_to_nest)
                original_func_body = fixed_passes[last_function_index][9:-1]
                new_func_body = original_func_body
                if original_func_body:
                    new_func_body += ',' + inside
                else:
                    new_func_body = inside
                fixed_passes[last_function_index] = f'function({new_func_body})'
                loop_passes_to_nest = []
            fixed_passes.append(p)
    # 最后如果还有没嵌套的loop，合并进最后一个function
    if last_function_index != -1 and loop_passes_to_nest:
        inside = ','.join(loop_passes_to_nest)
        original_func_body = fixed_passes[last_function_index][9:-1]
        new_func_body = original_func_body
        if original_func_body:
            new_func_body += ',' + inside
        else:
            new_func_body = inside
        fixed_passes[last_function_index] = f'function({new_func_body})'

    return ','.join(fixed_passes)


def _report_opt_failure(pipeline, stderr_text):
    '''opt 执行失败时把关键报错信息打印到 stderr, 便于排查(如 unknown pass).

    优化/训练过程中大量 pass 组合会触发 opt 崩溃, 逐条打印会淹没整体输出,
    因此默认静默; 设置环境变量 RUYITUNER_SHOW_OPT_FAILURES=1 可重新开启输出.'''
    if os.environ.get('RUYITUNER_SHOW_OPT_FAILURES') != '1':
        return
    msg = (stderr_text or "").strip()
    key_line = msg.splitlines()[-1] if msg else "no stderr output"
    print(f'[opt failed] passes="{pipeline}": {key_line}', file=sys.stderr)


# 合法的优化等级写法: "-Oz" 或 "default<Oz>" (opt 管道形式), 用于基线评分
_OPT_LEVEL_FLAGS = ('-O0', '-O1', '-O2', '-O3', '-Os', '-Oz',
                    'default<O0>', 'default<O1>', 'default<O2>',
                    'default<O3>', 'default<Os>', 'default<Oz>')


def _count_after_opt(after_ll_code, original_ir_code, llvm_tools_path, count_mode):
    '''统计优化后 IR 的代码大小; 统计失败时回退统计原始 IR.

    与 opt 崩溃时的处理一致: 特定序列的计数不可得(如 obj-size 口径下 llc 无法
    汇编该 IR)时视为无收益, 返回原始 IR 的计数; 若原始 IR 本身也无法统计(如
    工具链缺失), 异常继续向上抛出, 保证配置错误仍快速失败.'''
    try:
        return get_inst_count(after_ll_code, llvm_tools_path, count_mode=count_mode)
    except RuntimeError:
        return get_inst_count(original_ir_code, llvm_tools_path, count_mode=count_mode)


def get_instrcount(ir_code, opt_flags, llvm_tools_path, count_mode='auto'):
    #统计IR指令数，这里是做了统计指令数的集中情况的预处理，真正最终统计指令数是在get_inst_count里最终落地
    #count_mode 计数方式开关 (见 get_inst_count): 'auto' | 'opt-stats' | 'text' | 'obj-size'

    pipeline = ",".join(opt_flags)
    opt_path = os.path.join(llvm_tools_path, "opt") if llvm_tools_path else "opt"

    # 使用 subprocess 运行 opt 命令
    input_code_io = io.StringIO()
    input_code_io.write(ir_code)
    input_code_io.seek(0)

    if pipeline in _OPT_LEVEL_FLAGS:
        # 统计默认系统优化级别（O1~Oz)的IR指令数
        try:
            # 优化等级作为 opt 顶层参数; 目标架构由 IR 内嵌的 target triple 决定
            flag = f"-{pipeline[len('default<'):-1]}" if pipeline.startswith('default<') else pipeline
            cmd_opt = [opt_path] + [flag] + ["-S"]
            result = subprocess.run(cmd_opt, input=input_code_io.getvalue(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            after_ll_code = result.stdout
            return _count_after_opt(after_ll_code, ir_code, llvm_tools_path, count_mode)
        except subprocess.CalledProcessError as e:
            _report_opt_failure(pipeline, e.stderr)
            return get_inst_count(ir_code, llvm_tools_path, count_mode=count_mode)
    elif opt_flags == []:
        # 直接统计ll文件的IR指令数
        return get_inst_count(ir_code, llvm_tools_path, count_mode=count_mode)
    else:
        # 统计自定义pass序列（pipeline）优化后的指令数
        pipeline = fix_loop_nesting(pipeline)
        cmd_opt = f'{opt_path} -S "-passes={pipeline}"'
        try:
            result = subprocess.run(cmd_opt, shell=True, input=input_code_io.getvalue(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            after_ll_code = result.stdout
            return _count_after_opt(after_ll_code, ir_code, llvm_tools_path, count_mode)
        except subprocess.CalledProcessError as e:
            _report_opt_failure(pipeline, e.stderr)
            return get_inst_count(ir_code, llvm_tools_path, count_mode=count_mode)
