#!/bin/bash

# ============================================================
# Project:
#   Linux Scheduled Task Automation
#
# Script:
#   maintenance-task.sh
#
# Description:
#   Performs a safe, read-only system maintenance snapshot and
#   records the results in a timestamped report and execution
#   log. The script can run manually, through cron, or through
#   a systemd timer.
#
# Author:
#   Ash
#
# Repository:
#   linux-admin-journey
#
# Target Platform:
#   Rocky Linux 9
#
# Created:
#   July 2026
#
# Current Version:
#   1.0.0
#
# ============================================================
#
# Version History
#
# 1.0.0
# - Initial production release.
# - Supports manual, cron, and systemd timer execution.
# - Records disk, memory, uptime, package, and service status.
# - Generates timestamped reports.
# - Maintains a persistent execution log.
# - Uses locking to prevent overlapping executions.
#
# ============================================================
#
# Safety
#
# This script is read-only. It does not:
# - Install or remove packages.
# - Restart or stop services.
# - Delete logs or temporary files.
# - Modify users, permissions, networking, or firewall rules.
#
# ============================================================

set -u
set -o pipefail

# ------------------------------------------------------------
# Project paths
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${PROJECT_ROOT}/reports"
LOG_DIR="${PROJECT_ROOT}/logs"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/maintenance-run-${TIMESTAMP}.txt"
LOG_FILE="${LOG_DIR}/maintenance-task.log"
LOCK_FILE="/tmp/linux-admin-maintenance.lock"

mkdir -p "${REPORT_DIR}" "${LOG_DIR}"

# ------------------------------------------------------------
# State
# ------------------------------------------------------------

SCRIPT_VERSION="1.0.0"
EXIT_STATUS=0
FAILED_SERVICE_COUNT=0
AVAILABLE_UPDATE_COUNT="Unknown"
ROOT_USAGE_PERCENT="Unknown"
MEMORY_USAGE_PERCENT="Unknown"

# ------------------------------------------------------------
# Formatting and logging functions
# ------------------------------------------------------------

write_section() {
    printf '%s\n' "============================================================"
    printf ' %s\n' "$1"
    printf '%s\n' "============================================================"
}

write_item() {
    printf '%-28s %s\n' "$1:" "$2"
}

log_message() {
    local level="$1"
    local message="$2"

    printf '%s [%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "${level}" \
        "${message}" >> "${LOG_FILE}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

get_operating_system() {
    if [[ -r /etc/os-release ]]; then
        awk -F= '
            /^PRETTY_NAME=/ {
                value=$2
                gsub(/^"|"$/, "", value)
                print value
                exit
            }
        ' /etc/os-release
    else
        uname -s
    fi
}

get_root_usage() {
    df -P / 2>/dev/null |
        awk 'NR == 2 {gsub(/%/, "", $5); print $5}'
}

get_memory_usage() {
    free 2>/dev/null |
        awk '
            /^Mem:/ {
                if ($2 > 0) {
                    printf "%.0f", ($3 / $2) * 100
                } else {
                    print "0"
                }
            }
        '
}

get_failed_service_count() {
    if ! command_exists systemctl; then
        printf '0'
        return
    fi

    systemctl --failed --no-legend --plain 2>/dev/null |
        awk 'NF > 0 {count++} END {print count + 0}'
}

get_available_update_count() {
    if command_exists dnf; then
        local update_output
        local dnf_status

        update_output="$(dnf -q check-update 2>/dev/null)"
        dnf_status=$?

        case "${dnf_status}" in
            0)
                printf '0'
                ;;
            100)
                awk '
                    /^[[:alnum:]_.+-]+[[:space:]]+[[:alnum:]_.:+-]+[[:space:]]+/ {
                        count++
                    }

                    END {
                        print count + 0
                    }
                ' <<< "${update_output}"
                ;;
            *)
                printf 'Unknown'
                ;;
        esac
    else
        printf 'Unavailable'
    fi
}

acquire_lock() {
    if command_exists flock; then
        exec 9>"${LOCK_FILE}"

        if ! flock -n 9; then
            log_message "WARNING" \
                "Maintenance task did not start because another instance is running."

            printf 'Another maintenance task instance is already running.\n' >&2
            exit 1
        fi
    else
        log_message "WARNING" \
            "flock is unavailable; overlap protection could not be enabled."
    fi
}

cleanup() {
    local task_status=$?

    if [[ "${task_status}" -eq 0 ]]; then
        log_message "INFO" \
            "Maintenance task completed successfully. Report: ${REPORT_FILE}"
    else
        log_message "ERROR" \
            "Maintenance task exited with status ${task_status}. Report: ${REPORT_FILE}"
    fi
}

trap cleanup EXIT

# ------------------------------------------------------------
# Prepare audit values
# ------------------------------------------------------------

acquire_lock

log_message "INFO" "Maintenance task started."

ROOT_USAGE_PERCENT="$(get_root_usage)"
MEMORY_USAGE_PERCENT="$(get_memory_usage)"
FAILED_SERVICE_COUNT="$(get_failed_service_count)"
AVAILABLE_UPDATE_COUNT="$(get_available_update_count)"

[[ -n "${ROOT_USAGE_PERCENT}" ]] || ROOT_USAGE_PERCENT="Unknown"
[[ -n "${MEMORY_USAGE_PERCENT}" ]] || MEMORY_USAGE_PERCENT="Unknown"

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux Scheduled Maintenance Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "${SCRIPT_VERSION}"
    write_item "Report file" "${REPORT_FILE}"

    printf '\n'
    write_section "Executive Summary"

    write_item "Root filesystem usage" "${ROOT_USAGE_PERCENT}%"
    write_item "Memory usage" "${MEMORY_USAGE_PERCENT}%"
    write_item "Failed services" "${FAILED_SERVICE_COUNT}"
    write_item "Available updates" "${AVAILABLE_UPDATE_COUNT}"

    printf '\n'
    write_section "System Information"

    write_item "Operating system" "$(get_operating_system)"
    write_item "Kernel version" "$(uname -r)"
    write_item "Architecture" "$(uname -m)"
    write_item "Uptime" "$(uptime -p 2>/dev/null || uptime)"
    write_item "Boot time" "$(uptime -s 2>/dev/null || printf 'Unavailable')"

    printf '\n'
    write_section "Filesystem Usage"

    if command_exists df; then
        df -hT 2>&1
    else
        printf 'WARNING: df is unavailable.\n'
        EXIT_STATUS=1
    fi

    printf '\n'
    write_section "Memory Usage"

    if command_exists free; then
        free -h 2>&1
    else
        printf 'WARNING: free is unavailable.\n'
        EXIT_STATUS=1
    fi

    printf '\n'
    write_section "System Load"

    if [[ -r /proc/loadavg ]]; then
        write_item "Load averages" "$(cut -d' ' -f1-3 /proc/loadavg)"
    else
        write_item "Load averages" "Unavailable"
    fi

    if command_exists uptime; then
        uptime
    fi

    printf '\n'
    write_section "Failed Services"

    if command_exists systemctl; then
        systemctl --failed --no-pager 2>&1
    else
        printf 'WARNING: systemctl is unavailable.\n'
        EXIT_STATUS=1
    fi

    printf '\n'
    write_section "Available Package Updates"

    write_item "Available update count" "${AVAILABLE_UPDATE_COUNT}"

    if command_exists dnf; then
        dnf -q check-update 2>&1
        DNF_STATUS=$?

        if [[ "${DNF_STATUS}" -ne 0 && "${DNF_STATUS}" -ne 100 ]]; then
            printf 'WARNING: dnf check-update returned status %s.\n' \
                "${DNF_STATUS}"
            EXIT_STATUS=1
        fi
    else
        printf 'WARNING: dnf is unavailable.\n'
        EXIT_STATUS=1
    fi

    printf '\n'
    write_section "Recent High-Priority Logs"

    if command_exists journalctl; then
        journalctl \
            --priority=err \
            --since "24 hours ago" \
            --no-pager \
            -n 50 2>&1
    else
        printf 'WARNING: journalctl is unavailable.\n'
        EXIT_STATUS=1
    fi

    printf '\n'
    write_section "Maintenance Assessment"

    if [[ "${ROOT_USAGE_PERCENT}" =~ ^[0-9]+$ ]]; then
        if (( ROOT_USAGE_PERCENT >= 90 )); then
            printf 'WARNING: Root filesystem usage is critical.\n'
        elif (( ROOT_USAGE_PERCENT >= 80 )); then
            printf 'REVIEW: Root filesystem usage is elevated.\n'
        else
            printf 'PASS: Root filesystem usage is within the expected range.\n'
        fi
    else
        printf 'REVIEW: Root filesystem usage could not be evaluated.\n'
    fi

    if [[ "${MEMORY_USAGE_PERCENT}" =~ ^[0-9]+$ ]]; then
        if (( MEMORY_USAGE_PERCENT >= 90 )); then
            printf 'WARNING: Memory usage is critical.\n'
        elif (( MEMORY_USAGE_PERCENT >= 80 )); then
            printf 'REVIEW: Memory usage is elevated.\n'
        else
            printf 'PASS: Memory usage is within the expected range.\n'
        fi
    else
        printf 'REVIEW: Memory usage could not be evaluated.\n'
    fi

    if (( FAILED_SERVICE_COUNT > 0 )); then
        printf 'WARNING: %s failed service(s) require investigation.\n' \
            "${FAILED_SERVICE_COUNT}"
    else
        printf 'PASS: No failed services were detected.\n'
    fi

    case "${AVAILABLE_UPDATE_COUNT}" in
        0)
            printf 'PASS: No package updates are currently available.\n'
            ;;
        Unknown|Unavailable)
            printf 'REVIEW: Package update status could not be determined.\n'
            ;;
        *)
            printf 'REVIEW: %s package update(s) are available.\n' \
                "${AVAILABLE_UPDATE_COUNT}"
            ;;
    esac

    printf '\n'
    write_section "End of Report"

    if [[ "${EXIT_STATUS}" -eq 0 ]]; then
        printf 'Scheduled maintenance snapshot completed successfully.\n'
    else
        printf 'Scheduled maintenance snapshot completed with warnings.\n'
    fi

} > "${REPORT_FILE}"

printf '\n'
printf 'Scheduled maintenance task completed.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"
printf 'Execution log:\n'
printf '%s\n' "${LOG_FILE}"

exit "${EXIT_STATUS}"