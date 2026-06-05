#!/bin/bash

# ==================================================
# Backup Automation Script
# ==================================================
#
# Purpose:
# Create a compressed backup of the source-data directory.
#
# The script:
# - Checks that the source-data directory exists
# - Creates a timestamped backup filename
# - Compresses the source-data directory
# - Stores the backup in the backups directory
# - Verifies the archive contents
# - Writes a success entry to a log file
# - Displays the current number of backup archives
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

# Verify the source directory exists before attempting backup.
# This prevents the script from failing unexpectedly if the
# source-data directory has been deleted or renamed.
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup completed successfully."

echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created successfully: $BACKUP_FILE" >> "$LOG_FILE"

echo ""
echo "Backup contents:"
tar -tzf "$BACKUP_DIR/$BACKUP_FILE"

# Display the total number of backup archives currently stored.
# This provides a quick verification that new backups are being created.
echo ""
echo "Current backup count:"
ls backups/*.tar.gz | wc -l