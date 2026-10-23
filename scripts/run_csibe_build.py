#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从 CSiBE v2.1.1 自身的项目构建文件读取编译配置, 生成 ruyituner 命令并批量运行
(scripts/run_csibe_build.py).

本脚本是运行 CSiBE v2.1.1 的一条新路径, 不再依赖 RunCSiBE.md 里写死的命令:
直接解析每个项目源码目录下自带的 Makefile.in (CSiBE v2.1.1 官方构建系统的配置
模板, 与源码一起发布), 展开其中的 $(VAR) 变量引用, 从 CFLAGS 中提取编译宏
(-D/-U) 与头文件路径 (-I) 拼成 --c_flags, 再为 x86 / RISC-V / AArch64 三套
工具链分别构造 ruyituner 命令 (均带 --search_scope project) 批量运行, 为每个
项目找出最优 pass 序列, 汇总基线大小/实际编译后总大小/缩减率并生成 TSV 数据表.

Makefile.in 解析规则:
  - 收集项目目录树下所有 Makefile.in 的 CFLAGS (部分项目顶层 Makefile.in 只是
    递归, 真正的 CFLAGS 在子目录的 Makefile.in 里);
  - $(CCOPT) 展开为空 (优化等级由 ruyituner 的 --opt-level 决定);
  - $(VPATH) 展开为该 Makefile.in 所在目录 (源码包中它是 @CSiBE-SRCDIR@ 占位符),
    -I 相对路径按该目录解析为绝对路径, 不存在的头文件目录丢弃并提示;
  - 只保留 -D/-U/-I 参数, -w/-ansi/-fno-builtin 等不传给 ruyituner
    (-ansi 由统一的 --c_std gnu89 代替), 重复参数去重.

架构差异: aarch64 命令在 --c_flags 中追加 --target=aarch64-unknown-linux-gnu
(交叉工具链的 clang 默认 triple 为 unknown, 必须显式指定); riscv 的 libmspack
追加 --sysroot (默认 /opt/riscv/sysroot, 可经 --riscv_sysroot 修改、置空关闭,
--riscv_sysroot_projects 调整应用的项目列表), 其余项目与 x86 相同.

用法示例:
  python3 scripts/run_csibe_build.py \
      --x86_path /llvm_dir/build-x86/bin \
      --riscv_path /llvm_dir/build-riscv/bin \
      --aarch64_path /llvm_dir/build-aarch64/bin

  只跑 x86:          追加 --only_arch x86
  只跑指定项目:      追加 --projects compiler,jpeg-6b
  只看将执行的命令:  追加 --dry_run (下载与解压仍会先完成, 只是不真正执行)
  已下载仍重下:      追加 --force
  跳过下载与解压:    追加 --no_download (直接用现有缓存目录运行)
  指定数据集目录:    追加 --dataset_dir <目录> (缺省 output/csibe_cache/CSiBE-v2.1.1,
                     可指向 datasets/c_files/CSiBE-v2.1.1 等其它副本)

本脚本自成一体: 源码包下载/解压、任务运行/汇总与 TSV 数据表格的逻辑都在本文件内
实现, 不 import scripts/run_csibe.py 与 scripts/run_csibe_auto.py; 外部脚本只以
子进程方式调用 ruyituner.py.
"""

import argparse
import csv
import os
import re
import shlex
import shutil
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.error
import urllib.request
from collections import namedtuple

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
RUYITUNER_PY = os.path.join(PROJECT_ROOT, 'ruyituner.py')

# CSiBE v2.1.1 的 17 个 benchmark (与 CSiBE 仓库 cmake/subprojects.cmake 中
# adopt_subprojects 展开出的项目一致; testdata 与
# linux-2.4.23-pre3-testplatform 两个目录不参与运行)
CSIBE_V211_PROJECTS = [
    'bzip2-1.0.2',
    'cg_compiler_opensrc',
    'compiler',
    'flex-2.5.31',
    'jikespg-1.3',
    'jpeg-6b',
    'libmspack',
    'libpng-1.2.5',
    'lwip-0.5.3.preproc',
    'mpeg2dec-0.3.1',
    'mpgcut-1.1',
    'OpenTCP-1.0.4',
    'replaypc-0.4.0.preproc',
    'teem-1.6.0-src',
    'ttt-0.10.1.preproc',
    'unrarlib-0.4.0',
    'zlib-1.1.4',
]

# riscv 交叉工具链默认头文件是裸机 newlib, 缺 dirent 等, 依赖宿主头文件的项目
# 需要追加 glibc sysroot (与 RunCSiBE.md 的 libmspack 处理一致)
DEFAULT_RISCV_SYSROOT = '/opt/riscv/sysroot'
DEFAULT_RISCV_SYSROOT_PROJECTS = ['libmspack']

DEFAULT_OUTPUT = os.path.join(PROJECT_ROOT, 'output', 'CSiBE_build_summary.txt')
DEFAULT_DATA_OUTPUT = os.path.join(PROJECT_ROOT, 'output', 'CSiBE_build_data.tsv')

# ---- 官方源码包下载与解压 (缓存目录 output/csibe_cache/, 已被 git 忽略) ----

CACHE_DIR = os.path.join(PROJECT_ROOT, 'output', 'csibe_cache')
DEFAULT_TAR_PATH = os.path.join(CACHE_DIR, 'CSiBE-v2.1.1.tar.gz')
DATASET_DIR = os.path.join(CACHE_DIR, 'CSiBE-v2.1.1')
TARBALL_URL = ('https://github.com/szeged/csibe/releases/download/'
               'CSiBE-v2.1.1/CSiBE-v2.1.1.tar.gz')
# 不参与运行: testdata 为测试数据; linux-2.4.23-pre3-testplatform 的 .c 文件
# 几乎都不能被 clang 独立编译
SKIP_DIRS = {'testdata', 'linux-2.4.23-pre3-testplatform'}


def download_tarball(tar_path, force):
    """下载官方源码包到 tar_path; 已存在且非空时跳过 (force 强制重新下载)."""
    if os.path.isfile(tar_path) and os.path.getsize(tar_path) > 0 and not force:
        print(f'[run_csibe_build] {tar_path} 已存在, 跳过下载 (--force 可强制重新下载).')
        return
    out_dir = os.path.dirname(tar_path)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    print(f'[run_csibe_build] 下载 {TARBALL_URL}')
    part_path = tar_path + '.part'
    req = urllib.request.Request(TARBALL_URL, headers={'User-Agent': 'ruyi-tuner'})
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            total = int(resp.headers.get('Content-Length') or 0)
            done = 0
            with open(part_path, 'wb') as fh:
                while True:
                    chunk = resp.read(1 << 20)
                    if not chunk:
                        break
                    fh.write(chunk)
                    done += len(chunk)
                    if total:
                        print(f'[run_csibe_build]   已下载 {done} / {total} 字节'
                              f' ({done * 100 // total}%)', end='\r', flush=True)
        if total:
            print()
    except (urllib.error.URLError, OSError) as exc:
        print(f'[run_csibe_build] 下载失败: {exc}')
        if os.path.isfile(part_path):
            os.remove(part_path)
        sys.exit(1)
    os.replace(part_path, tar_path)
    print(f'[run_csibe_build] 下载完成: {tar_path} ({os.path.getsize(tar_path)} 字节)')


def extract_dataset(tar_path, dataset_dir):
    """把源码包中的 CSiBE/src 内容解压到 dataset_dir.

    dataset_dir 已有内容时先清空再写入, 保证与源码包完全一致 (跳过 SKIP_DIRS)."""
    print(f'[run_csibe_build] 解压 {tar_path} 到 {dataset_dir}')
    tmp_dir = tempfile.mkdtemp(prefix='csibe-v2.1.1-extract-')
    try:
        try:
            with tarfile.open(tar_path, 'r:gz') as tf:
                tf.extractall(tmp_dir)
        except (tarfile.TarError, OSError) as exc:
            print(f'[run_csibe_build] 解压失败: {exc}')
            sys.exit(1)
        src_dir = os.path.join(tmp_dir, 'CSiBE', 'src')
        if not os.path.isdir(src_dir):
            print(f'[run_csibe_build] 源码包内容异常: 未找到 CSiBE/src 目录, 终止.')
            sys.exit(1)
        if os.path.isdir(dataset_dir):
            shutil.rmtree(dataset_dir)
        os.makedirs(dataset_dir)
        copied = skipped = 0
        for name in sorted(os.listdir(src_dir)):
            if name in SKIP_DIRS:
                print(f'[run_csibe_build]   跳过 (不参与运行): {name}')
                skipped += 1
                continue
            src = os.path.join(src_dir, name)
            dst = os.path.join(dataset_dir, name)
            if os.path.isdir(src):
                shutil.copytree(src, dst)
            else:
                shutil.copy2(src, dst)
            copied += 1
        print(f'[run_csibe_build] 解压完成: {copied} 个条目, 跳过 {skipped} 个目录.')
    finally:
        shutil.rmtree(tmp_dir, ignore_errors=True)


# Makefile 变量定义与 $(VAR) 引用
VAR_ASSIGN_RE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s*(:=|=)\s*(.*)$')
VAR_REF_RE = re.compile(r'\$\(([A-Za-z_][A-Za-z0-9_]*)\)')


def read_makefile_variables(mk_path, vpath_dir):
    """读取一个 Makefile.in 的变量定义, 返回变量字典.

    行尾 \\ 续行先合并成逻辑行, 规则行 (缩进开头) 与注释行跳过;
    CCOPT 强制置空、VPATH 强制置为 vpath_dir (该 Makefile.in 所在目录),
    不取文件里 @CSiBE-CCOPT@ / @CSiBE-SRCDIR@ 占位符的值."""
    logical_lines = []
    buf = None
    with open(mk_path, encoding='utf-8', errors='ignore') as fh:
        for raw in fh:
            line = raw.rstrip('\n')
            if buf is not None:
                line = buf + line.lstrip()
                buf = None
            if line.rstrip().endswith('\\'):
                buf = line.rstrip()[:-1] + ' '
                continue
            logical_lines.append(line)
        if buf is not None:
            logical_lines.append(buf)

    variables = {}
    for line in logical_lines:
        if not line.strip() or line.strip().startswith('#'):
            continue
        m = VAR_ASSIGN_RE.match(line)
        if not m:
            continue
        name, value = m.group(1), m.group(3).strip()
        if name in ('CCOPT', 'VPATH'):
            continue
        variables[name] = value
    variables['CCOPT'] = ''
    variables['VPATH'] = vpath_dir
    return variables


def expand_make_variables(text, variables):
    """递归展开 $(VAR) 引用, 未定义的变量展开为空, 最多迭代 16 次防循环."""
    for _ in range(16):
        expanded = VAR_REF_RE.sub(lambda m: variables.get(m.group(1), ''), text)
        if expanded == text:
            return expanded
        text = expanded
    return text


def extract_project_flags(project_dir):
    """解析 project_dir 目录树下所有 Makefile.in 的 CFLAGS, 提取 -D/-U/-I 参数.

    -I 相对路径按该 Makefile.in 所在目录解析为绝对路径 (clang 在数据集根目录下
    执行也成立); 不存在的头文件目录丢弃并提示; 返回保序去重的参数列表."""
    flags = []
    seen = set()
    makefiles = []
    for root, _dirs, files in os.walk(project_dir):
        for name in files:
            if name == 'Makefile.in':
                makefiles.append(os.path.join(root, name))
    for mk_path in sorted(makefiles):
        mk_dir = os.path.dirname(mk_path)
        variables = read_makefile_variables(mk_path, mk_dir)
        cflags = expand_make_variables(variables.get('CFLAGS', ''), variables)
        if not cflags.strip():
            continue
        for token in cflags.split():
            if token.startswith('-I') and len(token) > 2:
                path = token[2:]
                if not os.path.isabs(path):
                    path = os.path.join(mk_dir, path)
                path = os.path.abspath(path)
                if not os.path.isdir(path):
                    print(f'[run_csibe_build] 丢弃不存在的头文件目录 {token} '
                          f'(来自 {os.path.relpath(mk_path, project_dir)})')
                    continue
                item = '-I' + path
            elif token.startswith(('-D', '-U')):
                item = token
            else:
                # -w/-ansi/-fno-builtin 等不传给 ruyituner (-ansi 由 --c_std 代替)
                continue
            if item not in seen:
                seen.add(item)
                flags.append(item)
    return flags


Task = namedtuple('Task', ['project', 'arch', 'cmd_line'])


def _has_flag(argv, name):
    """argv 中是否已包含某命令行开关 (支持 "--name value" 与 "--name=value" 两种写法)."""
    return any(a == name or a.startswith(name + '=') for a in argv)


def extract_stage3(lines):
    """从输出行中截取实际编译对比阶段: 自该阶段标题(含紧邻分隔线)起,
    到 [ruyituner] 全部完成. 为止; 找不到标题时返回 None."""
    start = None
    for i, line in enumerate(lines):
        if '阶段 3/3' in line:
            start = i
            break
    if start is None:
        return None
    # 带上紧邻在前的 "===...===" 分隔线
    if start > 0 and set(lines[start - 1].strip()) == {'='}:
        start -= 1
    # 收尾信息 (全部完成/已清理) 不属于本阶段, 截断在 全部完成 之前
    end = len(lines)
    for j in range(start, len(lines)):
        if lines[j] == '[ruyituner] 全部完成.':
            end = j
            break
    return '\n'.join(lines[start:end]).rstrip()


def build_command(project, arch, paths, dataset_root, flags,
                  riscv_sysroot, sysroot_projects, extra_args):
    """为一个项目拼出一条 ruyituner 命令 (--search_scope project 模式)."""
    argv = [sys.executable, '-u', RUYITUNER_PY,
            '--dataset', os.path.join(dataset_root, project),
            '--llvm_tools_path', paths[arch],
            '--count_mode', 'obj-size',
            '--input_type', 'c',
            '--c_std', 'gnu89',
            '--search_scope', 'project']
    c_flags = list(flags)
    if arch == 'aarch64':
        # 交叉工具链 clang 默认 triple 为 unknown, 必须显式指定目标
        c_flags.append('--target=aarch64-unknown-linux-gnu')
    if arch == 'riscv' and riscv_sysroot and project in sysroot_projects:
        c_flags.append(f'--sysroot={riscv_sysroot}')
    if c_flags:
        argv.append(f'--c_flags={" ".join(c_flags)}')
    for flag, value in extra_args:
        if not _has_flag(argv, flag):
            argv += [flag, value]
    return argv


def run_task(project, arch, argv, out_fh):
    """运行一条命令, 实时回显输出, 并把实际编译对比阶段内容写入汇总文件."""
    print(f'[run_csibe_build] ============ {project} ({arch}) ============')
    print('[run_csibe_build] 命令:', ' '.join(shlex.quote(a) for a in argv))
    proc = subprocess.Popen(argv, cwd=PROJECT_ROOT, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, bufsize=1)
    lines = []
    for line in proc.stdout:
        sys.stdout.write(line)
        sys.stdout.flush()
        lines.append(line.rstrip('\n'))
    rc = proc.wait()

    stage3 = extract_stage3(lines)
    if stage3 is None:
        tail = '\n'.join(lines[-8:]) if lines else '(无输出)'
        stage3 = (f'[run_csibe_build] 未输出实际编译对比阶段 (exit={rc}), 输出末尾:\n{tail}')
        print(f'[run_csibe_build] 警告: 未输出实际编译对比阶段 (exit={rc}), 详情见汇总文件')

    out_fh.write(f'{project}：{arch}：\n')
    out_fh.write(stage3 + '\n\n')
    out_fh.flush()
    return rc


# ---- 从汇总文件抽取数据生成 TSV 表格 ----

# 汇总文件段落标题: "项目名：x86：" / "项目名：riscv：" / "项目名：aarch64："
SECTION_RE = re.compile(r'^(.+?)[：:]\s*(x86|riscv|aarch64)[：:]?\s*$')
# 旧日志格式的项目行: "1. 项目名"
PROJECT_RE = re.compile(r'^(\d+)\.\s*(.+)$')
# 旧日志格式的架构行: "x86" / "riscv" / "aarch64"
ARCH_LINE_RE = re.compile(r'^(x86|riscv|aarch64)\s*[:：]?$')
METRIC_RE = re.compile(
    r'^\[ruyituner\] (?:clang -\S+ )?(基线大小 .+): (\d+)$'
    r'|^\[ruyituner\] (按优化序列实际编译后总大小(?:（[^）]*）)?|实际编译后总大小): (\d+)$'
    r'|^\[ruyituner\] (实际代码体积缩减率): ([\d.]+)%$'
)
METRIC_KEYS = {
    '基线大小 (来自前一步 GA 输出)': 'baseline',
    '实际编译后总大小': 'actual',
    '实际代码体积缩减率': 'reduction',
}


def parse_summary(path):
    """从汇总文件中抽取各项目 x86/riscv/aarch64 的基线大小、实际编译后
    总大小与实际代码体积缩减率, 返回 [(项目名, {架构: {metric: value}}), ...],
    项目顺序与首次出现顺序一致; 兼容旧版运行日志格式."""
    order = []
    data = {}
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
            m = SECTION_RE.match(line)
            if m:
                cur_name, cur_arch = m.group(1), m.group(2)
                ensure(cur_name, cur_arch)
                continue
            m = PROJECT_RE.match(line)
            if m:
                cur_name = m.group(2)
                cur_arch = None
                ensure(cur_name)
                continue
            m = ARCH_LINE_RE.match(line)
            if m:
                cur_arch = m.group(1)
                if cur_name is not None:
                    ensure(cur_name, cur_arch)
                continue
            m = METRIC_RE.match(line)
            if m:
                if m.group(1) is not None:
                    key = METRIC_KEYS['基线大小 (来自前一步 GA 输出)']
                    value = int(m.group(2))
                elif m.group(3) is not None:
                    key = METRIC_KEYS['实际编译后总大小']
                    value = int(m.group(4))
                else:
                    key = METRIC_KEYS['实际代码体积缩减率']
                    value = m.group(6)
                if cur_name is None or cur_arch is None:
                    continue
                ensure(cur_name, cur_arch)[key] = value
    return [(name, data[name]) for name in order]


def write_data_table(records, out_path):
    """把 parse_summary 的结果写成制表符分隔的数据表格 (含表头与合计行).

    列为 项目名称 + x86/riscv/aarch64 各三列 (基线大小/实际编译后总大小/
    实际代码体积缩减率); 缩减率带 % 号; 合计行各架构分别求和, 缩减率按
    (1 − 实际编译后总大小合计/基线大小合计) 换算 (基线合计为 0 时留空)."""
    header = [
        '项目名称',
        'x86基线大小', 'x86实际编译后总大小', 'x86实际代码体积缩减率(%)',
        'riscv基线大小', 'riscv实际编译后总大小', 'riscv实际代码体积缩减率(%)',
        'aarch64基线大小', 'aarch64实际编译后总大小', 'aarch64实际代码体积缩减率(%)',
    ]
    sums = {arch: {'baseline': 0, 'actual': 0} for arch in ('x86', 'riscv', 'aarch64')}

    def fmt_red(d):
        v = d.get('reduction', '')
        return f'{v}%' if v != '' else ''

    def total_red(arch):
        if sums[arch]['baseline'] == 0:
            return ''
        return f"{(1 - sums[arch]['actual'] / sums[arch]['baseline']) * 100:.2f}%"

    out_dir = os.path.dirname(out_path)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with open(out_path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, delimiter='\t')
        w.writerow(header)
        for name, data in records:
            x86 = data.get('x86', {})
            riscv = data.get('riscv', {})
            aarch64 = data.get('aarch64', {})
            for arch, d in (('x86', x86), ('riscv', riscv), ('aarch64', aarch64)):
                sums[arch]['baseline'] += int(d.get('baseline') or 0)
                sums[arch]['actual'] += int(d.get('actual') or 0)
            w.writerow([
                name,
                x86.get('baseline', ''), x86.get('actual', ''), fmt_red(x86),
                riscv.get('baseline', ''), riscv.get('actual', ''), fmt_red(riscv),
                aarch64.get('baseline', ''), aarch64.get('actual', ''), fmt_red(aarch64),
            ])
        w.writerow([
            '合计',
            sums['x86']['baseline'], sums['x86']['actual'], total_red('x86'),
            sums['riscv']['baseline'], sums['riscv']['actual'], total_red('riscv'),
            sums['aarch64']['baseline'], sums['aarch64']['actual'], total_red('aarch64'),
        ])


def main():
    # 本脚本的 print 接入管道时默认块缓冲, 会与 ruyituner (-u 无缓冲) 的输出错位,
    # 改为行缓冲保证顺序一致
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(line_buffering=True)
    parser = argparse.ArgumentParser(
        description='解析 CSiBE v2.1.1 各项目自带 Makefile.in 的编译配置, '
                    '生成并批量运行 x86/RISC-V/AArch64 的 ruyituner 命令',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--x86_path', type=str, default=None,
                        help='x86 工具链 bin 目录')
    parser.add_argument('--riscv_path', type=str, default=None,
                        help='RISC-V 工具链 bin 目录')
    parser.add_argument('--aarch64_path', type=str, default=None,
                        help='AArch64 工具链 bin 目录')
    parser.add_argument('--only_arch', type=str, default=None,
                        choices=['x86', 'riscv', 'aarch64'], help='只跑一个架构')
    parser.add_argument('--projects', type=str, default=None,
                        help='只跑指定项目, 逗号分隔 (如 compiler,jpeg-6b)')
    parser.add_argument('--dataset_dir', type=str,
                        default=DATASET_DIR,
                        help='数据集根目录, 含各项目子目录 (缺省 '
                             'output/csibe_cache/CSiBE-v2.1.1)')
    parser.add_argument('--tar_path', type=str,
                        default=DEFAULT_TAR_PATH,
                        help='源码包缓存路径 (缺省 output/csibe_cache/CSiBE-v2.1.1.tar.gz)')
    parser.add_argument('--force', action='store_true',
                        help='源码包已存在时仍强制重新下载')
    parser.add_argument('--no_download', action='store_true',
                        help='跳过下载与解压, 直接用 --dataset_dir 现有目录运行')
    parser.add_argument('--riscv_sysroot', type=str,
                        default=DEFAULT_RISCV_SYSROOT,
                        help='riscv 需要 glibc 头文件的项目追加的 --sysroot 路径 '
                             '(置空关闭, 默认 /opt/riscv/sysroot)')
    parser.add_argument('--riscv_sysroot_projects', type=str,
                        default=','.join(DEFAULT_RISCV_SYSROOT_PROJECTS),
                        help='应用 --riscv_sysroot 的项目, 逗号分隔 (默认 libmspack)')
    parser.add_argument('--opt-level', type=str, default=None,
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='追加到每条 ruyituner 命令的基线优化等级 (缺省不追加)')
    parser.add_argument('--ir-opt-level', type=str, default=None,
                        choices=['O0', 'O1', 'O2', 'O3', 'Os', 'Oz'],
                        help='追加到每条 ruyituner 命令的 C→IR 转换优化等级 (缺省不追加)')
    parser.add_argument('--dry_run', action='store_true',
                        help='只解析并打印将执行的命令, 不实际运行')
    parser.add_argument('--output', type=str, default=DEFAULT_OUTPUT,
                        help=f'汇总输出文件 (默认: {DEFAULT_OUTPUT})')
    parser.add_argument('--data_output', type=str, default=DEFAULT_DATA_OUTPUT,
                        help=f'数据表格输出文件 (TSV, 默认: {DEFAULT_DATA_OUTPUT})')
    args = parser.parse_args()

    # 下载与解压 (缓存目录 output/csibe_cache/, 与仓库跟踪的
    # datasets/c_files/CSiBE-v2.1.1 分开)
    if not args.no_download:
        download_tarball(args.tar_path, args.force)
        extract_dataset(args.tar_path, args.dataset_dir)
    else:
        if not os.path.isdir(args.dataset_dir):
            print(f'[run_csibe_build] 数据集目录不存在: {args.dataset_dir}, 终止.')
            sys.exit(1)
        print(f'[run_csibe_build] --no_download: 跳过下载与解压, 直接使用 {args.dataset_dir}')
    dataset_root = os.path.abspath(args.dataset_dir)

    archs = [args.only_arch] if args.only_arch else ['x86', 'riscv', 'aarch64']
    paths = {'x86': args.x86_path, 'riscv': args.riscv_path,
             'aarch64': args.aarch64_path}
    for arch in archs:
        if not paths[arch]:
            parser.error(f'缺少 {arch} 工具链路径 (--{arch}_path)')
        if not os.path.isdir(paths[arch]):
            print(f'[run_csibe_build] 警告: {arch} 工具链目录不存在: {paths[arch]}')

    # 项目选择与检查
    projects = list(CSIBE_V211_PROJECTS)
    if args.projects:
        wanted = {p.strip() for p in args.projects.split(',') if p.strip()}
        unknown = sorted(p for p in wanted if p not in CSIBE_V211_PROJECTS)
        if unknown:
            print(f'[run_csibe_build] 未知项目已忽略: {", ".join(unknown)}')
        projects = [p for p in projects if p in wanted]
    missing = [p for p in projects if not os.path.isdir(os.path.join(dataset_root, p))]
    projects = [p for p in projects if p not in missing]
    if missing:
        print(f'[run_csibe_build] 数据集中缺少目录, 跳过: {", ".join(missing)}')
    if not projects:
        print('[run_csibe_build] 没有可运行的项目, 终止.')
        sys.exit(1)

    extra_args = []
    if args.opt_level is not None:
        extra_args.append(('--opt-level', args.opt_level))
    if args.ir_opt_level is not None:
        extra_args.append(('--ir-opt-level', args.ir_opt_level))
    sysroot_projects = {p.strip() for p in args.riscv_sysroot_projects.split(',')
                        if p.strip()}

    # 每个项目解析一次 Makefile.in 编译配置, 三个架构复用
    tasks = []
    flag_map = {}
    for project in projects:
        flags = extract_project_flags(os.path.join(dataset_root, project))
        flag_map[project] = flags
        print(f'[run_csibe_build] {project}: 来自 Makefile.in 的编译参数: '
              f'{" ".join(flags) if flags else "(无 -D/-I 参数)"}')
        for arch in archs:
            argv = build_command(project, arch, paths, dataset_root, flags,
                                 args.riscv_sysroot, sysroot_projects, extra_args)
            tasks.append(Task(project, arch, argv))

    print(f'[run_csibe_build] 共 {len(tasks)} 条命令 (项目数: {len(projects)})')
    if args.dry_run:
        for task in tasks:
            print(f'  {task.project} ({task.arch}):',
                  ' '.join(shlex.quote(a) for a in task.cmd_line))
        print(f'[run_csibe_build] 汇总将写入: {args.output}')
        print(f'[run_csibe_build] 数据表格将写入: {args.data_output}')
        sys.exit(0)

    out_dir = os.path.dirname(args.output)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with open(args.output, 'w', encoding='utf-8') as out_fh:
        out_fh.write('# CSiBE v2.1.1 各项目 ruyituner 输出 实际编译对比阶段汇总 '
                     '(编译参数取自各项目 Makefile.in)\n')
        out_fh.write(f'# 生成时间: {time.strftime("%Y-%m-%d %H:%M:%S")}\n')
        out_fh.write(f'# 数据集根目录: {dataset_root}\n')
        out_fh.write(f'# x86 工具链: {args.x86_path}\n')
        out_fh.write(f'# riscv 工具链: {args.riscv_path}\n')
        out_fh.write(f'# aarch64 工具链: {args.aarch64_path}\n')
        out_fh.write(f'# riscv --sysroot: {args.riscv_sysroot or "(未使用)"} '
                     f'(项目: {", ".join(sorted(sysroot_projects)) or "无"})\n')
        for project in projects:
            flags = flag_map[project]
            out_fh.write(f'# {project}: {" ".join(flags) if flags else "(无 -D/-I 参数)"}\n')
        out_fh.write('\n')
        out_fh.flush()
        for task in tasks:
            run_task(task.project, task.arch, task.cmd_line, out_fh)
    print(f'[run_csibe_build] 全部完成, 汇总已写入: {args.output}')

    # 从汇总文件中抽取数据生成 TSV 表格
    records = parse_summary(args.output)
    write_data_table(records, args.data_output)
    print(f'[run_csibe_build] 共 {len(records)} 个项目, 数据表格已写入: {args.data_output}')


if __name__ == '__main__':
    main()
