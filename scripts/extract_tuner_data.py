#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""从 ruyituner 运行输出日志中抽取实际编译对比数据, 生成 CSV/TSV.

功能:
    解析 ruyituner 的输出日志 (如 tuner1-9-data), 按项目抽取 x86 / riscv
    两种架构的基线大小、实际编译后总大小、实际代码体积缩减率, 输出为表格文件.

输出列:
    项目名称 | x86基线大小 | x86实际编译后总大小 | x86实际代码体积缩减率
             | riscv基线大小 | riscv实际编译后总大小 | riscv实际代码体积缩减率

用法:
    python3 scripts/extract_tuner_data.py <输入日志> <输出文件>

    - <输出文件> 后缀决定列分隔符: .tsv 用制表符 (粘贴到 Excel/WPS 每列自动分开),
      其余后缀用逗号.
    - 也可用 --delimiter 显式指定分隔符.

示例:
    # 生成制表符分隔的文件
    python3 scripts/extract_tuner_data.py /home/ruyituner1-9-data output/实际编译对比.tsv
    # 生成逗号分隔的 CSV
    python3 scripts/extract_tuner_data.py /home/ruyituner1-9-data output/实际编译对比.csv
"""
import argparse
import csv
import re

PROJECT_RE = re.compile(r'^(\d+)\.\s*(.+)$')
ARCH_RE = re.compile(r'^(x86|riscv)\s*[:：]?$')
METRIC_RE = re.compile(
    r'^\[ruyituner\] (基线大小 .+): (\d+)$'
    r'|^\[ruyituner\] (实际编译后总大小): (\d+)$'
    r'|^\[ruyituner\] (实际代码体积缩减率): ([\d.]+)%$'
)

METRIC_KEYS = {
    '基线大小 (来自前一步 GA 输出)': 'baseline',
    '实际编译后总大小': 'actual',
    '实际代码体积缩减率': 'reduction',
}


def parse(path):
    projects = []  # [(name, {arch: {baseline, actual, reduction}})]
    cur_name = None
    cur_arch = None
    cur_data = {}

    with open(path, encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            m = PROJECT_RE.match(line)
            if m:
                if cur_name is not None and cur_data:
                    projects.append((cur_name, cur_data))
                cur_name = m.group(2)
                cur_arch = None
                cur_data = {}
                continue
            m = ARCH_RE.match(line)
            if m:
                cur_arch = m.group(1)
                cur_data.setdefault(cur_arch, {})
                continue
            m = METRIC_RE.match(line)
            if m:
                if m.group(1) is not None:  # 基线大小
                    key = METRIC_KEYS['基线大小 (来自前一步 GA 输出)']
                    value = int(m.group(2))
                elif m.group(3) is not None:  # 实际编译后总大小
                    key = METRIC_KEYS['实际编译后总大小']
                    value = int(m.group(4))
                else:  # 缩减率 (保留原始字符串, 避免丢失末尾的 0)
                    key = METRIC_KEYS['实际代码体积缩减率']
                    value = m.group(6)
                if cur_arch is None:
                    continue
                cur_data.setdefault(cur_arch, {})[key] = value
    if cur_name is not None and cur_data:
        projects.append((cur_name, cur_data))
    return projects


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('input')
    ap.add_argument('output')
    ap.add_argument('--delimiter', default='',
                    help='列分隔符 (默认: 按输出文件后缀 .tsv 用制表符, 否则用逗号)')
    args = ap.parse_args()

    if args.delimiter:
        delim = args.delimiter
    elif args.output.lower().endswith('.tsv'):
        delim = '\t'
    else:
        delim = ','

    projects = parse(args.input)
    header = [
        '项目名称',
        'x86基线大小', 'x86实际编译后总大小', 'x86实际代码体积缩减率(%)',
        'riscv基线大小', 'riscv实际编译后总大小', 'riscv实际代码体积缩减率(%)',
    ]
    with open(args.output, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, delimiter=delim)
        w.writerow(header)
        for name, data in projects:
            x86 = data.get('x86', {})
            riscv = data.get('riscv', {})

            def fmt_red(d):
                # 缩减率带上 % 号
                v = d.get('reduction', '')
                return f'{v}%' if v != '' else ''

            w.writerow([
                name,
                x86.get('baseline', ''), x86.get('actual', ''),
                fmt_red(x86),
                riscv.get('baseline', ''), riscv.get('actual', ''),
                fmt_red(riscv),
            ])
    print(f'共 {len(projects)} 个项目, 已写入 {args.output}')


if __name__ == '__main__':
    main()
