
import sys
import os
import argparse as ap
import csv
import ast
import pandas as pd

# Get the absolute path of the current file
current_file_path = os.path.abspath(__file__)
# Get the parent directory of the current file
project_root = os.path.dirname(os.path.dirname(current_file_path))
sys.path.append(project_root)

from utils.PassSyner import PassSyner
from utils.common import get_inst_count_method


args = ap.ArgumentParser()
args.add_argument("--dataset", type=str, required=True, help="Dataset path for training containing .ll files")
args.add_argument("--llvm_tools_path", type=str, required=True, help="Path to a specific version LLVM binary files")
args.add_argument("--output_dir", type=str, required=True, help="output file path")
args.add_argument("--num_workers", type=int, default=16, help="number of workers for parallel processing")
args.add_argument("--passfile", type=str, required=True, help="the pass list to be used for synergistic pair finding, e.g., llvm21_1_8 or llvm18_1_6")
args.add_argument("--isriscv", action='store_true', help="Whether the target architecture is RISC-V, which requires special handling in clang command")
# Get the LLVM tools path from environment variables
args = args.parse_args()

print("Instruction counting method:", get_inst_count_method(args.llvm_tools_path))

"""
Step 1. Find synergistic pairs and save to CSV
"""

if args.llvm_tools_path is None:
    raise EnvironmentError("LLVM_TOOLS_PATH environment variable is not set.")
if not os.path.exists(args.passfile):
    raise FileNotFoundError(f"Pass file {args.passfile} does not exist.")
else:
    with open(args.passfile, 'r') as f:
        passlist = [line.strip() for line in f if line.strip()]

syner = PassSyner(args.dataset, args.llvm_tools_path, passlist=passlist, isriscv=args.isriscv, num_works=args.num_workers)
output_file = os.path.join(args.output_dir, 'Step1_FindSynerPairs.csv')
if not os.path.exists(output_file):
    with open(output_file, 'w') as f:
        pass
    print("Created output file:", output_file)
syner.FindSynerPasses(output_file)
print("Step1 Completed: Synergistic pairs have been found and saved to Step1_FindSynerPairs.csv")

"""
Step 2. Remove rows with empty lists and save to a new CSV
"""
output = os.path.join(args.output_dir, 'Step2_FilterSynerPairs.csv')
df = pd.read_csv(output_file)
# Remove rows where the Synerpairlist column is an empty list
df = df[df['Synerpairlist'].apply(lambda x: x != '[]')]

# Save the processed CSV file
df.to_csv(output, index=False)
print("Rows with empty lists have been successfully removed and saved to Step2_FilterSynerPairs.csv")

"""
Step 3. Enumerate synergistic pairs and save to a new CSV
"""
input_path = os.path.join(args.output_dir, 'Step2_FilterSynerPairs.csv')
output_path = os.path.join(args.output_dir, 'Step3_EnumeratedPairs.csv')

syner_list = []
# Open the original CSV file
with open(input_path, mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    
    # Open the new CSV file for writing enumerated results
    with open(output_path, mode='w', encoding='utf-8', newline='') as outfile:
        writer = csv.writer(outfile)
        
        # Write the header
        writer.writerow(['index', 'synerpair'])
        
        # Enumerate all list values in the rows and write to the new file
        index_counter = 0
        seen_elements = set()
        for row in reader:
            # Get the value from the 'Synerpairlist' column and parse it as a list
            value_str = row['Synerpairlist']
            value_list = ast.literal_eval(value_str)
            
            # Enumerate the values in the list and skip duplicates
            for element in value_list:
                if element not in seen_elements:
                    writer.writerow([index_counter, element])
                    syner_list.append(element)
                    seen_elements.add(element)
                    index_counter += 1
    
print("Step3 Completed: Enumeration completed and saved to Step3_EnumeratedPairs.csv")