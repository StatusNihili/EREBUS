# ATROPOS / EREBUS Identity Migration

Date: 2026-10-08

## Purpose

The deployed system on ATROPOS still retained several identifiers from the
project's former erebOS identity. This migration updated the live machine and
operating-system identity to ATROPOS / EREBUS without altering boot-critical
filesystem identifiers unnecessarily.

## Pre-change audit

Before making changes, the live ATROPOS installation was searched for
references to `erebos` and `erebOS`.

Legacy identity was found in:

- `/etc/hostname`
- `/etc/os-release`
- `/etc/lsb-release`
- `/boot/grub/grub.cfg`
- `/etc/fstab`
- SSH host public-key comments

No additional references were found in:

- `/usr/local`
- `/opt`
- `/home/andy`

`/etc/hosts` contained no hostname-specific entry.

## Backup

Before modification, copies of the affected identity files and `/etc/fstab`
were preserved on ATROPOS under:

    /root/erebus-identity-backup-2026-10-08/

The backup contains:

- `hostname`
- `os-release`
- `lsb-release`
- `fstab`
- `grub.cfg`

## Changes

### Hostname

The static hostname was changed from:

    erebos

to:

    atropos

### Operating-system identity

`/etc/os-release` now contains:

    NAME="EREBUS"
    ID=erebus
    PRETTY_NAME="EREBUS"
    HOME_URL="https://github.com/StatusNihili/EREBUS"
    BUILD_ID="lfs-13.1-systemd"

The upstream LFS build identity was deliberately preserved.

### LSB identity

`/etc/lsb-release` now contains:

    DISTRIB_ID="EREBUS"
    DISTRIB_RELEASE="LFS-13.1-systemd"
    DISTRIB_DESCRIPTION="EREBUS (Linux From Scratch 13.1-systemd)"

### GRUB

The GRUB menu label was changed from:

    erebOS, Linux 7.1.8

to:

    EREBUS, Linux 7.1.8

The kernel path, filesystem UUID and root PARTUUID were not changed.

## Deliberately retained legacy references

The following were not changed during this migration.

### Filesystem labels

`/etc/fstab` still references:

    LABEL=erebOS-root
    LABEL=EREBOS_EFI

These labels are operational filesystem identifiers and will only be migrated
as a separate, coordinated change with corresponding `/etc/fstab` edits and
boot validation.

### SSH public-key comments

SSH host public keys still contain trailing comments of the form:

    root@erebos

These comments do not affect the host-key material or SSH authentication and
were left unchanged.

## Validation

ATROPOS was rebooted after the migration.

Post-reboot validation confirmed:

- ATROPOS booted successfully into EREBUS
- `hostnamectl` reports static hostname `atropos`
- `hostnamectl` reports operating system `EREBUS`
- Linux 7.1.8 remains in use
- wired networking returned successfully
- key-authenticated SSH from CLOTHO remained operational
- `systemctl is-system-running` returned `running`

The ATROPOS / EREBUS live identity migration is therefore considered complete,
apart from the deliberately deferred filesystem-label decision and cosmetic
SSH public-key comments.
