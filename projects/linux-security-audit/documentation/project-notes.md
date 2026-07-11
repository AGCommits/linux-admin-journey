# Project Notes

## Purpose

The purpose of this project was to develop a reusable Bash security auditing tool for Rocky Linux.

The script performs a structured, read-only review of important Linux security controls and produces a timestamped report containing findings, status checks, and practical recommendations.

The project builds on earlier Linux administration work by combining user management, service administration, permissions, logging, SSH, firewalld, SELinux, and Bash scripting in one security-focused tool.

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Linux security administration
* Bash scripting
* User and group auditing
* UID and privilege analysis
* Sudo configuration review
* Password-policy review
* SSH configuration auditing
* firewalld
* SELinux
* Failed-login analysis
* File-permission auditing
* SUID and SGID file discovery
* World-writable file discovery
* systemd service review
* Journal analysis
* Structured reporting
* Git and GitHub

---

## Development Environment

The project was developed using:

* Visual Studio Code on Windows
* Git Bash
* Git
* GitHub
* Rocky Linux 9 virtual machine
* Bash

Windows was used for editing and version control, while Rocky Linux was used for real execution and validation.

---

## Project Workflow

The project followed this workflow:

```text
Visual Studio Code
        ↓
Bash syntax validation
        ↓
Git commit and push
        ↓
GitHub
        ↓
Rocky Linux git pull
        ↓
Execution with sudo
        ↓
Report inspection
        ↓
Representative sample report
```

Running the script with `sudo` provided more complete access to protected files, authentication logs, SSH configuration, and security-related system information.

---

## Script Purpose

The script audits the local system without changing it.

It checks:

* Local user accounts
* Interactive login accounts
* UID 0 accounts
* Administrative group membership
* Sudo configuration
* Password policy
* PAM password quality settings
* Root password status
* SSH service and configuration
* Firewall status
* SELinux status
* Failed-login activity
* Critical file permissions
* World-writable files
* World-writable directories
* SUID files
* SGID files
* Failed services
* Enabled services
* Listening network services
* Recent authentication events

---

## Report Structure

The generated report includes:

1. Report Header
2. Executive Summary
3. System Information
4. Local User Accounts
5. Administrative Access
6. Password and Authentication Policy
7. SSH Security Review
8. Firewall Assessment
9. SELinux Assessment
10. Failed Login Activity
11. Critical File Permissions
12. World-Writable Files
13. World-Writable Directories
14. SUID Files
15. SGID Files
16. Service Security Review
17. Listening Network Services
18. Recent Security-Relevant Logs
19. Security Recommendations
20. Overall Security Assessment

---

## User Account Auditing

The script reads `/etc/passwd` to display:

* Username
* UID
* GID
* Home directory
* Login shell

It also separates interactive login accounts from service accounts and identifies all UID 0 accounts.

A normal Linux system should generally contain only one UID 0 account:

```text
root
```

Additional UID 0 accounts require investigation because they have unrestricted administrative privileges.

---

## Administrative Access

The project reviews:

* The `wheel` group
* Active entries in `/etc/sudoers`
* Files stored under `/etc/sudoers.d`

This provides visibility into which users or groups may perform privileged actions through `sudo`.

The script does not expose passwords or modify privilege configuration.

---

## Password Policy

The audit reviews settings from:

```text
/etc/login.defs
```

including:

* `PASS_MAX_DAYS`
* `PASS_MIN_DAYS`
* `PASS_WARN_AGE`
* `PASS_MIN_LEN`
* `ENCRYPT_METHOD`

It also checks:

```text
/etc/security/pwquality.conf
```

and displays root password status using:

```bash
passwd -S root
```

These checks provide an overview of password ageing and password-quality configuration.

---

## SSH Security Review

The project checks:

* Whether `sshd` is active
* `PermitRootLogin`
* `PasswordAuthentication`
* Effective SSH configuration where permissions allow

The script treats direct root login as a security concern when explicitly enabled.

It also identifies password authentication as an item for review because key-based authentication is generally preferable for administrative access.

---

## Firewall Assessment

The script uses:

```bash
firewall-cmd
```

to check whether firewalld is active.

When available, it reports:

* Active zones
* Default zone
* Current zone configuration
* Enabled services and ports

The script records a warning if firewalld is installed but inactive or unavailable.

---

## SELinux Assessment

The project checks SELinux using:

```bash
getenforce
sestatus
```

The preferred state is:

```text
Enforcing
```

Permissive or disabled modes are reported as warnings because they reduce mandatory access-control protection.

---

## Failed Login Analysis

The script uses:

```bash
lastb
```

to review recent failed login records from the system's `btmp` database.

The number of failed records is included in the executive summary and contributes to the final security assessment.

A small number of failures may require routine review, while repeated failures may indicate password guessing, misconfiguration, or unauthorised access attempts.

---

## Critical File Permissions

The script checks ownership and permissions for:

* `/etc/passwd`
* `/etc/shadow`
* `/etc/group`
* `/etc/gshadow`
* `/etc/sudoers`
* `/etc/ssh/sshd_config`

These files contain or control sensitive account, authentication, privilege, and SSH information.

Unexpected ownership or permissions should be investigated.

---

## World-Writable Files

The script searches the root filesystem for regular files writable by all users.

The search uses:

```bash
find / -xdev -type f -perm -0002
```

The `-xdev` option prevents the search from crossing into other mounted filesystems.

World-writable regular files may allow unauthorised users to modify data or executable content and therefore require review.

---

## World-Writable Directories

The project also identifies world-writable directories.

Some world-writable directories are legitimate, such as temporary directories, but they should normally have the sticky bit enabled.

The script records these directories as review items rather than automatically treating all of them as vulnerabilities.

---

## SUID and SGID Files

The script identifies files with:

```text
SUID
SGID
```

permissions.

These files are not automatically insecure. Many are required for normal system operation.

However, they execute with elevated user or group privileges and should be periodically reviewed to confirm that each file is expected.

---

## Service Review

The project reviews:

* Failed systemd services
* Enabled services
* Listening TCP and UDP services

Failed services may represent operational or security problems.

Enabled services and listening ports are useful for identifying unnecessary attack surface.

---

## Security-Relevant Logs

The script searches the system journal for recent events including:

* Authentication failures
* Failed passwords
* Accepted passwords
* Accepted public keys
* `sudo`
* `su`
* Session opening
* Session closing

This provides a focused overview of recent authentication and privilege activity.

---

## Security Scoring

The script maintains counters for:

* Passed checks
* Warnings
* Review items
* Failed checks

The final overall status may be:

```text
GOOD
REVIEW RECOMMENDED
NEEDS ATTENTION
CRITICAL
```

The score is intended as a simple administrative summary.

It is not a replacement for a formal compliance audit, vulnerability scanner, or penetration test.

---

## Safety

The script is read-only.

It does not:

* Change user accounts
* Reset passwords
* Modify groups
* Change sudo configuration
* Edit SSH configuration
* Change firewall rules
* Change SELinux mode
* Modify file permissions
* Enable or disable services
* Install or remove packages

This design makes it suitable for routine security assessment and troubleshooting.

---

## Error Handling

The script uses:

```bash
set -u
set -o pipefail
```

It deliberately avoids `set -e` because individual audit commands may fail due to permissions, missing packages, empty logs, or unavailable services.

Expected failures are handled explicitly so that the script can continue and produce the remainder of the report.

---

## Testing Summary

Testing included:

* Bash syntax validation
* Git commit and push
* Git pull on Rocky Linux
* Execution with elevated privileges
* Report-generation verification
* Review of security findings
* Verification of ignored timestamped reports
* Confirmation that the working tree remained clean

The script completed successfully on Rocky Linux.

---

## Outcome

The completed project provides a broad Linux security-auditing tool that combines multiple administration disciplines in one report.

It strengthened practical understanding of Linux security controls, privileged access, file permissions, authentication logs, firewalld, SELinux, systemd, and defensive Bash scripting.
