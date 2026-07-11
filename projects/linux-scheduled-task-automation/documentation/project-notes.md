# Project Notes

## Purpose

The purpose of this project was to develop a reusable Bash automation solution capable of performing routine Linux system maintenance and generating structured maintenance reports.

The project demonstrates how repetitive administration tasks can be automated safely using Bash and scheduled execution while maintaining a read-only approach.

The completed solution combines system monitoring, package management, service administration, filesystem monitoring, logging, and report generation into a single automated maintenance task.

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Bash scripting
* Linux automation
* Cron scheduling
* Routine system maintenance
* Filesystem monitoring
* Package management
* Service monitoring
* Journal analysis
* Report generation
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

Windows was used for editing and version control, while Rocky Linux was used for execution and validation.

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
Script execution
        ↓
Maintenance report generation
```

The completed workflow closely mirrors professional Linux administration and DevOps practices.

---

## Script Purpose

The script performs a structured maintenance audit by reviewing:

* System information
* System uptime
* Filesystem usage
* Failed services
* Available package updates
* Recent system errors
* Maintenance recommendations

The collected information is written to a timestamped report for future reference.

---

## Report Structure

The generated report includes:

1. Executive Summary
2. System Information
3. Uptime Information
4. Filesystem Usage
5. Failed Services
6. Package Update Status
7. Recent System Errors
8. Maintenance Recommendations
9. Overall Maintenance Assessment

This structure allows administrators to begin with a high-level overview before examining more detailed maintenance information.

---

## Linux Commands Used

The project makes use of standard Linux administration commands including:

* `uptime`
* `df`
* `systemctl`
* `dnf`
* `journalctl`
* `hostnamectl`
* `date`
* `whoami`
* `awk`
* `grep`

These commands are commonly available on enterprise Linux distributions such as Rocky Linux.

---

## Automation

The project was designed to support scheduled execution using cron.

Because the script requires no user interaction, it can be executed automatically at regular intervals to generate maintenance reports without administrator intervention.

---

## Error Handling

The project was designed to continue executing even if individual maintenance commands fail.

Examples include:

* Repository unavailable
* No package updates
* Empty logs
* Missing services

Rather than terminating execution, the script records available information and continues processing the remaining maintenance checks.

---

## Safety

The project performs only read-only maintenance checks.

It does not:

* Install updates
* Remove packages
* Restart services
* Delete files
* Modify configuration
* Change permissions

This makes the project safe to execute repeatedly on production systems.

---

## Testing Summary

Testing was completed on Rocky Linux.

Validation included:

* Bash syntax checking
* Successful report generation
* Filesystem inspection
* Package update review
* Failed service review
* Journal inspection
* GitHub synchronisation
* Linux execution after Git pull

---

## Outcome

The completed project provides a reusable Linux maintenance solution suitable for scheduled execution and routine administration.

The project strengthened practical understanding of Linux automation, Bash scripting, cron scheduling, structured reporting, and professional software development practices.
