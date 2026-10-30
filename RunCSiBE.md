# RuyiTuner 运行CSiBE说明

本文档为RuyiTuner运行datasets/c_files/CSiBE-v2.1.1下各个项目的详细说明，每个项目都给出了运行的具体命令参数，运行过程中注意替换工具链路径为本地路径。

本文档列出的命令均加了 --search_scope project 参数，走 project 模式：为整个项目找一条公共的最优 pass 序列（该模式输出一条公共 Path 与整体缩减率 Overall Reduction Rate），例如：

python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

其中，bzip2-1.0.2、cg_compiler_opensrc、compiler、jikespg-1.3、lwip-0.5.3.preproc、mpgcut-1.1、replaypc-0.4.0.preproc、ttt-0.10.1.preproc、zlib-1.1.4，这9个项目，只需要添加--c_std gnu89 之后，正常的配置参数运行即可。flex-2.5.31、jpeg-6b、libmspack、libpng-1.2.5、linux-2.4.23-pre3-testplatform、mpeg2dec-0.3.1、OpenTCP-1.0.4、teem-1.6.0-src、unrarlib-0.4.0则需要一些额外的--c_flags参数。

本次测试采用的是LLVM22.1.0-rc2的x86、RISC-V和AArch64版本，其中RISC-V和AArch64为交叉工具链（宿主x86_64），AArch64命令需要在 --c_flags 中显式添加 --target=aarch64-unknown-linux-gnu。

如需把优化工具链与基线工具链分开（例如基线用普通工具链、pass 评分与训练用优化工具链），用 scripts/run_csibe_build.py 运行并追加 --opt_x86_path/--opt_riscv_path/--opt_aarch64_path（对应架构命令自动追加 --opt_tools_path）。

具体如下：

## 1.bzip2-1.0.2
x86：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/bzip2-1.0.2/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/bzip2-1.0.2/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/bzip2-1.0.2/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 2.cg_compiler_opensrc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/cg_compiler_opensrc/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/cg_compiler_opensrc/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/cg_compiler_opensrc/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 3.compiler
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 4.flex-2.5.31
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DHAVE_CONFIG_H' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DHAVE_CONFIG_H' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DHAVE_CONFIG_H --target=aarch64-unknown-linux-gnu' --search_scope project

## 5.jikespg-1.3
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jikespg-1.3/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jikespg-1.3/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jikespg-1.3/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 6.jpeg-6b
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jpeg-6b/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DSTDC_HEADERS' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jpeg-6b/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DSTDC_HEADERS' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jpeg-6b/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DSTDC_HEADERS --target=aarch64-unknown-linux-gnu' --search_scope project

## 7.libmspack
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libmspack/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libmspack/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE --sysroot=/opt/riscv/sysroot' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libmspack/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE --target=aarch64-unknown-linux-gnu' --search_scope project

## 8.libpng-1.2.5
x86：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libpng-1.2.5/ --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libpng-1.2.5/ --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-I../include/zlib' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libpng-1.2.5/ --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 9.linux-2.4.23-pre3-testplatform

CSiBE自带脚本编译出来的文件，没有这个项目。Linux 内核的 .c 文件几乎都不能被 clang 独立编译，必须走内核构建系统（CSiBE 自己的 Makefile 也只带完整 CFLAGS 编译其中一小部分）。ruyituner 对这种文件的设计行为就是告警并跳过（仅在全部失败时才报错），Readme 的"注意事项"里也写了这一点。所以这个项目不做处理。

## 10.lwip-0.5.3.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 11.mpeg2dec-0.3.1
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpeg2dec-0.3.1 --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpeg2dec-0.3.1 --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpeg2dec-0.3.1 --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude --target=aarch64-unknown-linux-gnu' --search_scope project

## 12.mpgcut-1.1
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpgcut-1.1 --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpgcut-1.1 --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpgcut-1.1 --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 13.OpenTCP-1.0.4
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/OpenTCP-1.0.4 --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -D__IO_NEAR -D__io=' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/OpenTCP-1.0.4 --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -D__IO_NEAR -D__io=' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/OpenTCP-1.0.4 --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu -Iinclude -D__IO_NEAR -D__io=' --search_scope project

## 14.replaypc-0.4.0.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/replaypc-0.4.0.preproc --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/replaypc-0.4.0.preproc --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/replaypc-0.4.0.preproc --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 15.teem-1.6.0-src
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/teem-1.6.0-src --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -DTEEM_32BIT=1 -DTEEM_ENDIAN=1234 -DTEEM_QNANHIBIT=1 -DTEEM_BIGBITFIELD=1 -DTEEM_DIO=0 -DTEEM32BIT=1' --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/teem-1.6.0-src --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -DTEEM_32BIT=1 -DTEEM_ENDIAN=1234 -DTEEM_QNANHIBIT=1 -DTEEM_BIGBITFIELD=1 -DTEEM_DIO=0 -DTEEM32BIT=1' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/teem-1.6.0-src --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -DTEEM_32BIT=1 -DTEEM_ENDIAN=1234 -DTEEM_QNANHIBIT=1 -DTEEM_BIGBITFIELD=1 -DTEEM_DIO=0 -DTEEM32BIT=1 --target=aarch64-unknown-linux-gnu' --search_scope project

## 16.ttt-0.10.1.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/ttt-0.10.1.preproc --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/ttt-0.10.1.preproc --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/ttt-0.10.1.preproc --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project

## 17.unrarlib-0.4.0
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/unrarlib-0.4.0 --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iunrarlib' --search_scope project

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/unrarlib-0.4.0 --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iunrarlib' --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/unrarlib-0.4.0 --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iunrarlib --target=aarch64-unknown-linux-gnu' --search_scope project

## 18.zlib-1.1.4
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/zlib-1.1.4 --baseline_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/zlib-1.1.4 --baseline_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --search_scope project

aarch64:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/zlib-1.1.4 --baseline_tools_path /home/XXX/llvm-project/build-aarch64/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '--target=aarch64-unknown-linux-gnu' --search_scope project