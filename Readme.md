# RuyiTuner

基于遗传算法(GA)的LLVM编译优化Pass调优工具，通过识别和利用LLVM Pass之间的协同效应来优化代码大小和性能。

## 项目简介

RuyiTuner 是一个自动化的LLVM编译器优化工具，它通过以下步骤工作：

1. **训练阶段**: 分析LLVM Pass组合，发现具有协同效应的Pass对
2. **优化阶段**: 使用遗传算法和发现的协同Pass对优化LLVM IR代码

## 项目结构

```
├── datasets/           # LLVM IR (.ll) 测试文件
├── output/             # 训练输出结果
│   ├── Step1_FindSynerPairs.csv       # 发现的协同Pass对(已过滤空结果)
│   ├── Step2_EnumeratedPairs.csv      # 枚举的所有协同对
├── passes_examples/    # pass列表的一些示例文件
│   ├── passes_21.1.8.txt              # 手动筛选的LLVM 21.1.8版本的pass列表
│   ├── passes_22.1.0.txt              # 手动筛选的LLVM 22.1.0版本的pass列表
│   ├── passes_2118-gen.txt            # 自动生成的LLVM 21.1.8版本的pass列表
│   ├── passes_2210-gen.txt            # 自动生成的LLVM 22.1.0版本的pass列表
├── ruyituner.py        # 一键入口：依次执行训练(train.py)与优化(run.py)
├── scripts/            # 主要执行脚本
│   ├── train.py        # 训练脚本：发现协同Pass对（含pass列表自动生成）
│   ├── run.py          # 运行脚本：使用GA优化代码
│   └── utils/          # 工具模块
│       ├── GA.py       # 遗传算法实现
│       ├── PassSyner.py # Pass协同效应分析
│       └── common.py   # 公共工具函数
|── README.md           # 项目说明文档
|── passes_XXX.txt      # 可自定义的LLVM Pass列表,可以采用脚本自动生成或者自己编辑
```

## 环境要求

- Python 3.7+
- pandas
- LLVM 工具链
  - RuyiTuner 对 LLVM 版本没有硬性要求，较新版本的 LLVM 工具链均可使用，只需搭配与该版本匹配的 pass 列表（可手动构建，或由 train.py 自动生成，详见使用方法）。
  - 不同构建之间的区别仅在于指令计数方式：使用 `-DLLVM_FORCE_ENABLE_STATS=ON`（或 `-DLLVM_ENABLE_ASSERTIONS=ON`）构建的 opt 可通过 `opt -passes=instcount -stats` 进行指令计数；使用未启用统计（如默认 Release）构建的 opt 时，RuyiTuner 会自动回退为对 IR 文本的统计。两种方式计数结果基本一致，互不影响正确性。
  - RuyiTuner 只用到 opt，构建 LLVM 时执行 `ninja opt` 仅构建该工具即可，能显著节省构建时间。

## 使用方法

### 1. 一键完成训练与优化（ruyituner.py）

ruyituner.py 是对 train.py 和 run.py 的封装，一次调用即可依次完成训练与GA优化两个阶段。

```bash
# 完整流程：训练 → 用训练得到的协同Pass对做GA优化
python3 ruyituner.py \
    --dataset ./datasets/x86 \
    --llvm_tools_path /llvm_dir/build/bin

# 仅训练，不优化
python3 ruyituner.py \
    --dataset ./datasets/x86 \
    --llvm_tools_path /llvm_dir/build/bin \
    --only_train

# 仅优化（复用已有的Step2_EnumeratedPairs.csv）
python3 ruyituner.py \
    --dataset ./datasets/x86 \
    --llvm_tools_path /llvm_dir/build/bin \
    --only_run \
    --paircsv ./output/Step2_EnumeratedPairs.csv
```

**参数说明：**
- `--dataset`: 包含 .ll 文件的数据集目录（必选，训练与优化共用）
- `--llvm_tools_path`: LLVM工具链路径，包含opt（必选）
- `--output_dir`: (可选) 训练输出目录，默认项目根目录下的output/，自动创建
- `--passfile`: (可选) 训练用的pass列表文件；不提供时由train.py自动生成（默认不写文件）
- `--paircsv`: (可选) 优化用的协同对CSV，默认`<output_dir>/Step2_EnumeratedPairs.csv`
- `--num_workers`: (可选) 训练并行线程数，默认16
- `--passlist_output`/`--no_parse_check`/`--keep_instrumentation`/`--extra_exclude`: (可选) 透传给train.py的pass列表生成参数
- `--only_train`/`--only_run`: (可选) 仅执行训练/仅执行优化，两者不能同时使用

### 2. 训练阶段：生成pass列表并发现协同Pass对

训练需要一份与所使用LLVM版本匹配的pass列表（passes_XXXX.txt），可以手动选择构建，也可以由train.py自动生成；自动生成的pass列表会检查输出IR是否可以被opt重新解析，剔除不可用的pass，避免在训练和优化阶段出现问题。可自主添加LLVM Pass到passes_XXXX.txt文件中以及训练文件到datasets文件夹中作为补充。训练脚本会分析指定数据集中的 .ll 文件，识别具有协同效应的Pass组合，并生成两个阶段的CSV文件。

```bash
mkdir -p output
cd scripts

# 手动指定pass列表进行训练（--output_dir也可省略，默认使用项目根目录下的output/）
python3 train.py \
    --dataset ../datasets/x86 \
    --llvm_tools_path ../llvm_dir/build/bin \
    --output_dir ../output \
    --passfile ../passes_XXXX.txt

# 不提供--passfile，自动生成与LLVM版本匹配的pass列表后进行训练（--output_dir也可省略,默认使用项目根目录下的output/；pass列表默认不写文件，除非指定--passlist_output）
python3 train.py \
    --dataset ../datasets/x86 \
    --llvm_tools_path ../llvm_dir/build/bin \
    --output_dir ../output

# 仅生成pass列表，不训练
python3 train.py \
    --gen_passlist_only \
    --llvm_tools_path ../llvm_dir/build/bin \
    --passlist_output ../passes_XXXX.txt
```

**参数说明：**
- `--dataset`: 包含 .ll 文件的数据集目录（必选）
- `--llvm_tools_path`: LLVM工具链路径，包含opt（必选）
- `--output_dir`: (可选) 输出结果保存目录；未指定时自动创建并使用项目根目录下的output目录
- `--passfile`: (可选) LLVM Pass列表文件；不提供时自动生成与LLVM版本匹配的pass列表（默认不写文件）
- `--gen_passlist_only`: (可选) 仅生成pass列表并退出，不训练；该模式下--dataset/--output_dir可不提供
- `--passlist_output`: (可选) 指定时把自动生成的pass列表写入该文件；仅生成模式(--gen_passlist_only)未指定时默认写passes_<LLVM版本号>.txt
- `--no_parse_check`: (可选) 跳过输出IR的opt解析检查
- `--keep_instrumentation`: (可选) 保留插桩类pass（asan/tsan/pgo-*等，默认剔除）
- `--extra_exclude`: (可选) 额外的pass排除规则（正则表达式）
- `--num_workers`: (可选) 并行处理的工作进程数，默认16

**输出文件：**
- `Step1_FindSynerPairs.csv`: 发现的协同Pass对（写入时已过滤掉空列表行）
- `Step2_EnumeratedPairs.csv`: 枚举所有协同对的最终结果

### 3. 优化阶段：使用GA优化代码

使用训练得到的协同Pass对，通过遗传算法优化LLVM IR代码。

```bash
cd scripts
python3 run.py \
    --dataset ../datasets/x86 \
    --llvm_tools_path ../llvm_dir/build/bin \
    --paircsv ../output/Step2_EnumeratedPairs.csv
```

**参数说明：**
- `--dataset`: 待优化的 .ll 文件或包含 .ll 文件的目录
- `--llvm_tools_path`: LLVM工具链路径
- `--paircsv`: 训练阶段生成的协同Pass对CSV文件

**输出：**
- 输出用于优化的Pass序列
- 打印该序列下的优化得分
- 输出所有文件的平均优化得分


## 版本

### 1.0版本位于分支v1.0上；

### 1.x版本位于分支v1.x上，是基于1.0版本进行的后续开发。

#### 1.1版本变更
- datasets下的.ll测试文件，都是x86架构的，将它们移动到datasets/x86下；
- 目前的passes.txt中的pass序列为LLVM21.1.8版本的，将passes.txt改为passes_21.1.8.txt，删除里边一些无法识别的pass和对缩减代码体积无益的stub类pass；添加LLVM22.1.0版本的pass序列文件passes_22.1.0.txt；
- 增加了脚本gen_passlist.py，它可以根据所使用的LLVM版本生成passes_XXX.txt的脚本，这样使得ruyituner能被更多版本的LLVM来使用；经过测试，生成的pass列表更加完整和高效，会自动去除对代码体积无益的stub等pass；
- 使用脚本gen_passlist.py生成了针对LLVM 21.1.8的passes_2118-gen.txt和针对LLVM 22.1.0的passes_2210-gen.txt；
- 将所有passes_XXX.txt移动到新建目录passes_examples下；
- 更新utils/common.py，增加了异常和错误处理代码，还增加了libAutophase处理前的准备代码，去除了一些libAutophase无法识别的LLVM22引入的新语法；
- 根据上述变动，更新Readme文件；同时，更新Readme中一些与代码不符的内容；

#### 1.2版本变更
- 指令计数不再依赖lib/libAutophase_21_1_8.so,改为直接使用opt对IR文本统计，移除了ctypes加载代码和LLVM22新语法的预处理代码，也不再要求GLIBC_2.38；这种方式解决了lib/libAutophase_21_1_8.so对LLVM版本限制较多的情况；
- gen_passlist.py的解析检查相应改为用opt重新解析输出IR，并剔除输出为空模块(0条指令)的pass；
- 增加了新的统计方式，使用opt instcount stats（-passes=instcount -stats，需LLVM_FORCE_ENABLE_STATS=ON构建）进行指令计数，并且优先使用这种方式，失败时自动回退文本统计；
- run.py/train.py的输出信息中新增一行展示当前使用的指令计数方式（opt-stats或text）；
- 更新Readme中`环境要求`部分的 `LLVM 工具链`的内容。

#### 1.3版本变更
- 将gen_passlist.py的功能合并进scripts/train.py并删除原脚本，pass列表生成与训练由同一脚本完成；
- train.py的--passfile参数改为可选：提供时直接使用，不提供时自动生成与--llvm_tools_path匹配的pass列表后再训练（默认不写文件，除非指定--passlist_output）；
- 新增--gen_passlist_only参数：仅生成pass列表并退出，不进行训练（该模式下--dataset可不提供）；
- train.py的--output_dir参数改为可选：未指定时自动创建并使用项目根目录下的output目录，并输出提示信息（训练示例注释同步说明--output_dir可省略）；
- 新增pass列表生成相关参数：--passlist_output（指定生成文件路径）、--no_parse_check（跳过输出IR解析检查）、--keep_instrumentation（保留插桩类pass）、--extra_exclude（额外排除规则）；
- 新增ruyituner.py入口脚本，一次调用依次完成训练(train.py)与优化(run.py)两个阶段，支持--only_train/--only_run单独执行；
- 将utils工具模块移动到scripts目录下，并更新相关脚本中的路径引用；
- 训练阶段不再保存中间文件，空列表行的过滤在写入时直接完成，输出文件由3个减少为2个，并重新编号为Step1_FindSynerPairs.csv与Step2_EnumeratedPairs.csv；
- 更新Readme中`环境要求`部分对两种指令计数方式的描述：由"结果一致"改为"结果基本一致"（text与opt-stats在部分pass上计数存在细微差异，后续再排查）；
- 根据上述修改，更新Readme，包含合并`使用方法`部分的`准备阶段`与`训练阶段`，更新参数列表等内容。

#### 1.4版本变更
- 新增RISC-V训练数据集datasets/riscv：使用面向RISC-V的交叉clang从C++源码生成10个.ll文件（clang++ -O0 -S -emit-llvm --target=riscv64-unknown-linux-gnu），覆盖整数运算/数组/矩阵/字符串switch/位操作/双精度浮点/结构体/排序查找/递归等类别，每个文件含main+scanf/printf I/O与多个C++修饰名函数，并内嵌riscv64的target triple与datalayout，风格与datasets/x86一致；
- 数据集生成的clang命令使用`-Xclang -disable-O0-optnone`，避免-O0默认的optnone/noinline属性导致opt跳过所有pass（表现为单pass指令数不减少、训练找不到协同对）；
- 修复utils/common.py中-Oz评分分支的目标参数问题：原--target=...是clang的参数，LLVM 21.x/22.x各build目录下的opt均不支持（实测均只接受-mtriple），导致--isriscv时-Oz评分静默回退为原始IR计数；该分支现不再附加任何目标参数，目标架构由IR内嵌的target triple决定；
- 移除--isriscv参数：ruyituner.py/train.py/run.py删除该命令行参数，utils/common.py、utils/GA.py、utils/PassSyner.py删除参数定义与透传，架构信息由每个.ll文件自身的内嵌target triple决定，天然支持RISC-V、x86及混合架构数据集；
- utils/GA.py新增防御处理：协同对列表为空时直接返回空路径与0分，避免GA在空协同对图上崩溃（IndexError）；
- train.py的pass列表生成默认剔除module(internalize)：opt独立运行该pass时会连同main一起internalize，随后清理类pass会清空整个模块，导致GA得分虚高为1.0（假胜利）；已在生成pass列表时默认排除，无需再手动加--extra_exclude；
- utils/common.py中opt执行失败的逐条报错([opt failed])默认静默输出，避免优化阶段大量pass组合崩溃信息淹没整体输出；设置环境变量RUYITUNER_SHOW_OPT_FAILURES=1可重新开启以便排查；
- scripts/run.py中0分文件的输出信息补充空行，避免与下一个文件的优化结果混排；
- 根据上述修改，更新Readme中对应参数说明。