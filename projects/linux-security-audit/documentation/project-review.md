# Project Review

## Overview

The Linux Security Audit project successfully achieved its primary objective of creating a reusable Bash-based security auditing tool for Rocky Linux.

The completed script gathers security-related information from multiple areas of the operating system, performs structured assessments, and generates a professional timestamped report suitable for routine security reviews and troubleshooting.

The project demonstrates practical Linux security administration, Bash scripting, defensive programming, structured reporting, and professional software development practices.

---

# Objectives Achieved

The project successfully achieved the following objectives:

* Developed a reusable Bash security auditing tool.
* Generated timestamped audit reports.
* Reviewed local user accounts.
* Identified administrative users and privileged access.
* Audited password policy configuration.
* Reviewed SSH security settings.
* Audited firewalld configuration.
* Reviewed SELinux status.
* Analysed failed login activity.
* Audited critical file permissions.
* Identified world-writable files.
* Identified world-writable directories.
* Identified SUID files.
* Identified SGID files.
* Reviewed failed services.
* Reviewed listening services.
* Reviewed recent authentication logs.
* Generated recommendations.
* Produced an overall security assessment.
* Integrated the project into Git and GitHub.

---

# Strengths

## Readability

The script is organised into clearly defined sections using reusable helper functions and consistent formatting.

This makes the code easier to maintain and extend.

---

## Defensive Design

The script continues executing even when individual audit commands fail.

This ensures that as much useful security information as possible is collected during every execution.

---

## Safety

The project performs only read-only operations.

No users, passwords, permissions, services, firewall rules or SELinux settings are modified.

This makes the script suitable for execution on production systems.

---

## Report Structure

The generated report progresses logically from an executive summary to detailed technical findings before presenting recommendations and an overall assessment.

This structure makes the report suitable for both quick reviews and more detailed investigations.

---

## Professional Workflow

Development followed a structured workflow using:

* Visual Studio Code
* Git
* GitHub
* Rocky Linux

Testing was performed on a real Rocky Linux virtual machine following Git synchronisation from the Windows development environment.

---

# Challenges

Several technical challenges were addressed during development, including:

* Handling permission-restricted files.
* Collecting information from optional services.
* Designing consistent report formatting.
* Managing cross-platform development between Windows and Rocky Linux.
* Maintaining a clean Git history throughout development.

Resolving these challenges strengthened both Linux administration and software development skills.

---

# Skills Developed

This project improved practical experience with:

* Linux security administration
* Bash scripting
* User and privilege auditing
* Password policies
* SSH configuration
* firewalld
* SELinux
* File permissions
* Authentication logging
* Systemd services
* Structured reporting
* Git
* GitHub
* Rocky Linux administration

---

# Future Enhancements

Potential future improvements include:

* CIS benchmark comparisons.
* Security scoring.
* Compliance reporting.
* JSON report generation.
* HTML reports.
* Historical audit comparison.
* Scheduled execution.
* Email notifications.
* Optional command-line arguments.
* Automated compliance checks.

---

# Overall Assessment

The Linux Security Audit project successfully delivers a practical and reusable Linux security auditing solution.

The project demonstrates professional Bash scripting, defensive programming, Linux security administration, structured documentation, Git-based development, and real-world testing on Rocky Linux.

It provides a strong portfolio example for Linux Systems Administration, Infrastructure, and Security-focused roles while establishing a solid foundation for more advanced security automation projects.
