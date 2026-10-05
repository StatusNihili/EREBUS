# Phase 00 — Build Host Validation

## Build host

- Host identity: CLOTHO
- Hardware: Acer Nitro 5 AN515-52
- Distribution: Ubuntu 24.04.5 LTS
- Architecture: x86_64
- CPU: Intel Core i5-8300H
- CPU cores/threads: 4 cores / 8 threads
- RAM: 16 GB
- Swap: 4 GB
- Primary filesystem: ext4 on NVMe

## LFS host preparation

CLOTHO was checked before beginning the EREBUS build.

Required additions installed:

- Bison
- GNU Awk
- GNU M4
- Texinfo

Host compatibility requirements:

- `/bin/sh` points to Bash during active EREBUS/LFS build sessions.
- Ubuntu's normal Dash `/bin/sh` configuration is restored when leaving the EREBUS project.
- `awk` resolves to GNU Awk.
- `yacc` resolves to Bison.

C++ compiler sanity test completed successfully.

## Status

Phase 00 complete.

CLOTHO is ready to act as the EREBUS build workstation.
