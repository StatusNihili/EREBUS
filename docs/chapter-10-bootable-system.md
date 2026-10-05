# Chapter 10 — Making the LFS System Bootable

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 10 is complete.

Completed:

- target filesystem layout defined
- `/etc/fstab` created
- Linux 7.1.8 configured for the MacBookAir6,2
- kernel and modules built successfully
- kernel artifacts installed under `/boot`
- kernel configuration preserved in Git
- ATROPOS internal SSD partitioned using GPT
- EFI System Partition created as `/dev/sda1`
- EREBUS root partition created as `/dev/sda2`
- EREBUS filesystem deployed to ATROPOS
- GRUB 2.14 installed for x86_64 EFI
- removable/fallback EFI boot path created
- final GRUB configuration created using the real root PARTUUID
- first native MacBookAir6,2 boot completed successfully

## Target storage layout

The ATROPOS internal SSD (2014 MacBook Air) is dedicated entirely to EREBUS.

Planned layout:

    GPT
    ├── Partition 1   512 MiB   FAT32   EFI System Partition
    │                            filesystem label: EREBOS_EFI
    └── Partition 2   remainder  ext4    EREBUS root filesystem
                                 filesystem label: erebOS-root

No dedicated swap partition is planned.

If swap is required after deployment, a swapfile can be added later without
changing the partition layout.

## /etc/fstab

The target filesystem table is:

    LABEL=erebOS-root   /            ext4   defaults                                     1  1
    LABEL=EREBOS_EFI    /boot/efi    vfat   rw,relatime,codepage=437,iocharset=iso8859-1,umask=0077  0  2

Stable filesystem labels are used instead of /dev/sdX device names.

The EFI System Partition will be mounted at:

    /boot/efi

The ESP mount point has been created in the EREBUS root filesystem.

## Kernel

Kernel version:

    Linux 7.1.8

Kernel release:

    7.1.8

Build host:

    CLOTHO — Acer Nitro 5 AN515-52

Build parallelism:

    MAKEFLAGS=-j4

Build command:

    time make

Build result:

    Kernel: arch/x86/boot/bzImage is ready (#1)

Build timing:

    real    9m50.410s
    user    34m40.550s
    sys     3m40.640s

## Kernel configuration strategy

The kernel was configured specifically for the target MacBookAir6,2 rather
than by detecting the CLOTHO build host.

The process was:

    make mrproper
    make defconfig

followed by deliberate LFS and MacBookAir6,2 configuration changes.

make localmodconfig was not used because it would configure the kernel for
CLOTHO rather than the target ATROPOS system.

The first EREBUS kernel prioritises reliable booting and diagnostics over
aggressive minimisation.

## No-initramfs design

The initial EREBUS boot is designed without an initramfs.

For this reason, all components required to reach and mount the root
filesystem are built directly into the kernel.

Boot-critical storage configuration includes:

    CONFIG_ATA=y
    CONFIG_SATA_AHCI=y
    CONFIG_SCSI=y
    CONFIG_BLK_DEV_SD=y
    CONFIG_EXT4_FS=y

This provides the path:

    MacBook PCIe SSD
        -> AHCI
        -> SCSI disk layer
        -> ext4 root filesystem

EFI and partition support is also built in:

    CONFIG_EFI=y
    CONFIG_EFI_STUB=y
    CONFIG_EFI_PARTITION=y

## LFS/systemd kernel configuration

Important LFS 13.1-systemd settings include:

    CONFIG_WERROR=n
    CONFIG_PSI=y
    CONFIG_PSI_DEFAULT_DISABLED=n
    CONFIG_CGROUPS=y
    CONFIG_MEMCG=y
    CONFIG_CGROUP_SCHED=y
    CONFIG_RT_GROUP_SCHED=n
    CONFIG_DEVTMPFS=y
    CONFIG_DEVTMPFS_MOUNT=y
    CONFIG_LEGACY_TIOCSTI=n
    CONFIG_TMPFS=y
    CONFIG_TMPFS_POSIX_ACL=y

Diagnostic framebuffer support was enabled:

    CONFIG_SYSFB_SIMPLEFB=y
    CONFIG_DRM_PANIC=y
    CONFIG_DRM_PANIC_SCREEN="kmsg"
    CONFIG_DRM_FBDEV_EMULATION=y
    CONFIG_DRM_SIMPLEDRM=y
    CONFIG_FRAMEBUFFER_CONSOLE=y

These settings improve visibility of early boot failures before the full
graphics driver is loaded.

## MacBookAir6,2-specific kernel choices

Apple EFI support:

    CONFIG_APPLE_PROPERTIES=y

Internal keyboard support:

    CONFIG_HID_APPLE=y

USB and recovery input support is built into the kernel:

    CONFIG_USB=y
    CONFIG_USB_XHCI_HCD=y
    CONFIG_USB_XHCI_PCI=y
    CONFIG_HID=y
    CONFIG_HID_GENERIC=y
    CONFIG_USB_HID=y

Intel graphics is modular for the initial boot:

    CONFIG_DRM_I915=m

This allows SimpleDRM to remain available during the earliest boot stages
and preserves useful early-console diagnostics.

Additional target hardware is modular:

    CONFIG_MOUSE_BCM5974=m
    CONFIG_SENSORS_APPLESMC=m
    CONFIG_INTEL_POWERCLAMP=m
    CONFIG_X86_PKG_TEMP_THERMAL=m

Broad USB Ethernet coverage was included because the exact recovery adapter
chipset should not be assumed before target testing:

    CONFIG_USB_USBNET=m
    CONFIG_USB_NET_AX8817X=m
    CONFIG_USB_NET_AX88179_178A=m
    CONFIG_USB_RTL8152=m
    CONFIG_USB_NET_CDCETHER=m

Wired Ethernet remains the preferred initial networking and recovery path.

## Installed kernel artifacts

Installed under /boot:

    /boot/vmlinuz-7.1.8-lfs-13.1-systemd
    /boot/System.map-7.1.8
    /boot/config-7.1.8

Observed sizes:

    vmlinuz-7.1.8-lfs-13.1-systemd   approximately 14 MiB
    System.map-7.1.8                 approximately 8.2 MiB
    config-7.1.8                     approximately 146 KiB

Kernel modules were installed under:

    /usr/lib/modules/7.1.8

Installed module tree size:

    approximately 12 MiB

Kernel documentation was copied to:

    /usr/share/doc/linux-7.1.8

## Reproducible kernel configuration

The exact successful kernel configuration has been preserved in the
repository as:

    configs/kernel/linux-7.1.8-macbookair6-2.config

SHA256:

    1a7fc61a477f45ca394aba855148c671ca70289f95566fd261a8a3fbf152cf4e

This checksum matches /boot/config-7.1.8 from the built EREBUS filesystem.

The kernel source tree was retained at:

    /sources/linux-7.1.8

and ownership was normalised to root:root after the build.

No /usr/src/linux symlink was created.

## GRUB

GRUB version:

    GRUB 2.14

Architecture/platform:

    x86_64 EFI

Target EFI System Partition:

    /dev/sda1

Target root partition:

    /dev/sda2

GRUB was installed on ATROPOS using the removable EFI
fallback path.

The installation completed successfully and created:

    /boot/efi/EFI/BOOT/BOOTX64.EFI

This avoids dependence on firmware NVRAM boot-entry creation and provides
the standard UEFI removable-media fallback path.

## GRUB deployment

During the CLOTHO-hosted build, final GRUB installation was deliberately
deferred because the real ATROPOS EFI System Partition did not yet
exist.

After deployment to ATROPOS, the real ESP was mounted at:

    /boot/efi

GRUB installation was then performed against the actual target filesystem
rather than the temporary build image.

This preserved the rule that no bootloader installation would be attempted
against CLOTHO or an artificial ESP during the hosted build.

## Target deployment sequence

The planned deployment procedure was completed on the physical
MacBookAir6,2.

Final target layout:

    /dev/sda1    EFI System Partition
    /dev/sda2    EREBUS root filesystem

Filesystem labels:

    EREBOS_EFI
    erebOS-root

Deployment included:

1. confirming the internal SSD identity before destructive changes
2. creating the GPT partition table
3. creating the EFI System Partition
4. creating the ext4 root partition
5. deploying the EREBUS root filesystem
6. mounting the ESP at `/boot/efi`
7. recording the actual root partition identifiers
8. installing GRUB for x86_64 EFI using the removable/fallback path
9. creating the final GRUB configuration
10. rebooting into EREBUS natively

The first native boot reached the `erebos login` prompt successfully.

## GRUB root identification

The deployed EREBUS root filesystem is:

    /dev/sda2

Root filesystem UUID:

    03f54e54-7874-485e-b23d-22d41b138918

Root partition PARTUUID:

    4bf7a06c-5108-426e-9522-bcb536ec1126

The final kernel command line identifies the root filesystem using the real
target PARTUUID rather than relying on a device name:

    root=PARTUUID=4bf7a06c-5108-426e-9522-bcb536ec1126

This avoids dependence on Linux block-device enumeration order.

## Current checkpoint

Chapter 10 is complete.

ATROPOS (MacBookAir6,2) now boots EREBUS natively from its internal SSD using the
installed Linux 7.1.8 kernel and GRUB 2.14 EFI bootloader.

The first native boot successfully reached the local `erebos login` prompt.

Subsequent validation has also confirmed working wired networking and
remote administration over OpenSSH.

Further hardware enablement and server functionality now belong to the
post-LFS/BLFS phase rather than Chapter 10.

## Recovery snapshot

A complete offline recovery snapshot was created after the Chapter 10
kernel milestone:

    backups/erebOS-ch10-kernel.img

Filesystem integrity was checked offline with:

    e2fsck -fn

Result:

    PASS

Snapshot storage:

- logical size: 64 GB
- actual disk usage: approximately 23 GB

Filesystem summary:

    erebOS-lfs: 357475/4194304 files (0.1% non-contiguous),
    2816474/16777216 blocks

This snapshot represents the known-good EREBUS system after:

- completion of LFS Chapter 9
- creation of the target /etc/fstab
- successful Linux 7.1.8 build for MacBookAir6,2
- installation of kernel modules and boot artifacts
- verification of GRUB 2.14 x86_64 EFI support

Final GRUB installation was subsequently completed on ATROPOS after the
real EFI System Partition was created and mounted at `/boot/efi`.
