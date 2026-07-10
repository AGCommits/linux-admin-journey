# Linux Security Hardening and Auditing

## Overview

This project provides a read-only Bash security auditing tool for Rocky Linux systems.

The script collects and analyses important security information, including user accounts, administrative access, password policies, SSH configuration, firewall status, SELinux status, failed login activity, risky file permissions, privileged files, active services, and critical system-file permissions.

The project is designed to demonstrate practical Linux security administration, Bash scripting, troubleshooting, reporting, and Git-based development.

## Objectives

The objectives of this project are to:

- Review local user accounts and login shells.
- Identify UID 0 accounts.
- Identify sudo-capable users and groups.
- Review password-age and authentication policy.
- Audit SSH service and configuration.
- Verify firewall status.
- Verify SELinux status and enforcement mode.
- Review failed login activity.
- Identify world-writable files and directories.
- Identify SUID and SGID files.
- Check permissions on critical security files.
- Review enabled and failed services.
- Produce a structured security assessment.
- Generate a timestamped audit report.
- Provide practical recommendations without modifying the system.

## Safety

The audit is read-only.

It does not:

- Change passwords.
- Modify SSH configuration.
- Add or remove users.
- Change firewall rules.
- Change SELinux mode.
- Modify permissions.
- Disable services.
- Install or remove packages.

## Core Tools

The project uses:

- `awk`
- `grep`
- `find`
- `stat`
- `getent`
- `lastb`
- `systemctl`
- `firewall-cmd`
- `getenforce`
- `sestatus`
- `sshd`
- `sudo`
- Bash functions and conditional logic
- Git and GitHub

## Project Structure

```text
linux-security-audit/
├── assets/
├── config/
├── documentation/
├── reports/
├── screenshots/
├── scripts/
│   └── security-audit.sh
├── .gitignore
└── README.md