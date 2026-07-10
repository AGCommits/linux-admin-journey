#!/bin/bash

#
# Linux Service Administration
#
# service-monitor.sh
#
# Purpose:
# A simple monitoring service used to demonstrate how systemd
# manages long-running background processes.
#
# The script continuously writes timestamped heartbeat messages
# to a log file every 10 seconds.
#

# ================================
# Project Path Detection
# ================================

PROJECT_DIR="/home/ash/linux-service-administration"
LOG_FILE="$PROJECT_DIR/reports/service-monitor.log"

# ================================
# Service Loop
# ================================
# This infinite loop represents a continuously running service.

while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Service heartbeat - Running normally." >> "$LOG_FILE"

    sleep 10
done
