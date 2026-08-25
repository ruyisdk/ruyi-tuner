# RuyiTuner 版本变更记录

## 1.0版本位于分支v1.0上；

## 1.x版本位于分支v1.x上，是基于1.0版本进行的后续开发。

### 1.1版本变更
- datasets下的.ll测试文件，都是x86架构的，将它们移动到datasets/x86下；
- 目前的passes.txt中的pass序列为LLVM21.1.8版本的，将passes.txt改为passes_21.1.8.txt，删除里边一些无法识别的pass和对缩减代码体积无益的stub类pass；添加LLVM22.1.0版本的pass序列文件passes_22.1.0.txt；
- 增加了脚本gen_passlist.py，它可以根据所使用的LLVM版本生成passes_XXX.txt的脚本，这样使得ruyituner能被更多版本的LLVM来使用；经过测试，生成的pass列表更加完整和高效，会自动去除对代码体积无益的stub等pass；
- 使用脚本gen_passlist.py生成了针对LLVM 21.1.8的passes_2118-gen.txt和针对LLVM 22.1.0的passes_2210-gen.txt；
- 将所有passes_XXX.txt移动到新建目录passes_examples下；
- 更新utils/common.py，增加了异常和错误处理代码，还增加了libAutophase处理前的准备代码，去除了一些libAutophase无法识别的LLVM22引入的新语法；
- 根据上述变动，更新Readme文件；同时，更新Readme中一些与代码不符的内容；

### 1.2版本变更
- 指令计数不再依赖lib/libAutophase_21_1_8.so,改为直接使用opt对IR文本统计，移除了ctypes加载代码和LLVM22新语法的预处理代码，也不再要求GLIBC_2.38；这种方式解决了lib/libAutophase_21_1_8.so对LLVM版本限制较多的情况；
- gen_passlist.py的解析检查相应改为用opt重新解析输出IR，并剔除输出为空模块(0条指令)的pass；
- 增加了新的统计方式，使用opt instcount stats（-passes=instcount -stats，需LLVM_FORCE_ENABLE_STATS=ON构建）进行指令计数，并且优先使用这种方式，失败时自动回退文本统计；
- run.py/train.py的输出信息中新增一行展示当前使用的指令计数方式（opt-stats或text）；
- 更新Readme中`环境要求`部分的 `LLVM 工具链`的内容。

### 1.3版本变更
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

### 1.4版本变更
- 新增RISC-V训练数据集datasets/riscv：使用面向RISC-V的交叉clang从C++源码生成10个.ll文件（clang++ -O0 -S -emit-llvm --target=riscv64-unknown-linux-gnu），覆盖整数运算/数组/矩阵/字符串switch/位操作/双精度浮点/结构体/排序查找/递归等类别，每个文件含main+scanf/printf I/O与多个C++修饰名函数，并内嵌riscv64的target triple与datalayout，风格与datasets/x86一致；
- 数据集生成的clang命令使用`-Xclang -disable-O0-optnone`，避免-O0默认的optnone/noinline属性导致opt跳过所有pass（表现为单pass指令数不减少、训练找不到协同对）；
- 修复utils/common.py中-Oz评分分支的目标参数问题：原--target=...是clang的参数，LLVM 21.x/22.x各build目录下的opt均不支持（实测均只接受-mtriple），导致--isriscv时-Oz评分静默回退为原始IR计数；该分支现不再附加任何目标参数，目标架构由IR内嵌的target triple决定；
- 移除--isriscv参数：ruyituner.py/train.py/run.py删除该命令行参数，utils/common.py、utils/GA.py、utils/PassSyner.py删除参数定义与透传，架构信息由每个.ll文件自身的内嵌target triple决定，天然支持RISC-V、x86及混合架构数据集；
- utils/GA.py新增防御处理：协同对列表为空时直接返回空路径与0分，避免GA在空协同对图上崩溃（IndexError）；
- train.py的pass列表生成默认剔除module(internalize)：opt独立运行该pass时会连同main一起internalize，随后清理类pass会清空整个模块，导致GA得分虚高为1.0（假胜利）；已在生成pass列表时默认排除，无需再手动加--extra_exclude；
- utils/common.py中opt执行失败的逐条报错([opt failed])默认静默输出，避免优化阶段大量pass组合崩溃信息淹没整体输出；设置环境变量`RUYITUNER_SHOW_OPT_FAILURES=1`可重新开启以便排查；
- scripts/run.py中0分文件的输出信息补充空行，避免与下一个文件的优化结果混排；
- 根据上述修改，更新Readme中对应参数说明。

### 1.5版本变更
- 新增--opt-level参数（ruyituner.py/run.py，默认Oz）：GA基线评分原来写死-Oz，现可由O0/O1/O2/O3/Os/Oz控制；utils/common.py的优化等级分支相应泛化，同时支持-Ox与default<Ox>两种写法；
- 将Readme中的版本变更记录拆分为独立的CHANGELOG.md，并按独立文件重新分级标题层级；Readme的版本章节改为指向CHANGELOG.md的链接，并注明新增条目追加到最新版本段；
- Readme细节更新：精简标题tagline；项目结构树修正（README.md改为Readme.md、去除根目录不存在的passes_XXX.txt条目、新增CHANGELOG.md）；训练示例的passfile路径改为passes_examples/passes_2210-gen.txt；环境要求补充pandas安装命令与RUYITUNER_SHOW_OPT_FAILURES环境变量说明；--num_workers描述改为"并行工作线程数"；项目简介按主题拆分段落并加粗关键词；
- Readme新增"注意事项"小节：小数据集上-Os/-Oz基线可能相同需更大真实程序、.ll文件需内嵌target triple且不带optnone（否则opt跳过pass）、RISC-V数据集需搭配面向RISC-V的交叉编译工具链opt；
- 使用方法补充细节说明：训练阶段补充协同对的发现过程（单Pass筛选+两两配对）、优化阶段补充GA算法简介/整体优化过程/评分标准与真实输出示例；
- 新增架构一致性校验：utils/common.py中check_dataset_arch_matches_opt在训练/优化前校验数据集.ll文件内嵌target triple的架构与opt默认目标架构一致（train.py/run.py均已接入），防止用x86目标架构的opt处理riscv数据（反之亦然）；文件缺失triple或架构不匹配时直接报错退出；
- Readme整体介绍改为突出Pass协同效应分析：标题tagline、项目简介与工作流程以协同效应为定位，遗传算法保留为搜索方法的描述（基于遗传算法搜索最优Pass序列），优化阶段对遗传算法的描述保持不变；
- 项目简介的使用方式中补充输入输出说明，并添加指向使用说明的跳转链接；
- scripts/run.py中0分文件的输出改为与正分文件相同的格式（统一输出Path/Score/Mean三行，0分时Path输出为空；Mean仍只统计正分文件、正分文件为空时记0.0；此前0分文件仅打印一行提示）；
- train.py生成pass列表时，被剔除pass的具体清单与原因默认不打印（仅输出剔除数量），设置环境变量`RUYITUNER_SHOW_EXCLUDED_PASSES=1`可恢复逐条输出；Readme`环境要求`同步补充该环境变量说明；