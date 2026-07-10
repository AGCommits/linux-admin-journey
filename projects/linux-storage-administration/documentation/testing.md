# Test 1 - Disk Usage Analysis

## Objective

Verify that Linux storage usage commands correctly identify filesystem and directory sizes.

## Commands Tested

```bash
du -sh ~/*
find ~ -type f -exec du -h {} + | sort -h | tail -20
```

## Results

- Home directory usage successfully analysed.
- Project directories were identified and compared.
- Firefox cache files were identified as the largest files.
- No unusually large project files were present.

## Result

Passed.

# Test 2 - Filesystem Configuration

## Objective

Verify the Linux filesystem configuration matches the mounted filesystems.

## Commands Tested

```bash
cat /etc/fstab
cat -n /etc/fstab
blkid
findmnt
```

## Results

- Verified the root filesystem configuration.
- Verified the boot partition configuration.
- Verified the swap configuration.
- Confirmed that `/etc/fstab` entries matched the active mounted filesystems.
- Confirmed that the `/boot` partition is mounted by UUID.
- Confirmed that LVM logical volumes are mounted using `/dev/mapper` paths.

## Result

Passed.


---

# Test 3 - Storage Audit Script

## Objective

Verify that the storage audit script generates an accurate timestamped report.

## Commands Tested

```bash
./scripts/storage-audit.sh
LATEST_REPORT=$(ls -t reports/storage-audit-*.txt | head -1)
head -20 "$LATEST_REPORT"
