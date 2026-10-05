# EREBUS

**EREBUS** is a Linux From Scratch (LFS) / Beyond Linux From Scratch (BLFS)
project to build a lightweight, purpose-built Linux operating system for a
headless home-lab server.

EREBUS runs on **ATROPOS**, a 2014 13-inch MacBook Air, and is built and
administered primarily from **CLOTHO**, an Acer Nitro 5 workstation.

EREBUS forms part of **TENEBRAE**, the wider home-lab environment.

> The project was originally named `erebOS`. A controlled rename to EREBUS is
> in progress. Some repository paths, image names and installed-system
> metadata may temporarily retain the former name until each dependency has
> been migrated and tested.

## Current status

The Linux From Scratch 13.1-systemd base system is complete.

EREBUS has been deployed to ATROPOS and successfully boots natively from the
internal SSD.

Validated functionality includes:

- Linux 7.1.8 booting successfully on MacBookAir6,2
- GRUB 2.14 x86_64 EFI booting through the fallback EFI path
- ext4 root filesystem on the internal SSD
- wired networking through an ASIX AX88179 USB Gigabit Ethernet adapter
- systemd-networkd DHCP networking
- OpenSSH 10.5p1 remote administration
- Ed25519 key-based SSH authentication
- password SSH authentication disabled
- keyboard-interactive SSH authentication disabled
- direct root SSH login disabled
- SSH and networking successfully surviving a full reboot
- remote administration from CLOTHO
- documented recovery snapshots and troubleshooting history

The project is now moving from the core LFS construction phase into
**BLFS/post-LFS server enablement**.

## Purpose

EREBUS exists to create a Linux system that is:

- built from source and understood rather than treated as a black box
- intentionally small and maintainable
- designed around its actual hardware and server role
- practical rather than minimal for minimalism's sake
- reproducible where sensible
- well documented
- remotely manageable
- recoverable when something goes wrong

It is not intended to become a general-purpose Linux distribution or compete
with established projects such as Debian, Ubuntu, Arch or Gentoo.

## Systems

### CLOTHO

Primary build and administration workstation.

Hardware:

- Acer Nitro 5 AN515-52
- Intel Core i5-8300H
- 16 GB RAM
- Ubuntu build host

Roles:

- LFS/BLFS build workstation
- source preparation
- project documentation
- Git/GitHub management
- remote administration of ATROPOS
- recovery workstation

### ATROPOS

EREBUS production target.

Hardware:

- 2014 13-inch MacBook Air
- MacBookAir6,2
- Intel x86-64 / Haswell platform
- 4 GB RAM
- internal PCIe SSD
- Broadcom BCM4360 Wi-Fi
- USB Gigabit Ethernet available

Primary role:

- headless TENEBRAE home-lab server

Wired Ethernet and SSH are the preferred administration and recovery path.

### LACHESIS

The Dell system is known as **LACHESIS**.

It is part of the wider TENEBRAE environment but is not an EREBUS build or
deployment target.

## Design principles

### Server first

EREBUS is primarily a headless server operating system.

A lightweight graphical environment may be added later for occasional local
use, but it must not compromise the server-first design.

### Function over novelty

Customisation should have a technical or usability purpose.

Standard Linux conventions should be preserved where they improve
compatibility, reliability or maintainability.

### Hardware-aware

EREBUS is designed specifically for ATROPOS rather than as a generic distro.

Hardware-specific decisions should be documented and tested against the
MacBookAir6,2 target.

### Build portability

CLOTHO has a newer CPU than ATROPOS.

The project therefore avoids accidental build-host CPU optimisation leaking
into target binaries.

This became a formal project concern after GMP was found to contain
host-specific compiler tuning which caused GCC to execute an illegal
instruction on ATROPOS.

That failure and its repair are preserved in the Chapter 8 documentation.

### Documentation is part of the build

The repository preserves:

- build stages
- package versions
- kernel configuration
- boot configuration
- troubleshooting history
- failed builds
- recovery procedures
- architectural decisions
- networking configuration
- security configuration
- hardware-specific decisions
- maintenance procedures

Failures and their solutions are considered valuable project documentation.

## Build base

Pinned base:

- Linux From Scratch 13.1-systemd
- x86-64
- systemd
- Linux 7.1.8
- GRUB 2.14
- build parallelism: `MAKEFLAGS=-j4`

The LFS base remains pinned for a given EREBUS release rather than silently
following the development book.

BLFS packages will be selected according to actual server requirements rather
than installed indiscriminately.

## Remote administration

ATROPOS is administered remotely from CLOTHO using OpenSSH.

Current effective SSH authentication policy:

```text
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
```

A normal user account is used for remote login and root privileges are
obtained locally after authentication.

See:

```text
docs/remote-administration.md
```

## Current project phase

Core LFS construction is complete.

The next phase is BLFS/post-LFS server enablement.

Planned work includes:

1. define the BLFS build and package-tracking policy
2. establish a post-deployment recovery strategy
3. configure time synchronisation and trust infrastructure
4. configure server firewall policy
5. add hardware health and thermal monitoring
6. configure SSD maintenance and TRIM
7. review laptop-specific power and lid behaviour
8. establish logging and monitoring policy
9. stabilise home-lab addressing and DNS integration
10. add BCM4360 Wi-Fi as optional secondary networking
11. define backup and restore procedures
12. install only the services required by the TENEBRAE home lab
13. add a lightweight optional local graphical environment
14. perform extended soak and recovery testing

## Repository structure

```text
docs/
    Build records, architecture, troubleshooting and operational documentation.

configs/
    Preserved configuration including the Linux kernel configuration.

host-checks/
    Build-host validation records.

package-lists/
    Source/package information associated with the pinned LFS base.

scripts/
    Build-session and maintenance tooling.

README.md
    Project overview.
```

Some filenames currently retain the former `erebOS` name while the EREBUS
rename is being migrated in controlled stages.

## Session workflow

The existing build-session tooling prepares CLOTHO for LFS/BLFS work by:

- temporarily switching `/bin/sh` from Dash to Bash
- temporarily disabling the Ubuntu `/etc/bash.bashrc`
- mounting the build filesystem at `/mnt/lfs`
- mounting required virtual filesystems
- providing the chroot command

When the session ends, the stop script restores CLOTHO to its normal Ubuntu
state.

The session scripts have been renamed to `start-erebus.sh` and
`stop-erebus.sh`. The local project directory and build image filename will
be migrated separately after their dependencies have been audited and tested.

## Git and GitHub

Git contains:

- documentation
- scripts
- package manifests
- configuration
- patches
- kernel configuration
- build metadata
- troubleshooting records
- diagrams and project assets

Git does not contain:

- filesystem images
- recovery images
- downloaded source archives
- large generated binaries
- transient build directories

Milestone commits are preferred over committing every individual package.

## References

EREBUS uses the official Linux From Scratch and Beyond Linux From Scratch
books as its primary technical references.

The repository documents the EREBUS implementation and project-specific
decisions rather than replacing the upstream LFS/BLFS documentation.
