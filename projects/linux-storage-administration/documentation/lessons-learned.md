# Lessons Learned

## What I Learned

- How Linux represents disks, partitions, logical volumes and filesystems.
- How to inspect block devices with `lsblk`.
- How to identify filesystems and UUIDs with `blkid`.
- How to analyse capacity with `df`.
- How to analyse directory usage with `du`.
- How `/etc/fstab` controls automatic mounts.
- How LVM logical volumes differ from standard partitions.
- How to create an automated storage audit report.

---

## Challenges

The first audit script counted the VirtualBox optical drive as a physical disk.

It also counted temporary and virtual filesystems as mounted storage.

The UUID section required additional handling because `blkid` may need elevated privileges.

The report command also briefly duplicated the `reports/` path.

---

## Fixes Applied

- Filtered `lsblk` output to count only devices of type `disk`.
- Filtered `findmnt` output to count relevant storage filesystem types.
- Added safe UUID handling.
- Used a reusable `LATEST_REPORT` variable.
- Added HEALTHY, WARNING and CRITICAL usage classifications.

---

## Future Improvements

- Add LVM physical volume, volume group and logical volume reporting.
- Add inode usage checks.
- Add filesystem mount-option analysis.
- Add JSON or HTML report export.
- Add automatic warning notifications.


