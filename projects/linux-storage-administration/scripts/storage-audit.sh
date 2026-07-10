#!/bin/bash

#
# Linux Storage Audit Script
#
# Purpose:
# Generate a professional storage audit report.
#

# ==========================================
# Configuration
# ==========================================

START_TIME=$(date +%s)

REPORT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

REPORT_FILE="$PROJECT_DIR/reports/storage-audit-$REPORT_DATE.txt"

# ==========================================
# Executive Summary Variables
# ==========================================

HOSTNAME=$(hostname)

ROOT_USAGE=$(df -h / | awk 'NR==2 {print $5}')

ROOT_USAGE_VALUE=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

ROOT_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')

BOOT_USAGE=$(df -h /boot | awk 'NR==2 {print $5}')

BOOT_USAGE_VALUE=$(df -h /boot | awk 'NR==2 {gsub("%",""); print $5}')

FILESYSTEM_COUNT=$(findmnt -rn -t xfs,ext4,btrfs,vfat,ntfs,iso9660 | wc -l)

DISK_COUNT=$(lsblk -dn -o TYPE | grep -c '^disk$')

# ==========================================
# Begin Report
# ==========================================

#
# Storage Health
#

if [ "$ROOT_USAGE_VALUE" -lt 70 ]; then
    ROOT_HEALTH="HEALTHY"
elif [ "$ROOT_USAGE_VALUE" -lt 90 ]; then
    ROOT_HEALTH="WARNING"
else
    ROOT_HEALTH="CRITICAL"
fi

if [ "$BOOT_USAGE_VALUE" -lt 70 ]; then
    BOOT_HEALTH="HEALTHY"
elif [ "$BOOT_USAGE_VALUE" -lt 90 ]; then
    BOOT_HEALTH="WARNING"
else
    BOOT_HEALTH="CRITICAL"
fi

exec > "$REPORT_FILE"

echo "========================================="
echo " Linux Storage Audit Report"
echo "========================================="
echo "Generated: $(date)"
echo

echo "========================================="
echo " Executive Summary"
echo "========================================="

echo "Hostname:              $HOSTNAME"
echo "Detected Disks:        $DISK_COUNT"
echo "Mounted Filesystems:   $FILESYSTEM_COUNT"
echo "Root Usage:            $ROOT_USAGE ($ROOT_HEALTH)"
echo "Root Available:        $ROOT_AVAILABLE"
echo "Boot Usage:            $BOOT_USAGE ($BOOT_HEALTH)"

echo

echo "========================================="
echo " Block Devices"
echo "========================================="

lsblk

echo

echo "========================================="
echo " Filesystems"
echo "========================================="

lsblk -f

echo "========================================="
echo " Filesystem UUIDs"
echo "========================================="

if sudo -n blkid >/dev/null 2>&1; then
    sudo -n blkid
else
    echo "Filesystem UUID details require root privileges."
    echo "Run the script with sudo for the full UUID inventory."
    lsblk -f
fi

echo

blkid

echo

echo "========================================="
echo " Mounted Filesystems"
echo "========================================="

findmnt

echo

echo "========================================="
echo " Disk Usage"
echo "========================================="

df -h

echo

echo "========================================="
echo " Home Directory Usage"
echo "========================================="

du -sh ~

echo

echo "========================================="
echo " Top Level Directory Usage"
echo "========================================="

du -sh ~/* | sort -h

echo

echo "========================================="
echo " Largest Files"
echo "========================================="

find ~ -type f -exec du -h {} + | sort -h | tail -20

echo

echo "========================================="
echo " Filesystem Table (/etc/fstab)"
echo "========================================="

cat /etc/fstab

echo

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

echo "========================================="
echo " Report Statistics"
echo "========================================="

echo "Execution Time: ${DURATION} seconds"

echo

echo "========================================="
echo " End of Report"
echo "========================================="
