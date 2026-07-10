#!/bin/bash

# ============================================================
# Project:
#   Linux Security Hardening and Auditing
#
# Script:
#   security-audit.sh
#
# Description:
#   Performs a read-only security audit of a Rocky Linux system
#   and generates a structured report containing security
#   findings, status checks, and practical recommendations.
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
# - Audits local user accounts and UID 0 accounts.
# - Reviews sudo-capable groups and administrative access.
# - Reviews password and authentication policy.
# - Audits SSH configuration and service status.
# - Checks firewall and SELinux status.
# - Reviews failed login activity.
# - Checks critical system-file permissions.
# - Searches for world-writable, SUID, and SGID files.
# - Reviews enabled and failed services.
# - Generates an executive summary and recommendations.
#
# ============================================================
#
# Safety
#
# This script is read-only. It does not:
# - Modify users, passwords, groups, or permissions.
# - Change SSH, firewall, or SELinux configuration.
# - Enable, disable, start, or stop services.
# - Install or remove software packages.
#
# Some checks provide more complete results when run with sudo.
# ============================================================

set -u
set -o pipefail

# ------------------------------------------------------------
# Project paths and report naming
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${PROJECT_ROOT}/reports"
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/security-audit-${TIMESTAMP}.txt"

mkdir -p "${REPORT_DIR}"

# ------------------------------------------------------------
# Audit state
# ------------------------------------------------------------

PASS_COUNT=0
WARNING_COUNT=0
REVIEW_COUNT=0
FAIL_COUNT=0

FIREWALL_STATUS="UNKNOWN"
SELINUX_STATUS="UNKNOWN"
SSH_SERVICE_STATUS="UNKNOWN"
SSH_ROOT_LOGIN_STATUS="UNKNOWN"
SSH_PASSWORD_AUTH_STATUS="UNKNOWN"
FAILED_SERVICE_COUNT=0
FAILED_LOGIN_COUNT=0
UID_ZERO_COUNT=0
WORLD_WRITABLE_COUNT=0
SUID_COUNT=0
SGID_COUNT=0

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

write_fail() {
    printf 'FAIL: %s\n' "$1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

# ------------------------------------------------------------
# Utility functions
# ------------------------------------------------------------

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

get_sshd_setting() {
    local setting="$1"
    local config_file="/etc/ssh/sshd_config"

    if [[ ! -r "${config_file}" ]]; then
        printf 'Unavailable'
        return
    fi

    awk -v setting="${setting}" '
        BEGIN {
            IGNORECASE = 1
        }

        /^[[:space:]]*#/ {
            next
        }

        {
            key = $1
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)

            if (tolower(key) == tolower(setting)) {
                print $2
                found = 1
            }
        }

        END {
            if (!found) {
                print "Default or unspecified"
            }
        }
    ' "${config_file}" | tail -n 1
}

count_failed_logins() {
    if ! command_exists lastb; then
        printf '0'
        return
    fi

    lastb -n 100 2>/dev/null |
        awk '
            /^btmp begins/ {
                next
            }

            NF > 0 {
                count++
            }

            END {
                print count + 0
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

get_world_writable_count() {
    find / \
        -xdev \
        -type f \
        -perm -0002 \
        2>/dev/null |
        wc -l |
        tr -d '[:space:]'
}

get_suid_count() {
    find / \
        -xdev \
        -type f \
        -perm -4000 \
        2>/dev/null |
        wc -l |
        tr -d '[:space:]'
}

get_sgid_count() {
    find / \
        -xdev \
        -type f \
        -perm -2000 \
        2>/dev/null |
        wc -l |
        tr -d '[:space:]'
}

file_permission_summary() {
    local path="$1"

    if [[ -e "${path}" ]]; then
        stat -c '%A %a %U:%G %n' "${path}" 2>/dev/null
    else
        printf 'Missing: %s\n' "${path}"
    fi
}

# ------------------------------------------------------------
# Pre-collect summary values
# ------------------------------------------------------------

UID_ZERO_COUNT="$(
    awk -F: '$3 == 0 {count++} END {print count + 0}' /etc/passwd
)"

FAILED_LOGIN_COUNT="$(count_failed_logins)"
FAILED_SERVICE_COUNT="$(get_failed_service_count)"
WORLD_WRITABLE_COUNT="$(get_world_writable_count)"
SUID_COUNT="$(get_suid_count)"
SGID_COUNT="$(get_sgid_count)"

if command_exists systemctl; then
    if systemctl is-active --quiet sshd; then
        SSH_SERVICE_STATUS="ACTIVE"
    else
        SSH_SERVICE_STATUS="INACTIVE"
    fi
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

SSH_ROOT_LOGIN_STATUS="$(get_sshd_setting PermitRootLogin)"
SSH_PASSWORD_AUTH_STATUS="$(get_sshd_setting PasswordAuthentication)"

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux Security Audit Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "1.0.0"
    write_item "Report file" "${REPORT_FILE}"

    if [[ "$(id -u)" -ne 0 ]]; then
        printf '\n'
        write_warning "The script is not running as root. Some results may be incomplete."
    fi

    printf '\n'
    write_section "Executive Summary"

    write_item "UID 0 accounts" "${UID_ZERO_COUNT}"
    write_item "SSH service" "${SSH_SERVICE_STATUS}"
    write_item "SSH root login" "${SSH_ROOT_LOGIN_STATUS}"
    write_item "SSH password auth" "${SSH_PASSWORD_AUTH_STATUS}"
    write_item "Firewall" "${FIREWALL_STATUS}"
    write_item "SELinux" "${SELINUX_STATUS}"
    write_item "Failed login records" "${FAILED_LOGIN_COUNT}"
    write_item "Failed services" "${FAILED_SERVICE_COUNT}"
    write_item "World-writable files" "${WORLD_WRITABLE_COUNT}"
    write_item "SUID files" "${SUID_COUNT}"
    write_item "SGID files" "${SGID_COUNT}"

    printf '\n'
    write_section "System Information"

    write_item "Operating system" "$(get_operating_system)"
    write_item "Kernel version" "$(uname -r)"
    write_item "Architecture" "$(uname -m)"
    write_item "Uptime" "$(uptime -p 2>/dev/null || uptime)"

    if command_exists hostnamectl; then
        write_subsection "Hostname Details"
        hostnamectl 2>&1
    fi

    printf '\n'
    write_section "Local User Accounts"

    write_subsection "Accounts from /etc/passwd"

    awk -F: '
        {
            printf "%-20s UID=%-6s GID=%-6s HOME=%-30s SHELL=%s\n",
                   $1, $3, $4, $6, $7
        }
    ' /etc/passwd

    write_subsection "Interactive Login Accounts"

    awk -F: '
        $7 !~ /(nologin|false|sync|shutdown|halt)$/ {
            printf "%-20s UID=%-6s HOME=%-30s SHELL=%s\n",
                   $1, $3, $6, $7
        }
    ' /etc/passwd

    write_subsection "UID 0 Accounts"

    awk -F: '
        $3 == 0 {
            printf "%-20s UID=%s SHELL=%s\n", $1, $3, $7
        }
    ' /etc/passwd

    if [[ "${UID_ZERO_COUNT}" -eq 1 ]]; then
        write_pass "Only one UID 0 account was detected."
    else
        write_warning "${UID_ZERO_COUNT} UID 0 accounts were detected."
    fi

    printf '\n'
    write_section "Administrative Access"

    write_subsection "Wheel Group"

    if getent group wheel >/dev/null 2>&1; then
        getent group wheel
    else
        write_warning "The wheel group was not found."
    fi

    write_subsection "Sudo Configuration Files"

    if [[ -r /etc/sudoers ]]; then
        grep -Ev '^[[:space:]]*(#|$)' /etc/sudoers 2>/dev/null ||
            write_review "No active sudoers entries were displayed."
    else
        write_warning "/etc/sudoers could not be read."
    fi

    if [[ -d /etc/sudoers.d ]]; then
        printf '\nFiles under /etc/sudoers.d:\n'
        find /etc/sudoers.d \
            -maxdepth 1 \
            -type f \
            -printf '%f\n' \
            2>/dev/null |
            sort
    fi

    printf '\n'
    write_section "Password and Authentication Policy"

    write_subsection "/etc/login.defs Policy"

    if [[ -r /etc/login.defs ]]; then
        grep -E \
            '^[[:space:]]*(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE|PASS_MIN_LEN|ENCRYPT_METHOD)' \
            /etc/login.defs 2>/dev/null ||
            write_review "Relevant password policy entries were not found."
    else
        write_warning "/etc/login.defs could not be read."
    fi

    write_subsection "PAM Password Quality Configuration"

    if [[ -r /etc/security/pwquality.conf ]]; then
        grep -Ev '^[[:space:]]*(#|$)' \
            /etc/security/pwquality.conf 2>/dev/null ||
            write_review "No active pwquality.conf settings were found."
    else
        write_warning "/etc/security/pwquality.conf could not be read."
    fi

    write_subsection "Root Password Status"

    if command_exists passwd; then
        passwd -S root 2>&1 ||
            write_warning "Root password status could not be collected."
    fi

    printf '\n'
    write_section "SSH Security Review"

    write_item "sshd service" "${SSH_SERVICE_STATUS}"
    write_item "PermitRootLogin" "${SSH_ROOT_LOGIN_STATUS}"
    write_item "PasswordAuthentication" "${SSH_PASSWORD_AUTH_STATUS}"

    if [[ "${SSH_SERVICE_STATUS}" == "ACTIVE" ]]; then
        write_pass "The SSH service is active."
    else
        write_review "The SSH service is not active."
    fi

    case "${SSH_ROOT_LOGIN_STATUS,,}" in
        no|prohibit-password|without-password)
            write_pass "Direct SSH root login is restricted."
            ;;
        yes)
            write_warning "Direct SSH root login is enabled."
            ;;
        *)
            write_review "PermitRootLogin relies on a default or unspecified value."
            ;;
    esac

    case "${SSH_PASSWORD_AUTH_STATUS,,}" in
        no)
            write_pass "SSH password authentication is disabled."
            ;;
        yes)
            write_review "SSH password authentication is enabled."
            ;;
        *)
            write_review "PasswordAuthentication relies on a default or unspecified value."
            ;;
    esac

    write_subsection "Active SSH Configuration"

    if command_exists sshd; then
        if [[ "$(id -u)" -eq 0 ]]; then
            sshd -T 2>/dev/null |
                grep -E \
                    '^(port|permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries|x11forwarding|permitemptypasswords|usepam) ' ||
                write_warning "Effective SSH configuration could not be collected."
        else
            write_review "Run with sudo to inspect the complete effective SSH configuration."
        fi
    else
        write_warning "The sshd command is not installed."
    fi

    printf '\n'
    write_section "Firewall Assessment"

    write_item "Firewall status" "${FIREWALL_STATUS}"

    if [[ "${FIREWALL_STATUS}" == "ACTIVE" ]]; then
        write_pass "firewalld is active."

        write_subsection "Active Zones"
        firewall-cmd --get-active-zones 2>&1

        write_subsection "Default Zone"
        firewall-cmd --get-default-zone 2>&1

        write_subsection "Current Zone Configuration"
        firewall-cmd --list-all 2>&1
    elif [[ "${FIREWALL_STATUS}" == "INACTIVE" ]]; then
        write_warning "firewalld is installed but not active."
    else
        write_warning "firewall-cmd is not installed."
    fi

    printf '\n'
    write_section "SELinux Assessment"

    write_item "SELinux state" "${SELINUX_STATUS}"

    case "${SELINUX_STATUS}" in
        Enforcing)
            write_pass "SELinux is enforcing."
            ;;
        Permissive)
            write_warning "SELinux is running in permissive mode."
            ;;
        Disabled)
            write_warning "SELinux is disabled."
            ;;
        *)
            write_review "SELinux status could not be fully determined."
            ;;
    esac

    if command_exists sestatus; then
        write_subsection "Detailed SELinux Status"
        sestatus 2>&1
    fi

    printf '\n'
    write_section "Failed Login Activity"

    write_item "Failed login records reviewed" "${FAILED_LOGIN_COUNT}"

    if command_exists lastb; then
        write_subsection "Recent Failed Logins"

        lastb -n 20 2>&1 ||
            write_warning "Failed login records could not be read."
    else
        write_warning "The lastb command is not available."
    fi

    if [[ "${FAILED_LOGIN_COUNT}" -eq 0 ]]; then
        write_pass "No failed login records were found in the reviewed sample."
    elif [[ "${FAILED_LOGIN_COUNT}" -le 10 ]]; then
        write_review "${FAILED_LOGIN_COUNT} failed login records were found."
    else
        write_warning "${FAILED_LOGIN_COUNT} failed login records were found."
    fi

    printf '\n'
    write_section "Critical File Permissions"

    for critical_file in \
        /etc/passwd \
        /etc/shadow \
        /etc/group \
        /etc/gshadow \
        /etc/sudoers \
        /etc/ssh/sshd_config
    do
        file_permission_summary "${critical_file}"
    done

    printf '\n'
    write_section "World-Writable Files"

    write_item "World-writable file count" "${WORLD_WRITABLE_COUNT}"

    find / \
        -xdev \
        -type f \
        -perm -0002 \
        -printf '%m %u:%g %p\n' \
        2>/dev/null |
        sort |
        head -n 100

    if [[ "${WORLD_WRITABLE_COUNT}" -eq 0 ]]; then
        write_pass "No world-writable regular files were found on the root filesystem."
    else
        write_warning "${WORLD_WRITABLE_COUNT} world-writable regular files require review."
    fi

    printf '\n'
    write_section "World-Writable Directories"

    find / \
        -xdev \
        -type d \
        -perm -0002 \
        -printf '%m %u:%g %p\n' \
        2>/dev/null |
        sort |
        head -n 100

    write_review "World-writable directories should be reviewed for appropriate sticky-bit protection."

    printf '\n'
    write_section "SUID Files"

    write_item "SUID file count" "${SUID_COUNT}"

    find / \
        -xdev \
        -type f \
        -perm -4000 \
        -printf '%m %u:%g %p\n' \
        2>/dev/null |
        sort

    if [[ "${SUID_COUNT}" -eq 0 ]]; then
        write_pass "No SUID files were detected."
    else
        write_review "${SUID_COUNT} SUID files were detected and should be periodically reviewed."
    fi

    printf '\n'
    write_section "SGID Files"

    write_item "SGID file count" "${SGID_COUNT}"

    find / \
        -xdev \
        -type f \
        -perm -2000 \
        -printf '%m %u:%g %p\n' \
        2>/dev/null |
        sort

    if [[ "${SGID_COUNT}" -eq 0 ]]; then
        write_pass "No SGID files were detected."
    else
        write_review "${SGID_COUNT} SGID files were detected and should be periodically reviewed."
    fi

    printf '\n'
    write_section "Service Security Review"

    write_item "Failed service count" "${FAILED_SERVICE_COUNT}"

    write_subsection "Failed Services"

    if command_exists systemctl; then
        systemctl --failed --no-pager 2>&1

        write_subsection "Enabled Services"

        systemctl list-unit-files \
            --type=service \
            --state=enabled \
            --no-pager 2>&1
    else
        write_warning "systemctl is not available."
    fi

    if [[ "${FAILED_SERVICE_COUNT}" -eq 0 ]]; then
        write_pass "No failed systemd services were detected."
    else
        write_warning "${FAILED_SERVICE_COUNT} failed systemd services were detected."
    fi

    printf '\n'
    write_section "Listening Network Services"

    if command_exists ss; then
        ss -lntup 2>&1 ||
            write_warning "Listening network services could not be collected."
    else
        write_warning "The ss command is not installed."
    fi

    printf '\n'
    write_section "Recent Security-Relevant Logs"

    if command_exists journalctl; then
        write_subsection "Authentication and Privilege Events"

        journalctl \
            --since "24 hours ago" \
            --no-pager \
            2>/dev/null |
            grep -Ei \
                'authentication failure|failed password|accepted password|accepted publickey|sudo|su:|session opened|session closed' |
            tail -n 100 ||
            write_review "No matching authentication events were found."
    else
        write_warning "journalctl is not available."
    fi

    printf '\n'
    write_section "Security Recommendations"

    if [[ "${UID_ZERO_COUNT}" -gt 1 ]]; then
        write_warning "Review all UID 0 accounts and remove unnecessary privileged accounts."
    else
        write_pass "No additional UID 0 accounts require investigation."
    fi

    if [[ "${SSH_ROOT_LOGIN_STATUS,,}" == "yes" ]]; then
        write_warning "Set PermitRootLogin to no or prohibit-password where appropriate."
    else
        write_pass "No recommendation is required for direct SSH root access."
    fi

    if [[ "${SSH_PASSWORD_AUTH_STATUS,,}" == "yes" ]]; then
        write_review "Consider SSH key authentication and disabling password authentication."
    else
        write_pass "SSH password authentication is not explicitly enabled."
    fi

    if [[ "${FIREWALL_STATUS}" != "ACTIVE" ]]; then
        write_warning "Enable and configure firewalld unless another firewall is intentionally used."
    else
        write_pass "The host firewall is active."
    fi

    if [[ "${SELINUX_STATUS}" != "Enforcing" ]]; then
        write_warning "Use SELinux enforcing mode unless a documented exception exists."
    else
        write_pass "SELinux is enforcing."
    fi

    if [[ "${WORLD_WRITABLE_COUNT}" -gt 0 ]]; then
        write_warning "Review world-writable regular files and remove unnecessary write access."
    else
        write_pass "No world-writable regular files require remediation."
    fi

    if [[ "${FAILED_SERVICE_COUNT}" -gt 0 ]]; then
        write_warning "Investigate failed systemd services."
    else
        write_pass "No failed services require investigation."
    fi

    if [[ "${FAILED_LOGIN_COUNT}" -gt 10 ]]; then
        write_warning "Investigate repeated failed login attempts."
    else
        write_review "Continue monitoring failed login activity."
    fi

    printf '\n'
    write_section "Overall Security Assessment"

    write_item "Passed checks" "${PASS_COUNT}"
    write_item "Warnings" "${WARNING_COUNT}"
    write_item "Review items" "${REVIEW_COUNT}"
    write_item "Failed checks" "${FAIL_COUNT}"

    if [[ "${FAIL_COUNT}" -gt 0 ]]; then
        write_item "Overall status" "CRITICAL"
        printf 'Immediate investigation is recommended.\n'
    elif [[ "${WARNING_COUNT}" -ge 5 ]]; then
        write_item "Overall status" "NEEDS ATTENTION"
        printf 'Several security findings require investigation.\n'
    elif [[ "${WARNING_COUNT}" -gt 0 || "${REVIEW_COUNT}" -gt 0 ]]; then
        write_item "Overall status" "REVIEW RECOMMENDED"
        printf 'The system is operational, but identified items should be reviewed.\n'
    else
        write_item "Overall status" "GOOD"
        printf 'No significant issues were identified by this audit.\n'
    fi

    printf '\n'
    write_section "End of Report"

    printf 'Security audit completed successfully.\n'

} > "${REPORT_FILE}"

printf '\n'
printf 'Security audit completed successfully.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"