#!/bin/bash

# ==================================================
# Backup Automation Script
# ==================================================
#
# Purpose:
# Create a compressed backup of the source-data directory.
#
# The script:
# - Creates a timestamped backup filename
# - Compresses the source-data directory
# - Stores the backup in the backups directory
# - Verifies the archive contents
# - Writes a success entry to a log file
#
# ==================================================

SOURCE_DIR="source-data"
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backup-$DATE.tar.gz"

echo "===== Backup Automation Script ====="
echo "Source directory: $SOURCE_DIR"
echo "Backup directory: $BACKUP_DIR"
echo "Backup file: $BACKUP_FILE"
echo ""

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup completed successfully."

echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created successfully: $BACKUP_FILE" >> "$LOG_FILE"

echo ""
echo "Backup contents:"
tar -tzf "$BACKUP_DIR/$BACKUP_FILE"