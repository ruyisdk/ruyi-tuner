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
│   ├── Step1_FindSynerPairs.csv       # 发现的协同Pass对
│   ├── Step2_FilterSynerPairs.csv     # 过滤后的协同Pass对
│   ├── Step3_EnumeratedPairs.csv      # 枚举的所有协同对
├── passes_examples/    # pass列表的一些示例文件
│   ├── passes_21.1.8.txt              # 手动筛选的LLVM 21.1.8版本的pass列表
│   ├── passes_22.1.0.txt              # 手动筛选的LLVM 22.1.0版本的pass列表
│   ├── passes_2118-gen.txt            # 脚本gen_passlist.py筛选的LLVM 21.1.8版本的pass列表
│   ├── passes_2210-gen.txt            # 脚本gen_passlist.py筛选的LLVM 22.1.0版本的pass列表
├── scripts/            # 主要执行脚本
│   ├── train.py        # 训练脚本：发现协同Pass对
│   └── run.py          # 运行脚本：使用GA优化代码
├── utils/              # 工具模块
│   ├── GA.py           # 遗传算法实现
│   ├── PassSyner.py    # Pass协同效应分析
│   └── common.py       # 公共工具函数
├── gen_passlist.py     # 根据所使用的LLVM版本生成passes_XXX.txt的脚本
|── README.md           # 项目说明文档
|── passes_XXX.txt      # 可自定义的LLVM Pass列表,可以采用脚本自动生成或者自己编辑
```

## 环境要求

- Python 3.7+
- pandas
- LLVM 工具链 (默认为 LLVM 21，如需使用其他版本，可以自行更换工具链以及pass列表)

## 使用方法

### 1. 准备阶段：生成passes_XXXX.txt

passes_XXXX.txt文件，可以通过手动选择来构建，也可以使用gen_passlist.py脚本来自动生成。gen_passlist.py生成的pass列表会自动进行检查输出IR是否可以被opt重新解析，避免在训练和优化阶段出现问题。

```bash
python gen_passlist.py --llvm_tools_path ../llvm_dir/build/bin --output passes_XXXX.txt
```

### 2. 训练阶段：发现协同Pass对

可自主添加LLVM Pass到 `passes_XXXX.txt` 文件中以及训练文件到datasets文件夹中作为补充。训练脚本会分析指定数据集中的 .ll 文件，识别具有协同效应的Pass组合，并生成三个阶段的CSV文件。

```bash
mkdir -p output
cd scripts
python3 train.py \
    --dataset ../datasets/x86 \
    --llvm_tools_path ../llvm_dir/build/bin \
    --output_dir ../output \
    --passfile ../passes_XXXX.txt
```

**参数说明：**
- `--dataset`: 包含 .ll 文件的数据集目录
- `--llvm_tools_path`: LLVM工具链路径（包含opt、llc等工具）
- `--output_dir`: 输出结果保存目录
- `--passfile`: LLVM Pass列表文件
- `--num_workers`: (可选) 并行处理的工作进程数，默认16
- `--isriscv`: (可选) 是否是针对RISC-V架构的代码优化

**输出文件：**
- `Step1_FindSynerPairs.csv`: 初步发现的协同Pass对
- `Step2_FilterSynerPairs.csv`: 过滤空列表后的结果
- `Step3_EnumeratedPairs.csv`: 枚举所有协同对的最终结果

### 3. 优化阶段：使用GA优化代码

使用训练得到的协同Pass对，通过遗传算法优化LLVM IR代码。

```bash
cd scripts
python3 run.py \
    --dataset ../datasets/x86 \
    --llvm_tools_path ../llvm_dir/build/bin \
    --paircsv ../output/Step3_EnumeratedPairs.csv
```

**参数说明：**
- `--dataset`: 待优化的 .ll 文件或包含 .ll 文件的目录
- `--llvm_tools_path`: LLVM工具链路径
- `--paircsv`: 训练阶段生成的协同Pass对CSV文件
- `--isriscv`: (可选) 是否是针对RISC-V架构的代码优化

**输出：**
- 输出用于优化的Pass序列
- 打印该序列下的优化得分
- 输出所有文件的平均优化得分


## 版本

### 1. 1.0版本位于分支v1.0上；

### 2. 1.x版本位于分支v1.x上，是基于1.0版本进行的后续开发。

#### 1.1版本变更
- datasets下的.ll测试文件，都是x86架构的，将它们移动到datasets/x86下；
- 目前的passes.txt中的pass序列为LLVM21.1.8版本的，将passes.txt改为passes_21.1.8.txt，删除里边一些无法识别的pass和对缩减代码体积无益的stub类pass；添加LLVM22.1.0版本的pass序列文件passes_22.1.0.txt；
- 增加了脚本gen_passlist.py，它可以根据所使用的LLVM版本生成passes_XXX.txt的脚本，这样使得ruyituner能被更多版本的LLVM来使用；经过测试，生成的pass列表更加完整和高效，会自动去除对代码体积无益的stub等pass；
- 使用脚本gen_passlist.py生成了针对LLVM 21.1.8的passes_2118-gen.txt和针对LLVM 22.1.0的passes_2210-gen.txt；
- 将所有passes_XXX.txt移动到新建目录passes_examples下；
- 更新utils/common.py，增加了异常和错误处理代码，还增加了libAutophase处理前的准备代码，去除了一些libAutophase无法识别的LLVM22引入的新语法；
- 根据上述变动，更新Readme文件；同时，更新Readme中一些与代码不符的内容；
- v1.1版本发布于2026年8月19日。

#### 1.2版本变更
- 更新utils/common.py：指令计数不再依赖lib/libAutophase_21_1_8.so,改为直接对IR文本统计，与InstCount/instcount pass口径一致，移除了ctypes加载代码和LLVM22新语法的预处理代码，也不再要求GLIBC_2.38；gen_passlist.py的解析检查相应改为用opt重新解析输出IR，并剔除输出为空模块(0条指令)的pass；