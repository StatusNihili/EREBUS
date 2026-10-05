# Chapter 9 — System Configuration

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 9 is complete.

Completed on 2026-10-03.

Final checkpoint:

- General network configuration completed
- Device and module handling reviewed
- System clock policy established
- Linux console configured
- System locale configured
- Global Readline configuration created
- Valid login shells configured
- Initial systemd behaviour configured
- Next stage: LFS Chapter 10 — Making the LFS System Bootable

## Network configuration

EREBUS uses systemd-networkd for initial network configuration and
systemd-resolved for DNS resolution.

The following services were verified as enabled:

- systemd-networkd
- systemd-resolved
- systemd-networkd-wait-online

Initial networking is deliberately wired-first. SSH and reliable wired
connectivity will be established before optional Broadcom wireless support
is added through BLFS.

### Wired DHCP profile

The network profile is:

    /etc/systemd/network/10-ethernet-dhcp.network

Contents:

    [Match]
    Type=ether

    [Network]
    DHCP=ipv4

    [DHCPv4]
    UseDomains=true

LFS normally demonstrates matching a specific network interface name.
EREBUS deliberately matches physical Ethernet interfaces by type instead.

Reason:

The final USB Gigabit Ethernet adapter interface name cannot be known
reliably while building inside the CLOTHO-hosted chroot. Matching Type=ether
provides a predictable wired recovery path without hard-coding a guessed
interface name.

After deployment to ATROPOS (MacBookAir6,2), this rule may be tightened to
match the chosen adapter by MAC address or device path if useful.

### DNS

No static /etc/resolv.conf was created.

systemd-resolved is enabled and will create the appropriate resolver link
when EREBUS boots normally.

### Hostname

The system hostname is:

    erebos

stored in:

    /etc/hostname

### Hosts file

/etc/hosts contains the standard IPv6 localhost and multicast entries.

No static IPv4 address or invented home-lab DNS domain was added during
the base LFS build. These will be configured as EREBUS is integrated
into the live home-lab network.

## Device and module handling

LFS Sections 9.3 and 9.4 were reviewed.

No custom udev rules were required during the build-host stage.

Hardware-specific rules will only be introduced if actual first-boot
testing on the MacBookAir6,2 demonstrates a need for them.

## System clock

The hardware real-time clock is being treated as UTC.

No local-time RTC configuration was introduced and /etc/adjtime was not
created for a local-time hardware clock.

This is the preferred configuration for EREBUS as a Linux server.

The system timezone is:

    Europe/London

## Linux console

/etc/vconsole.conf contains:

    KEYMAP=uk
    FONT=Lat2-Terminus16

The UK keymap matches the ATROPOS MacBook Air keyboard.

Lat2-Terminus16 provides suitable Unicode coverage for the Linux virtual
console and the C.UTF-8 console locale.

The configuration will be validated on the physical target after the
first boot because localectl cannot configure the console from the LFS
chroot environment.

## System locale

The normal EREBUS locale is:

    en_GB.UTF-8

/etc/locale.conf contains:

    LANG=en_GB.UTF-8

The locale was verified before configuration:

- language: British English
- character map: UTF-8
- international currency symbol: GBP
- international telephone prefix: 44

/etc/profile follows the LFS console/session split:

- Linux virtual console sessions use C.UTF-8
- other sessions use en_GB.UTF-8 from /etc/locale.conf

This keeps the local console within the character coverage supported by
the configured console font while providing British English localisation
for normal remote and user sessions.

## Readline configuration

The standard LFS system-wide Readline configuration was installed as:

    /etc/inputrc

It provides:

- 8-bit input and output handling
- line wrapping
- silent terminal bell behaviour
- navigation mappings for the Linux console and common terminal emulators

## Valid login shells

/etc/shells contains:

    /bin/sh
    /bin/bash

Additional shells can be added later if they are installed through BLFS.

## Systemd configuration

The tty1 console is configured not to clear automatically at the end of
boot.

Configuration:

    /etc/systemd/system/getty@tty1.service.d/noclear.conf

Contents:

    [Service]
    TTYVTDisallocate=no

Reason:

During the initial hardware bring-up phase, retaining boot messages on
tty1 makes local troubleshooting easier if networking or userspace startup
fails.

Other optional systemd customisations were deliberately deferred:

- no custom tmpfiles rules
- no global user-process lingering changes
- no custom journald policy yet
- no additional service overrides
- no aggressive coredump restrictions during development

These policies will be revisited during BLFS and server hardening once the
base system has booted successfully on the target hardware.

## EREBUS-specific decisions

The principal Chapter 9 deviation from the generic LFS examples is the
wired DHCP match rule:

    Type=ether

rather than a hard-coded interface name.

This is intentional because EREBUS was built on CLOTHO (Acer Nitro 5)
and runs on ATROPOS (MacBookAir6,2), using USB Gigabit Ethernet for initial
network access and recovery.

No ATROPOS-specific udev customisation was added before testing on the
actual target hardware.

## Next step

LFS Chapter 10 — Making the LFS System Bootable.

Chapter 10 will define the target storage layout, build the Linux kernel
for the MacBookAir6,2, and prepare GRUB for the target UEFI system.
