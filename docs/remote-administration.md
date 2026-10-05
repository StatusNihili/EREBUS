# EREBUS Remote Administration

## Purpose

EREBUS is intended to operate primarily as a headless TENEBRAE home-lab server.

Remote administration is provided through OpenSSH, with ATROPOS's local console retained as a recovery path.

## OpenSSH installation

OpenSSH 10.5p1 was built and installed on ATROPOS (MacBookAir6,2) after repairing the GMP/MPFR/MPC portability problem documented in `chapter-08-basic-system.md`.

Verification completed successfully:

- `misc.o`, which had previously triggered a GCC illegal-instruction failure, compiled successfully.
- Full OpenSSH build completed successfully.
- OpenSSH regression tests completed successfully.
- Installed client reported:

      OpenSSH_10.5p1, OpenSSL 4.0.1 9 Jun 2026

The matching BLFS systemd service unit was installed from:

    blfs-systemd-units-20251204

The `sshd.service` unit is enabled for `multi-user.target`.

## Administrative account

A normal administrative account was created:

    andy

Account properties:

- UID: 1000
- GID: 1000
- shell: `/bin/bash`

Direct remote administration is performed as `andy`.

Root privileges are obtained after login using:

    su -

Direct SSH login as root is disabled.

## Authentication

An existing Ed25519 key on CLOTHO, the Acer Nitro build/admin workstation, is used for EREBUS access:

    ~/.ssh/air_ed25519

The public key was installed into the `andy` account on ATROPOS.

Key-based login was verified successfully from CLOTHO.

## SSH hardening

The effective SSH authentication policy is:

    PermitRootLogin no
    PubkeyAuthentication yes
    PasswordAuthentication no
    KbdInteractiveAuthentication no

Configuration syntax was validated with:

    sshd -t

The daemon was reloaded after configuration changes.

Password and keyboard-interactive SSH authentication are disabled.

Root SSH login is disabled entirely.

## Network validation

During initial setup ATROPOS used:

    192.168.1.231

CLOTHO reached ATROPOS successfully over TCP port 22.

The SSH protocol handshake advertised:

    SSH-2.0-OpenSSH_10.5

RSA, ECDSA and Ed25519 host keys were generated during installation.

The Ed25519 host key was accepted and stored by CLOTHO on first connection.

IP addresses documented here are DHCP-era setup addresses and should not be treated as permanent addressing policy.

## Reboot validation

A complete reboot test was performed after OpenSSH installation and hardening.

After reboot:

- EREBUS returned successfully to the local login prompt.
- networking returned automatically.
- `sshd.service` started automatically.
- `systemctl is-active sshd` reported `active`.
- key-authenticated login from CLOTHO succeeded without local intervention.
- the hardened SSH policy remained in effect.

This established working remote administration independent of the ATROPOS keyboard and display.

## Recovery considerations

Until networking, boot configuration and recovery procedures are fully mature, the ATROPOS local console should remain available as an emergency administration path.

SSH configuration changes should be validated with:

    sshd -t

before reloading or restarting the daemon.

When changing authentication policy remotely, keep an existing working SSH session open until a fresh connection has been verified successfully.
