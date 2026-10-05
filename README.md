# EREBUS

**EREBUS** is a Linux From Scratch (LFS) / Beyond Linux From Scratch (BLFS) project to build a lightweight, purpose-built Linux system for a home-lab server.

The system is designed for a repurposed MacBook Air and is being built as both a practical server platform and a deep technical learning project: build the system from source, understand the boot chain and userspace, document the decisions, and keep the finished machine small enough to remain comprehensible.

> **Status:** The base LFS 13.1-systemd system is complete, has booted successfully on the target MacBookAir6,2, and has working wired networking plus OpenSSH remote administration. Post-LFS / BLFS work is now under way.

> **Naming migration:** this project was originally named `erebOS`. The repository and project identity are now **EREBUS**. Historical build notes may still contain the former name until the installed system and archived artefacts are migrated.

## Role

EREBUS is intended to become the server foundation of **TENEBRAE**, the wider home-lab environment.

The target priorities are:

- lightweight, understandable Linux base
- headless-first operation with a basic local graphical environment available when useful
- reliable remote administration
- deliberate package selection rather than a conventional full distribution
- documented build, maintenance and recovery procedures
- hardware-specific configuration for the target MacBook Air
- practical self-hosted services, monitoring, automation and networking experiments

## Target hardware

**Target:** MacBook Air (`ATROPOS`)  
**Build host:** Acer Nitro (`CLOTHO`)

The base system was built on the Nitro and deployed to the MacBook Air after the bootable LFS image was completed.

## Current technical state

The completed LFS base currently includes:

- Linux 7.1.8
- GRUB 2.14, x86_64 EFI
- systemd
- ext4 root filesystem
- successful native boot on MacBookAir6,2
- ASIX AX88179 wired Ethernet support
- OpenSSH with key-based administration
- documented recovery snapshots

Broadcom BCM4360 Wi-Fi and further server functionality belong to the BLFS / post-LFS phase.

## Build workflow

At a high level:

1. Prepare and validate the build host.
2. Prepare the target filesystem and sources.
3. Build the cross-toolchain and temporary tools.
4. Enter chroot and build the final LFS base system.
5. Configure userspace, systemd, the kernel and bootloader.
6. Deploy to the target MacBook Air.
7. Validate native boot, networking and remote administration.
8. Add selected BLFS components and home-lab services.

The detailed chronological record lives under [`docs/`](docs/).

## Repository structure

```text
EREBUS/
├── configs/
│   └── kernel/
├── docs/
│   ├── chapter-06-temporary-tools.md
│   ├── chapter-07-chroot.md
│   ├── chapter-08-basic-system.md
│   ├── chapter-09-system-configuration.md
│   ├── chapter-10-bootable-system.md
│   ├── chapter-11-finalization.md
│   ├── remote-administration.md
│   └── session-workflow.md
├── host-checks/
├── package-lists/
├── scripts/
│   ├── start-erebus.sh
│   └── stop-erebus.sh
└── README.md
```

## Build-session helpers

The helper scripts manage the hosted LFS session, including the `/bin/sh` switch required for LFS work, the `/mnt/lfs` mount, virtual filesystems and restoration of the Ubuntu host when the session ends.

Start a session:

```bash
./scripts/start-erebus.sh
```

End a session:

```bash
./scripts/stop-erebus.sh
```

During the naming migration, the start script can also recognise the legacy `~/Projects/erebOS` project directory and `erebOS-lfs.img` image so the rename can be completed without breaking the build workflow.

## Documentation philosophy

The repository preserves the process rather than presenting only a polished end state. Build failures, wrong assumptions, troubleshooting, recovery procedures and abandoned experiments are documented where they are useful.

The goal is for the documentation to become both a learning record and a maintenance manual for the finished system.

## References

EREBUS is built primarily from:

- Linux From Scratch 13.1-systemd
- Beyond Linux From Scratch

The repository records the EREBUS implementation and project-specific decisions; it does not replace the upstream LFS/BLFS documentation.

---

**STATUS NIHILI** · Software · Systems · Hardware · Experiments
