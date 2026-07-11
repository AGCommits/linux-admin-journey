#!/bin/bash

# ============================================================
# Project:
#   Linux System Health Monitoring Dashboard
#
# Script:
#   system-health-dashboard.sh
#
# Description:
#   Performs a comprehensive, read-only health assessment of a
#   Rocky Linux system and generates a structured report covering
#   CPU, memory, storage, services, networking, security, package
#   status, and recent system errors.
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
# - Adds CPU and load monitoring.
# - Adds memory and swap assessment.
# - Adds filesystem and inode monitoring.
# - Adds failed-service and listening-port checks.
# - Adds network-connectivity checks.
# - Adds firewall and SELinux checks.
# - Adds package-update assessment.
# - Adds recent high-priority log review.
# - Generates an overall health score and recommendations.
#
# ============================================================
#
# Safety
#
# This script is read-only. It does not modify system services,
# packages, users, filesystems, networking, firewall rules, or
# SELinux configuration.
#
# ============================================================

set -u
set -o pipefail

# ------------------------------------------------------------
# Project paths
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${PROJECT_ROOT}/reports"
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/system-health-${TIMESTAMP}.txt"

mkdir -p "${REPORT_DIR}"

# ------------------------------------------------------------
# Thresholds
# ------------------------------------------------------------

CPU_WARNING_THRESHOLD=75
CPU_CRITICAL_THRESHOLD=90

MEMORY_WARNING_THRESHOLD=80
MEMORY_CRITICAL_THRESHOLD=90

SWAP_WARNING_THRESHOLD=50
SWAP_CRITICAL_THRESHOLD=80

DISK_WARNING_THRESHOLD=80
DISK_CRITICAL_THRESHOLD=90

INODE_WARNING_THRESHOLD=80
INODE_CRITICAL_THRESHOLD=90

LOAD_WARNING_MULTIPLIER=1
LOAD_CRITICAL_MULTIPLIER=2

FAILED_SERVICE_WARNING_THRESHOLD=1
FAILED_SERVICE_CRITICAL_THRESHOLD=5

UPDATE_WARNING_THRESHOLD=20
UPDATE_CRITICAL_THRESHOLD=100

# ------------------------------------------------------------
# Status counters
# ------------------------------------------------------------

PASS_COUNT=0
WARNING_COUNT=0
CRITICAL_COUNT=0
REVIEW_COUNT=0

CPU_STATUS="UNKNOWN"
MEMORY_STATUS="UNKNOWN"
SWAP_STATUS="UNKNOWN"
STORAGE_STATUS="UNKNOWN"
INODE_STATUS="UNKNOWN"
SERVICE_STATUS="UNKNOWN"
NETWORK_STATUS="UNKNOWN"
FIREWALL_STATUS="UNKNOWN"
SELINUX_STATUS="UNKNOWN"
UPDATE_STATUS="UNKNOWN"
LOG_STATUS="UNKNOWN"

CPU_USAGE_PERCENT=0
MEMORY_USAGE_PERCENT=0
SWAP_USAGE_PERCENT=0
MAX_DISK_USAGE_PERCENT=0
MAX_INODE_USAGE_PERCENT=0
FAILED_SERVICE_COUNT=0
AVAILABLE_UPDATE_COUNT="Unknown"
RECENT_ERROR_COUNT=0
LISTENING_TCP_COUNT=0
LISTENING_UDP_COUNT=0
ACTIVE_INTERFACE_COUNT=0
CPU_COUNT=1
LOAD_1_MINUTE="0"
DEFAULT_GATEWAY="Not detected"
PRIMARY_IPV4="Not detected"

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
    printf '%-32s %s\n' "$1:" "$2"
}

record_pass() {
    printf 'PASS: %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

record_warning() {
    printf 'WARNING: %s\n' "$1"
    WARNING_COUNT=$((WARNING_COUNT + 1))
}

record_critical() {
    printf 'CRITICAL: %s\n' "$1"
    CRITICAL_COUNT=$((CRITICAL_COUNT + 1))
}

record_review() {
    printf 'REVIEW: %s\n' "$1"
    REVIEW_COUNT=$((REVIEW_COUNT + 1))
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Data collection functions
# ------------------------------------------------------------

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

get_cpu_usage() {
    if command_exists top; then
        top -bn1 2>/dev/null |
            awk '
                /^%Cpu/ {
                    for (i = 1; i <= NF; i++) {
                        if ($i ~ /id/) {
                            idle = $(i - 1)
                            gsub(/,/, ".", idle)
                            printf "%.0f", 100 - idle
                            exit
                        }
                    }
                }
            '
    else
        printf '0'
    fi
}

get_memory_usage() {
    free 2>/dev/null |
        awk '
            /^Mem:/ {
                if ($2 > 0) {
                    printf "%.0f", ($3 / $2) * 100
                } else {
                    print 0
                }
            }
        '
}

get_swap_usage() {
    free 2>/dev/null |
        awk '
            /^Swap:/ {
                if ($2 > 0) {
                    printf "%.0f", ($3 / $2) * 100
                } else {
                    print 0
                }
            }
        '
}

get_max_disk_usage() {
    df -P -x tmpfs -x devtmpfs 2>/dev/null |
        awk '
            NR > 1 {
                gsub(/%/, "", $5)

                if ($5 > max) {
                    max = $5
                }
            }

            END {
                print max + 0
            }
        '
}

get_max_inode_usage() {
    df -Pi -x tmpfs -x devtmpfs 2>/dev/null |
        awk '
            NR > 1 {
                gsub(/%/, "", $5)

                if ($5 > max) {
                    max = $5
                }
            }

            END {
                print max + 0
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

get_update_count() {
    if ! command_exists dnf; then
        printf 'Unavailable'
        return
    fi

    local output
    local status

    output="$(dnf -q check-update 2>/dev/null)"
    status=$?

    case "${status}" in
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
            ' <<< "${output}"
            ;;
        *)
            printf 'Unknown'
            ;;
    esac
}

get_recent_error_count() {
    if ! command_exists journalctl; then
        printf '0'
        return
    fi

    journalctl \
        --priority=err \
        --since "24 hours ago" \
        --no-pager \
        2>/dev/null |
        awk 'NF > 0 {count++} END {print count + 0}'
}

get_default_gateway() {
    if command_exists ip; then
        ip -4 route show default 2>/dev/null |
            awk '
                {
                    for (i = 1; i <= NF; i++) {
                        if ($i == "via") {
                            print $(i + 1)
                            exit
                        }
                    }
                }
            '
    fi
}

get_primary_ipv4() {
    if command_exists ip; then
        ip -4 -o address show scope global 2>/dev/null |
            awk 'NR == 1 {print $4; exit}'
    fi
}

get_active_interface_count() {
    if command_exists ip; then
        ip -o link show up 2>/dev/null |
            awk -F': ' '$2 != "lo" {count++} END {print count + 0}'
    else
        printf '0'
    fi
}

get_listening_tcp_count() {
    if command_exists ss; then
        ss -lntH 2>/dev/null |
            wc -l |
            tr -d '[:space:]'
    else
        printf '0'
    fi
}

get_listening_udp_count() {
    if command_exists ss; then
        ss -lnuH 2>/dev/null |
            wc -l |
            tr -d '[:space:]'
    else
        printf '0'
    fi
}

ping_target() {
    local target="$1"

    command_exists ping || return 1

    ping -c 1 -W 2 "${target}" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Collect system values
# ------------------------------------------------------------

CPU_COUNT="$(nproc 2>/dev/null || printf '1')"
LOAD_1_MINUTE="$(cut -d' ' -f1 /proc/loadavg 2>/dev/null || printf '0')"

CPU_USAGE_PERCENT="$(get_cpu_usage)"
MEMORY_USAGE_PERCENT="$(get_memory_usage)"
SWAP_USAGE_PERCENT="$(get_swap_usage)"
MAX_DISK_USAGE_PERCENT="$(get_max_disk_usage)"
MAX_INODE_USAGE_PERCENT="$(get_max_inode_usage)"
FAILED_SERVICE_COUNT="$(get_failed_service_count)"
AVAILABLE_UPDATE_COUNT="$(get_update_count)"
RECENT_ERROR_COUNT="$(get_recent_error_count)"
ACTIVE_INTERFACE_COUNT="$(get_active_interface_count)"
LISTENING_TCP_COUNT="$(get_listening_tcp_count)"
LISTENING_UDP_COUNT="$(get_listening_udp_count)"

DEFAULT_GATEWAY="$(get_default_gateway)"
PRIMARY_IPV4="$(get_primary_ipv4)"

[[ -n "${CPU_USAGE_PERCENT}" ]] || CPU_USAGE_PERCENT=0
[[ -n "${MEMORY_USAGE_PERCENT}" ]] || MEMORY_USAGE_PERCENT=0
[[ -n "${SWAP_USAGE_PERCENT}" ]] || SWAP_USAGE_PERCENT=0
[[ -n "${MAX_DISK_USAGE_PERCENT}" ]] || MAX_DISK_USAGE_PERCENT=0
[[ -n "${MAX_INODE_USAGE_PERCENT}" ]] || MAX_INODE_USAGE_PERCENT=0
[[ -n "${DEFAULT_GATEWAY}" ]] || DEFAULT_GATEWAY="Not detected"
[[ -n "${PRIMARY_IPV4}" ]] || PRIMARY_IPV4="Not detected"

# ------------------------------------------------------------
# Evaluate system health
# ------------------------------------------------------------

if (( CPU_USAGE_PERCENT >= CPU_CRITICAL_THRESHOLD )); then
    CPU_STATUS="CRITICAL"
elif (( CPU_USAGE_PERCENT >= CPU_WARNING_THRESHOLD )); then
    CPU_STATUS="WARNING"
else
    CPU_STATUS="HEALTHY"
fi

if (( MEMORY_USAGE_PERCENT >= MEMORY_CRITICAL_THRESHOLD )); then
    MEMORY_STATUS="CRITICAL"
elif (( MEMORY_USAGE_PERCENT >= MEMORY_WARNING_THRESHOLD )); then
    MEMORY_STATUS="WARNING"
else
    MEMORY_STATUS="HEALTHY"
fi

if (( SWAP_USAGE_PERCENT >= SWAP_CRITICAL_THRESHOLD )); then
    SWAP_STATUS="CRITICAL"
elif (( SWAP_USAGE_PERCENT >= SWAP_WARNING_THRESHOLD )); then
    SWAP_STATUS="WARNING"
else
    SWAP_STATUS="HEALTHY"
fi

if (( MAX_DISK_USAGE_PERCENT >= DISK_CRITICAL_THRESHOLD )); then
    STORAGE_STATUS="CRITICAL"
elif (( MAX_DISK_USAGE_PERCENT >= DISK_WARNING_THRESHOLD )); then
    STORAGE_STATUS="WARNING"
else
    STORAGE_STATUS="HEALTHY"
fi

if (( MAX_INODE_USAGE_PERCENT >= INODE_CRITICAL_THRESHOLD )); then
    INODE_STATUS="CRITICAL"
elif (( MAX_INODE_USAGE_PERCENT >= INODE_WARNING_THRESHOLD )); then
    INODE_STATUS="WARNING"
else
    INODE_STATUS="HEALTHY"
fi

if (( FAILED_SERVICE_COUNT >= FAILED_SERVICE_CRITICAL_THRESHOLD )); then
    SERVICE_STATUS="CRITICAL"
elif (( FAILED_SERVICE_COUNT >= FAILED_SERVICE_WARNING_THRESHOLD )); then
    SERVICE_STATUS="WARNING"
else
    SERVICE_STATUS="HEALTHY"
fi

NETWORK_STATUS="HEALTHY"

if ! ping_target "127.0.0.1"; then
    NETWORK_STATUS="CRITICAL"
elif [[ "${DEFAULT_GATEWAY}" == "Not detected" ]] ||
     ! ping_target "${DEFAULT_GATEWAY}"; then
    NETWORK_STATUS="WARNING"
elif ! ping_target "1.1.1.1"; then
    NETWORK_STATUS="WARNING"
elif ! command_exists getent ||
     ! getent hosts github.com >/dev/null 2>&1; then
    NETWORK_STATUS="WARNING"
fi

if command_exists firewall-cmd; then
    if firewall-cmd --state >/dev/null 2>&1; then
        FIREWALL_STATUS="ACTIVE"
    else
        FIREWALL_STATUS="INACTIVE"
    fi
else
    FIREWALL_STATUS="NOT INSTALLED"
fi

if command_exists getenforce; then
    SELINUX_STATUS="$(getenforce 2>/dev/null || printf 'UNKNOWN')"
else
    SELINUX_STATUS="NOT INSTALLED"
fi

case "${AVAILABLE_UPDATE_COUNT}" in
    Unknown|Unavailable)
        UPDATE_STATUS="REVIEW"
        ;;
    *)
        if (( AVAILABLE_UPDATE_COUNT >= UPDATE_CRITICAL_THRESHOLD )); then
            UPDATE_STATUS="CRITICAL"
        elif (( AVAILABLE_UPDATE_COUNT >= UPDATE_WARNING_THRESHOLD )); then
            UPDATE_STATUS="WARNING"
        elif (( AVAILABLE_UPDATE_COUNT > 0 )); then
            UPDATE_STATUS="REVIEW"
        else
            UPDATE_STATUS="HEALTHY"
        fi
        ;;
esac

if (( RECENT_ERROR_COUNT >= 20 )); then
    LOG_STATUS="CRITICAL"
elif (( RECENT_ERROR_COUNT >= 5 )); then
    LOG_STATUS="WARNING"
elif (( RECENT_ERROR_COUNT > 0 )); then
    LOG_STATUS="REVIEW"
else
    LOG_STATUS="HEALTHY"
fi

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux System Health Monitoring Dashboard"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "1.0.0"
    write_item "Report file" "${REPORT_FILE}"

    printf '\n'
    write_section "Executive Summary"

    write_item "CPU health" "${CPU_STATUS}"
    write_item "Memory health" "${MEMORY_STATUS}"
    write_item "Swap health" "${SWAP_STATUS}"
    write_item "Storage health" "${STORAGE_STATUS}"
    write_item "Inode health" "${INODE_STATUS}"
    write_item "Service health" "${SERVICE_STATUS}"
    write_item "Network health" "${NETWORK_STATUS}"
    write_item "Firewall" "${FIREWALL_STATUS}"
    write_item "SELinux" "${SELINUX_STATUS}"
    write_item "Package status" "${UPDATE_STATUS}"
    write_item "Recent log health" "${LOG_STATUS}"

    printf '\n'
    write_section "System Information"

    write_item "Operating system" "$(get_operating_system)"
    write_item "Kernel version" "$(uname -r)"
    write_item "Architecture" "$(uname -m)"
    write_item "CPU count" "${CPU_COUNT}"
    write_item "Uptime" "$(uptime -p 2>/dev/null || uptime)"
    write_item "Boot time" "$(uptime -s 2>/dev/null || printf 'Unavailable')"

    printf '\n'
    write_section "CPU Health"

    write_item "CPU usage" "${CPU_USAGE_PERCENT}%"
    write_item "1-minute load" "${LOAD_1_MINUTE}"
    write_item "Logical CPUs" "${CPU_COUNT}"
    write_item "Assessment" "${CPU_STATUS}"

    if command_exists lscpu; then
        write_subsection "CPU Information"
        lscpu 2>&1
    fi

    if [[ "${CPU_STATUS}" == "CRITICAL" ]]; then
        record_critical "CPU utilisation is critically high."
    elif [[ "${CPU_STATUS}" == "WARNING" ]]; then
        record_warning "CPU utilisation is elevated."
    else
        record_pass "CPU utilisation is within the expected range."
    fi

    printf '\n'
    write_section "Memory and Swap Health"

    write_item "Memory usage" "${MEMORY_USAGE_PERCENT}%"
    write_item "Memory assessment" "${MEMORY_STATUS}"
    write_item "Swap usage" "${SWAP_USAGE_PERCENT}%"
    write_item "Swap assessment" "${SWAP_STATUS}"

    if command_exists free; then
        write_subsection "Memory Details"
        free -h 2>&1
    fi

    case "${MEMORY_STATUS}" in
        CRITICAL)
            record_critical "Memory utilisation is critically high."
            ;;
        WARNING)
            record_warning "Memory utilisation is elevated."
            ;;
        *)
            record_pass "Memory utilisation is within the expected range."
            ;;
    esac

    case "${SWAP_STATUS}" in
        CRITICAL)
            record_critical "Swap utilisation is critically high."
            ;;
        WARNING)
            record_warning "Swap utilisation is elevated."
            ;;
        *)
            record_pass "Swap utilisation is within the expected range."
            ;;
    esac

    printf '\n'
    write_section "Storage Health"

    write_item "Highest filesystem usage" "${MAX_DISK_USAGE_PERCENT}%"
    write_item "Storage assessment" "${STORAGE_STATUS}"

    write_subsection "Filesystem Capacity"
    df -hT 2>&1

    case "${STORAGE_STATUS}" in
        CRITICAL)
            record_critical "At least one filesystem is critically full."
            ;;
        WARNING)
            record_warning "At least one filesystem has elevated usage."
            ;;
        *)
            record_pass "Filesystem usage is within the expected range."
            ;;
    esac

    printf '\n'
    write_section "Filesystem Inode Health"

    write_item "Highest inode usage" "${MAX_INODE_USAGE_PERCENT}%"
    write_item "Inode assessment" "${INODE_STATUS}"

    write_subsection "Inode Usage"
    df -hi 2>&1

    case "${INODE_STATUS}" in
        CRITICAL)
            record_critical "At least one filesystem has critical inode usage."
            ;;
        WARNING)
            record_warning "At least one filesystem has elevated inode usage."
            ;;
        *)
            record_pass "Filesystem inode usage is within the expected range."
            ;;
    esac

    printf '\n'
    write_section "Service Health"

    write_item "Failed service count" "${FAILED_SERVICE_COUNT}"
    write_item "Service assessment" "${SERVICE_STATUS}"

    if command_exists systemctl; then
        write_subsection "Failed Services"
        systemctl --failed --no-pager 2>&1
    fi

    case "${SERVICE_STATUS}" in
        CRITICAL)
            record_critical "${FAILED_SERVICE_COUNT} failed services require immediate investigation."
            ;;
        WARNING)
            record_warning "${FAILED_SERVICE_COUNT} failed services require investigation."
            ;;
        *)
            record_pass "No failed services were detected."
            ;;
    esac

    printf '\n'
    write_section "Network Health"

    write_item "Primary IPv4" "${PRIMARY_IPV4}"
    write_item "Default gateway" "${DEFAULT_GATEWAY}"
    write_item "Active interfaces" "${ACTIVE_INTERFACE_COUNT}"
    write_item "Listening TCP ports" "${LISTENING_TCP_COUNT}"
    write_item "Listening UDP ports" "${LISTENING_UDP_COUNT}"
    write_item "Network assessment" "${NETWORK_STATUS}"

    if command_exists ip; then
        write_subsection "Interface Summary"
        ip -brief address 2>&1

        write_subsection "Routing Table"
        ip route show 2>&1
    fi

    if command_exists ss; then
        write_subsection "Listening Ports"
        ss -lntup 2>&1
    fi

    case "${NETWORK_STATUS}" in
        CRITICAL)
            record_critical "Local network functionality is unavailable."
            ;;
        WARNING)
            record_warning "One or more network-connectivity checks failed."
            ;;
        *)
            record_pass "Network connectivity checks passed."
            ;;
    esac

    printf '\n'
    write_section "Security Health"

    write_item "Firewall status" "${FIREWALL_STATUS}"
    write_item "SELinux status" "${SELINUX_STATUS}"

    if command_exists firewall-cmd &&
       firewall-cmd --state >/dev/null 2>&1; then

        write_subsection "Firewall Configuration"
        firewall-cmd --list-all 2>&1
    fi

    if command_exists sestatus; then
        write_subsection "SELinux Details"
        sestatus 2>&1
    fi

    if [[ "${FIREWALL_STATUS}" == "ACTIVE" ]]; then
        record_pass "The host firewall is active."
    else
        record_warning "The host firewall is not active or could not be confirmed."
    fi

    if [[ "${SELINUX_STATUS}" == "Enforcing" ]]; then
        record_pass "SELinux is enforcing."
    else
        record_warning "SELinux is not enforcing or could not be confirmed."
    fi

    printf '\n'
    write_section "Package Update Health"

    write_item "Available updates" "${AVAILABLE_UPDATE_COUNT}"
    write_item "Package assessment" "${UPDATE_STATUS}"

    if command_exists dnf; then
        write_subsection "Available Package Updates"
        dnf -q check-update 2>&1
        DNF_STATUS=$?

        if [[ "${DNF_STATUS}" -ne 0 && "${DNF_STATUS}" -ne 100 ]]; then
            printf 'Package check returned status %s.\n' "${DNF_STATUS}"
        fi
    fi

    case "${UPDATE_STATUS}" in
        CRITICAL)
            record_critical "A very large number of package updates are available."
            ;;
        WARNING)
            record_warning "Numerous package updates are available."
            ;;
        REVIEW)
            record_review "Package updates are available or could not be fully assessed."
            ;;
        *)
            record_pass "No package updates are currently available."
            ;;
    esac

    printf '\n'
    write_section "Recent High-Priority Logs"

    write_item "Recent error count" "${RECENT_ERROR_COUNT}"
    write_item "Log assessment" "${LOG_STATUS}"

    if command_exists journalctl; then
        journalctl \
            --priority=err \
            --since "24 hours ago" \
            --no-pager \
            -n 100 \
            2>&1
    fi

    case "${LOG_STATUS}" in
        CRITICAL)
            record_critical "A high number of recent system errors were detected."
            ;;
        WARNING)
            record_warning "Multiple recent system errors were detected."
            ;;
        REVIEW)
            record_review "A small number of recent system errors were detected."
            ;;
        *)
            record_pass "No recent high-priority system errors were detected."
            ;;
    esac

    printf '\n'
    write_section "Overall System Assessment"

    write_item "Passed checks" "${PASS_COUNT}"
    write_item "Warnings" "${WARNING_COUNT}"
    write_item "Critical findings" "${CRITICAL_COUNT}"
    write_item "Review items" "${REVIEW_COUNT}"

    if (( CRITICAL_COUNT > 0 )); then
        write_item "Overall health" "CRITICAL"
        printf 'Immediate investigation is recommended.\n'
    elif (( WARNING_COUNT >= 3 )); then
        write_item "Overall health" "NEEDS ATTENTION"
        printf 'Several system-health findings require investigation.\n'
    elif (( WARNING_COUNT > 0 || REVIEW_COUNT > 0 )); then
        write_item "Overall health" "REVIEW RECOMMENDED"
        printf 'The system is operational, but identified items should be reviewed.\n'
    else
        write_item "Overall health" "HEALTHY"
        printf 'No significant system-health issues were detected.\n'
    fi

    printf '\n'
    write_section "Recommendations"

    if [[ "${CPU_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Review CPU-intensive processes using top or ps.\n'
    fi

    if [[ "${MEMORY_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Review memory-intensive processes and application usage.\n'
    fi

    if [[ "${SWAP_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Investigate sustained swap utilisation.\n'
    fi

    if [[ "${STORAGE_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Investigate filesystems with elevated disk usage.\n'
    fi

    if [[ "${INODE_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Investigate filesystems with elevated inode usage.\n'
    fi

    if [[ "${SERVICE_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Investigate failed systemd services.\n'
    fi

    if [[ "${NETWORK_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Review interface, gateway, internet, and DNS connectivity.\n'
    fi

    if [[ "${FIREWALL_STATUS}" != "ACTIVE" ]]; then
        printf -- '- Confirm the intended host firewall configuration.\n'
    fi

    if [[ "${SELINUX_STATUS}" != "Enforcing" ]]; then
        printf -- '- Review SELinux configuration and enforcement mode.\n'
    fi

    if [[ "${UPDATE_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Review and schedule available package updates.\n'
    fi

    if [[ "${LOG_STATUS}" != "HEALTHY" ]]; then
        printf -- '- Review recent high-priority journal messages.\n'
    fi

    if (( WARNING_COUNT == 0 && CRITICAL_COUNT == 0 && REVIEW_COUNT == 0 )); then
        printf -- '- Continue routine monitoring and maintenance.\n'
    fi

    printf '\n'
    write_section "End of Report"

    printf 'System health monitoring completed successfully.\n'

} > "${REPORT_FILE}"

printf '\n'
printf 'System health monitoring completed successfully.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"