import os
import csv
import threading
from concurrent.futures import ThreadPoolExecutor
from utils.common import get_instrcount


class PassSyner:
    def __init__(self, datasetpath, llvm_tools_path, passlist, num_works, count_mode='auto'):
        self.datasetpath = datasetpath
        self.llvm_tools_path = llvm_tools_path
        self.Passes = passlist
        self.num_works = num_works
        self.count_mode = count_mode
        self.lock = threading.Lock()

    def _process_file(self, filepath, output_csv_path):
        with open(filepath, 'r') as ll_file:
            ll_code = ll_file.read()
        print("Processing:", filepath)

        original_codesize = get_instrcount(ll_code, [], llvm_tools_path=self.llvm_tools_path, count_mode=self.count_mode)
        syner_passpairs = []
        action_aval = []

        sinpass_ic = {}

        # find valid passes
        for action in self.Passes:
            action_ic = get_instrcount(ll_code, [action], llvm_tools_path=self.llvm_tools_path, count_mode=self.count_mode)
            sinpass_ic.update({action: action_ic})
            code_size_change = original_codesize - action_ic
            if code_size_change > 0:
                action_aval.append(action)

        for action2 in action_aval:
            for action1 in self.Passes:
                code_size_org = sinpass_ic.get(action2)
                code_size_now = get_instrcount(ll_code, [action1, action2], llvm_tools_path=self.llvm_tools_path, count_mode=self.count_mode)
                code_size_change = code_size_org - code_size_now
                if code_size_change > 0:
                    syner_passpairs.append((action1, action2))

        print(f"The number of syner_passpairs in {filepath}: " , len(syner_passpairs))
        
        filename = os.path.basename(filepath)

        # 空列表行直接跳过, 不写入，替代原来的过滤步骤
        if not syner_passpairs:
            return

        with self.lock:
            with open(output_csv_path, 'a', newline='') as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow([filename, syner_passpairs])

    def FindSynerPasses(self, output_csv_path):
        ll_files = []
        for root, dirs, files in os.walk(self.datasetpath):
            for file in files:
                if file.endswith(".ll"):
                    ll_files.append(os.path.join(root, file))

        with open(output_csv_path, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Filename', 'Synerpairlist'])

        with ThreadPoolExecutor(max_workers=self.num_works) as executor:
            futures = [executor.submit(self._process_file, filepath, output_csv_path) for filepath in ll_files]
            for future in futures:
                future.result()

        print(f"Results saved to {output_csv_path}")

    