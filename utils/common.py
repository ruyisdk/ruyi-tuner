import os,ctypes
import io,sys
import subprocess


project_directory = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(project_directory)
lib_path = os.path.join(project_directory, "lib", "libAutophase_21_1_8.so")

class AutophaseDataStruct(ctypes.Structure):
    _fields_ = [("name", ctypes.c_char * 64), ("value", ctypes.c_int)]


def get_inst_count(ir_code):
    autophase_lib = ctypes.CDLL(lib_path)
    result_array = (AutophaseDataStruct * 56)()
    autophase_lib.GetAutophase(ir_code.encode(), result_array)
    result_dict = {item.name.decode(): item.value for item in result_array}
    return result_dict['TotalInsts']

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
            return get_inst_count(after_ll_code)
        except subprocess.CalledProcessError as e:
            return get_inst_count(ir_code)
    elif opt_flags == []:
        return get_inst_count(ir_code)
    else:
        pipeline = fix_loop_nesting(pipeline)
        cmd_opt = f'{opt_path} -S "-passes={pipeline}"'
        try:
            result = subprocess.run(cmd_opt, shell=True, input=input_code_io.getvalue(), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            after_ll_code = result.stdout
            return get_inst_count(after_ll_code)
        except subprocess.CalledProcessError as e:
            return get_inst_count(ir_code)
