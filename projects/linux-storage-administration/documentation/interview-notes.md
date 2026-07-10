# Interview Talking Points

## Explain the Project

I developed a Bash-based storage auditing tool for Rocky Linux.

The tool automatically generates a timestamped report containing block devices, filesystems, mount points, UUIDs, disk usage, directory usage, `/etc/fstab` configuration and storage health classifications.

---

## Skills Demonstrated

- Linux storage administration
- LVM awareness
- Filesystem analysis
- Mount configuration
- Capacity monitoring
- Bash scripting
- System auditing
- Troubleshooting

---

## Biggest Challenge

The first version counted non-disk devices and virtual filesystems, which made the summary inaccurate.

I refined the filtering logic so the report counted only actual disks and relevant mounted filesystems.

---

## Key Learning

Storage administration requires understanding several layers:

```text
Disk
Partition
LVM
Filesystem
Mount Point
Files and Directories


