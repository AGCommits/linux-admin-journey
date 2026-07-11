# Lessons Learned

## Overview

The Linux System Health Dashboard project strengthened my understanding of Linux system monitoring, Bash scripting, and health reporting.

By combining multiple administration commands into a single dashboard, I gained practical experience in presenting system health information in a structured and meaningful way.

---

# Linux System Monitoring

This project improved my understanding of:

* CPU monitoring
* Memory monitoring
* Storage monitoring
* Service monitoring
* Process monitoring
* Network monitoring
* User activity
* System uptime
* Overall system health assessment

I gained a better understanding of how these areas combine to provide an overall view of a Linux system's operational health.

---

# Bash Scripting

The project reinforced several important Bash scripting techniques, including:

* Creating reusable helper functions
* Organising large scripts into logical sections
* Capturing command output
* Formatting structured reports
* Defensive scripting
* Error handling
* Variable management

These techniques improved both readability and maintainability.

---

# Linux Administration

The project provided practical experience using common Linux administration commands, including:

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

These commands are widely used by Linux Systems Administrators during routine monitoring and troubleshooting.

---

# Dashboard Design

One of the most valuable lessons was learning how to present technical information in a way that allows administrators to quickly assess system health.

Using an executive summary followed by detailed sections makes the report useful for both quick reviews and deeper investigations.

---

# Error Handling

The project demonstrated the importance of allowing monitoring scripts to continue running even when some commands cannot collect data.

Examples include:

* Missing services
* Empty process information
* Network configuration differences
* Restricted permissions

Recording these situations while continuing execution produces a more useful dashboard than terminating early.

---

# Read-Only Monitoring

Designing the dashboard as a read-only tool reinforced the importance of separating monitoring from system administration.

A monitoring dashboard should observe and report system health without making changes.

---

# Git Workflow

Developing the project across Windows and Rocky Linux strengthened my understanding of:

* Git commits
* GitHub synchronisation
* Rebasing
* Cross-platform development
* Version control best practices

This workflow closely reflects professional software development practices.

---

# Documentation

Producing professional documentation alongside the code reinforced the importance of recording:

* Design decisions
* Testing procedures
* Recovery guidance
* Lessons learned
* Project reviews

Good documentation improves maintainability and makes projects easier to explain during interviews.

---

# Future Improvements

Potential future improvements include:

* Historical health comparisons
* HTML dashboards
* JSON report output
* Email notifications
* Scheduled monitoring
* Integration with monitoring platforms
* Health scoring
* Optional command-line arguments

---

# Summary

This project significantly improved my confidence in Linux system monitoring, Bash scripting, structured reporting, and defensive programming.

It also demonstrated the importance of presenting technical health information in a clear, organised format suitable for routine administration and troubleshooting.
