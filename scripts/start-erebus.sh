#!/usr/bin/env bash

set -e

# Prefer the new EREBUS project path, but tolerate the legacy path during migration.
if [ -d "$HOME/Projects/EREBUS" ]; then
    PROJECT="$HOME/Projects/EREBUS"
elif [ -d "$HOME/Projects/erebOS" ]; then
    PROJECT="$HOME/Projects/erebOS"
else
    PROJECT="$HOME/Projects/EREBUS"
fi

# Prefer the renamed image, but fall back to the legacy image name until it is renamed locally.
if [ -f "$PROJECT/build/erebus-lfs.img" ]; then
    IMAGE="$PROJECT/build/erebus-lfs.img"
else
    IMAGE="$PROJECT/build/erebOS-lfs.img"
fi

LFS="/mnt/lfs"

echo "=== Starting EREBUS build session ==="

if [ "$(readlink -f /bin/sh)" != "/usr/bin/bash" ]; then
    echo "Switching host /bin/sh to Bash..."
    sudo ln -sf bash /bin/sh
fi

if [ -e /etc/bash.bashrc ] && [ ! -e /etc/bash.bashrc.NOUSE ]; then
    echo "Temporarily disabling host /etc/bash.bashrc..."
    sudo mv /etc/bash.bashrc /etc/bash.bashrc.NOUSE
fi

sudo mkdir -p "$LFS"

if ! mountpoint -q "$LFS"; then
    echo "Mounting EREBUS filesystem..."
    sudo mount -o loop -t ext4 "$IMAGE" "$LFS"
fi

sudo mkdir -p "$LFS"/{dev,proc,sys,run}

if ! mountpoint -q "$LFS/dev"; then
    sudo mount --bind /dev "$LFS/dev"
fi

if ! mountpoint -q "$LFS/dev/pts"; then
    sudo mount -t devpts devpts \
        -o gid=5,mode=0620 "$LFS/dev/pts"
fi

if ! mountpoint -q "$LFS/proc"; then
    sudo mount -t proc proc "$LFS/proc"
fi

if ! mountpoint -q "$LFS/sys"; then
    sudo mount -t sysfs sysfs "$LFS/sys"
fi

if ! mountpoint -q "$LFS/run"; then
    sudo mount -t tmpfs tmpfs "$LFS/run"
fi

if [ -h "$LFS/dev/shm" ]; then
    sudo install -d -m 1777 "$LFS$(realpath /dev/shm)"
elif ! mountpoint -q "$LFS/dev/shm"; then
    sudo mount -t tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
fi

echo
echo "EREBUS environment ready."
echo "/bin/sh -> $(readlink -f /bin/sh)"
echo
findmnt | grep "$LFS"

echo
echo "To enter EREBUS:"
echo
echo "sudo chroot /mnt/lfs /usr/bin/env -i \\"
echo "    HOME=/root TERM=\"\$TERM\" \\"
echo "    PS1='(EREBUS chroot) \\u:\\w\\\$ ' \\"
echo "    PATH=/usr/bin:/usr/sbin \\"
echo "    MAKEFLAGS='-j4' TESTSUITEFLAGS='-j4' \\"
echo "    /bin/bash --login"
