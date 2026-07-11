# Design Document

## Project Name

Linux Scheduled Task Automation

## Purpose

The purpose of this project is to create a reusable Bash automation solution that performs scheduled Linux system maintenance and generates a structured maintenance report.

The project demonstrates practical Linux automation using cron and Bash while providing administrators with a repeatable method of collecting maintenance information.

The completed solution combines Bash scripting, scheduled execution, logging, package management, service monitoring, and professional report generation.

## Objectives

The project objectives are to:

* Automate routine Linux maintenance.
* Generate timestamped maintenance reports.
* Review failed services.
* Review package updates.
* Review filesystem usage.
* Review recent system errors.
* Review system uptime.
* Produce maintenance recommendations.
* Operate safely without modifying the operating system.
* Demonstrate scheduled task automation using cron.

## Design Goals

The solution is designed to be:

* Modular
* Readable
* Professionally documented
* Safe to execute
* Read-only
* Suitable for scheduled execution
* Suitable for portfolio demonstration
* Compatible with Rocky Linux 9
* Easy to maintain and extend

## Target Platform

The project targets Rocky Linux 9.

Development is performed using Visual Studio Code on Windows.

Testing and execution are performed on a Rocky Linux virtual machine.

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
Scheduled execution
        ↓
Maintenance report
```

## Project Structure

```text
linux-scheduled-task-automation/
├── assets/
├── config/
├── documentation/
├── reports/
├── screenshots/
├── scripts/
│   └── maintenance.sh
├── .gitignore
└── README.md
```

## Input

The script requires no user interaction.

It gathers maintenance information directly from the local system.

## Output

Reports are stored inside:

```text
reports/
```

using timestamped filenames.

Generated reports are ignored using `.gitignore`, while a representative sample report is retained for portfolio purposes.

## Report Structure

The generated report contains:

1. Executive Summary
2. System Information
3. Uptime
4. Filesystem Usage
5. Failed Services
6. Package Updates
7. Recent System Errors
8. Maintenance Recommendations
9. Overall Assessment

## Core Commands

The project uses standard Linux administration commands including:

* uptime
* df
* systemctl
* dnf
* journalctl
* hostnamectl
* date
* whoami
* awk
* grep

## Error Handling

The script continues execution even when individual maintenance commands fail.

Expected failures are recorded within the report while allowing remaining maintenance checks to complete.

## Safety

The project performs only read-only maintenance checks.

It does not:

* Install updates
* Remove packages
* Restart services
* Delete files
* Modify configuration

## Design Decisions

Key design decisions include:

* Read-only execution
* Timestamped reports
* Structured report sections
* Defensive error handling
* Reusable helper functions
* Professional report formatting

## Limitations

The project reports system maintenance status only.

It does not automatically repair detected issues or install available updates.

## Future Improvements

Possible future enhancements include:

* Email notifications
* HTML reports
* JSON export
* Automatic update scheduling
* Historical report comparison
* System health scoring

## Summary

The Linux Scheduled Task Automation project demonstrates practical Linux automation, Bash scripting, routine maintenance reporting, defensive programming, and professional software development practices.
