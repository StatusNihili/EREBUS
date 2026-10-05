#!/usr/bin/env bash

set -e

LFS="/mnt/lfs"

echo "=== Closing EREBUS build session ==="

if mountpoint -q "$LFS/dev/shm"; then
    sudo umount "$LFS/dev/shm"
fi

if mountpoint -q "$LFS/dev/pts"; then
    sudo umount "$LFS/dev/pts"
fi

for target in sys proc run dev; do
    if mountpoint -q "$LFS/$target"; then
        sudo umount "$LFS/$target"
    fi
done

if mountpoint -q "$LFS"; then
    sudo umount "$LFS"
fi

if [ -e /etc/bash.bashrc.NOUSE ] && [ ! -e /etc/bash.bashrc ]; then
    echo "Restoring Ubuntu /etc/bash.bashrc..."
    sudo mv /etc/bash.bashrc.NOUSE /etc/bash.bashrc
fi

if [ "$(readlink -f /bin/sh)" != "/usr/bin/dash" ]; then
    echo "Restoring Ubuntu /bin/sh to Dash..."
    sudo ln -sf dash /bin/sh
fi

echo
echo "EREBUS session closed."
echo "/bin/sh -> $(readlink -f /bin/sh)"
