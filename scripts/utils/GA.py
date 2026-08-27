from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from utils.common import get_instrcount

def LeverageSyner_GA_codesize(edges, ll_code, llvm_tools_path, opt_level='Oz', count_mode='auto'):
        import random
        # 基线: 按用户指定的优化等级(opt_level, 默认Oz)优化后的指令数/代码大小
        baseline_count = get_instrcount(ll_code, [f'-{opt_level}'], llvm_tools_path=llvm_tools_path, count_mode=count_mode)
        if(baseline_count == 0):
            print("file", ll_code, f": {opt_level} baseline is 0!\n")
            return 0
        # 协同对列表为空时无法构建图, 直接返回空路径/零分, 避免 generate_population 崩溃
        if not edges:
            print("协同对列表为空, 跳过该文件.\n")
            return [], 0
        # 创建图
        graph = defaultdict(list)
        nodes = set()
        for start, end in edges:
            graph[start].append(end)
            nodes.add(start)
            nodes.add(end)

        # 遗传算法参数

        # random.seed(1234)
        POPULATION_SIZE = 100
        GENERATIONS = 10
        MUTATION_RATE = 0.5
        SELECTION_RATE = 0.1
        MAX_PATH_LENGTH = 2  # 限制路径的最大长度

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
        def fitness_function(path):
            score = (baseline_count - get_instrcount(ll_code, path, llvm_tools_path=llvm_tools_path, count_mode=count_mode)) / baseline_count
            return score, path

        def calculate_fitness(population):
            fitness_scores = []
            with ThreadPoolExecutor() as executor:
                futures = [executor.submit(fitness_function, path) for path in population]
                for future in futures:
                    max_score, best_sub_path = future.result()  # 获取最大分数和对应的子路径
                    fitness_scores.append((max_score, best_sub_path))  # 存储最大分数和子路径
            return sorted(fitness_scores, key=lambda x: x[0], reverse=True)

        # 选择
        def selection(fitness_scores, rate):
            selected = fitness_scores[:int(len(fitness_scores) * rate)]
            return [path for _, path in selected]

        # 交叉
        def crossover(parent1, parent2):
            # random.seed(1234)
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
            # random.seed(1234)
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


        # 遗传算法主函数
        def genetic_algorithm(nodes, graph, population_size, generations, mutation_rate, selection_rate, max_length):
            population = generate_population(graph, nodes, population_size, max_length)
            # population = generate_random_init_population(label, csv_path)
            fitness_scores = calculate_fitness(population)
            for i in range(generations):
                fitness_scores = calculate_fitness(population)
                # print(f"best score in generation {i}: ", fitness_scores[0][0])
                selected = selection(fitness_scores, selection_rate)
                next_population = []
                while len(next_population) < population_size:
                    parent1, parent2 = find_parents_with_common_nodes(selected)
                    child1, child2 = crossover(parent1, parent2)
                    next_population.append(mutate(child1, mutation_rate))
                    next_population.append(mutate(child2, mutation_rate))
                population = next_population
            final_fitness_scores = calculate_fitness(population)
            # 仅在输出时加非负约束: 最优得分为负时, 负值与对应路径没有意义,
            # 按无收益输出空路径与0分; 不改变适应度计算与选择过程
            if final_fitness_scores[0][0] < 0:
                return [], 0.0
            best_path = final_fitness_scores[0][1]
            best_cost = final_fitness_scores[0][0]
            return best_path, best_cost
        
        best_path, best_cost = genetic_algorithm(nodes, graph, POPULATION_SIZE, GENERATIONS, MUTATION_RATE, SELECTION_RATE, MAX_PATH_LENGTH)
        return best_path, best_cost