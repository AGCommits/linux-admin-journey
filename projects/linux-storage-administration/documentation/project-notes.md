# Phase 2 - Storage Discovery

## Objective

Inspect the storage configuration of the Rocky Linux virtual machine.

## Commands Used

```bash
lsblk
lsblk -f
blkid
df -h
findmnt
```

## Findings

The system contains a single 40 GB virtual disk.

Storage is organised using LVM.

The root filesystem uses XFS.

A separate XFS filesystem is used for `/boot`.

Swap space is provided through a dedicated logical volume.

The VirtualBox Guest Additions ISO is mounted as a read-only ISO9660 filesystem.

## Learning Outcomes

- Identified block devices.
- Distinguished between partitions and logical volumes.
- Reviewed filesystem UUIDs.
- Examined mounted filesystems.
- Inspected disk capacity and utilisation.

# Phase 3 - Disk Usage Analysis

## Objective

Investigate filesystem and directory usage to identify storage consumption.

## Commands Used

```bash
du -sh ~
du -sh ~/*
du -sh ~/* | sort -h
du -sh .
du -sh *
find ~ -type f -exec du -h {} + | sort -h | tail -20
```

## Learning Outcomes

- Measured total home directory usage.
- Compared directory sizes.
- Sorted storage consumption.
- Investigated project size.
- Located the largest files in the home directory.
- Understood the difference between `df` and `du`.

# Phase 4 - Filesystem Configuration

## Objective

Inspect Linux filesystem configuration and understand how filesystems are mounted during boot.

## Commands Used

```bash
cat /etc/fstab
cat -n /etc/fstab
blkid
findmnt
```

## Learning Outcomes

- Examined the `/etc/fstab` configuration file.
- Compared UUIDs with mounted filesystems.
- Understood how Linux identifies filesystems.
- Compared configured mounts with active mounts.
- Learned how Linux automatically mounts filesystems during boot.

---

# Phase 6 - Storage Health Assessment

## Objective

Add clear storage health classifications to the audit report.

## Health Thresholds

```text
HEALTHY  - Below 70% usage
WARNING  - 70% to 89% usage
CRITICAL - 90% usage or higher

