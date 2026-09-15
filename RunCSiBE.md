# RuyiTuner 运行CSiBE说明

本文档为RuyiTuner运行datasets/c_files/CSiBE-v2.1.1下各个项目的详细说明，每个项目都给出了运行的具体命令参数，运行过程中注意替换工具链路径为本地路径。

bzip2-1.0.2、cg_compiler_opensrc、compiler、jikespg-1.3、lwip-0.5.3.preproc、mpgcut-1.1、replaypc-0.4.0.preproc、ttt-0.10.1.preproc、zlib-1.1.4，这9个项目，只需要添加--c_std gnu89 之后，正常的配置参数运行即可。

flex-2.5.31、jpeg-6b、libmspack、libpng-1.2.5、linux-2.4.23-pre3-testplatform、mpeg2dec-0.3.1、OpenTCP-1.0.4、teem-1.6.0-src、unrarlib-0.4.0则需要一些额外的--c_flags参数。

具体如下：

## 1.bzip2-1.0.2
x86：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/bzip2-1.0.2/  --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89
9个文件都能成功，平均优化率为15.43%

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/bzip2-1.0.2/  --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89
9个文件都能成功，平均优化率为 8.68%

## 2.cg_compiler_opensrc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/cg_compiler_opensrc/  --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89
22个文件都能成功，平均优化率为30.99%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/cg_compiler_opensrc/   --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89
22个文件都能成功，平均优化率为28.74%

## 3.compiler
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/  --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89
6个文件都能成功，平均优化率42%。

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/compiler/  --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89
6个文件都能成功，平均优化率53.94%

## 4.flex-2.5.31
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31/ --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DHAVE_CONFIG_H'
22个文件都能成功，，平均优化率11.45%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/flex-2.5.31/ --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DHAVE_CONFIG_H'
22个文件都能成功，，平均优化率9.74%

## 5.jikespg-1.3
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jikespg-1.3/     --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89
17个文件都能成功，平均优化率11.42%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jikespg-1.3/     --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89
17个文件都能成功，平均优化率10.61%

## 6.jpeg-6b
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jpeg-6b/     --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DSTDC_HEADERS'
67个文件都能成功，平均优化率37.93%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/jpeg-6b/     --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin      --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-DSTDC_HEADERS'
67个文件都能成功，平均优化率36.87%

## 7.libmspack
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libmspack/ --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -I/home/XXX/ruyi-tuner/datasets/c_files/CSiBE-v2.1.1/libmspack/mspack'
25个文件都能成功，平均优化率40.29%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libmspack/ --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -I/home/XXX/ruyi-tuner/datasets/c_files/CSiBE-v2.1.1/libmspack/mspack --sysroot=/opt/riscv/sysroot'
25个文件都能成功，平均优化率34.51%

## 8.libpng-1.2.5
x86：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libpng-1.2.5/     --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
18个文件都能成功，平均优化率7.82%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/libpng-1.2.5/ --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-I../include/zlib'
18个文件都能成功，平均优化率8.95%

## 9.linux-2.4.23-pre3-testplatform
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/linux-2.4.23-pre3-testplatform     --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
 C→IR 编译完成: 成功 22 个, 失败 878 个.
CSiBE编译出来的，直接没有这个项目。Linux 内核的 .c 文件几乎都不能被 clang 独立编译，必须走内核构建系统（CSiBE 自己的 Makefile 也只带完整 CFLAGS 编译其中一小部分）。ruyituner 对这种文件的设计行为就是告警并跳过（仅在全部失败时才报错），Readme 的"注意事项"里也写了这一点。
22个文件，极个别优化率极高，大批没有优化的，平均优化率37.51%。

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/linux-2.4.23-pre3-testplatform     --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89
C→IR 编译完成: 成功 19 个, 失败 881 个.
19个文件，极个别优化率极高，大批没有优化的，平均优化率33.78%

## 10.lwip-0.5.3.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc     --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
30个文件都能成功，平均优化率10.24%

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/lwip-0.5.3.preproc     --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89
30个文件都能成功，平均优化率 13.53%

## 11.mpeg2dec-0.3.1
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpeg2dec-0.3.1 --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude'
C→IR 编译完成: 成功 28 个, 失败 1 个.
28个文件成功，平均优化率61.47%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpeg2dec-0.3.1 --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude'
C→IR 编译完成: 成功 28 个, 失败 1 个.
28个文件成功，平均优化率12.51%

## 12.mpgcut-1.1
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpgcut-1.1    --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89
1个文件都能成功，平均优化率2.31%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/mpgcut-1.1    --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin  --count_mode obj-size --input_type c --c_std gnu89
1个文件都能成功，平均优化率0.90%

## 13.OpenTCP-1.0.4
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/OpenTCP-1.0.4 --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -D__IO_NEAR -D__io='
22个文件都能成功，平均优化率35.74%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/OpenTCP-1.0.4 --llvm_tools_path /home/XXX/llvm-project//build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -D__IO_NEAR -D__io='
22个文件都能成功，平均优化率37.47%

## 14.replaypc-0.4.0.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/replaypc-0.4.0.preproc    --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
 C→IR 编译完成: 成功 38 个, 失败 1 个.
38个文件成功，平均优化率15.68%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/replaypc-0.4.0.preproc    --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89 
 C→IR 编译完成: 成功 38 个, 失败 1 个.
38个文件成功，平均优化率13.74%

## 15.teem-1.6.0-src
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/teem-1.6.0-src --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -DTEEM_32BIT=1 -DTEEM_ENDIAN=1234 -DTEEM_QNANHIBIT=1 -DTEEM_BIGBITFIELD=1 -DTEEM_DIO=0 -DTEEM32BIT=1'
293个文件都能成功，平均优化率26.20%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/teem-1.6.0-src --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iinclude -DTEEM_32BIT=1 -DTEEM_ENDIAN=1234 -DTEEM_QNANHIBIT=1 -DTEEM_BIGBITFIELD=1 -DTEEM_DIO=0 -DTEEM32BIT=1'
293个文件都能成功，平均优化率22.27%

## 16.ttt-0.10.1.preproc
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/ttt-0.10.1.preproc    --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
6个文件都能成功，平均优化率33.02%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/ttt-0.10.1.preproc    --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89 
6个文件都能成功，平均优化率27.19%

## 17.unrarlib-0.4.0
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/unrarlib-0.4.0 --llvm_tools_path /home/XXX/llvm-project/build-x86/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iunrarlib'
3个文件都能成功，平均优化率23.99%

riscv：
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/unrarlib-0.4.0 --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin --count_mode obj-size --input_type c --c_std gnu89 --c_flags '-Iunrarlib'
3个文件都能成功，平均优化率23.70%

## 18.zlib-1.1.4
x86:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/zlib-1.1.4    --llvm_tools_path /home/XXX/llvm-project/build-x86/bin     --count_mode obj-size --input_type c --c_std gnu89 
16个文件都能成功，平均优化率30.62%

riscv:
python3 ruyituner.py --dataset datasets/c_files/CSiBE-v2.1.1/zlib-1.1.4    --llvm_tools_path /home/XXX/llvm-project/build-riscv/bin     --count_mode obj-size --input_type c --c_std gnu89 
16个文件都能成功，平均优化率35.19%