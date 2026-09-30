#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""从实际编译对比汇总文件中抽取数据, 生成 CSV/TSV.

功能:
    解析实际编译对比汇总文件 (如批量运行后生成的 output/CSiBE_Step3_summary.txt,
    也兼容旧的 ruyituner 运行日志), 按项目抽取 x86 / riscv 两种架构的
    基线大小、实际编译后总大小、实际代码体积缩减率, 输出为表格文件.

输出列:
    项目名称 | x86基线大小 | x86实际编译后总大小 | x86实际代码体积缩减率
             | riscv基线大小 | riscv实际编译后总大小 | riscv实际代码体积缩减率

用法:
    python3 scripts/extract_tuner_data.py [<输入汇总文件>] <输出文件>

    - <输入汇总文件> 省略时默认读取 output/CSiBE_Step3_summary.txt.
    - <输出文件> 后缀决定列分隔符: .tsv 用制表符 (粘贴到 Excel/WPS 每列自动分开),
      其余后缀用逗号.
    - 也可用 --delimiter 显式指定分隔符.

示例:
    # 读取默认的汇总文件, 生成制表符分隔的文件
    python3 scripts/extract_tuner_data.py output/实际编译对比.tsv
    # 显式指定汇总文件, 生成逗号分隔的 CSV
    python3 scripts/extract_tuner_data.py output/CSiBE_Step3_summary.txt output/实际编译对比.csv
"""
import argparse
import csv
import re

# 汇总文件段落标题: "项目名：x86：" / "项目名：riscv："
SECTION_RE = re.compile(r'^(.+?)[：:]\s*(x86|riscv)[：:]?\s*$')
# 旧日志格式的项目行: "1. 项目名"
PROJECT_RE = re.compile(r'^(\d+)\.\s*(.+)$')
# 旧日志格式的架构行: "x86" / "riscv"
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
    order = []  # 项目名首次出现顺序
    data = {}  # {项目名: {架构: {baseline, actual, reduction}}}
    cur_name = None
    cur_arch = None

    def ensure(name, arch=None):
        if name not in data:
            data[name] = {}
            order.append(name)
        if arch is None:
            return data[name]
        return data[name].setdefault(arch, {})

    with open(path, encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            # 汇总文件段落标题 (同时确定项目与架构)
            m = SECTION_RE.match(line)
            if m:
                cur_name, cur_arch = m.group(1), m.group(2)
                ensure(cur_name, cur_arch)
                continue
            # 旧日志格式的项目行
            m = PROJECT_RE.match(line)
            if m:
                cur_name = m.group(2)
                cur_arch = None
                ensure(cur_name)
                continue
            # 旧日志格式的架构行
            m = ARCH_RE.match(line)
            if m:
                cur_arch = m.group(1)
                if cur_name is not None:
                    ensure(cur_name, cur_arch)
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
                if cur_name is None or cur_arch is None:
                    continue
                ensure(cur_name, cur_arch)[key] = value
    return [(name, data[name]) for name in order]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('input', nargs='?', default='output/CSiBE_Step3_summary.txt',
                    help='输入的实际编译对比汇总文件 (默认: output/CSiBE_Step3_summary.txt)')
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
    sums = {arch: {'baseline': 0, 'actual': 0} for arch in ('x86', 'riscv')}

    def fmt_red(d):
        # 缩减率带上 % 号
        v = d.get('reduction', '')
        return f'{v}%' if v != '' else ''

    def total_red(arch):
        # 合计行缩减率 = (1 - 实际编译后总大小合计/基线大小合计) * 100
        if sums[arch]['baseline'] == 0:
            return ''
        return f"{(1 - sums[arch]['actual'] / sums[arch]['baseline']) * 100:.2f}%"

    with open(args.output, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, delimiter=delim)
        w.writerow(header)
        for name, data in projects:
            x86 = data.get('x86', {})
            riscv = data.get('riscv', {})
            # 累加合计行所需的各列总和
            for arch, d in (('x86', x86), ('riscv', riscv)):
                sums[arch]['baseline'] += int(d.get('baseline') or 0)
                sums[arch]['actual'] += int(d.get('actual') or 0)
            w.writerow([
                name,
                x86.get('baseline', ''), x86.get('actual', ''),
                fmt_red(x86),
                riscv.get('baseline', ''), riscv.get('actual', ''),
                fmt_red(riscv),
            ])
        # 末尾追加合计行
        w.writerow([
            '合计',
            sums['x86']['baseline'], sums['x86']['actual'], total_red('x86'),
            sums['riscv']['baseline'], sums['riscv']['actual'], total_red('riscv'),
        ])
    print(f'共 {len(projects)} 个项目, 已写入 {args.output}')


if __name__ == '__main__':
    main()
