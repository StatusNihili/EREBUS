# EREBUS Build Storage

## Build host storage

CLOTHO (Acer Nitro 5) contains:

- `/dev/nvme0n1` — 2 TB Kingston NVMe SSD
  - Ubuntu build host
  - EREBUS project files
  - EREBUS LFS build image

- `/dev/sda` — 1 TB Toshiba SATA HDD
  - Existing EFI and ext4 partitions
  - Treated as legacy/existing storage
  - Not used by the EREBUS build

## LFS filesystem

EREBUS was initially constructed inside a sparse 64 GB ext4 filesystem image:

`~/Projects/erebOS/build/erebOS-lfs.img`

It is mounted at:

`/mnt/lfs`

This isolates the LFS build from CLOTHO's physical partition layout and avoids modifying either physical disk.
