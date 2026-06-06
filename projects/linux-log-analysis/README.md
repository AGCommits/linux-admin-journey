# Linux Log Analysis

## Overview

This project demonstrates Linux log analysis, Bash scripting, troubleshooting, and automated report generation using Rocky Linux.

The goal of the project was to create a reusable administration tool capable of collecting system information and generating timestamped reports for operational review.

---

## Features

* Recent login analysis
* Failed login analysis
* System error collection
* SSH activity review
* Service failure investigation
* CPU information reporting
* Network information reporting
* Memory usage reporting
* Disk usage reporting
* Top memory-consuming processes
* Executive summary section
* Automated timestamped report generation

---

## Technologies Used

* Rocky Linux 9
* Bash
* systemd
* journalctl
* VirtualBox
* Git
* GitHub

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

## Example Commands

Run the reporting script:

```bash
./scripts/log-analyzer.sh
```

View generated reports:

```bash
ls reports
```

Review failed services:

```bash
systemctl --failed
```

---

## Skills Demonstrated

* Linux Administration
* Bash Scripting
* Troubleshooting
* Log Analysis
* Service Investigation
* System Monitoring
* Documentation
* Handoff Preparation

---

## Key Learning Outcomes

* Working with Linux log files
* Investigating failed services
* Building maintainable Bash scripts
* Creating automated reports
* Writing handoff-quality documentation
* Managing projects using Git and GitHub

---

## Author

Ash

Linux System Administration Portfolio Project
