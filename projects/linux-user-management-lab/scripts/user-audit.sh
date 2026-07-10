#!/bin/bash

# ==================================================
# Linux User Management Lab - Audit Script
# ==================================================
# Purpose:
# This script verifies the user accounts, group
# memberships, department directory permissions,
# and project structure created during the Linux
# User Management Lab.
# ==================================================

echo "=========================================="
echo " Linux User Management Lab Audit"
echo "=========================================="
echo "Generated: $(date)"
echo "Hostname: $(hostname)"
echo "Executed by: $(whoami)"
echo ""

echo "=== User Group Membership ==="

for user in alice bob charlie; do
    if id "$user" &>/dev/null; then
        groups "$user"
    else
        echo "WARNING: User '$user' does not exist."
    fi
done

echo ""
echo "=== Department Directory Permissions ==="

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPARTMENTS_DIR="${PROJECT_ROOT}/departments"

if [[ -d "$DEPARTMENTS_DIR" ]]; then
    ls -ld "${DEPARTMENTS_DIR}"/*
else
    echo "WARNING: Department directory not found:"
    echo "$DEPARTMENTS_DIR"
fi

echo ""
echo "=== Project Structure ==="

if command -v tree &>/dev/null; then
    tree "$PROJECT_ROOT"
else
    echo "The 'tree' command is not installed."
    echo "Using 'find' as a fallback:"
    find "$PROJECT_ROOT" -maxdepth 3 -print
fi

echo ""
echo "Audit complete."
