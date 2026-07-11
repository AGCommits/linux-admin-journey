#!/bin/bash

# ============================================================
# Project:
#   Linux Apache Web Server Administration
#
# Script:
#   apache-audit.sh
#
# Description:
#   Performs a read-only audit of Apache installation, service
#   status, configuration, virtual hosts, firewall access,
#   SELinux contexts, listening ports, website availability,
#   and recent Apache logs.
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
# - Audits Apache package and service status.
# - Runs Apache configuration validation.
# - Reviews loaded modules and virtual hosts.
# - Checks HTTP firewall access.
# - Reviews SELinux state and file contexts.
# - Checks TCP port 80.
# - Performs a local HTTP request.
# - Reviews Apache access and error logs.
# - Generates an overall service assessment.
#
# ============================================================
#
# Safety
#
# This script is read-only and does not modify Apache,
# firewalld, SELinux, website files, or system services.
# ============================================================

set -u
set -o pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${PROJECT_ROOT}/reports"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/apache-audit-${TIMESTAMP}.txt"

LOCAL_HOSTNAME="linux-admin.local"
WEB_ROOT="/var/www/linux-admin-site"
VHOST_FILE="/etc/httpd/conf.d/linux-admin-site.conf"

mkdir -p "${REPORT_DIR}"

PASS_COUNT=0
WARNING_COUNT=0
REVIEW_COUNT=0

PACKAGE_STATUS="NOT INSTALLED"
SERVICE_STATUS="INACTIVE"
SERVICE_ENABLED="DISABLED"
CONFIG_STATUS="UNKNOWN"
HTTP_STATUS="FAILED"
PORT_STATUS="NOT LISTENING"
FIREWALL_STATUS="UNKNOWN"
SELINUX_STATUS="UNKNOWN"

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

if rpm -q httpd >/dev/null 2>&1; then
    PACKAGE_STATUS="INSTALLED"
fi

if command_exists systemctl; then
    if systemctl is-active --quiet httpd; then
        SERVICE_STATUS="ACTIVE"
    fi

    if systemctl is-enabled --quiet httpd; then
        SERVICE_ENABLED="ENABLED"
    fi
fi

if command_exists apachectl; then
    if apachectl configtest >/dev/null 2>&1; then
        CONFIG_STATUS="VALID"
    else
        CONFIG_STATUS="INVALID"
    fi
fi

if command_exists ss &&
   ss -lnt |
       awk '$4 ~ /:80$/ {found=1} END {exit !found}'; then
    PORT_STATUS="LISTENING"
fi

if command_exists curl &&
   curl \
       --fail \
       --silent \
       --max-time 5 \
       "http://${LOCAL_HOSTNAME}/" \
       >/dev/null 2>&1; then
    HTTP_STATUS="PASS"
fi

if command_exists firewall-cmd; then
    if firewall-cmd --state >/dev/null 2>&1; then
        if firewall-cmd --query-service=http >/dev/null 2>&1; then
            FIREWALL_STATUS="HTTP ALLOWED"
        else
            FIREWALL_STATUS="HTTP NOT ALLOWED"
        fi
    else
        FIREWALL_STATUS="INACTIVE"
    fi
else
    FIREWALL_STATUS="NOT INSTALLED"
fi

if command_exists getenforce; then
    SELINUX_STATUS="$(getenforce 2>/dev/null || printf 'UNKNOWN')"
fi

{
    write_section "Linux Apache Web Server Audit Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname)"
    write_item "Executed by" "$(whoami)"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "1.0.0"
    write_item "Report file" "${REPORT_FILE}"

    printf '\n'
    write_section "Executive Summary"

    write_item "Apache package" "${PACKAGE_STATUS}"
    write_item "Apache service" "${SERVICE_STATUS}"
    write_item "Enabled at boot" "${SERVICE_ENABLED}"
    write_item "Configuration" "${CONFIG_STATUS}"
    write_item "TCP port 80" "${PORT_STATUS}"
    write_item "HTTP test" "${HTTP_STATUS}"
    write_item "Firewall" "${FIREWALL_STATUS}"
    write_item "SELinux" "${SELINUX_STATUS}"
    write_item "Virtual host file" "$([[ -f "${VHOST_FILE}" ]] && printf 'PRESENT' || printf 'MISSING')"
    write_item "Document root" "$([[ -d "${WEB_ROOT}" ]] && printf 'PRESENT' || printf 'MISSING')"

    printf '\n'
    write_section "Apache Package Information"

    if [[ "${PACKAGE_STATUS}" == "INSTALLED" ]]; then
        rpm -qi httpd 2>&1
        write_pass "The Apache package is installed."
    else
        write_warning "The Apache package is not installed."
    fi

    printf '\n'
    write_section "Apache Service Status"

    if command_exists systemctl; then
        systemctl status httpd \
            --no-pager \
            --lines=30 \
            2>&1
    fi

    if [[ "${SERVICE_STATUS}" == "ACTIVE" ]]; then
        write_pass "The Apache service is active."
    else
        write_warning "The Apache service is not active."
    fi

    if [[ "${SERVICE_ENABLED}" == "ENABLED" ]]; then
        write_pass "Apache is enabled at boot."
    else
        write_warning "Apache is not enabled at boot."
    fi

    printf '\n'
    write_section "Configuration Validation"

    if command_exists apachectl; then
        apachectl configtest 2>&1

        if [[ "${CONFIG_STATUS}" == "VALID" ]]; then
            write_pass "Apache configuration syntax is valid."
        else
            write_warning "Apache configuration syntax is invalid."
        fi
    else
        write_warning "apachectl is unavailable."
    fi

    printf '\n'
    write_section "Virtual Host Configuration"

    if [[ -r "${VHOST_FILE}" ]]; then
        cat "${VHOST_FILE}"
        write_pass "The portfolio virtual-host configuration is present."
    else
        write_warning "The portfolio virtual-host configuration is missing."
    fi

    if command_exists apachectl; then
        write_subsection "Resolved Virtual Hosts"
        apachectl -S 2>&1
    fi

    printf '\n'
    write_section "Loaded Apache Modules"

    if command_exists apachectl; then
        apachectl -M 2>&1
    fi

    printf '\n'
    write_section "Document Root"

    write_item "Expected path" "${WEB_ROOT}"

    if [[ -d "${WEB_ROOT}" ]]; then
        find "${WEB_ROOT}" \
            -maxdepth 2 \
            -printf '%M %u:%g %p\n' \
            2>/dev/null |
            sort

        write_pass "The document root is present."
    else
        write_warning "The document root is missing."
    fi

    printf '\n'
    write_section "Listening Ports"

    if command_exists ss; then
        ss -lntp 2>&1 |
            awk 'NR == 1 || $4 ~ /:80$|:443$/'
    fi

    if [[ "${PORT_STATUS}" == "LISTENING" ]]; then
        write_pass "A service is listening on TCP port 80."
    else
        write_warning "No service was detected on TCP port 80."
    fi

    printf '\n'
    write_section "HTTP Availability Test"

    write_item "Test URL" "http://${LOCAL_HOSTNAME}/"
    write_item "Test status" "${HTTP_STATUS}"

    if command_exists curl; then
        curl \
            --include \
            --silent \
            --show-error \
            --max-time 5 \
            "http://${LOCAL_HOSTNAME}/" |
            head -n 20
    fi

    if [[ "${HTTP_STATUS}" == "PASS" ]]; then
        write_pass "The local website responded successfully."
    else
        write_warning "The local website did not respond successfully."
    fi

    printf '\n'
    write_section "Firewall Assessment"

    write_item "Firewall status" "${FIREWALL_STATUS}"

    if command_exists firewall-cmd &&
       firewall-cmd --state >/dev/null 2>&1; then

        firewall-cmd --list-all 2>&1
    fi

    if [[ "${FIREWALL_STATUS}" == "HTTP ALLOWED" ]]; then
        write_pass "The firewall permits HTTP traffic."
    else
        write_review "HTTP firewall access is not confirmed."
    fi

    printf '\n'
    write_section "SELinux Assessment"

    write_item "SELinux status" "${SELINUX_STATUS}"

    if command_exists sestatus; then
        sestatus 2>&1
    fi

    if command_exists ls; then
        write_subsection "Web Root Context"
        ls -ldZ "${WEB_ROOT}" 2>&1

        write_subsection "Website File Context"
        ls -lZ "${WEB_ROOT}" 2>&1
    fi

    if [[ "${SELINUX_STATUS}" == "Enforcing" ]]; then
        write_pass "SELinux is enforcing."
    else
        write_review "SELinux is not enforcing or could not be confirmed."
    fi

    printf '\n'
    write_section "Apache Access Log"

    ACCESS_LOG="/var/log/httpd/linux-admin-site-access.log"

    if [[ -r "${ACCESS_LOG}" ]]; then
        tail -n 50 "${ACCESS_LOG}"
    else
        write_review "The virtual-host access log is empty or unavailable."
    fi

    printf '\n'
    write_section "Apache Error Log"

    ERROR_LOG="/var/log/httpd/linux-admin-site-error.log"

    if [[ -r "${ERROR_LOG}" ]]; then
        tail -n 50 "${ERROR_LOG}"
    else
        write_review "The virtual-host error log is empty or unavailable."
    fi

    printf '\n'
    write_section "Recent Apache Journal"

    if command_exists journalctl; then
        journalctl \
            -u httpd \
            --since "24 hours ago" \
            --no-pager \
            -n 100 \
            2>&1
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

    printf 'Apache web server audit completed successfully.\n'

} > "${REPORT_FILE}"

printf '\n'
printf 'Apache web server audit completed successfully.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"