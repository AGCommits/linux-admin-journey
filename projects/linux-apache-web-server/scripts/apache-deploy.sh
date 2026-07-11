#!/bin/bash

# ============================================================
# Project:
#   Linux Apache Web Server Administration
#
# Script:
#   apache-deploy.sh
#
# Description:
#   Installs and configures Apache on Rocky Linux, deploys a
#   portfolio website, configures a virtual host, enables the
#   HTTP firewall service, applies SELinux file contexts, and
#   verifies the completed deployment.
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
# - Installs Apache when required.
# - Creates a dedicated web root.
# - Deploys a custom website and virtual host.
# - Validates Apache configuration before restart.
# - Configures firewalld for HTTP traffic.
# - Applies SELinux-aware file contexts.
# - Creates backups before replacing managed files.
# - Performs local HTTP verification.
#
# ============================================================
#
# Safety
#
# This script changes the local Rocky Linux system.
#
# It:
# - Installs the httpd package when necessary.
# - Creates /var/www/linux-admin-site.
# - Creates /etc/httpd/conf.d/linux-admin-site.conf.
# - Adds linux-admin.local to /etc/hosts when absent.
# - Enables and starts httpd.
# - Enables the firewalld HTTP service when firewalld is active.
#
# Existing managed files are backed up before replacement.
# ============================================================

set -u
set -o pipefail

# ------------------------------------------------------------
# Project and deployment paths
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SOURCE_SITE_FILE="${PROJECT_ROOT}/site/index.html"
SOURCE_VHOST_FILE="${PROJECT_ROOT}/config/linux-admin-site.conf"

WEB_ROOT="/var/www/linux-admin-site"
DESTINATION_SITE_FILE="${WEB_ROOT}/index.html"
DESTINATION_VHOST_FILE="/etc/httpd/conf.d/linux-admin-site.conf"

LOCAL_HOSTNAME="linux-admin.local"
HOSTS_FILE="/etc/hosts"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"

# ------------------------------------------------------------
# Formatting functions
# ------------------------------------------------------------

write_section() {
    printf '\n%s\n' "============================================================"
    printf ' %s\n' "$1"
    printf '%s\n' "============================================================"
}

write_item() {
    printf '%-28s %s\n' "$1:" "$2"
}

write_success() {
    printf 'SUCCESS: %s\n' "$1"
}

write_warning() {
    printf 'WARNING: %s\n' "$1"
}

write_error() {
    printf 'ERROR: %s\n' "$1" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        write_error "Run this deployment script using sudo."
        exit 1
    fi
}

require_source_files() {
    if [[ ! -r "${SOURCE_SITE_FILE}" ]]; then
        write_error "Website source file not found: ${SOURCE_SITE_FILE}"
        exit 1
    fi

    if [[ ! -r "${SOURCE_VHOST_FILE}" ]]; then
        write_error "Virtual-host source file not found: ${SOURCE_VHOST_FILE}"
        exit 1
    fi
}

backup_file() {
    local target_file="$1"

    if [[ -f "${target_file}" ]]; then
        cp -a \
            "${target_file}" \
            "${target_file}.bak-${TIMESTAMP}"

        write_success "Backup created: ${target_file}.bak-${TIMESTAMP}"
    fi
}

install_apache() {
    write_section "Apache Package Installation"

    if rpm -q httpd >/dev/null 2>&1; then
        write_success "The httpd package is already installed."
        return
    fi

    if ! command_exists dnf; then
        write_error "dnf is unavailable."
        exit 1
    fi

    dnf install -y httpd

    if ! rpm -q httpd >/dev/null 2>&1; then
        write_error "The httpd package installation failed."
        exit 1
    fi

    write_success "The httpd package was installed."
}

deploy_website() {
    write_section "Website Deployment"

    mkdir -p "${WEB_ROOT}"

    backup_file "${DESTINATION_SITE_FILE}"

    install \
        -o root \
        -g root \
        -m 0644 \
        "${SOURCE_SITE_FILE}" \
        "${DESTINATION_SITE_FILE}"

    write_success "Website deployed to ${DESTINATION_SITE_FILE}."
}

deploy_virtual_host() {
    write_section "Virtual Host Deployment"

    backup_file "${DESTINATION_VHOST_FILE}"

    install \
        -o root \
        -g root \
        -m 0644 \
        "${SOURCE_VHOST_FILE}" \
        "${DESTINATION_VHOST_FILE}"

    write_success "Virtual host deployed to ${DESTINATION_VHOST_FILE}."
}

configure_local_hostname() {
    write_section "Local Hostname Configuration"

    if grep -Eq \
        "(^|[[:space:]])${LOCAL_HOSTNAME}([[:space:]]|$)" \
        "${HOSTS_FILE}"; then

        write_success "${LOCAL_HOSTNAME} already exists in ${HOSTS_FILE}."
        return
    fi

    printf '127.0.0.1 %s\n' "${LOCAL_HOSTNAME}" >> "${HOSTS_FILE}"

    write_success "${LOCAL_HOSTNAME} added to ${HOSTS_FILE}."
}

apply_selinux_contexts() {
    write_section "SELinux File Contexts"

    if ! command_exists restorecon; then
        write_warning "restorecon is unavailable."
        return
    fi

    restorecon -Rv "${WEB_ROOT}" "${DESTINATION_VHOST_FILE}"

    write_success "SELinux file contexts were restored."
}

validate_apache_configuration() {
    write_section "Apache Configuration Validation"

    if ! command_exists apachectl; then
        write_error "apachectl is unavailable."
        exit 1
    fi

    if ! apachectl configtest; then
        write_error "Apache configuration validation failed."
        exit 1
    fi

    write_success "Apache configuration syntax is valid."
}

configure_service() {
    write_section "Apache Service Management"

    systemctl enable httpd
    systemctl restart httpd

    if ! systemctl is-active --quiet httpd; then
        write_error "The httpd service is not active."
        systemctl status httpd --no-pager --lines=30
        exit 1
    fi

    write_success "The httpd service is active."
}

configure_firewall() {
    write_section "Firewall Configuration"

    if ! command_exists firewall-cmd; then
        write_warning "firewall-cmd is unavailable."
        return
    fi

    if ! firewall-cmd --state >/dev/null 2>&1; then
        write_warning "firewalld is not active."
        return
    fi

    if firewall-cmd --query-service=http >/dev/null 2>&1; then
        write_success "The HTTP firewall service is already enabled."
        return
    fi

    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload

    if firewall-cmd --query-service=http >/dev/null 2>&1; then
        write_success "The HTTP firewall service was enabled."
    else
        write_error "The HTTP firewall rule could not be confirmed."
        exit 1
    fi
}

verify_deployment() {
    write_section "Deployment Verification"

    write_item "Virtual hostname" "${LOCAL_HOSTNAME}"
    write_item "Document root" "${WEB_ROOT}"
    write_item "Virtual-host file" "${DESTINATION_VHOST_FILE}"

    if command_exists curl; then
        if curl \
            --fail \
            --silent \
            --show-error \
            --max-time 5 \
            "http://${LOCAL_HOSTNAME}/" \
            >/dev/null; then

            write_success "The website responded successfully over HTTP."
        else
            write_error "The website did not respond successfully."
            exit 1
        fi
    else
        write_warning "curl is unavailable; HTTP verification was skipped."
    fi

    if command_exists ss; then
        if ss -lnt |
            awk '$4 ~ /:80$/ {found=1} END {exit !found}'; then

            write_success "A service is listening on TCP port 80."
        else
            write_error "No listening service was detected on TCP port 80."
            exit 1
        fi
    fi
}

# ------------------------------------------------------------
# Deployment workflow
# ------------------------------------------------------------

require_root
require_source_files

write_section "Linux Apache Web Server Deployment"

write_item "Project root" "${PROJECT_ROOT}"
write_item "Target hostname" "${LOCAL_HOSTNAME}"
write_item "Target web root" "${WEB_ROOT}"

install_apache
deploy_website
deploy_virtual_host
configure_local_hostname
apply_selinux_contexts
validate_apache_configuration
configure_service
configure_firewall
verify_deployment

write_section "Deployment Complete"

printf 'Apache deployment completed successfully.\n'
printf 'Local website address:\n'
printf 'http://%s/\n' "${LOCAL_HOSTNAME}"