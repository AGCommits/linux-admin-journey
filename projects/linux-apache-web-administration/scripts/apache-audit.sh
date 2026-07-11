#!/bin/bash

# ============================================================
# Project:
#   Linux Apache Web Server Administration
#
# Script:
#   apache-audit.sh
#
# Description:
#   Performs a read-only audit of an Apache HTTP Server
#   installation on Rocky Linux and generates a structured
#   report covering package state, service health, configuration,
#   virtual hosts, ports, firewall rules, SELinux, document-root
#   permissions, logs, and local HTTP availability.
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
# - Detects the Apache package and installed version.
# - Reviews httpd service state and boot enablement.
# - Validates Apache configuration syntax.
# - Reviews configured virtual hosts and loaded modules.
# - Audits listening HTTP and HTTPS ports.
# - Reviews firewalld configuration.
# - Reviews SELinux status and Apache-related booleans.
# - Audits document-root permissions and deployed content.
# - Reviews recent access, error, and journal logs.
# - Performs local HTTP and HTTPS availability tests.
# - Generates an executive summary and recommendations.
#
# ============================================================
#
# Safety
#
# This script is read-only. It does not:
# - Install or remove Apache.
# - Start, stop, restart, or reload services.
# - Modify Apache configuration.
# - Change firewall rules.
# - Change SELinux policy or booleans.
# - Change file ownership or permissions.
# - Deploy or remove website content.
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
REPORT_FILE="${REPORT_DIR}/apache-audit-${TIMESTAMP}.txt"

mkdir -p "${REPORT_DIR}"

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

SCRIPT_VERSION="1.0.0"

HTTPD_PACKAGE="httpd"
HTTPD_SERVICE="httpd"
HTTPD_CONFIG="/etc/httpd/conf/httpd.conf"
HTTPD_CONFIG_DIR="/etc/httpd"
DOCUMENT_ROOT="/var/www/html"

LOCAL_HTTP_URL="http://127.0.0.1/"
LOCAL_HTTPS_URL="https://127.0.0.1/"

# ------------------------------------------------------------
# Audit state
# ------------------------------------------------------------

PASS_COUNT=0
WARNING_COUNT=0
REVIEW_COUNT=0
FAIL_COUNT=0

PACKAGE_STATUS="NOT INSTALLED"
APACHE_VERSION="Unavailable"

SERVICE_ACTIVE_STATUS="UNKNOWN"
SERVICE_ENABLED_STATUS="UNKNOWN"
CONFIG_STATUS="UNKNOWN"

HTTP_LISTENER_STATUS="NOT DETECTED"
HTTPS_LISTENER_STATUS="NOT DETECTED"

FIREWALL_STATUS="UNKNOWN"
HTTP_FIREWALL_STATUS="NOT CONFIGURED"
HTTPS_FIREWALL_STATUS="NOT CONFIGURED"

SELINUX_STATUS="UNKNOWN"

DOCUMENT_ROOT_STATUS="MISSING"
INDEX_FILE_STATUS="MISSING"

HTTP_TEST_STATUS="NOT TESTED"
HTTPS_TEST_STATUS="NOT TESTED"

FAILED_SERVICE_COUNT=0
VIRTUAL_HOST_COUNT=0
ACCESS_LOG_COUNT=0
ERROR_LOG_COUNT=0

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

get_package_status() {
    if command_exists rpm &&
       rpm -q "${HTTPD_PACKAGE}" >/dev/null 2>&1; then
        printf 'INSTALLED'
    else
        printf 'NOT INSTALLED'
    fi
}

get_apache_version() {
    if command_exists httpd; then
        httpd -v 2>/dev/null |
            awk -F': ' '/Server version/ {print $2; exit}'
    elif command_exists apachectl; then
        apachectl -v 2>/dev/null |
            awk -F': ' '/Server version/ {print $2; exit}'
    else
        printf 'Unavailable'
    fi
}

get_service_active_status() {
    if ! command_exists systemctl; then
        printf 'UNAVAILABLE'
        return
    fi

    if systemctl is-active --quiet "${HTTPD_SERVICE}"; then
        printf 'ACTIVE'
    else
        printf 'INACTIVE'
    fi
}

get_service_enabled_status() {
    if ! command_exists systemctl; then
        printf 'UNAVAILABLE'
        return
    fi

    if systemctl is-enabled --quiet "${HTTPD_SERVICE}" 2>/dev/null; then
        printf 'ENABLED'
    else
        printf 'DISABLED'
    fi
}

test_apache_configuration() {
    local output
    local status

    if command_exists apachectl; then
        output="$(apachectl configtest 2>&1)"
        status=$?
    elif command_exists httpd; then
        output="$(httpd -t 2>&1)"
        status=$?
    else
        printf 'UNAVAILABLE'
        return
    fi

    if [[ "${status}" -eq 0 ]]; then
        printf 'VALID'
    else
        printf 'INVALID'
    fi
}

get_failed_service_count() {
    if ! command_exists systemctl; then
        printf '0'
        return
    fi

    systemctl --failed \
        --type=service \
        --no-legend \
        --plain \
        2>/dev/null |
        awk 'NF > 0 {count++} END {print count + 0}'
}

listener_exists() {
    local port="$1"

    if ! command_exists ss; then
        return 1
    fi

    ss -lntH 2>/dev/null |
        awk -v port="${port}" '
            {
                address=$4

                if (address ~ ":" port "$") {
                    found=1
                }
            }

            END {
                exit(found ? 0 : 1)
            }
        '
}

get_firewall_status() {
    if ! command_exists firewall-cmd; then
        printf 'NOT INSTALLED'
        return
    fi

    if firewall-cmd --state >/dev/null 2>&1; then
        printf 'ACTIVE'
    else
        printf 'INACTIVE'
    fi
}

firewall_service_configured() {
    local service_name="$1"

    if [[ "${FIREWALL_STATUS}" != "ACTIVE" ]]; then
        return 1
    fi

    firewall-cmd --quiet --query-service="${service_name}" 2>/dev/null
}

get_selinux_status() {
    if command_exists getenforce; then
        getenforce 2>/dev/null || printf 'UNKNOWN'
    else
        printf 'NOT INSTALLED'
    fi
}

get_virtual_host_count() {
    local output

    if command_exists apachectl; then
        output="$(apachectl -S 2>/dev/null)"
    elif command_exists httpd; then
        output="$(httpd -S 2>/dev/null)"
    else
        printf '0'
        return
    fi

    awk '
        /namevhost|default server|port [0-9]+ namevhost/ {
            count++
        }

        END {
            print count + 0
        }
    ' <<< "${output}"
}

count_log_lines() {
    local log_file="$1"

    if [[ -r "${log_file}" ]]; then
        wc -l < "${log_file}" | tr -d '[:space:]'
    else
        printf '0'
    fi
}

test_web_endpoint() {
    local url="$1"
    local insecure="${2:-false}"
    local status_code

    if ! command_exists curl; then
        printf 'UNAVAILABLE'
        return
    fi

    if [[ "${insecure}" == "true" ]]; then
        status_code="$(
            curl \
                --insecure \
                --silent \
                --show-error \
                --output /dev/null \
                --write-out '%{http_code}' \
                --connect-timeout 5 \
                --max-time 10 \
                "${url}" \
                2>/dev/null
        )"
    else
        status_code="$(
            curl \
                --silent \
                --show-error \
                --output /dev/null \
                --write-out '%{http_code}' \
                --connect-timeout 5 \
                --max-time 10 \
                "${url}" \
                2>/dev/null
        )"
    fi

    case "${status_code}" in
        200|201|202|204|301|302|303|307|308|401|403)
            printf 'PASS (%s)' "${status_code}"
            ;;
        000|"")
            printf 'FAIL'
            ;;
        *)
            printf 'REVIEW (%s)' "${status_code}"
            ;;
    esac
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
# Collect audit values
# ------------------------------------------------------------

PACKAGE_STATUS="$(get_package_status)"
APACHE_VERSION="$(get_apache_version)"

SERVICE_ACTIVE_STATUS="$(get_service_active_status)"
SERVICE_ENABLED_STATUS="$(get_service_enabled_status)"
CONFIG_STATUS="$(test_apache_configuration)"

FAILED_SERVICE_COUNT="$(get_failed_service_count)"
VIRTUAL_HOST_COUNT="$(get_virtual_host_count)"

if listener_exists 80; then
    HTTP_LISTENER_STATUS="LISTENING"
fi

if listener_exists 443; then
    HTTPS_LISTENER_STATUS="LISTENING"
fi

FIREWALL_STATUS="$(get_firewall_status)"

if firewall_service_configured http; then
    HTTP_FIREWALL_STATUS="CONFIGURED"
fi

if firewall_service_configured https; then
    HTTPS_FIREWALL_STATUS="CONFIGURED"
fi

SELINUX_STATUS="$(get_selinux_status)"

if [[ -d "${DOCUMENT_ROOT}" ]]; then
    DOCUMENT_ROOT_STATUS="PRESENT"
fi

if [[ -f "${DOCUMENT_ROOT}/index.html" ]]; then
    INDEX_FILE_STATUS="PRESENT"
fi

HTTP_TEST_STATUS="$(test_web_endpoint "${LOCAL_HTTP_URL}")"

if [[ "${HTTPS_LISTENER_STATUS}" == "LISTENING" ]]; then
    HTTPS_TEST_STATUS="$(test_web_endpoint "${LOCAL_HTTPS_URL}" true)"
else
    HTTPS_TEST_STATUS="NOT CONFIGURED"
fi

ACCESS_LOG_COUNT="$(count_log_lines /var/log/httpd/access_log)"
ERROR_LOG_COUNT="$(count_log_lines /var/log/httpd/error_log)"

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux Apache Web Server Audit Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Effective UID" "$(id -u)"
    write_item "Script version" "${SCRIPT_VERSION}"
    write_item "Report file" "${REPORT_FILE}"

    if [[ "$(id -u)" -ne 0 ]]; then
        printf '\n'
        write_warning \
            "The audit is not running as root. Protected log and configuration data may be incomplete."
    fi

    printf '\n'
    write_section "Executive Summary"

    write_item "Apache package" "${PACKAGE_STATUS}"
    write_item "Apache version" "${APACHE_VERSION}"
    write_item "Service active" "${SERVICE_ACTIVE_STATUS}"
    write_item "Service enabled" "${SERVICE_ENABLED_STATUS}"
    write_item "Configuration" "${CONFIG_STATUS}"
    write_item "HTTP port 80" "${HTTP_LISTENER_STATUS}"
    write_item "HTTPS port 443" "${HTTPS_LISTENER_STATUS}"
    write_item "Firewall" "${FIREWALL_STATUS}"
    write_item "Firewall HTTP service" "${HTTP_FIREWALL_STATUS}"
    write_item "Firewall HTTPS service" "${HTTPS_FIREWALL_STATUS}"
    write_item "SELinux" "${SELINUX_STATUS}"
    write_item "Document root" "${DOCUMENT_ROOT_STATUS}"
    write_item "Index file" "${INDEX_FILE_STATUS}"
    write_item "Local HTTP test" "${HTTP_TEST_STATUS}"
    write_item "Local HTTPS test" "${HTTPS_TEST_STATUS}"
    write_item "Virtual host count" "${VIRTUAL_HOST_COUNT}"
    write_item "Failed services" "${FAILED_SERVICE_COUNT}"

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
    write_section "Apache Package Information"

    write_item "Package status" "${PACKAGE_STATUS}"
    write_item "Apache version" "${APACHE_VERSION}"

    if command_exists rpm; then
        write_subsection "Installed Package Details"

        rpm -qi "${HTTPD_PACKAGE}" 2>&1 ||
            printf 'The httpd package is not installed.\n'

        write_subsection "Apache-Related Packages"

        rpm -qa |
            grep -Ei '^(httpd|mod_|apr|apr-util)' |
            sort ||
            printf 'No Apache-related RPM packages were found.\n'
    else
        write_warning "The rpm command is unavailable."
    fi

    printf '\n'
    write_section "Apache Service Status"

    write_item "Runtime status" "${SERVICE_ACTIVE_STATUS}"
    write_item "Boot status" "${SERVICE_ENABLED_STATUS}"

    if command_exists systemctl; then
        systemctl status "${HTTPD_SERVICE}" \
            --no-pager \
            --lines=30 \
            2>&1 ||
            printf 'The httpd service is not currently active.\n'

        write_subsection "Service Unit Definition"

        systemctl cat "${HTTPD_SERVICE}" 2>&1 ||
            printf 'The httpd unit definition could not be displayed.\n'
    else
        write_warning "systemctl is unavailable."
    fi

    if [[ "${SERVICE_ACTIVE_STATUS}" == "ACTIVE" ]]; then
        write_pass "The Apache service is active."
    else
        write_warning "The Apache service is not active."
    fi

    if [[ "${SERVICE_ENABLED_STATUS}" == "ENABLED" ]]; then
        write_pass "Apache is enabled to start during boot."
    else
        write_review "Apache is not enabled to start during boot."
    fi

    printf '\n'
    write_section "Apache Configuration Validation"

    write_item "Configuration status" "${CONFIG_STATUS}"
    write_item "Primary configuration" "${HTTPD_CONFIG}"
    write_item "Configuration directory" "${HTTPD_CONFIG_DIR}"

    write_subsection "Configuration Test Output"

    if command_exists apachectl; then
        apachectl configtest 2>&1
    elif command_exists httpd; then
        httpd -t 2>&1
    else
        printf 'Apache configuration tools are unavailable.\n'
    fi

    if [[ "${CONFIG_STATUS}" == "VALID" ]]; then
        write_pass "Apache configuration syntax is valid."
    elif [[ "${CONFIG_STATUS}" == "INVALID" ]]; then
        write_fail "Apache configuration syntax is invalid."
    else
        write_warning "Apache configuration could not be validated."
    fi

    write_subsection "Active Configuration Files"

    if [[ -d "${HTTPD_CONFIG_DIR}" ]]; then
        find "${HTTPD_CONFIG_DIR}" \
            -maxdepth 3 \
            -type f \
            \( -name '*.conf' -o -name '*.load' \) \
            -printf '%M %u:%g %p\n' \
            2>/dev/null |
            sort
    else
        printf 'Apache configuration directory was not found.\n'
    fi

    printf '\n'
    write_section "Virtual Host Configuration"

    write_item "Detected virtual hosts" "${VIRTUAL_HOST_COUNT}"

    if command_exists apachectl; then
        apachectl -S 2>&1
    elif command_exists httpd; then
        httpd -S 2>&1
    else
        printf 'Virtual-host information is unavailable.\n'
    fi

    if (( VIRTUAL_HOST_COUNT > 0 )); then
        write_pass "At least one Apache virtual host was detected."
    else
        write_review \
            "No explicit virtual hosts were detected; Apache may be using its default configuration."
    fi

    printf '\n'
    write_section "Loaded Apache Modules"

    if command_exists apachectl; then
        apachectl -M 2>&1
    elif command_exists httpd; then
        httpd -M 2>&1
    else
        printf 'Loaded module information is unavailable.\n'
    fi

    printf '\n'
    write_section "Listening Ports"

    write_item "HTTP port 80" "${HTTP_LISTENER_STATUS}"
    write_item "HTTPS port 443" "${HTTPS_LISTENER_STATUS}"

    if command_exists ss; then
        write_subsection "Listening Web Sockets"

        ss -lntp 2>&1 |
            awk '
                NR == 1 ||
                $4 ~ /:80$/ ||
                $4 ~ /:443$/
            '
    else
        write_warning "The ss command is unavailable."
    fi

    if [[ "${HTTP_LISTENER_STATUS}" == "LISTENING" ]]; then
        write_pass "An HTTP listener was detected on port 80."
    else
        write_warning "No HTTP listener was detected on port 80."
    fi

    if [[ "${HTTPS_LISTENER_STATUS}" == "LISTENING" ]]; then
        write_pass "An HTTPS listener was detected on port 443."
    else
        write_review "No HTTPS listener was detected on port 443."
    fi

    printf '\n'
    write_section "Firewall Assessment"

    write_item "firewalld status" "${FIREWALL_STATUS}"
    write_item "HTTP service" "${HTTP_FIREWALL_STATUS}"
    write_item "HTTPS service" "${HTTPS_FIREWALL_STATUS}"

    if [[ "${FIREWALL_STATUS}" == "ACTIVE" ]]; then
        write_subsection "Active Zones"
        firewall-cmd --get-active-zones 2>&1

        write_subsection "Default Zone"
        firewall-cmd --get-default-zone 2>&1

        write_subsection "Current Zone Configuration"
        firewall-cmd --list-all 2>&1

        write_pass "firewalld is active."
    elif [[ "${FIREWALL_STATUS}" == "INACTIVE" ]]; then
        write_warning "firewalld is installed but inactive."
    else
        write_warning "firewall-cmd is not installed."
    fi

    if [[ "${HTTP_FIREWALL_STATUS}" == "CONFIGURED" ]]; then
        write_pass "The HTTP firewall service is configured."
    else
        write_review "The HTTP firewall service is not configured."
    fi

    if [[ "${HTTPS_FIREWALL_STATUS}" == "CONFIGURED" ]]; then
        write_pass "The HTTPS firewall service is configured."
    else
        write_review "The HTTPS firewall service is not configured."
    fi

    printf '\n'
    write_section "SELinux Assessment"

    write_item "SELinux status" "${SELINUX_STATUS}"

    if command_exists sestatus; then
        write_subsection "Detailed SELinux Status"
        sestatus 2>&1
    fi

    if command_exists getsebool; then
        write_subsection "Apache SELinux Booleans"

        getsebool -a 2>/dev/null |
            grep '^httpd_' |
            sort
    else
        write_review \
            "Apache-related SELinux booleans could not be displayed."
    fi

    if command_exists ls; then
        write_subsection "Document Root SELinux Context"

        ls -ldZ "${DOCUMENT_ROOT}" 2>&1 ||
            printf 'Document root context is unavailable.\n'

        if [[ -e "${DOCUMENT_ROOT}/index.html" ]]; then
            ls -lZ "${DOCUMENT_ROOT}/index.html" 2>&1
        fi
    fi

    case "${SELINUX_STATUS}" in
        Enforcing)
            write_pass "SELinux is enforcing."
            ;;
        Permissive)
            write_warning "SELinux is in permissive mode."
            ;;
        Disabled)
            write_warning "SELinux is disabled."
            ;;
        *)
            write_review "SELinux status could not be fully determined."
            ;;
    esac

    printf '\n'
    write_section "Document Root Review"

    write_item "Document root" "${DOCUMENT_ROOT}"
    write_item "Directory status" "${DOCUMENT_ROOT_STATUS}"
    write_item "Index file" "${INDEX_FILE_STATUS}"

    write_subsection "Permissions"

    file_permission_summary "${DOCUMENT_ROOT}"
    file_permission_summary "${DOCUMENT_ROOT}/index.html"

    write_subsection "Document Root Contents"

    if [[ -d "${DOCUMENT_ROOT}" ]]; then
        find "${DOCUMENT_ROOT}" \
            -maxdepth 2 \
            -printf '%M %u:%g %p\n' \
            2>/dev/null |
            sort |
            head -n 100
    else
        printf 'Document root does not exist.\n'
    fi

    if [[ "${DOCUMENT_ROOT_STATUS}" == "PRESENT" ]]; then
        write_pass "The Apache document root exists."
    else
        write_warning "The Apache document root is missing."
    fi

    if [[ "${INDEX_FILE_STATUS}" == "PRESENT" ]]; then
        write_pass "An index.html file is deployed."
    else
        write_review "No index.html file was found."
    fi

    printf '\n'
    write_section "Local Web Availability Tests"

    write_item "HTTP endpoint" "${LOCAL_HTTP_URL}"
    write_item "HTTP result" "${HTTP_TEST_STATUS}"
    write_item "HTTPS endpoint" "${LOCAL_HTTPS_URL}"
    write_item "HTTPS result" "${HTTPS_TEST_STATUS}"

    if [[ "${HTTP_TEST_STATUS}" == PASS* ]]; then
        write_pass "The local HTTP endpoint responded successfully."
    elif [[ "${HTTP_TEST_STATUS}" == REVIEW* ]]; then
        write_review \
            "The local HTTP endpoint responded with a non-standard status."
    else
        write_warning "The local HTTP endpoint did not respond successfully."
    fi

    if [[ "${HTTPS_TEST_STATUS}" == PASS* ]]; then
        write_pass "The local HTTPS endpoint responded successfully."
    elif [[ "${HTTPS_TEST_STATUS}" == "NOT CONFIGURED" ]]; then
        write_review "HTTPS is not currently configured."
    elif [[ "${HTTPS_TEST_STATUS}" == REVIEW* ]]; then
        write_review \
            "The local HTTPS endpoint returned a status requiring review."
    else
        write_warning "The local HTTPS endpoint did not respond successfully."
    fi

    if command_exists curl; then
        write_subsection "HTTP Response Headers"

        curl \
            --silent \
            --show-error \
            --head \
            --connect-timeout 5 \
            --max-time 10 \
            "${LOCAL_HTTP_URL}" \
            2>&1 ||
            printf 'HTTP response headers could not be collected.\n'
    fi

    printf '\n'
    write_section "Apache Log Review"

    write_item "Access log lines" "${ACCESS_LOG_COUNT}"
    write_item "Error log lines" "${ERROR_LOG_COUNT}"

    write_subsection "Recent Access Log Entries"

    if [[ -r /var/log/httpd/access_log ]]; then
        tail -n 50 /var/log/httpd/access_log
    else
        printf 'The Apache access log is unavailable or unreadable.\n'
    fi

    write_subsection "Recent Error Log Entries"

    if [[ -r /var/log/httpd/error_log ]]; then
        tail -n 50 /var/log/httpd/error_log
    else
        printf 'The Apache error log is unavailable or unreadable.\n'
    fi

    write_subsection "Recent Apache Journal Entries"

    if command_exists journalctl; then
        journalctl \
            -u "${HTTPD_SERVICE}" \
            --since "24 hours ago" \
            --no-pager \
            -n 100 \
            2>&1
    else
        write_warning "journalctl is unavailable."
    fi

    printf '\n'
    write_section "Failed Service Review"

    write_item "Failed service count" "${FAILED_SERVICE_COUNT}"

    if command_exists systemctl; then
        systemctl --failed \
            --type=service \
            --no-pager \
            2>&1
    else
        write_warning "systemctl is unavailable."
    fi

    if (( FAILED_SERVICE_COUNT == 0 )); then
        write_pass "No failed systemd services were detected."
    else
        write_warning \
            "${FAILED_SERVICE_COUNT} failed service(s) require investigation."
    fi

    printf '\n'
    write_section "Apache Security Recommendations"

    if [[ "${PACKAGE_STATUS}" == "INSTALLED" ]]; then
        write_pass "The Apache package is installed."
    else
        write_warning "Install the httpd package before deploying the website."
    fi

    if [[ "${SERVICE_ACTIVE_STATUS}" == "ACTIVE" ]]; then
        write_pass "The Apache service is running."
    else
        write_warning "Start Apache after validating its configuration."
    fi

    if [[ "${SERVICE_ENABLED_STATUS}" == "ENABLED" ]]; then
        write_pass "Apache is configured to start at boot."
    else
        write_review "Enable Apache at boot if persistent hosting is required."
    fi

    if [[ "${CONFIG_STATUS}" == "VALID" ]]; then
        write_pass "Apache configuration syntax is valid."
    else
        write_warning "Correct Apache configuration errors before starting it."
    fi

    if [[ "${HTTP_FIREWALL_STATUS}" == "CONFIGURED" ]]; then
        write_pass "The firewall permits HTTP traffic."
    else
        write_review \
            "Configure the HTTP firewall service if remote access is required."
    fi

    if [[ "${HTTPS_FIREWALL_STATUS}" == "CONFIGURED" ]]; then
        write_pass "The firewall permits HTTPS traffic."
    else
        write_review \
            "Configure HTTPS and its firewall service before production use."
    fi

    if [[ "${SELINUX_STATUS}" == "Enforcing" ]]; then
        write_pass "SELinux remains in enforcing mode."
    else
        write_warning "Use SELinux enforcing mode where possible."
    fi

    if [[ "${HTTPS_LISTENER_STATUS}" != "LISTENING" ]]; then
        write_review \
            "Configure TLS before exposing the website beyond a test environment."
    else
        write_pass "An HTTPS listener is configured."
    fi

    if [[ "${INDEX_FILE_STATUS}" == "PRESENT" ]]; then
        write_pass "Website content is deployed."
    else
        write_review "Deploy a controlled index page to the document root."
    fi

    printf '\n'
    write_section "Overall Assessment"

    write_item "Passed checks" "${PASS_COUNT}"
    write_item "Warnings" "${WARNING_COUNT}"
    write_item "Review items" "${REVIEW_COUNT}"
    write_item "Failed checks" "${FAIL_COUNT}"

    if (( FAIL_COUNT > 0 )); then
        write_item "Overall status" "CRITICAL"
        printf 'Apache configuration or operation has failed checks.\n'
    elif (( WARNING_COUNT >= 5 )); then
        write_item "Overall status" "NEEDS ATTENTION"
        printf 'Several Apache findings require investigation.\n'
    elif (( WARNING_COUNT > 0 || REVIEW_COUNT > 0 )); then
        write_item "Overall status" "REVIEW RECOMMENDED"
        printf 'Apache is operational or partially configured, but review items remain.\n'
    else
        write_item "Overall status" "GOOD"
        printf 'No significant Apache issues were identified.\n'
    fi

    printf '\n'
    write_section "End of Report"

    printf 'Apache audit completed successfully.\n'

} > "${REPORT_FILE}"

printf '\n'
printf 'Apache audit completed successfully.\n'
printf 'Report saved to:\n'
printf '%s\n' "${REPORT_FILE}"