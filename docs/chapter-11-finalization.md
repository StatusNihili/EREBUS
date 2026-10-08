# Chapter 11 — Finalization

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 11 is complete.

Build-side finalization was completed on 2026-10-03.

The completed LFS base system has since been deployed to the physical
MacBookAir6,2 and successfully booted natively from its internal SSD.

Post-deployment validation has confirmed:

- successful local boot to the `erebos login` prompt
- working wired networking
- working OpenSSH remote administration
- successful reboot with networking and `sshd` returning automatically
- key-only SSH access from CLOTHO, the Acer Nitro administration workstation

The project has therefore moved beyond the LFS construction phase and into
post-LFS/BLFS hardware enablement and server configuration.

## System identity

The upstream LFS provenance is preserved in:

    /etc/lfs-release

with:

    13.1-systemd

The installed operating system now identifies itself as EREBUS, and the
production machine hostname is `atropos`.

### /etc/os-release

    NAME="EREBUS"
    ID=erebus
    PRETTY_NAME="EREBUS"
    HOME_URL="https://github.com/StatusNihili/EREBUS"
    BUILD_ID="lfs-13.1-systemd"

### /etc/lsb-release

    DISTRIB_ID="EREBUS"
    DISTRIB_RELEASE="LFS-13.1-systemd"
    DISTRIB_DESCRIPTION="EREBUS (Linux From Scratch 13.1-systemd)"

The live identity migration was completed and reboot-tested on 2026-10-08.
Full details are recorded in:

    docs/identity-migration.md

No artificial EREBUS release number or codename has been assigned yet.

## Root account

The root account was verified with:

    passwd -S root

Status:

    P

This confirms that a usable root password is already configured.

The password itself is not recorded in project documentation.

## Final configuration review

The following files were reviewed before deployment:

- /etc/fstab
- /etc/hosts
- /etc/inputrc
- /etc/profile
- /etc/resolv.conf
- /etc/vimrc

/etc/resolv.conf is intentionally absent before first boot because
systemd-resolved is enabled.

/etc/vimrc was found to be missing during this review and was corrected
before deployment.

The installed /etc/vimrc follows the LFS configuration and includes:

- Vim defaults loaded before local customisation
- nocompatible mode
- normal backspace behaviour
- mouse support disabled
- syntax highlighting enabled
- dark-background handling for xterm and PuTTY terminals

## Firmware review

No general firmware bundle was installed.

This is intentional. Firmware will be added only for hardware that
actually requires it.

The first-boot-critical hardware path does not require external firmware:

- AHCI storage
- ext4 root filesystem
- EFI/SimpleDRM console
- USB keyboard
- Apple HID support
- Apple SMC
- BCM5974 trackpad

The Intel i915 module reports firmware names for newer Intel graphics
generations, but these are not required for the MacBookAir6,2 Haswell
graphics first-boot path.

Broadcom BCM4360 Wi-Fi support remains deferred to the BLFS/post-LFS
hardware-enablement phase.

The original prerequisite for this work has now been satisfied: wired
networking and SSH are operational and have survived a complete reboot.

## Wired recovery adapter

The USB Gigabit Ethernet adapter intended for initial networking and
recovery was positively identified on the build host:

    USB ID: 0b95:1790
    Device: ASIX AX88179 Gigabit Ethernet

The EREBUS Linux 7.1.8 module tree contains a matching alias:

    alias usb:v0B95p1790d*dc*dsc*dp*icFFiscFFip00in* ax88179_178a

The kernel configuration contains:

    CONFIG_USB_NET_AX88179_178A=m

The ax88179_178a driver declares no external firmware requirement.

This confirms that the planned wired first-boot networking path is present
in the EREBUS kernel.

## First-boot networking path

The planned wired first-boot networking path has now been validated on the
physical ATROPOS system.

Functional path:

    ATROPOS USB
        -> ASIX AX88179
        -> ax88179_178a module
        -> systemd-networkd
        -> IPv4 DHCP
        -> wired home-lab network
        -> OpenSSH

During initial target validation ATROPOS received:

    192.168.1.231

CLOTHO successfully reached ATROPOS over the LAN and established
authenticated SSH sessions.

Wired Ethernet remains the preferred administration and recovery path.

Broadcom BCM4360 Wi-Fi remains optional secondary networking work for the
BLFS/post-LFS phase.

## Next step

The Linux From Scratch base system is complete and boots successfully on the
target MacBookAir6,2.

The next project phase is BLFS/post-LFS server enablement.

Immediate priorities are:

1. preserve the completed native-boot milestone in project documentation
2. continue using wired Ethernet and key-only SSH as the primary
   administration path
3. add only the BLFS components required for the home-lab server role
4. configure Broadcom BCM4360 Wi-Fi as optional secondary networking
5. establish time synchronisation, firewall policy, logging and monitoring
6. define backup, recovery and update procedures
7. retain the local console as a recovery path while the system matures

OpenSSH installation, authentication policy and reboot validation are
documented separately in:

    docs/remote-administration.md

## Pre-deployment recovery snapshot

A final offline recovery snapshot was created after completion of the LFS
base system and all pre-deployment checks:

    backups/erebOS-predeployment.img

The source image was checked offline before copying:

    e2fsck -fn build/erebOS-lfs.img

Result:

    PASS

The recovery snapshot itself was then checked independently:

    e2fsck -fn backups/erebOS-predeployment.img

Result:

    PASS

Filesystem summary:

    erebOS-lfs: 357478/4194304 files (0.1% non-contiguous),
    2816477/16777216 blocks

Snapshot storage:

- logical size: 64 GB
- actual disk usage: approximately 23 GB

This is the canonical known-good recovery point immediately before
deployment to the physical MacBookAir6,2.
