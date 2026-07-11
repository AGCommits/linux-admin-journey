# Design Document

## Project Name

Linux Security Audit

## Purpose

The purpose of this project is to create a reusable Bash script that performs a structured security audit of a Rocky Linux system.

The script collects information relating to users, authentication, permissions, services, firewall configuration, SELinux, software updates, and system security before producing a professional, timestamped report.

The project demonstrates practical Linux security administration, Bash scripting, defensive programming, structured reporting, and Git-based software development.

## Objectives

The project objectives are to:

* Identify basic system information.
* Review logged-in users.
* Review user account security.
* Review sudo configuration.
* Inspect password policy.
* Review SSH configuration.
* Review firewall status.
* Review SELinux configuration.
* Review failed services.
* Review package update status.
* Review recent authentication activity.
* Review recent security-related log entries.
* Produce a structured executive summary.
* Generate a timestamped report.
* Continue running when individual commands fail.

## Design Goals

The script is designed to be:

* Readable
* Modular
* Professionally documented
* Safe to execute
* Read-only
* Suitable for troubleshooting
* Suitable for portfolio demonstration
* Compatible with Rocky Linux 9
* Resilient when some information cannot be collected

## Target Platform

The primary target platform is Rocky Linux 9.

Development is performed in Visual Studio Code on Windows.

Testing is performed on a Rocky Linux virtual machine using Git and GitHub for synchronisation.

## Development Workflow

```text
Visual Studio Code
        ↓
Bash syntax validation
        ↓
Git commit
        ↓
GitHub
        ↓
Rocky Linux
        ↓
Real execution
        ↓
Representative sample report
```

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
```

## Input

The script requires no user input.

It inspects the local Linux system and gathers security-related information using standard administration commands.

## Output

Reports are stored inside:

```text
reports/
```

using timestamped filenames.

A single representative report is retained within the repository while generated reports are ignored using `.gitignore`.

## Report Structure

The report contains:

1. Executive Summary
2. System Information
3. User Security
4. Authentication
5. SSH Configuration
6. Firewall Status
7. SELinux Status
8. Services
9. Package Updates
10. Security Logs
11. Audit Assessment
12. Recommendations

## Core Commands

The project makes use of standard Linux administration commands including:

* id
* who
* last
* lastb
* passwd
* chage
* grep
* awk
* systemctl
* firewall-cmd
* sestatus
* getenforce
* dnf
* journalctl
* hostnamectl

## Error Handling

The script does not terminate when non-critical commands fail.

Missing commands, unavailable services, or restricted information are handled gracefully while allowing the audit to continue.

## Safety

The project performs only diagnostic operations.

It does not:

* Modify users
* Change passwords
* Restart services
* Change firewall rules
* Change SELinux configuration
* Install updates
* Remove software

## Design Decisions

Key design decisions include:

* Read-only execution.
* Timestamped reports.
* Structured report sections.
* Reusable helper functions.
* Defensive error handling.
* Executive summary before detailed evidence.

## Limitations

The project reports the current system state only.

It does not perform vulnerability scanning, penetration testing, malware detection, or automated remediation.

## Future Improvements

Potential future improvements include:

* CIS benchmark comparisons.
* JSON report output.
* Security scoring.
* Email notifications.
* Historical audit comparison.
* Compliance reporting.

## Summary

The Linux Security Audit project provides a structured and reusable method of collecting security information from a Rocky Linux system while demonstrating practical Linux administration, Bash scripting, and professional reporting.
