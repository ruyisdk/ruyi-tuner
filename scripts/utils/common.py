import os
import io,sys
import re
import subprocess


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


def get_inst_count(ir_code, llvm_tools_path=None):
    '''统计 LLVM IR 文本中的总指令数, 等价于 LLVM InstCount/instcount pass 的 TotalInsts.

    优先使用 `opt -passes=instcount -stats` (需要 LLVM_FORCE_ENABLE_STATS=ON 构建的
    opt); 该方式不可用(opt 不存在/不支持 stats/运行失败或输出无统计行)时回退到按 IR
    文本缩进规律的文本统计.

    两种方式都只做计数不做合法性校验: opt 成功生成的输出必然是合法 IR; 被 module
    pass 清空的合法空模块(无 define/declare)返回 0.
    '''
    if not isinstance(ir_code, str):
        raise RuntimeError('输入不是字符串, 无法统计指令数')
    if llvm_tools_path:
        opt_path = os.path.join(llvm_tools_path, 'opt')
        if os.path.isfile(opt_path) and _opt_supports_stats(opt_path):
            count = _count_via_opt_stats(ir_code, opt_path)
            if count is not None:
                return count
    return _count_text(ir_code)


def get_inst_count_method(llvm_tools_path=None):
    '''返回当前会使用的指令计数方式: 'opt-stats' 或 'text'.

    与 get_inst_count 的决策逻辑一致, 供脚本在输出信息中展示计数方式.'''
    if llvm_tools_path:
        opt_path = os.path.join(llvm_tools_path, 'opt')
        if os.path.isfile(opt_path) and _opt_supports_stats(opt_path):
            return 'opt-stats'
    return 'text'

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
    '''opt 执行失败时把关键报错信息打印到 stderr, 便于排查(如 unknown pass)'''
    msg = (stderr_text or "").strip()
    key_line = msg.splitlines()[-1] if msg else "no stderr output"
    print(f'[opt failed] passes="{pipeline}": {key_line}', file=sys.stderr)


def get_instrcount(ir_code, opt_flags, isriscv, llvm_tools_path):

    pipeline = ",".join(opt_flags)
    opt_path = os.path.join(llvm_tools_path, "opt") if llvm_tools_path else "opt"

    # 使用 subprocess 运行 opt 命令
    input_code_io = io.StringIO()
    input_code_io.write(ir_code)
    input_code_io.seek(0)

    if pipeline == "default<Oz>" or pipeline == "-Oz":
        try:
            if isriscv:
                cmd_opt = [opt_path] + ["-Oz"] + ["-S"] + ["--target=riscv64-unknown-linux-gnu"]
            else:
                cmd_opt = [opt_path] + ["-Oz"] + ["-S"]
            result = subprocess.run(cmd_opt, input=input_code_io.getvalue(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            after_ll_code = result.stdout
            return get_inst_count(after_ll_code, llvm_tools_path)
        except subprocess.CalledProcessError as e:
            _report_opt_failure(pipeline, e.stderr)
            return get_inst_count(ir_code, llvm_tools_path)
    elif opt_flags == []:
        return get_inst_count(ir_code, llvm_tools_path)
    else:
        pipeline = fix_loop_nesting(pipeline)
        cmd_opt = f'{opt_path} -S "-passes={pipeline}"'
        try:
            result = subprocess.run(cmd_opt, shell=True, input=input_code_io.getvalue(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            after_ll_code = result.stdout
            return get_inst_count(after_ll_code, llvm_tools_path)
        except subprocess.CalledProcessError as e:
            _report_opt_failure(pipeline, e.stderr)
            return get_inst_count(ir_code, llvm_tools_path)
