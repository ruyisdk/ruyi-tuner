#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
自动下载 CSiBE v2.1.1 官方源码包并批量运行各 benchmark (scripts/run_csibe_auto.py).

流程:
  1. 从 GitHub Release 下载官方源码包 CSiBE-v2.1.1.tar.gz 到
     output/csibe_cache/ (output/ 已被 git 忽略; tar 已存在时跳过下载,
     --force 强制重下);
  2. 解压到临时目录, 再把其中的 CSiBE/src 内容放入
     output/csibe_cache/CSiBE-v2.1.1/ (先清空再写入, testdata 与
     linux-2.4.23-pre3-testplatform 两个目录不解压);
  3. 调用 scripts/run_csibe.py 批量运行 (自动把命令中的数据集路径
     datasets/c_files/CSiBE-v2.1.1 替换为上述缓存目录, 其余命令行参数原样
     透传; 仓库跟踪的 datasets/c_files/CSiBE-v2.1.1 不会被改动).

用法示例:
  python3 scripts/run_csibe_auto.py \
      --x86_path /llvm_dir/build-x86/bin \
      --riscv_path /llvm_dir/build-riscv/bin \
      --aarch64_path /llvm_dir/build-aarch64/bin

  只跑 x86:          追加 --only_arch x86
  只看将执行的命令:  追加 --dry_run (下载与解压仍会先完成, 只是不真正执行)
  已下载仍重下:      追加 --force
  跳过下载与解压:    追加 --no_download (直接用缓存目录运行)
"""

import argparse
import os
import shlex
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.error
import urllib.request

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUN_CSIBE_PY = os.path.join(PROJECT_ROOT, 'scripts', 'run_csibe.py')
# 下载缓存与解压后的数据集都放 output/csibe_cache/ (output/ 已被 git 忽略),
# 与仓库跟踪的 datasets/c_files/CSiBE-v2.1.1 分开, 不会改动仓库内数据集
CACHE_DIR = os.path.join(PROJECT_ROOT, 'output', 'csibe_cache')
DEFAULT_TAR_PATH = os.path.join(CACHE_DIR, 'CSiBE-v2.1.1.tar.gz')
DATASET_DIR = os.path.join(CACHE_DIR, 'CSiBE-v2.1.1')
URL = ('https://github.com/szeged/csibe/releases/download/'
       'CSiBE-v2.1.1/CSiBE-v2.1.1.tar.gz')
# 不同步也不参与运行: testdata 为测试数据; linux-2.4.23-pre3-testplatform 的
# .c 文件几乎都不能被 clang 独立编译 (RunCSiBE.md 已说明该目录不处理)
SKIP_DIRS = {'testdata', 'linux-2.4.23-pre3-testplatform'}


def download_tarball(tar_path, force):
    """下载官方源码包到 tar_path; 已存在且非空时跳过 (force 强制重新下载)."""
    if os.path.isfile(tar_path) and os.path.getsize(tar_path) > 0 and not force:
        print(f'[run_csibe_auto] {tar_path} 已存在, 跳过下载 (--force 可强制重新下载).')
        return
    out_dir = os.path.dirname(tar_path)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    print(f'[run_csibe_auto] 下载 {URL}')
    part_path = tar_path + '.part'
    req = urllib.request.Request(URL, headers={'User-Agent': 'ruyi-tuner'})
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
                        print(f'[run_csibe_auto]   已下载 {done} / {total} 字节'
                              f' ({done * 100 // total}%)', end='\r', flush=True)
        if total:
            print()
    except (urllib.error.URLError, OSError) as exc:
        print(f'[run_csibe_auto] 下载失败: {exc}')
        if os.path.isfile(part_path):
            os.remove(part_path)
        sys.exit(1)
    os.replace(part_path, tar_path)
    print(f'[run_csibe_auto] 下载完成: {tar_path} ({os.path.getsize(tar_path)} 字节)')


def extract_dataset(tar_path, dataset_dir):
    """把源码包中的 CSiBE/src 内容解压到 dataset_dir.

    dataset_dir 已有内容时先清空再写入, 保证与源码包完全一致 (跳过 SKIP_DIRS)."""
    print(f'[run_csibe_auto] 解压 {tar_path} 到 {dataset_dir}')
    tmp_dir = tempfile.mkdtemp(prefix='csibe-v2.1.1-extract-')
    try:
        try:
            with tarfile.open(tar_path, 'r:gz') as tf:
                tf.extractall(tmp_dir)
        except (tarfile.TarError, OSError) as exc:
            print(f'[run_csibe_auto] 解压失败: {exc}')
            sys.exit(1)
        src_dir = os.path.join(tmp_dir, 'CSiBE', 'src')
        if not os.path.isdir(src_dir):
            print(f'[run_csibe_auto] 源码包内容异常: 未找到 CSiBE/src 目录, 终止.')
            sys.exit(1)
        if os.path.isdir(dataset_dir):
            shutil.rmtree(dataset_dir)
        os.makedirs(dataset_dir)
        copied = skipped = 0
        for name in sorted(os.listdir(src_dir)):
            if name in SKIP_DIRS:
                print(f'[run_csibe_auto]   跳过 (不参与运行): {name}')
                skipped += 1
                continue
            src = os.path.join(src_dir, name)
            dst = os.path.join(dataset_dir, name)
            if os.path.isdir(src):
                shutil.copytree(src, dst)
            else:
                shutil.copy2(src, dst)
            copied += 1
        print(f'[run_csibe_auto] 解压完成: {copied} 个条目, 跳过 {skipped} 个目录.')
    finally:
        shutil.rmtree(tmp_dir, ignore_errors=True)


def run_csibe(run_args):
    """以项目根目录为工作目录调用 scripts/run_csibe.py.

    自动把命令中的数据集路径替换为缓存目录 (--dataset_dir), 用户已显式传入
    该参数时不重复追加; 其余参数原样透传."""
    if not any(a == '--dataset_dir' or a.startswith('--dataset_dir=')
               for a in run_args):
        run_args += ['--dataset_dir', DATASET_DIR]
    argv = [sys.executable, '-u', RUN_CSIBE_PY] + run_args
    print('[run_csibe_auto] 调用 run_csibe.py:',
          ' '.join(shlex.quote(a) for a in argv))
    return subprocess.call(argv, cwd=PROJECT_ROOT)


def main():
    # 本脚本的 print 接入管道时默认块缓冲, 会与子脚本 (-u 无缓冲) 的输出错位
    # (提示行冲到末尾), 改为行缓冲保证顺序一致
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(line_buffering=True)
    parser = argparse.ArgumentParser(
        description='下载 CSiBE v2.1.1 官方源码包, 解压同步后调用 '
                    'scripts/run_csibe.py 批量运行各 benchmark',
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--tar_path', type=str, default=DEFAULT_TAR_PATH,
                        help=f'源码包缓存路径 (默认: {DEFAULT_TAR_PATH})')
    parser.add_argument('--force', action='store_true',
                        help='源码包已存在时仍强制重新下载')
    parser.add_argument('--no_download', action='store_true',
                        help='跳过下载与解压, 直接用现有缓存目录调用 run_csibe.py')
    # 其余参数 (--x86_path/--riscv_path/--aarch64_path/--only_arch/--projects/
    # --opt-level/--ir-opt-level/--output/--data_output/--dry_run 等)
    # 原样透传给 scripts/run_csibe.py
    args, run_args = parser.parse_known_args()

    if not args.no_download:
        download_tarball(args.tar_path, args.force)
        extract_dataset(args.tar_path, DATASET_DIR)
    else:
        if not os.path.isdir(DATASET_DIR):
            print(f'[run_csibe_auto] 数据集缓存目录不存在: {DATASET_DIR}, 终止.')
            sys.exit(1)
        print(f'[run_csibe_auto] --no_download: 跳过下载与解压, 直接使用 {DATASET_DIR}')

    sys.exit(run_csibe(run_args))


if __name__ == '__main__':
    main()
