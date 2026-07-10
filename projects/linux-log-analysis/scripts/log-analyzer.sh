#!/bin/bash

#
# Linux Log Analysis Script
# Purpose:
#   Generate a timestamped Linux administration report for troubleshooting,
#   log review, failed service checks, login analysis, and system health review.
#
# Handoff Notes:
#   This script is designed to be readable and maintainable.
#   Each section has comments explaining what information is collected.
#

# ================================
# Configuration Section
# ================================
# These values control how much information appears in each report section.

MAX_RECENT_LOGINS=5
MAX_FAILED_LOGINS=10
MAX_ERRORS=20
MAX_SSH_LINES=20
MAX_PROCESSES=10

REPORT_DATE=$(date +"%Y-%m-%d_%H-%M")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

REPORT_FILE="$PROJECT_DIR/reports/log-report-$REPORT_DATE.txt"

# Redirect all normal output into the timestamped report file.
exec > "$REPORT_FILE"

# ================================
# Summary Variables
# ================================
# These collect quick summary values for the top of the report.

FAILED_SERVICE_COUNT=$(systemctl --failed --no-legend | wc -l)
CURRENT_USER_COUNT=$(who | wc -l)
FAILED_LOGIN_COUNT=$(sudo lastb 2>/dev/null | grep -v "btmp begins" | wc -l)

# ================================
# Report Header
# ================================

echo "================================="
echo " Linux Log Analysis Report"
echo "================================="
echo "Hostname: $(hostname)"
echo "Current User Running Script: $(whoami)"
echo "Kernel Version: $(uname -r)"
echo "Report Generated: $(date)"
echo "Report File: $REPORT_FILE"
echo

# ================================
# Executive Summary
# ================================
# Gives a quick overview before reading the full report.

echo "================================="
echo " Executive Summary"
echo "================================="
echo "Failed Services Detected: $FAILED_SERVICE_COUNT"
echo "Currently Logged In Users: $CURRENT_USER_COUNT"
echo "Failed Login Records Found: $FAILED_LOGIN_COUNT"
echo

if [ "$FAILED_SERVICE_COUNT" -gt 0 ]; then
    echo "WARNING: Failed services were detected. Review the Failed Services section."
fi

if [ "$FAILED_LOGIN_COUNT" -gt 0 ]; then
    echo "WARNING: Failed login records were detected. Review the Failed Logins section."
fi

echo

# ================================
# Recent Logins Section
# ================================
# Shows recent successful login activity.

echo "================================="
echo " Recent Logins"
echo "================================="
last -n "$MAX_RECENT_LOGINS"

# ================================
# Failed Logins Section
# ================================
# Shows recent failed login attempts.
# Requires sudo because failed login records are stored in /var/log/btmp.

echo
echo "================================="
echo " Failed Logins"
echo "================================="
sudo lastb 2>/dev/null | head -n "$MAX_FAILED_LOGINS"

# ================================
# Recent Errors Section
# ================================
# Shows recent system errors from journalctl.

echo
echo "================================="
echo " Recent Errors"
echo "================================="
journalctl -p err -n "$MAX_ERRORS"

# ================================
# SSH Activity Section
# ================================
# Searches journal logs for SSH-related activity.

echo
echo "================================="
echo " SSH Activity"
echo "================================="
journalctl | grep -i ssh | tail -n "$MAX_SSH_LINES"

# ================================
# System Uptime Section
# ================================
# Shows how long the system has been running and the load average.

echo
echo "================================="
echo " System Uptime"
echo "================================="
uptime

# ================================
# Memory Usage Section
# ================================
# Shows current RAM and swap usage.

echo
echo "================================="
echo " Memory Usage"
echo "================================="
free -h

# ================================
# Disk Usage Section
# ================================
# Shows mounted filesystems and disk usage.

echo
echo "================================="
echo " Disk Usage"
echo "================================="
df -h

# ================================
# Failed Services Section
# ================================
# Lists systemd services that failed.

echo
echo "================================="
echo " Failed Services"
echo "================================="
systemctl --failed

# ================================
# Logged In Users Section
# ================================
# Shows users currently logged into the system.

echo
echo "================================="
echo " Logged In Users"
echo "================================="
who

# ================================
# Network Information Section
# ================================
# Shows IP addressing and network interface information.

echo
echo "================================="
echo " Network Information"
echo "================================="
ip addr

# ================================
# Top Memory Processes Section
# ================================
# Shows the processes currently using the most memory.

echo
echo "================================="
echo " Top Memory Processes"
echo "================================="
ps aux --sort=-%mem | head -n "$MAX_PROCESSES"

# ================================
# CPU Information Section
# ================================
# Shows processor, architecture, and virtualization information.

echo
echo "================================="
echo " CPU Information"
echo "================================="

if command -v lscpu >/dev/null 2>&1; then
    lscpu
else
    echo "lscpu command not found."
fi

# ================================
# End of Report
# ================================

echo
echo "================================="
echo " End of Report"
echo "================================="
