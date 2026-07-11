# Project Notes

## Purpose

The purpose of this project was to develop a reusable Bash-based system health dashboard capable of providing a consolidated overview of the operational status of a Rocky Linux system.

The project combines system monitoring, resource utilisation, service monitoring, process analysis, networking information, and report generation into a single reusable administration tool.

The completed solution demonstrates practical Linux monitoring while producing a structured health report suitable for routine administration and troubleshooting.

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Bash scripting
* Linux system monitoring
* CPU monitoring
* Memory monitoring
* Storage monitoring
* Process management
* Service monitoring
* Network monitoring
* Structured report generation
* Defensive scripting
* Git and GitHub workflow
* Rocky Linux administration

---

## Development Environment

The project was developed using:

* Visual Studio Code on Windows
* Git
* GitHub
* Rocky Linux 9 virtual machine
* Bash

Windows was used for development and version control, while Rocky Linux was used for execution and validation.

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
Dashboard execution
        ↓
Health report generation
```

This workflow reflects a professional Linux administration and software development process.

---

## Dashboard Purpose

The dashboard provides a snapshot of overall system health by reviewing:

* System information
* CPU utilisation
* Memory utilisation
* Storage utilisation
* System uptime
* Failed services
* Active users
* Network status
* Running processes

The collected information is written to a timestamped report for future reference.

---

## Report Structure

The generated report includes:

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

The report begins with a high-level overview before progressing into more detailed technical information.

---

## Linux Commands Used

The project makes use of standard Linux administration commands including:

* `uptime`
* `free`
* `df`
* `lscpu`
* `systemctl`
* `ps`
* `ip`
* `who`
* `hostnamectl`
* `awk`
* `grep`

These commands are commonly used by Linux Systems Administrators when assessing overall system health.

---

## Monitoring Approach

The project was designed to provide a point-in-time health assessment.

Rather than continuously monitoring the system, the dashboard captures the current operational state whenever it is executed.

---

## Error Handling

The project was designed to continue executing even if individual health checks fail.

Examples include:

* Missing services
* Empty process information
* Network interfaces unavailable
* Command permission restrictions

Rather than terminating execution, the dashboard records available information and continues processing the remaining health checks.

---

## Safety

The project performs only read-only health monitoring.

It does not:

* Restart services
* Kill processes
* Install packages
* Modify configuration
* Change users
* Alter permissions

This makes the project safe to execute repeatedly on production systems.

---

## Testing Summary

Testing included:

* Bash syntax validation
* Successful report generation
* CPU information review
* Memory monitoring
* Storage monitoring
* Failed service review
* Process monitoring
* GitHub synchronisation
* Rocky Linux execution after Git pull

---

## Outcome

The completed project provides a reusable Linux system health dashboard suitable for routine administration and troubleshooting.

The project strengthened practical understanding of Linux monitoring, Bash scripting, structured reporting, defensive programming, and professional software development practices.
