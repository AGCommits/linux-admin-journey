# Design Document

## Project Name

Linux System Health Dashboard

## Purpose

The purpose of this project is to create a reusable Bash-based system health dashboard that provides administrators with a consolidated overview of the operational state of a Rocky Linux system.

The project combines CPU, memory, storage, processes, services, networking, and uptime information into a structured health report suitable for routine monitoring and troubleshooting.

The project demonstrates practical Linux administration, Bash scripting, defensive programming, structured reporting, and professional software development practices.

## Objectives

The project objectives are to:

* Generate a system health dashboard.
* Display system information.
* Review CPU utilisation.
* Review memory utilisation.
* Review storage utilisation.
* Review system uptime.
* Review failed services.
* Review active users.
* Review network status.
* Review running processes.
* Generate a timestamped report.
* Produce a reusable monitoring solution.

## Design Goals

The project is designed to be:

* Readable
* Modular
* Professionally documented
* Safe to execute
* Read-only
* Suitable for routine monitoring
* Suitable for troubleshooting
* Suitable for portfolio demonstration
* Compatible with Rocky Linux 9

## Target Platform

The project targets Rocky Linux 9.

Development is completed in Visual Studio Code on Windows.

Testing is performed on a Rocky Linux virtual machine.

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
Dashboard execution
        ↓
Health report
```

## Project Structure

```text
linux-system-health-dashboard/
├── assets/
├── config/
├── documentation/
├── reports/
├── screenshots/
├── scripts/
│   └── system-health-dashboard.sh
├── .gitignore
└── README.md
```

## Input

The script requires no user interaction.

It gathers health information directly from the local system.

## Output

Reports are written to:

```text
reports/
```

using timestamped filenames.

Generated reports are ignored using `.gitignore`, while a representative report is retained within the repository.

## Report Structure

The report contains:

1. Executive Summary
2. System Information
3. CPU Status
4. Memory Status
5. Storage Status
6. Uptime
7. Failed Services
8. Active Users
9. Network Status
10. Running Processes
11. Health Assessment
12. Recommendations

## Core Commands

The project uses standard Linux administration commands including:

* uptime
* free
* df
* lscpu
* systemctl
* ps
* ip
* who
* hostnamectl
* awk
* grep

## Error Handling

The script continues executing when individual health checks fail.

Expected failures are recorded while allowing the remainder of the report to be generated.

## Safety

The project performs only read-only health checks.

It does not modify services, processes, packages, users, or configuration.

## Design Decisions

Key design decisions include:

* Read-only execution.
* Timestamped reports.
* Executive summary.
* Structured report sections.
* Reusable helper functions.
* Defensive error handling.

## Limitations

The project provides a point-in-time system health assessment.

It does not provide continuous monitoring or historical trend analysis.

## Future Improvements

Potential future improvements include:

* Historical comparisons.
* HTML dashboard.
* JSON output.
* Email notifications.
* Monitoring integration.
* Scheduled execution.

## Summary

The Linux System Health Dashboard project demonstrates practical Linux monitoring, Bash scripting, structured reporting, and professional administration practices.
