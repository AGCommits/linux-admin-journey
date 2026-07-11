# Interview Notes

## Project Summary

The Linux Security Audit project is a Bash-based security auditing tool developed for Rocky Linux.

Its purpose is to assess the security posture of a Linux system by collecting information relating to user accounts, authentication, SSH configuration, firewall status, SELinux, file permissions, services, package updates, and recent security events.

The script generates a structured, timestamped report that assists with routine security reviews and troubleshooting.

The project was developed using Visual Studio Code on Windows, version controlled with Git and GitHub, and validated on a Rocky Linux virtual machine.

---

# Why I Built This Project

I wanted to strengthen my practical Linux security administration skills by developing a reusable auditing tool.

The project also allowed me to combine knowledge gained from earlier Linux administration projects into a single security-focused script.

---

# What the Project Does

The script automatically reviews:

* System information
* Local user accounts
* Administrative access
* Password policies
* SSH configuration
* Firewall status
* SELinux status
* Failed login activity
* Critical file permissions
* World-writable files
* World-writable directories
* SUID and SGID files
* Failed services
* Listening services
* Recent authentication logs

It then generates recommendations and an overall security assessment.

---

# Linux Commands Used

During development I gained practical experience using commands including:

* `id`
* `who`
* `last`
* `lastb`
* `passwd`
* `chage`
* `systemctl`
* `firewall-cmd`
* `getenforce`
* `sestatus`
* `journalctl`
* `find`
* `awk`
* `grep`

These are commonly used during Linux security administration and auditing.

---

# Design Decisions

Several important design decisions were made during development:

* Keep the script read-only.
* Continue running if individual checks fail.
* Produce a structured report rather than console output.
* Use reusable helper functions.
* Generate timestamped reports.
* Preserve one representative report while ignoring generated reports with `.gitignore`.

---

# Challenges

Some challenges encountered included:

* Handling permission-restricted files.
* Auditing systems with missing services.
* Designing readable report formatting.
* Managing Git synchronisation between Windows and Rocky Linux.
* Producing meaningful recommendations without modifying the system.

---

# What I Learned

This project improved my understanding of:

* Linux security administration
* Authentication
* Privileged access
* SSH hardening
* firewalld
* SELinux
* File permissions
* Security auditing
* Defensive Bash scripting
* Professional documentation

---

# Possible Interview Questions

## Why did you build this project?

To improve my Linux security administration skills while creating a reusable auditing tool suitable for routine system reviews.

---

## Why is the script read-only?

A security audit should collect evidence without changing the system.

Keeping the script read-only makes it safe to execute on production systems.

---

## Why did you avoid using `set -e`?

Security auditing scripts should continue gathering information even if one individual command fails.

Stopping early could produce an incomplete audit.

---

## Why are SUID files reported?

SUID files are not automatically insecure, but they execute with elevated privileges.

Administrators should periodically review them to ensure each one is expected.

---

## How did you test the project?

Testing included:

* Bash syntax validation
* Rocky Linux execution
* Report verification
* Security finding review
* GitHub synchronisation
* Cross-platform validation

---

## What would you improve?

Possible future improvements include:

* CIS benchmark comparisons
* Compliance reporting
* JSON output
* HTML reports
* Security scoring
* Historical comparisons
* Automated scheduling

---

# Key Takeaway

This project demonstrates practical Linux security administration, Bash scripting, defensive programming, structured reporting, and professional Git-based development practices.
