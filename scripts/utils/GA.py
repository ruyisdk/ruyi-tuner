from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from utils.common import get_c_object_size, get_instrcount


def _compute_baseline(ll_code, llvm_tools_path, opt_level, count_mode,
                      baseline_src=None, label='', baseline_tools_path=None):
    '''计算单个文件的基线大小.

    baseline_src 非 None 且计数方式为 obj-size 时 (即 C 输入场景), 基线改为
    直接用 clang -O<level> -c 把 C 源码编译为 .o 并统计 .text 大小, 与真实
    编译口径一致; clang 编译失败时回退 IR 口径基线. 其余情况维持原口径:
    用 opt -O<level> 优化 O0 级 IR 后计数/测大小.

    llvm_tools_path 为优化工具链 (候选序列评分用), baseline_tools_path 为
    基线工具链 (基线计算全程使用, 缺省与优化工具链相同).'''
    base_tools = baseline_tools_path or llvm_tools_path
    if baseline_src and count_mode == 'obj-size':
        size = get_c_object_size(
            baseline_src['src'], base_tools, opt_level=opt_level,
            c_std=baseline_src.get('c_std'),
            c_flags=baseline_src.get('c_flags'),
            cwd=baseline_src.get('src_root'))
        if size is not None:
            return size
        name = f' ({label})' if label else ''
        print(f'[baseline] clang -{opt_level} -c 直接编译失败, 回退 IR 口径基线{name}.')
    return get_instrcount(ll_code, [f'-{opt_level}'], tools_path=base_tools, count_mode=count_mode)


def _ga_search(graph, nodes, fitness_function, population_size=100, generations=10,
               mutation_rate=0.5, selection_rate=0.1, max_length=2, seed_paths=None):
    """遗传算法搜索最优 pass 序列 (单文件与项目两种模式共用).

    fitness_function(path) 返回 (得分, 路径); 本函数返回 (最优得分, 最优路径).
    seed_paths: 可选, 每代固定保留在种群中的种子序列 (项目模式硬约束重搜时用
    空序列兜底, 保证种群中始终至少有一个已知可用个体); 不传时行为不变."""
    import random

    def rate_text(score):
        # 硬约束适应度下不可行个体得分为 -inf, 进度输出单独标注为"不可行"
        return '不可行' if score == float('-inf') else f'{score * 100:.2f}%'

    # 初始种群生成
    def generate_population(graph, nodes, size, max_length):
        random.seed(1234)
        population = []
        for index in range(size):
            path = []
            available_nodes = sorted(set(nodes))
            current = random.choice(list(available_nodes))
            path.append(current)
            available_nodes.remove(current)

            while len(path) < max_length:
                next_nodes = graph[current]
                if len(next_nodes) != 0:
                    next_node = random.choice(next_nodes)
                    if next_node not in path:
                        path.append(next_node)
                        current = next_node
                        if current not in available_nodes:
                            break
                        available_nodes.remove(current)
                    else:
                        break
                else:
                    break

            population.append(path)
        return population

    # 计算适应度
    def calculate_fitness(population):
        fitness_scores = []
        with ThreadPoolExecutor() as executor:
            futures = [executor.submit(fitness_function, path) for path in population]
            for future in futures:
                score, best_sub_path = future.result()
                fitness_scores.append((score, best_sub_path))
        return sorted(fitness_scores, key=lambda x: x[0], reverse=True)

    # 选择
    def selection(fitness_scores, rate):
        selected = fitness_scores[:int(len(fitness_scores) * rate)]
        return [path for _, path in selected]

    # 交叉
    def crossover(parent1, parent2):
        common_nodes = set(parent1) & set(parent2)
        if not common_nodes:
            return parent1, parent2

        common_nodes = sorted(common_nodes)
        crossover_node = random.choice(list(common_nodes))
        idx1 = parent1.index(crossover_node)
        idx2 = parent2.index(crossover_node)

        child1 = parent1[:idx1] + parent2[idx2:]
        child2 = parent2[:idx2] + parent1[idx1:]

        return child1, child2

    def find_parents_with_common_nodes(selected):
        attempts = 0
        while attempts < 10:
            parent1, parent2 = random.sample(selected, 2)
            if set(parent1) & set(parent2):
                return parent1, parent2
            attempts += 1
        return selected[0], selected[1]

    # 变异
    def mutate(path, mutation_rate):
        if random.random() < mutation_rate:
            mutation_points = [i for i, node in enumerate(path) if len(graph[node]) > 1]
            if mutation_points:
                mutation_point = random.choice(mutation_points)
                current = path[mutation_point]
                next_node = random.choice(graph[current])
                mutated_path = path[:mutation_point + 1]
                mutated_path.append(next_node)
                current = next_node

                while current in graph and graph[current]:
                    next_nodes = graph[current]
                    next_node = random.choice(next_nodes)
                    if next_node not in mutated_path:
                        mutated_path.append(next_node)
                        current = next_node
                    else:
                        break

                path = mutated_path
        return path

    # 遗传算法主循环
    population = generate_population(graph, nodes, population_size, max_length)
    # 种子序列固定占种群末尾若干位, 保证每代都有已知可用个体参与进化
    if seed_paths:
        population = population[:population_size - len(seed_paths)] + list(seed_paths)
    print(f'GA 搜索开始: 种群 {population_size}, 代数 {generations}.')
    for i in range(generations):
        fitness_scores = calculate_fitness(population)
        print(f'GA 第 {i + 1}/{generations} 代: 当前最优缩减率 {rate_text(fitness_scores[0][0])}')
        selected = selection(fitness_scores, selection_rate)
        next_population = []
        while len(next_population) < population_size:
            parent1, parent2 = find_parents_with_common_nodes(selected)
            child1, child2 = crossover(parent1, parent2)
            next_population.append(mutate(child1, mutation_rate))
            next_population.append(mutate(child2, mutation_rate))
        population = (next_population[:population_size - len(seed_paths)] + list(seed_paths)
                      if seed_paths else next_population)
    final_fitness_scores = calculate_fitness(population)
    print(f'GA 搜索完成: 最优缩减率 {rate_text(final_fitness_scores[0][0])}')
    return final_fitness_scores[0][0], final_fitness_scores[0][1]


def LeverageSyner_GA_codesize_file(edges, ll_code, llvm_tools_path, opt_level='Oz', count_mode='auto', max_path_length=2, baseline_src=None, baseline_tools_path=None):
        # 基线: C 输入(obj-size 计数)时直接用 clang -O<level> -c 编译源码统计 .o,
        # 否则按用户指定的优化等级(opt_level, 默认Oz)优化 O0 级 IR 后计数/测大小;
        # 基线计算用 baseline_tools_path (缺省同优化工具链), 序列评分用 llvm_tools_path
        baseline_count = _compute_baseline(ll_code, llvm_tools_path, opt_level,
                                           count_mode, baseline_src,
                                           baseline_tools_path=baseline_tools_path)
        if(baseline_count == 0):
            # 基线大小为 0 时只提示跳过, 不再打印整个 .ll 文件内容 (文件名已由调用方打印);
            # obj-size 口径下通常为纯数据文件 (如 bzip2 的 randtable.c, .o 的 .text 为 0 字节)
            print(f"{opt_level} 基线为 0, 跳过该文件.")
            return [], 0.0, 0, 0
        # 协同对列表为空时无法构建图, 直接返回空路径/零分, 避免 generate_population 崩溃
        if not edges:
            print("协同对列表为空, 跳过该文件.\n")
            return [], 0.0, baseline_count, baseline_count
        # 创建图
        graph = defaultdict(list)
        nodes = set()
        for start, end in edges:
            graph[start].append(end)
            nodes.add(start)
            nodes.add(end)

        # 遗传算法参数
        POPULATION_SIZE = 100
        GENERATIONS = 10
        MUTATION_RATE = 0.5
        SELECTION_RATE = 0.1
        # 序列最大长度由 max_path_length 参数控制 (默认 2)

        # 单文件适应度: 相对指定优化等级基线的缩减比例
        def fitness_function(path):
            score = (baseline_count - get_instrcount(ll_code, path, tools_path=llvm_tools_path, count_mode=count_mode)) / baseline_count
            return score, path

        best_cost, best_path = _ga_search(graph, nodes, fitness_function,
                                          population_size=POPULATION_SIZE, generations=GENERATIONS,
                                          mutation_rate=MUTATION_RATE, selection_rate=SELECTION_RATE,
                                          max_length=max_path_length)
        # 仅在输出时加非负约束: 最优得分为负时, 负值与对应路径没有意义,
        # 按无收益输出空路径与0分; 不改变适应度计算与选择过程
        if best_cost < 0:
            return [], 0.0, baseline_count, baseline_count
        # 由得分反推最优路径的优化后大小, 避免重复运行 opt;
        # 得分为 0 (含浮点误差下的微小负值) 时, 优化后大小与基线一致, 不反超基线;
        # 大小本身是整数(字节数/指令数), 对反推值取整避免输出 13127.0 这类带小数尾巴的值
        after_count = baseline_count if best_cost <= 0 else round(baseline_count * (1.0 - best_cost))
        # 返回 (最优路径, 得分, 基线大小, 优化后大小), 供调用方汇总计算平均缩减率
        return best_path, best_cost, baseline_count, after_count


def _find_crashing_passes(path, failing_indices, codes, llvm_tools_path, count_mode):
    """定位单独运行即触发失败的 pass (硬约束重搜的元凶).

    最优序列整条管线在失败文件上崩溃, 元凶通常只是其中个别 pass: 对序列中的
    每个 pass (去重保序) 逐个在失败文件上单独运行, 单独运行即失败的 pass 即为
    元凶; 一个 pass 确认会在某个失败文件上崩溃后即不再测试其余失败文件."""
    culprits = set()
    for p in dict.fromkeys(path):
        for index in failing_indices:
            ok = [True]
            get_instrcount(codes[index], [p], tools_path=llvm_tools_path,
                           count_mode=count_mode, ok_out=ok)
            if not ok[0]:
                culprits.add(p)
                break
    return culprits


def _graph_without(graph, nodes, excluded):
    """返回剔除 excluded 中 pass 后的搜索图与节点集.

    重搜前把定位到的崩溃 pass 从图中剔除, 使 GA 种群不再被含这些 pass 的不可行
    个体稀释; 节点集保留所有未剔除 pass (单 pass 序列仍然合法)."""
    clean_graph = defaultdict(list)
    for start, ends in graph.items():
        if start in excluded:
            continue
        kept = [e for e in ends if e not in excluded]
        if kept:
            clean_graph[start] = kept
    clean_nodes = {n for n in nodes if n not in excluded}
    return clean_graph, clean_nodes


def LeverageSyner_GA_codesize_project(edges, file_codes, llvm_tools_path, opt_level='Oz', count_mode='auto', max_path_length=2, baseline_srcs=None, baseline_tools_path=None):
    """为项目(全部输入文件)寻找一条公共的最优 pass 序列 (聚合适应度 GA).

    file_codes: [(文件名, .ll 源码), ...];
    llvm_tools_path 为优化工具链 (序列评分用), baseline_tools_path 为基线
    工具链 (基线计算用, 缺省与优化工具链相同);
    baseline_srcs: 与 file_codes 对齐的 C 源文件信息列表 (C 输入时由 run.py
    从基线清单查得), 逐文件传给基线计算, 未匹配到源文件的元素为 None;
    适应度 = (Σ基线 - Σ优化后) / Σ基线, 即按文件大小加权的整体缩减率,
    与调用方的汇总口径一致; 序列在个别文件上 opt 失败时回退原始 IR 计数
    (视为无收益, 自然被惩罚);
    若最优序列在个别文件上 opt 失败 (真实编译阶段会回退直通编译, 项目内出现
    混合编译口径), 则先定位单独运行即失败的元凶 pass, 把这些 pass 从搜索图中
    剔除后, 在干净图上按"全文件可用"硬约束重搜一条对所有文件都适用的公共序列
    (以空序列兜底, 找不到更好的全可用序列时输出空路径与 0 分);
    基线为 0 的文件跳过; 无可评分文件或协同对列表为空时返回空路径与 0 分;
    返回 (最优路径, 得分, 总基线大小, 总优化后大小)."""
    if baseline_srcs is None:
        baseline_srcs = [None] * len(file_codes)
    # 逐文件计算基线, 基线为 0 的文件跳过
    codes = []
    names = []
    bases = []
    for (name, ll_code), baseline_src in zip(file_codes, baseline_srcs):
        base = _compute_baseline(ll_code, llvm_tools_path, opt_level,
                                 count_mode, baseline_src, label=name,
                                 baseline_tools_path=baseline_tools_path)
        if base == 0:
            print(f"{name}: {opt_level} 基线为 0, 跳过该文件.")
            continue
        codes.append(ll_code)
        names.append(name)
        bases.append(base)
    if not codes:
        print("没有基线非 0 的文件, 无法为项目寻找公共 pass 序列.")
        return [], 0.0, 0, 0
    total_baseline = sum(bases)

    # 协同对列表为空时无法构建图, 直接返回空路径/零分
    if not edges:
        print("协同对列表为空, 无法为项目寻找公共 pass 序列.\n")
        return [], 0.0, total_baseline, total_baseline

    # 创建图
    graph = defaultdict(list)
    nodes = set()
    for start, end in edges:
        graph[start].append(end)
        nodes.add(start)
        nodes.add(end)

    # 遗传算法参数 (与单文件模式一致)
    POPULATION_SIZE = 100
    GENERATIONS = 10
    MUTATION_RATE = 0.5
    SELECTION_RATE = 0.1
    # 序列最大长度由 max_path_length 参数控制 (默认 2)

    # (文件下标, 序列) -> (优化后大小, opt 管线是否成功) 的缓存: 不同个体/代数
    # 之间的序列大量重复, 缓存可避免重复运行 opt; 多线程下加锁避免同一序列重复计算
    import threading
    size_cache = {}
    cache_lock = threading.Lock()

    def file_size(index, path):
        key = (index, tuple(path))
        with cache_lock:
            cached = size_cache.get(key)
        if cached is not None:
            return cached
        ok = [True]
        size = get_instrcount(codes[index], list(path), tools_path=llvm_tools_path,
                              count_mode=count_mode, ok_out=ok)
        with cache_lock:
            size_cache[key] = (size, ok[0])
        return size, ok[0]

    # 聚合适应度: 全项目整体缩减率, 允许个别文件为负 (拖累其他文件的序列被自然惩罚)
    def aggregate_fitness(path):
        total_after = 0
        for index in range(len(codes)):
            size, _ok = file_size(index, path)
            total_after += size
        return (total_baseline - total_after) / total_baseline, path

    # 硬约束适应度: 任一文件的 opt 管线失败 (真实编译将回退直通编译) 时整个序列
    # 判为不可行 (-inf), 保证最终序列对所有文件可用、项目内编译口径一致
    def feasible_fitness(path):
        total_after = 0
        for index in range(len(codes)):
            size, ok = file_size(index, path)
            if not ok:
                return float('-inf'), path
            total_after += size
        return (total_baseline - total_after) / total_baseline, path

    best_cost, best_path = _ga_search(graph, nodes, aggregate_fitness,
                                      population_size=POPULATION_SIZE, generations=GENERATIONS,
                                      mutation_rate=MUTATION_RATE, selection_rate=SELECTION_RATE,
                                      max_length=max_path_length)
    # 最优序列若在个别文件上 opt 失败, 真实编译阶段只能对这些文件回退直通编译,
    # 项目内出现混合编译口径; 此时先定位元凶 pass, 再在剔除元凶的干净图上重搜
    failed_indices = [i for i in range(len(codes)) if not file_size(i, best_path)[1]]
    if failed_indices:
        failed_names = [names[i] for i in failed_indices]
        shown = ', '.join(failed_names[:5]) + (' ...' if len(failed_names) > 5 else '')
        print(f'最优序列在 {len(failed_names)} 个文件上 opt 失败 ({shown}),'
              f' 改按"全文件可用"硬约束重搜.')
        # 软约束最优序列 (含失败文件, 重搜前的解) 一并输出, 与最终 Path 行同格式,
        # 便于对照重搜前后的序列变化
        print('Path: ', best_path)
        culprits = _find_crashing_passes(best_path, failed_indices, codes,
                                         llvm_tools_path, count_mode)
        if culprits:
            print(f'定位到 {len(culprits)} 个单独运行即崩溃的 pass: {sorted(culprits)},'
                  f' 重搜前从搜索图中剔除.')
            search_graph, search_nodes = _graph_without(graph, nodes, culprits)
        else:
            print('未定位到单独运行即崩溃的 pass, 保持完整搜索图重搜.')
            search_graph, search_nodes = graph, nodes
        if not search_nodes:
            print('剔除崩溃 pass 后搜索图为空, 无可用公共序列, 按空序列输出.')
            hard_cost, hard_path = 0.0, []
        else:
            hard_cost, hard_path = _ga_search(search_graph, search_nodes, feasible_fitness,
                                              population_size=POPULATION_SIZE, generations=GENERATIONS,
                                              mutation_rate=MUTATION_RATE, selection_rate=SELECTION_RATE,
                                              max_length=max_path_length, seed_paths=[()])
        if hard_cost == float('-inf'):
            print('未找到对所有文件都可用的序列, 保持原最优序列 (失败文件按无收益计分).')
        else:
            best_cost, best_path = hard_cost, hard_path
    # 输出时加非负约束 (与单文件模式一致): 最优得分为负时按无收益输出空路径与 0 分
    if best_cost < 0:
        return [], 0.0, total_baseline, total_baseline
    after_count = total_baseline if best_cost <= 0 else round(total_baseline * (1.0 - best_cost))
    return best_path, best_cost, total_baseline, after_count

