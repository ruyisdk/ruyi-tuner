import os
from concurrent.futures import ThreadPoolExecutor
from utils.common import get_instrcount, _log_line


class PassSyner:
    def __init__(self, datasetpath, llvm_tools_path, passlist, num_works, count_mode='auto', search_scope='file'):
        self.datasetpath = datasetpath
        self.llvm_tools_path = llvm_tools_path
        self.Passes = passlist
        self.num_works = num_works
        self.count_mode = count_mode
        self.search_scope = search_scope

    def _process_file(self, filepath, index=None, total=None):
        with open(filepath, 'r') as ll_file:
            ll_code = ll_file.read()
        # 进度行与结果行统一带 [序号/总数] 前缀, 结果行再带文件名: 各文件并行
        # 处理, 输出顺序不固定, 靠前缀对应到具体文件
        tag = f'[{index}/{total}] ' if index is not None and total is not None else ''
        name = os.path.basename(filepath)
        _log_line(f'{tag}Processing: {filepath}')

        original_codesize = get_instrcount(ll_code, [], tools_path=self.llvm_tools_path, count_mode=self.count_mode)
        syner_passpairs = []
        action_aval = []

        sinpass_ic = {}

        # opt 超时黑名单: 超时过的 pass 在本文件后续不再尝试
        timed_out = set()
        # opt 失败黑名单: 单独运行即失败 (崩溃或输出无法统计) 的 pass 在本文件
        # 后续不再尝试; 其计数会回退为原始 IR, 不可能产生收益, 提前剔除可省去
        # 与所有 pass 的组合尝试
        failed = set()

        # find valid passes
        for action in self.Passes:
            ok = [True]
            action_ic = get_instrcount(ll_code, [action], tools_path=self.llvm_tools_path,
                                       count_mode=self.count_mode, timed_out=timed_out,
                                       ok_out=ok)
            if not ok[0] and action not in timed_out:
                failed.add(action)
            sinpass_ic.update({action: action_ic})
            code_size_change = original_codesize - action_ic
            if code_size_change > 0:
                action_aval.append(action)

        if failed:
            _log_line(f'{tag}{name}: 剔除 {len(failed)} 个单独运行即失败的 pass: {sorted(failed)}')

        # 组合级失败计数: 两个 pass 单独可用但组合后 opt 失败, 只跳过该组合、
        # 不剔除任何 pass (单独运行无元凶, 无法安全归因到某一个 pass)
        pair_failures = 0
        for action2 in action_aval:
            if action2 in timed_out or action2 in failed:
                continue
            for action1 in self.Passes:
                if action1 in timed_out or action1 in failed:
                    continue
                code_size_org = sinpass_ic.get(action2)
                ok = [True]
                code_size_now = get_instrcount(ll_code, [action1, action2],
                                               tools_path=self.llvm_tools_path,
                                               count_mode=self.count_mode,
                                               timed_out=timed_out, ok_out=ok)
                if not ok[0]:
                    pair_failures += 1
                    continue
                code_size_change = code_size_org - code_size_now
                if code_size_change > 0:
                    syner_passpairs.append((action1, action2))

        if pair_failures:
            _log_line(f'{tag}{name}: 跳过 {pair_failures} 个组合级 opt 失败 '
                      f'(两个 pass 单独可用但组合后失败)。')

        _log_line(f'{tag}{name}: 协同 pass 对数量 {len(syner_passpairs)}')

        # 始终返回本文件的失败黑名单: project 模式下 FindSynerPasses 汇总各文件
        # 的 failed 集合形成全局黑名单, 无协同对的文件同样参与汇总
        return name, syner_passpairs, failed

    def FindSynerPasses(self):
        """查找所有 .ll 文件的协同 pass 对, 返回 [(文件名, [(A, B), ...]), ...].

        结果不再写 CSV, 在内存中返回供调用方直接枚举去重.

        search_scope 为 project 时, 先把"在任一文件上单独运行即失败"的 pass
        汇总成全局黑名单, 再从各文件的协同对中剔除含黑名单 pass 的协同对:
        这些 pass 必然使 project 模式的公共序列在对应文件上崩溃, 不进 Step1
        可让优化阶段不再遭遇它们的崩溃."""
        ll_files = []
        if os.path.isfile(self.datasetpath):
            if self.datasetpath.endswith('.ll'):
                ll_files.append(self.datasetpath)
        else:
            for root, dirs, files in os.walk(self.datasetpath):
                for file in files:
                    if file.endswith(".ll"):
                        ll_files.append(os.path.join(root, file))

        results = []
        total = len(ll_files)
        if total:
            _log_line(f'协同对查找开始: 共 {total} 个 .ll 文件, '
                      f'并行线程 {min(self.num_works, total)} 个.')
        with ThreadPoolExecutor(max_workers=self.num_works) as executor:
            futures = [executor.submit(self._process_file, filepath, index, total)
                       for index, filepath in enumerate(ll_files, 1)]
            for future in futures:
                result = future.result()
                if result is not None:
                    results.append(result)

        # 各文件协同对数量求和 (同一协同对可能被多个文件找到, 去重后才是 Step1
        # 的实际条目数)
        generated_pairs = sum(len(pairs) for _, pairs, _ in results)
        _log_line(f'协同对生成总数: {generated_pairs} 个 (各文件求和, 未去重).')

        if self.search_scope == 'project':
            # 全局黑名单: 任一文件上单独运行即失败的 pass (崩溃/无法统计)
            global_failed = set()
            for _, _, failed in results:
                global_failed |= failed
            if global_failed:
                print(f"project 模式全局剔除 {len(global_failed)} 个在部分文件上单独运行即失败的 pass: {sorted(global_failed)}")
            final = []
            dropped = 0
            for filename, pairs, _ in results:
                if global_failed:
                    kept = [p for p in pairs if p[0] not in global_failed and p[1] not in global_failed]
                    dropped += len(pairs) - len(kept)
                else:
                    kept = pairs
                if kept:
                    final.append((filename, kept))
            if dropped:
                print(f"project 模式因全局剔除跳过 {dropped} 个协同对。")
            results = final
        else:
            results = [(filename, pairs) for filename, pairs, _ in results if pairs]

        kept_pairs = sum(len(pairs) for _, pairs in results)
        unique_pairs = len({pair for _, pairs in results for pair in pairs})
        print(f"协同对查找完成: {len(results)} 个文件找到协同 pass 对, "
              f"保留 {kept_pairs} 个协同对, 去重后 {unique_pairs} 个唯一协同对.")
        return results

    