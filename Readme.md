# RuyiTuner

基于遗传算法(GA)的LLVM编译优化Pass调优工具，通过识别和利用LLVM Pass之间的协同效应来优化代码大小和性能。

## 项目简介

RuyiTuner 是一个自动化的LLVM编译器优化工具，它通过以下步骤工作：

1. **训练阶段**: 分析LLVM Pass组合，发现具有协同效应的Pass对
2. **优化阶段**: 使用遗传算法和发现的协同Pass对优化LLVM IR代码

## 项目结构

```
├── datasets/           # LLVM IR (.ll) 测试文件
├── llvm_tools/      # LLVM工具链二进制文件
├── output/             # 训练输出结果
│   ├── Step1_FindSynerPairs.csv      # 发现的协同Pass对
│   ├── Step2_FilterSynerPairs.csv     # 过滤后的协同Pass对
│   ├── Step3_EnumeratedPairs.csv      # 枚举的所有协同对
├── scripts/            # 主要执行脚本
│   ├── train.py        # 训练脚本：发现协同Pass对
│   └── run.py          # 运行脚本：使用GA优化代码
├── utils/              # 工具模块
│   ├── GA.py           # 遗传算法实现
│   ├── PassSyner.py    # Pass协同效应分析
│   ├── common.py       # 公共工具函数
│   └── codesize_pairs.py  # 代码大小优化相关
|── README.md           # 项目说明文档
|── passes.txt           # 可自定义的LLVM Pass列表(应与llvm二进制文件的版本对应)
```

## 环境要求

- Python 3.7+
- pandas
- LLVM 工具链 (默认为 LLVM 21，如需使用其他版本，可以自行更换工具链以及pass列表)

## 使用方法

### 1. 训练阶段：发现协同Pass对

可自主添加LLVM Pass到 `passes.txt` 文件中以及训练文件到datasets文件夹中作为补充。训练脚本会分析指定数据集中的 .ll 文件，识别具有协同效应的Pass组合，并生成三个阶段的CSV文件。

```bash
mkdir -p output
cd scripts
python train.py \
    --dataset ../datasets \
    --llvm_tools_path ../llvm_tools \
    --output_dir ../output \
    --passfile ../passes.txt
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

### 2. 优化阶段：使用GA优化代码

使用训练得到的协同Pass对，通过遗传算法优化LLVM IR代码。

```bash
cd scripts
python run.py \
    --dataset ../datasets \
    --llvm_tools_path ../llvm_tools \
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




