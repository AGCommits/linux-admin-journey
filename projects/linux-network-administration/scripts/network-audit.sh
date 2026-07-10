#!/bin/bash

# ============================================================
# Linux Network Administration
# Script: network-audit.sh
#
# Purpose:
#   Collect and report essential Linux network configuration,
#   connectivity, routing, DNS, interface, socket, and
#   NetworkManager information.
#
# Target Platform:
#   Rocky Linux 9
#
# Safety:
#   This script uses read-only diagnostic commands. It does not
#   modify interfaces, routes, DNS, firewall rules, or services.
# ============================================================

# Do not enable "set -e".
# Individual network commands may legitimately fail when a
# system is disconnected, and the audit should continue.
set -u
set -o pipefail

# ------------------------------------------------------------
# Project paths and report naming
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${PROJECT_ROOT}/reports"
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/network-audit-${TIMESTAMP}.txt"

mkdir -p "${REPORT_DIR}"

# ------------------------------------------------------------
# Audit state
# ------------------------------------------------------------

DEFAULT_GATEWAY="Not detected"
DEFAULT_INTERFACE="Not detected"
PRIMARY_IPV4="Not detected"

GATEWAY_STATUS="NOT TESTED"
EXTERNAL_STATUS="NOT TESTED"
DNS_STATUS="NOT TESTED"
LOOPBACK_STATUS="NOT TESTED"

ACTIVE_INTERFACE_COUNT=0
LISTENING_TCP_COUNT=0
LISTENING_UDP_COUNT=0

# ------------------------------------------------------------
# Formatting functions
# ------------------------------------------------------------

write_section() {
    printf '%s\n' "=========================================="
    printf ' %s\n' "$1"
    printf '%s\n' "=========================================="
}

write_subsection() {
    printf '\n--- %s ---\n' "$1"
}

write_item() {
    printf '%-24s %s\n' "$1:" "$2"
}

write_warning() {
    printf 'WARNING: %s\n' "$1"
}

write_success() {
    printf 'SUCCESS: %s\n' "$1"
}

# ------------------------------------------------------------
# Utility functions
# ------------------------------------------------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

run_command() {
    local description="$1"
    shift

    if "$@" 2>&1; then
        return 0
    fi

    write_warning "${description} command failed or returned no usable data."
    return 1
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

get_default_route_details() {
    local default_route

    if ! command_exists ip; then
        return
    fi

    default_route="$(ip -4 route show default 2>/dev/null | head -n 1)"

    if [[ -n "${default_route}" ]]; then
        DEFAULT_GATEWAY="$(
            awk '
                {
                    for (i = 1; i <= NF; i++) {
                        if ($i == "via") {
                            print $(i + 1)
                            exit
                        }
                    }
                }
            ' <<< "${default_route}"
        )"

        DEFAULT_INTERFACE="$(
            awk '
                {
                    for (i = 1; i <= NF; i++) {
                        if ($i == "dev") {
                            print $(i + 1)
                            exit
                        }
                    }
                }
            ' <<< "${default_route}"
        )"
    fi

    [[ -n "${DEFAULT_GATEWAY}" ]] || DEFAULT_GATEWAY="Not detected"
    [[ -n "${DEFAULT_INTERFACE}" ]] || DEFAULT_INTERFACE="Not detected"
}

get_primary_ipv4() {
    if ! command_exists ip; then
        return
    fi

    PRIMARY_IPV4="$(
        ip -4 -o address show scope global 2>/dev/null |
            awk 'NR == 1 {print $4; exit}'
    )"

    [[ -n "${PRIMARY_IPV4}" ]] || PRIMARY_IPV4="Not detected"
}

collect_summary_counts() {
    if command_exists ip; then
        ACTIVE_INTERFACE_COUNT="$(
            ip -o link show up 2>/dev/null |
                awk -F': ' '$2 != "lo" {count++} END {print count + 0}'
        )"
    fi

    if command_exists ss; then
        LISTENING_TCP_COUNT="$(
            ss -lntH 2>/dev/null | wc -l | tr -d '[:space:]'
        )"

        LISTENING_UDP_COUNT="$(
            ss -lnuH 2>/dev/null | wc -l | tr -d '[:space:]'
        )"
    fi
}

test_ping_target() {
    local target="$1"

    command_exists ping || return 1

    ping -c 1 -W 2 "${target}" >/dev/null 2>&1
}

perform_connectivity_tests() {
    if test_ping_target "127.0.0.1"; then
        LOOPBACK_STATUS="PASS"
    else
        LOOPBACK_STATUS="FAIL"
    fi

    if [[ "${DEFAULT_GATEWAY}" != "Not detected" ]] &&
       test_ping_target "${DEFAULT_GATEWAY}"; then
        GATEWAY_STATUS="PASS"
    else
        GATEWAY_STATUS="FAIL"
    fi

    if test_ping_target "1.1.1.1"; then
        EXTERNAL_STATUS="PASS"
    else
        EXTERNAL_STATUS="FAIL"
    fi

    if command_exists getent &&
       getent hosts github.com >/dev/null 2>&1; then
        DNS_STATUS="PASS"
    else
        DNS_STATUS="FAIL"
    fi
}

# ------------------------------------------------------------
# Collect key values before writing the report
# ------------------------------------------------------------

get_default_route_details
get_primary_ipv4
collect_summary_counts
perform_connectivity_tests

# ------------------------------------------------------------
# Generate report
# ------------------------------------------------------------

{
    write_section "Linux Network Audit Report"

    write_item "Generated" "$(date)"
    write_item "Hostname" "$(hostname 2>/dev/null || printf 'Unknown')"
    write_item "Executed by" "$(whoami 2>/dev/null || printf 'Unknown')"
    write_item "Report file" "${REPORT_FILE}"
    printf '\n'

    write_section "Executive Summary"

    write_item "Primary IPv4" "${PRIMARY_IPV4}"
    write_item "Default gateway" "${DEFAULT_GATEWAY}"
    write_item "Default interface" "${DEFAULT_INTERFACE}"
    write_item "Active interfaces" "${ACTIVE_INTERFACE_COUNT}"
    write_item "Listening TCP ports" "${LISTENING_TCP_COUNT}"
    write_item "Listening UDP ports" "${LISTENING_UDP_COUNT}"
    write_item "Loopback test" "${LOOPBACK_STATUS}"
    write_item "Gateway test" "${GATEWAY_STATUS}"
    write_item "External IP test" "${EXTERNAL_STATUS}"
    write_item "DNS resolution test" "${DNS_STATUS}"
    printf '\n'

    write_section "System Information"

    write_item "Operating system" "$(get_operating_system)"
    write_item "Kernel version" "$(uname -r)"
    write_item "Architecture" "$(uname -m)"

    if command_exists hostnamectl; then
        write_subsection "Hostname Details"
        run_command "hostnamectl" hostnamectl
    else
        write_warning "hostnamectl is not installed."
    fi

    printf '\n'
    write_section "Network Interfaces"

    if command_exists ip; then
        write_subsection "Interface Summary"
        run_command "ip link" ip -brief link

        write_subsection "Detailed Interface Information"
        run_command "ip link details" ip -details link show
    else
        write_warning "The ip command is not installed."
    fi

    printf '\n'
    write_section "IP Address Information"

    if command_exists ip; then
        write_subsection "Address Summary"
        run_command "ip address summary" ip -brief address

        write_subsection "IPv4 Addresses"
        run_command "IPv4 address collection" ip -4 address show

        write_subsection "IPv6 Addresses"
        run_command "IPv6 address collection" ip -6 address show
    else
        write_warning "IP address information is unavailable."
    fi

    printf '\n'
    write_section "Routing Information"

    if command_exists ip; then
        write_subsection "IPv4 Routing Table"
        run_command "IPv4 routing table" ip -4 route show

        write_subsection "IPv6 Routing Table"
        run_command "IPv6 routing table" ip -6 route show

        write_subsection "Default Route Summary"
        write_item "Default gateway" "${DEFAULT_GATEWAY}"
        write_item "Outbound interface" "${DEFAULT_INTERFACE}"
    else
        write_warning "Routing information is unavailable."
    fi

    printf '\n'
    write_section "DNS Configuration"

    if command_exists resolvectl; then
        write_subsection "systemd-resolved Status"
        run_command "resolvectl status" resolvectl status
    elif [[ -r /etc/resolv.conf ]]; then
        write_subsection "/etc/resolv.conf"
        cat /etc/resolv.conf
    else
        write_warning "No readable DNS resolver configuration was found."
    fi

    if command_exists nmcli; then
        write_subsection "DNS Information from NetworkManager"
        nmcli --fields GENERAL.DEVICE,IP4.DNS,IP6.DNS device show 2>&1 ||
            write_warning "NetworkManager DNS information could not be collected."
    fi

    printf '\n'
    write_section "NetworkManager Status"

    if command_exists nmcli; then
        write_subsection "Device Status"
        run_command "NetworkManager device status" nmcli device status

        write_subsection "Active Connections"
        run_command "NetworkManager active connections" \
            nmcli connection show --active

        write_subsection "Configured Connection Profiles"
        run_command "NetworkManager connection profiles" \
            nmcli connection show
    else
        write_warning "nmcli is not installed."
    fi

    printf '\n'
    write_section "Listening Ports"

    if command_exists ss; then
        write_subsection "Listening TCP Ports"
        ss -lntp 2>&1 ||
            write_warning "Listening TCP ports could not be collected."

        write_subsection "Listening UDP Ports"
        ss -lnup 2>&1 ||
            write_warning "Listening UDP ports could not be collected."
    else
        write_warning "The ss command is not installed."
    fi

    printf '\n'
    write_section "Active Network Connections"

    if command_exists ss; then
        write_subsection "Established TCP Connections"

        if ! ss -nt state established 2>&1; then
            write_warning "Established TCP connections could not be collected."
        fi

        write_subsection "Socket Statistics"
        run_command "socket statistics" ss -s
    else
        write_warning "Active socket information is unavailable."
    fi

    printf '\n'
    write_section "Connectivity Tests"

    write_item "Loopback 127.0.0.1" "${LOOPBACK_STATUS}"
    write_item "Default gateway" "${GATEWAY_STATUS}"
    write_item "External IP 1.1.1.1" "${EXTERNAL_STATUS}"
    write_item "DNS lookup github.com" "${DNS_STATUS}"

    printf '\n'
    write_section "Diagnostic Interpretation"

    if [[ "${LOOPBACK_STATUS}" == "PASS" ]]; then
        write_success "The local TCP/IP stack responded successfully."
    else
        write_warning "The local loopback test failed."
    fi

    if [[ "${GATEWAY_STATUS}" == "PASS" ]]; then
        write_success "The configured default gateway is reachable."
    else
        write_warning "The default gateway was not detected or did not respond."
    fi

    if [[ "${EXTERNAL_STATUS}" == "PASS" ]]; then
        write_success "External IP connectivity is working."
    else
        write_warning "External IP connectivity could not be confirmed."
    fi

    if [[ "${DNS_STATUS}" == "PASS" ]]; then
        write_success "DNS name resolution is working."
    else
        write_warning "DNS name resolution could not be confirmed."
    fi

    printf '\n'
    write_section "End of Report"

    printf 'Network audit completed successfully.\n'

} > "${REPORT_FILE}"

printf 'Network audit report created:\n'
printf '%s\n' "${REPORT_FILE}"