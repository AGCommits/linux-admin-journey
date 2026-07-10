#!/bin/bash

# ============================================================
# Project:
#   Linux Scheduled Task Automation
#
# Script:
#   scheduled-task-audit.sh
#
# Description:
#   Audits cron configuration, systemd timers, maintenance task
#   files, recent executions, and scheduling health on Rocky
#   Linux systems.
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
# - Audits user and system cron configuration.
# - Reviews installed and active systemd timers.
# - Validates the maintenance service and timer files.
# - Checks recent maintenance execution history.
# - Generates a timestamped scheduling audit report.
#
# ============================================================
#
# Safety
#
# This script is read-only. It does not:
# - Install cron entries.
# - Enable or start systemd timers.
# - Modify service or timer unit files.
# - Remove scheduled jobs.
# - Change system configuration.
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
SERVICE_DIR="${PROJECT_ROOT}/services"
CONFIG_DIR="${PROJECT_ROOT}/config"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/scheduled-task-audit-${TIMESTAMP}.txt"

MAINTENANCE_SCRIPT="${PROJECT_ROOT}/scripts/maintenance-task.sh"
SERVICE_FILE="${SERVICE_DIR}/linux-admin-maintenance.service"
TIMER_FILE="${SERVICE_DIR}/linux-admin-maintenance.timer"
CRON_EXAMPLE="${CONFIG_DIR}/linux-admin-maintenance.cron.example"
MAINTENANCE_LOG="${LOG_DIR}/maintenance-task.log"

mkdir -p "${REPORT_DIR}"

# ------------------------------------------------------------
# Audit state
# ------------------------------------------------------------

SCRIPT_VERSION="1.0.0"

CROND_STATUS="UNKNOWN"
TIMER_STATUS="NOT INSTALLED"
TIMER_ENABLED_STATUS="NOT INSTALLED"
SERVICE_FILE_STATUS="MISSING"
TIMER_FILE_STATUS="MISSING"
MAINTENANCE_SCRIPT_STATUS="MISSING"
RECENT_EXECUTION_STATUS="NOT FOUND"

ACTIVE_TIMER_COUNT=0
FAILED_TIMER_COUNT=0
USER_CRON_ENTRY_COUNT=0
SYSTEM_CRON_FILE_COUNT=0

PASS_COUNT=0
WARNING_COUNT=0
REVIEW_COUNT=0

# ------------------------------------------------------------
# Formatting functions
# ------------------------------------------------------------

write_section() {
    printf '%s\n' "============================================================"
    printf ' %s\n' "$1"
    printf '%s\n' "============================================================"
}

write_subsection() {
    printf '\n--- %s ---\n' "$1"
}

write_item() {
    printf '%-30s %s\n' "$1:" "$2"
}

write_pass() {
    printf 'PASS: %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

write_warning() {
    printf 'WARNING: %s\n' "$1"
    WARNING_COUNT=$((WARNING_COUNT + 1))
}

write_review() {
    printf 'REVIEW: %s\n' "$1"
    REVIEW_COUNT=$((REVIEW_COUNT + 1))
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

count_user_cron_entries() {
    if ! command_exists crontab; then
        printf '0'
        return
    fi

    crontab -l 2>/dev/null |
        awk '
            /^[[:space:]]*#/ {
                next
            }

            /^[[:space:]]*$/ {
                next
            }

            {
                count++
            }

            END {
                print count + 0
            }
        '
}

count_system_cron_files() {
    find \
        /etc/cron.d \
        /etc/cron.daily \
        /etc/cron.hourly \
        /etc/cron.monthly \
        /etc/cron.weekly \
        -maxdepth 1 \
        -type f \
        2>/dev/null |
        wc -l |
        tr -d '[:space:]'
}

count_active_timers() {
    if ! command_exists systemctl; then
        printf '0'
        return
    fi

    systemctl list-timers \
        --all \
        --no-legend \
        --no-pager \
        2>/dev/null |
        awk 'NF > 0 {count++} END {print count + 0}'
}

count_failed_timers() {
    if ! command_exists systemctl; then
        printf '0'
        return
    fi

    systemctl --failed \
        --type=timer \
        --no-legend \
        --plain \
        2>/dev/null |
        awk 'NF > 0 {count++} END {print count + 0}'
}

validate_unit_file() {
    local unit_file="$1"

    if [[ ! -f "${unit_file}" ]]; then
        printf 'MISSING'
        return
    fi

    if command_exists systemd-analyze; then
        if systemd-analyze verify "${unit_file}" >/dev/null 2>&1; then
            printf 'VALID'
        else
            printf 'INVALID'
        fi
    else
        printf 'PRESENT'
    fi
}

check_recent_execution() {
    if [[ -s "${MAINTENANCE_LOG}" ]]; then
        if grep -q 'Maintenance task completed successfully' \
            "${MAINTENANCE_LOG}" 2>/dev/null; then
            printf 'SUCCESS FOUND'
        else
            printf 'LOG FOUND'
        fi
    else
        printf 'NOT FOUND'
    fi
}

# ------------------------------------------------------------
# Collect audit values
# ------------------------------------------------------------

if command_exists systemctl; then
    if systemctl is-active --quiet crond; then
        CROND_STATUS="ACTIVE"
    else
        CROND_STATUS="INACTIVE"
    fi
else
    CROND_STATUS="UNAVAILABLE"
fi

if systemctl list-unit-files \
    linux-admin-maintenance.timer \
    >/dev/null 2>&1; then

    if systemctl is-active --quiet linux-admin-maintenance.timer; then
        TIMER_STATUS="ACTIVE"
    else
        TIMER_STATUS="INACTIVE"
    fi

    if systemctl is-enabled --quiet linux-admin-maintenance.timer; then
        TIMER_ENABLED_STATUS="ENABLED"
    else
        TIMER_ENABLED_STATUS="DISABLED"
    fi
fi

if [[ -f "${MAINTENANCE_SCRIPT}" ]]; then
    if [[ -x "${MAINTENANCE_SCRIPT}" ]]; then
        MAINTENANCE_SCRIPT_STATUS="PRESENT AND EXECUTABLE"
    else
        MAINTENANCE_SCRIPT_STATUS="PRESENT BUT NOT EXECUTABLE"
    fi
fi

SERVICE_FILE_STATUS="$(validate_unit_file "${SERVICE_FILE}")"
TIMER_FILE_STATUS="$(validate_unit_file "${TIMER_FILE}")"
RECENT_EXECUTION_STATUS="$(check_recent_execution)"

ACTIVE_TIMER_COUNT="$(count_active_timers)"
FAILED_TIMER_COUNT="$(count_failed_timers)"
USER_CRON_ENTRY_COUNT="$(count_user_cron_entries)"
SYSTEM_CRON_FILE_COUNT="$(count_system_cron_files)"

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux Scheduled Task Audit Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "${SCRIPT_VERSION}"
    write_item "Report file" "${REPORT_FILE}"

    printf '\n'
    write_section "Executive Summary"

    write_item "crond service" "${CROND_STATUS}"
    write_item "Active timer count" "${ACTIVE_TIMER_COUNT}"
    write_item "Failed timer count" "${FAILED_TIMER_COUNT}"
    write_item "User cron entries" "${USER_CRON_ENTRY_COUNT}"
    write_item "System cron files" "${SYSTEM_CRON_FILE_COUNT}"
    write_item "Maintenance script" "${MAINTENANCE_SCRIPT_STATUS}"
    write_item "Service file" "${SERVICE_FILE_STATUS}"
    write_item "Timer file" "${TIMER_FILE_STATUS}"
    write_item "Installed timer" "${TIMER_STATUS}"
    write_item "Timer enabled" "${TIMER_ENABLED_STATUS}"
    write_item "Recent execution" "${RECENT_EXECUTION_STATUS}"

    printf '\n'
    write_section "System Information"

    write_item "Operating system" "$(get_operating_system)"
    write_item "Kernel version" "$(uname -r)"
    write_item "Architecture" "$(uname -m)"
    write_item "Uptime" "$(uptime -p 2>/dev/null || uptime)"

    printf '\n'
    write_section "Cron Service Status"

    write_item "crond status" "${CROND_STATUS}"

    if command_exists systemctl; then
        systemctl status crond \
            --no-pager \
            --lines=20 \
            2>&1
    else
        write_warning "systemctl is unavailable."
    fi

    if [[ "${CROND_STATUS}" == "ACTIVE" ]]; then
        write_pass "The cron service is active."
    else
        write_warning "The cron service is not active or could not be checked."
    fi

    printf '\n'
    write_section "Current User Crontab"

    if command_exists crontab; then
        if crontab -l 2>/dev/null; then
            :
        else
            printf 'No crontab exists for the current user.\n'
        fi
    else
        write_warning "The crontab command is unavailable."
    fi

    write_item "Active user entries" "${USER_CRON_ENTRY_COUNT}"

    printf '\n'
    write_section "System Cron Configuration"

    for cron_path in \
        /etc/crontab \
        /etc/cron.d \
        /etc/cron.hourly \
        /etc/cron.daily \
        /etc/cron.weekly \
        /etc/cron.monthly
    do
        write_subsection "${cron_path}"

        if [[ -f "${cron_path}" ]]; then
            cat "${cron_path}" 2>&1
        elif [[ -d "${cron_path}" ]]; then
            find "${cron_path}" \
                -maxdepth 1 \
                -type f \
                -printf '%M %u:%g %p\n' \
                2>/dev/null |
                sort
        else
            printf 'Not found.\n'
        fi
    done

    write_item "System cron file count" "${SYSTEM_CRON_FILE_COUNT}"

    printf '\n'
    write_section "Systemd Timers"

    write_subsection "All Timers"

    if command_exists systemctl; then
        systemctl list-timers \
            --all \
            --no-pager \
            2>&1
    else
        write_warning "systemctl is unavailable."
    fi

    write_subsection "Failed Timers"

    if command_exists systemctl; then
        systemctl --failed \
            --type=timer \
            --no-pager \
            2>&1
    fi

    write_item "Timer count" "${ACTIVE_TIMER_COUNT}"
    write_item "Failed timers" "${FAILED_TIMER_COUNT}"

    if [[ "${FAILED_TIMER_COUNT}" -eq 0 ]]; then
        write_pass "No failed systemd timers were detected."
    else
        write_warning "${FAILED_TIMER_COUNT} failed systemd timer(s) were detected."
    fi

    printf '\n'
    write_section "Maintenance Task Files"

    write_subsection "Maintenance Script"

    write_item "Path" "${MAINTENANCE_SCRIPT}"
    write_item "Status" "${MAINTENANCE_SCRIPT_STATUS}"

    if [[ -f "${MAINTENANCE_SCRIPT}" ]]; then
        stat -c '%A %a %U:%G %n' "${MAINTENANCE_SCRIPT}" 2>&1
    fi

    write_subsection "Service Unit"

    write_item "Path" "${SERVICE_FILE}"
    write_item "Validation" "${SERVICE_FILE_STATUS}"

    if [[ -r "${SERVICE_FILE}" ]]; then
        cat "${SERVICE_FILE}"
    fi

    write_subsection "Timer Unit"

    write_item "Path" "${TIMER_FILE}"
    write_item "Validation" "${TIMER_FILE_STATUS}"

    if [[ -r "${TIMER_FILE}" ]]; then
        cat "${TIMER_FILE}"
    fi

    write_subsection "Cron Example"

    write_item "Path" "${CRON_EXAMPLE}"

    if [[ -r "${CRON_EXAMPLE}" ]]; then
        cat "${CRON_EXAMPLE}"
    else
        printf 'Cron example not found.\n'
    fi

    printf '\n'
    write_section "Installed Maintenance Timer"

    write_item "Runtime status" "${TIMER_STATUS}"
    write_item "Enabled status" "${TIMER_ENABLED_STATUS}"

    if command_exists systemctl; then
        systemctl status linux-admin-maintenance.timer \
            --no-pager \
            --lines=30 \
            2>&1 ||
            printf 'The maintenance timer is not currently installed.\n'

        write_subsection "Next and Previous Execution"

        systemctl list-timers \
            linux-admin-maintenance.timer \
            --all \
            --no-pager \
            2>&1
    fi

    printf '\n'
    write_section "Maintenance Execution History"

    write_item "Execution status" "${RECENT_EXECUTION_STATUS}"
    write_item "Log file" "${MAINTENANCE_LOG}"

    if [[ -s "${MAINTENANCE_LOG}" ]]; then
        tail -n 50 "${MAINTENANCE_LOG}"
    else
        printf 'No maintenance execution log is currently available.\n'
    fi

    if command_exists journalctl; then
        write_subsection "Systemd Journal"

        journalctl \
            -u linux-admin-maintenance.service \
            --no-pager \
            -n 50 \
            2>&1
    fi

    printf '\n'
    write_section "Scheduling Assessment"

    if [[ "${MAINTENANCE_SCRIPT_STATUS}" == "PRESENT AND EXECUTABLE" ]]; then
        write_pass "The maintenance script exists and is executable."
    else
        write_warning "The maintenance script is missing or not executable."
    fi

    case "${SERVICE_FILE_STATUS}" in
        VALID|PRESENT)
            write_pass "The systemd service unit is present and valid."
            ;;
        *)
            write_warning "The systemd service unit is missing or invalid."
            ;;
    esac

    case "${TIMER_FILE_STATUS}" in
        VALID|PRESENT)
            write_pass "The systemd timer unit is present and valid."
            ;;
        *)
            write_warning "The systemd timer unit is missing or invalid."
            ;;
    esac

    if [[ "${TIMER_STATUS}" == "ACTIVE" ]]; then
        write_pass "The maintenance timer is active."
    else
        write_review "The maintenance timer is not active."
    fi

    if [[ "${TIMER_ENABLED_STATUS}" == "ENABLED" ]]; then
        write_pass "The maintenance timer is enabled at boot."
    else
        write_review "The maintenance timer is not enabled."
    fi

    if [[ "${RECENT_EXECUTION_STATUS}" == "SUCCESS FOUND" ]]; then
        write_pass "A successful maintenance execution was found."
    else
        write_review "No successful maintenance execution has been confirmed."
    fi

    printf '\n'
    write_section "Overall Assessment"

    write_item "Passed checks" "${PASS_COUNT}"
    write_item "Warnings" "${WARNING_COUNT}"
    write_item "Review items" "${REVIEW_COUNT}"

    if [[ "${WARNING_COUNT}" -gt 0 ]]; then
        write_item "Overall status" "NEEDS ATTENTION"
    elif [[ "${REVIEW_COUNT}" -gt 0 ]]; then
        write_item "Overall status" "REVIEW RECOMMENDED"
    else
        write_item "Overall status" "GOOD"
    fi

    printf '\n'
    write_section "End of Report"

    printf 'Scheduled task audit completed successfully.\n'

} > "${REPORT_FILE}"

printf '\n'
printf 'Scheduled task audit completed successfully.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"