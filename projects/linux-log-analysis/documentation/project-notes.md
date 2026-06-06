# Linux Log Analysis Project

## Project Overview

This project was created to develop practical Linux System Administration skills using Rocky Linux.

The project focuses on:

* Linux log analysis
* Bash scripting
* Service investigation
* System monitoring
* Report generation
* Troubleshooting
* Documentation and handoff preparation

---

## Project Structure

```text
linux-log-analysis/
├── documentation
│   └── project-notes.md
├── reports
│   ├── log-report-*.txt
│   └── service-failure-investigation.md
├── scripts
│   └── log-analyzer.sh
└── README.md
```

---

# Exercise 1 - Basic Log Analysis

## Objective

Learn how Linux stores and displays system logs.

## Commands Used

```bash
journalctl
journalctl -n 20
journalctl -b
journalctl --list-boots
last
lastb
```

## Skills Learned

* Reading system logs
* Viewing boot history
* Reviewing login activity
* Reviewing failed login attempts

---

# Exercise 2 - Building the Initial Script

## Objective

Create a reusable Bash script to automate log collection.

## Skills Learned

* Script creation
* Executable permissions
* Bash fundamentals

---

# Exercise 3 - Variables

## Objective

Learn how to store command output in variables.

## Example

```bash
REPORT_DATE=$(date +"%Y-%m-%d_%H-%M")
```

---

# Exercise 4 - Relative Paths

## Objective

Understand how Linux resolves file paths.

## Skills Learned

* Relative paths
* Directory navigation
* Script execution contexts

---

# Exercise 5 - Automated Report Generation

## Objective

Automatically generate timestamped reports.

## Skills Learned

* Output redirection
* Report generation
* Automation

---

# Exercise 6 - System Health Checks

## Commands Added

```bash
uptime
free -h
df -h
systemctl --failed
```

## Skills Learned

* Resource monitoring
* Capacity review
* Service health checks

---

# Exercise 7 - Failed Service Investigation

## Services Investigated

```text
mcelog.service
vboxadd.service
vboxadd-service.service
```

## Findings

The failures were primarily related to the VirtualBox environment rather than Rocky Linux itself.

---

# Exercise 8 - CPU Information

## Command Added

```bash
lscpu
```

## Skills Learned

* Hardware inventory
* Architecture review
* Virtualization awareness

---

# Exercise 9 - Documentation Improvements

## Changes Made

* Added project notes
* Added investigation notes
* Added portfolio notes
* Added interview talking points

---

# Exercise 10 - Script Cleanup and Handoff Comments

## Changes Made

* Added section comments
* Removed duplicate sections
* Standardised formatting

---

# Exercise 11 - Executive Summary Section

## Changes Made

The report now includes:

* Failed service count
* Logged-in user count
* Failed login count

---

# Exercise 12 - Script Error Handling

## Changes Made

Added command validation:

```bash
if command -v lscpu >/dev/null 2>&1
```

---

# Exercise 13 - Configuration Section

## Configuration Values

```bash
MAX_RECENT_LOGINS=5
MAX_FAILED_LOGINS=10
MAX_ERRORS=20
MAX_SSH_LINES=20
MAX_PROCESSES=10
```

---

# Exercise 14 - Warning Logic

## Warnings Added

* Failed services detected
* Failed login records detected

---

# Exercise 15 - Portable Script Paths

## Changes Made

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

REPORT_FILE="$PROJECT_DIR/reports/log-report-$REPORT_DATE.txt"
```

## Handoff Notes

Scripts should not depend on the user's current working directory.

---

# Milestone 1 Complete

The project now includes:

* Automated report generation
* Executive summary
* Login analysis
* Failed login analysis
* Error collection
* SSH activity review
* Service failure investigation
* CPU information
* Network information
* User activity
* Memory monitoring
* Disk monitoring
* Portable paths
* Error handling
* Documentation

---

# Portfolio Value

This project demonstrates:

* Linux administration
* Bash scripting
* Troubleshooting
* System monitoring
* Service investigation
* Documentation
* Report generation
* Handoff preparation

---

# Interview Talking Points

* Created a Bash script to automate Linux system reporting.
* Used journalctl, last, lastb, systemctl, grep, free, df, uptime, ip, ps, and lscpu.
* Investigated failed services and VirtualBox-related issues.
* Implemented configuration variables and portable paths.
* Added documentation and handoff-focused comments.

---

# Current Status

Project Status: Complete (Version 1.0)

Next Planned Activity:

Package the project into the GitHub portfolio repository and continue with the Backup Automation Script project.
