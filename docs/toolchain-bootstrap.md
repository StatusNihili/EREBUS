# EREBUS Bootstrap Toolchain

## Base

- Linux From Scratch: 13.1-systemd
- Build host: CLOTHO — Acer Nitro 5 AN515-52
- Target architecture: x86_64
- Target triplet: x86_64-lfs-linux-gnu
- Build filesystem: /mnt/lfs
- Parallel build setting: MAKEFLAGS=-j4

## Binutils — Pass 1

Version: 2.47

Result: PASS

Build timing:

- real: 0m55.640s
- user: 2m17.734s
- sys: 0m31.902s

Installed temporary linker and assembler successfully.

## GCC — Pass 1

Version: 16.2.0

Result: PASS

Build timing:

- real: 10m47.778s
- user: 37m46.755s
- sys: 3m8.714s

Verification:

- Target: x86_64-lfs-linux-gnu
- Sysroot: /mnt/lfs

## Linux API Headers

Kernel headers version: 7.1.8

Result: PASS

Installed headers: 1032

Verified:

- linux/version.h
- linux/types.h
- asm/unistd.h

## Glibc

Version: 2.44

Result: PASS

Install timing recorded:

- real: 0m21.348s
- user: 0m40.039s
- sys: 0m16.216s

Cross-toolchain sanity checks confirmed:

- startup files loaded from /mnt/lfs
- headers loaded from /mnt/lfs/usr/include
- libc loaded from /mnt/lfs/usr/lib/libc.so.6
- dynamic linker found in /mnt/lfs/usr/lib
- generated executable requests /lib64/ld-linux-x86-64.so.2
- no host Ubuntu libc leakage detected

## Status

The initial EREBUS cross-toolchain is functional.

Binutils, GCC, Linux API headers, and Glibc are correctly integrated and targeting the EREBUS filesystem.

## Libstdc++ — Pass 1

Version: GCC 16.2.0 libstdc++

Result: PASS

Install timing:

- real: 0m1.990s
- user: 0m0.885s
- sys: 0m1.298s

Verified:

- libstdc++.so.6.0.36 installed
- C++ headers installed under the temporary toolchain
- libtool .la archives removed as required

## Chapter 5 Status

LFS Chapter 5 — Compiling a Cross-Toolchain: COMPLETE.
