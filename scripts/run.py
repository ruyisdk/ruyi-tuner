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
from utils.common import get_inst_count_method

parser = ap.ArgumentParser()
parser.add_argument("--dataset", type=str, required=True, help="the directory containing .ll files or specific .ll files to be tuned")
parser.add_argument("--llvm_tools_path", type=str, required=True, help="Path to a specific version LLVM binary files")
parser.add_argument("--paircsv", type=str, required=True, help="the synergistic pair list to be used for training")
parser.add_argument("--isriscv", action='store_true', help="Whether the target architecture is RISC-V, which requires special handling in clang command")

args = parser.parse_args()

print("Instruction counting method:", get_inst_count_method(args.llvm_tools_path))

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

all = []

for filename in filenames:

    with open(filename, 'r') as ll_file:
        ll_code = ll_file.read()
    print("Current File:", filename)  
    path, score = LeverageSyner_GA_codesize(pairlist, ll_code, isriscv=args.isriscv, llvm_tools_path=args.llvm_tools_path)
    if (score == 0):
        print(f"Score is 0: {filename}")
        continue
    all.append(score)
    print("Path: ", path)
    print("Score: ", score)
    print("Mean: ", sum(all) / len(all))
    print()

