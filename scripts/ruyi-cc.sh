#!/bin/bash
# ruyi-cc.sh — 方案二编译器包装脚本: 在正常编译流程中应用 RuyiTuner 找到的最优 pass 序列.
#
# 工作原理 (与 RuyiTuner 评分口径一致, 序列整条替换优化管线):
#   真实 clang -<前端优化等级> -S -emit-llvm                    -> 前端生成 IR (与训练输入一致)
#   -> opt -S -passes=<RUYITUNER_PASS_SEQ>                      -> 应用最优 pass 序列
#   -> llc -filetype=obj                                        -> 后端生成目标文件
#
# 说明:
#   - 调用方传入的 -O 优化等级会被忽略, 优化管线完全由 RUYITUNER_PASS_SEQ 决定;
#   - 链接 (-o app 多个.o)、预处理 (-E/-M/-MM)、未识别出源文件等场景直通真实 clang,
#     序列不生效但构建不中断; opt/llc 失败时回退无序列直通编译;
#   - -g 调试信息、-MMD 依赖生成、-I/-D 等参数原样转发给前端 clang.
#
# 用法:
#   export RUYITUNER_LLVM_BIN=/home/ningning/llvm-project/build-x86-22.1.0/bin   # 必填: 工具链 bin 目录
#   export RUYITUNER_PASS_SEQ='mem2reg,instcombine'                              # 必填: pass 序列(逗号分隔)
#   export RUYITUNER_C_STD=gnu89                                                 # 可选: 追加 -std=<值> (旧式 C 代码)
#   export RUYITUNER_C_FLAGS='-DHAVE_CONFIG_H'                                   # 可选: 按空白拆分追加
#   export RUYITUNER_FRONT_OPT=Oz                                                 # 可选: 前端 IR 生成优化等级, 默认 Oz (与训练口径一致)
#   export RUYITUNER_RELOC_MODEL=static                                          # 可选: 强制 llc 使用 static 重定位模型
#   make CC=/path/to/ruyi-cc.sh                                                  # 作为 CC 使用
#
# 注意: 序列里含 loop(...) 元素时本脚本会自动按 utils/common.py 的 fix_loop_nesting
# 做嵌套处理 (与 RuyTuner 评分口径一致), 直接把 GA 输出的 Path 序列逗号连接即可.
#
# 调试: RUYITUNER_WRAP_DEBUG=1 打印实际执行的命令.

set -uf

LLVM_BIN="${RUYITUNER_LLVM_BIN:?请设置 RUYITUNER_LLVM_BIN (工具链 bin 目录)}"
REAL_CC="${RUYITUNER_REAL_CC:-$LLVM_BIN/clang}"
OPT="$LLVM_BIN/opt"
LLC="$LLVM_BIN/llc"
SEQ="${RUYITUNER_PASS_SEQ:?请设置 RUYITUNER_PASS_SEQ (pass 序列, 逗号分隔)}"

debug() {
    # 未开启调试时也要返回 0, 避免作为最后一个语句时影响脚本退出码
    if [ -n "${RUYITUNER_WRAP_DEBUG:-}" ]; then echo "[ruyi-cc] $*" >&2; fi
    return 0
}
warn()  { echo "[ruyi-cc] $*" >&2; }

# 与评分口径一致: 序列中的 loop(...) 元素不能单独出现, 按 utils/common.py 的
# fix_loop_nesting 嵌套进最近的 function(...) 之后才能交给 opt; 借用项目自带
# 函数处理, python3 或 import 失败时原样使用 (opt 失败会触发直通回退)
if command -v python3 >/dev/null 2>&1; then
    _wrap_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    _proj_root="$(dirname "$_wrap_dir")"
    if _fixed="$(python3 - "$SEQ" "$_proj_root" <<'PY'
import sys
seq, root = sys.argv[1], sys.argv[2]
sys.path.insert(0, root + '/scripts')
sys.path.insert(0, root)
from utils.common import fix_loop_nesting
print(fix_loop_nesting(seq))
PY
)"; then
        [ -n "$_fixed" ] && SEQ="$_fixed"
        debug "fix_loop_nesting 后序列: $SEQ"
    fi
fi

# 拆解参数: 找出 -o 输出文件与源文件 (最后一个 .c/.i/.cc/.cpp/.cxx/.C 参数)
args=("$@")
out=""
src=""
mode="link"   # link | compile | asm_only | preprocess
for ((i = 0; i < ${#args[@]}; i++)); do
    a="${args[$i]}"
    case "$a" in
        -o)  out="${args[$((i + 1))]}"; i=$((i + 1)) ;;
        -o*) out="${a#-o}" ;;
        -c)  mode="compile" ;;
        -S)  mode="asm_only" ;;
        -E|-M|-MM) mode="preprocess" ;;
        *.c|*.i|*.cc|*.cpp|*.cxx|*.C) src="$a" ;;
    esac
done

# 链接 / 预处理 / 未识别出源文件 (如 -c -x c - 从标准输入读取): 直通真实 clang
if [ "$mode" != "compile" ] && [ "$mode" != "asm_only" ]; then
    debug "直通 (非编译场景): $REAL_CC $*"
    exec "$REAL_CC" "$@"
fi
if [ -z "$src" ]; then
    warn "未识别出源文件, 直通编译 (序列不生效): $*"
    exec "$REAL_CC" "$@"
fi
if [ "$out" = "-" ]; then
    warn "-o - 输出到标准输出, 直通编译 (序列不生效)"
    exec "$REAL_CC" "$@"
fi
if [ -z "$out" ]; then
    out="$(basename "$src" "${src##*.}")o"   # foo.c -> foo.o
fi

# 前端参数: 去掉 -O*/-c/-S/-o 与源文件, 保留 -I/-D/-g/-MMD/-MF 等,
# 追加与 RuyiTuner C→IR 编译一致的选项
front_args=()
for ((i = 0; i < ${#args[@]}; i++)); do
    a="${args[$i]}"
    case "$a" in
        -O*)  ;;                    # 忽略优化等级, 管线由序列决定
        -c|-S) ;;
        -o)   i=$((i + 1)) ;;
        -o*)  ;;
        "$src") ;;
        *)    front_args+=("$a") ;;
    esac
done
# 前端 IR 生成优化等级与训练/评分口径一致 (默认 Oz, 即 --opt-level 默认值);
# 仅 O0 需要附加 -disable-O0-optnone, 其余优化等级前端不会产生 optnone 属性
front_opt="${RUYITUNER_FRONT_OPT:-Oz}"
front_args+=("-$front_opt" -S -emit-llvm)
[ "$front_opt" = "O0" ] && front_args+=(-Xclang -disable-O0-optnone)
[ -n "${RUYITUNER_C_STD:-}" ]   && front_args+=("-std=$RUYITUNER_C_STD")
[ -n "${RUYITUNER_C_FLAGS:-}" ] && read -ra _extra <<<"$RUYITUNER_C_FLAGS" && front_args+=("${_extra[@]}")
front_args+=("$src")

# 代码生成选项: 部分选项 (-fPIC 重定位模型、-mcmodel 代码模型) 是后端 llc 的参数,
# 前端转发给 clang 的同时也要同步给 llc, 否则生成的 .o 与普通编译不兼容;
# 注意 llc 默认 -relocation-model=static, 而 clang 在 x86_64/aarch64 上默认 PIC,
# 因此这里默认 pic (可用 RUYITUNER_RELOC_MODEL=static 覆盖, 显式 -fno-pic 时也转 static)
reloc="${RUYITUNER_RELOC_MODEL:-pic}"
llc_args=()
for a in "${args[@]}"; do
    case "$a" in
        -fPIC|-fpic|-fPIE|-fpie)    reloc="pic" ;;
        -fno-pic|-fno-PIC|-fno-pie|-fno-PIE) reloc="static" ;;
        -mcmodel=*)                 llc_args+=(-code-model="${a#-mcmodel=}") ;;
    esac
done
llc_args+=(-relocation-model="$reloc")

filetype="obj"; [ "$mode" = "asm_only" ] && filetype="asm"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

debug "前端: $REAL_CC ${front_args[*]}"
debug "opt : $OPT -S -passes=$SEQ"
debug "llc : $LLC -filetype=$filetype ${llc_args[*]} -o $out"
if "$REAL_CC" "${front_args[@]}" -o "$tmpdir/front.ll" &&
   "$OPT" -S -passes="$SEQ" "$tmpdir/front.ll" -o "$tmpdir/opt.ll" &&
   "$LLC" -filetype="$filetype" "${llc_args[@]}" "$tmpdir/opt.ll" -o "$out"; then
    debug "完成: $src -> $out"
else
    # opt/llc 失败时回退无序列直通编译, 保证构建不被中断
    warn "序列编译失败, 回退无序列直通编译: $src"
    exec "$REAL_CC" "$@"
fi
