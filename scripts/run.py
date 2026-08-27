import os
import sys
import pandas as pd
import argparse as ap
from pathlib import Path



# Get the absolute path of the current file
current_file_path = os.path.abspath(__file__)
# Get the parent directory of the current file
project_root = os.path.dirname(os.path.dirname(current_file_path))
sys.path.append(project_root)
# scripts/ 目录, 保证从任意工作目录运行时都能 import utils
sys.path.insert(0, os.path.dirname(current_file_path))
from utils.GA import LeverageSyner_GA_codesize
from utils.common import get_inst_count_method, check_dataset_arch_matches_opt

parser = ap.ArgumentParser()
parser.add_argument("--dataset", type=str, required=True, help="the directory containing .ll files or specific .ll files to be tuned")
parser.add_argument("--llvm_tools_path", type=str, required=True, help="Path to a specific version LLVM binary files")
parser.add_argument("--paircsv", type=str, required=True, help="the synergistic pair list to be used for training")
parser.add_argument("--opt-level", type=str, default="Oz", choices=["O0", "O1", "O2", "O3", "Os", "Oz"], help="optimization level for the GA baseline scoring (default: Oz)")
parser.add_argument("--count_mode", type=str, default="auto", choices=["auto", "opt-stats", "text", "obj-size"], help="instruction counting mode for scoring (default: auto)")

args = parser.parse_args()

print("Instruction counting method:", get_inst_count_method(args.llvm_tools_path, count_mode=args.count_mode))

df = pd.read_csv(args.paircsv)
pairlist= df["synerpair"].tolist()
# 将列表中的元素由str转换为元组
pairlist = [eval(pair) for pair in pairlist]


if os.path.isdir(args.dataset):
    filenames = list(Path(args.dataset).rglob("*.ll"))
elif os.path.isfile(args.dataset) and args.dataset.endswith(".ll"):
    filenames = [args.dataset]
else:
    raise ValueError("The dataset argument must be a directory containing .ll files or a specific .ll file.")

# 校验数据集架构与 opt 默认目标一致, 避免用 x86 的 opt 处理 riscv 的 .ll 文件
check_dataset_arch_matches_opt([str(f) for f in filenames], os.path.join(args.llvm_tools_path, 'opt'))

all = []

for filename in filenames:

    with open(filename, 'r') as ll_file:
        ll_code = ll_file.read()
    print("Current File:", filename)  
    path, score = LeverageSyner_GA_codesize(pairlist, ll_code, llvm_tools_path=args.llvm_tools_path, opt_level=args.opt_level, count_mode=args.count_mode)
    # 0分文件也按统一格式输出, 平均分仍只统计正分文件; 0分时Path输出为空
    if (score != 0):
        all.append(score)
    mean = sum(all) / len(all) if all else 0.0
    print("Path: ", path if score != 0 else [])
    print("Code Size Reduction Rate: ", f"{score * 100:.2f}%")
    print("Mean Reduction Rate: ", f"{mean * 100:.2f}%")
    print()

