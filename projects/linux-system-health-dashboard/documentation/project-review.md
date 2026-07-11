# Project Review

## Overview

The Linux System Health Dashboard project successfully achieved its primary objective of creating a reusable Bash-based monitoring solution for Rocky Linux.

The completed dashboard gathers information from multiple areas of the operating system and produces a structured, timestamped report that provides administrators with an overall assessment of system health.

The project demonstrates practical Linux monitoring, Bash scripting, defensive programming, structured reporting, and professional software development practices.

---

# Objectives Achieved

The project successfully achieved the following objectives:

* Developed a reusable Bash monitoring script.
* Generated timestamped health reports.
* Reviewed CPU utilisation.
* Reviewed memory utilisation.
* Reviewed storage utilisation.
* Reviewed system uptime.
* Reviewed failed services.
* Reviewed active users.
* Reviewed network status.
* Reviewed running processes.
* Generated health recommendations.
* Produced an overall health assessment.
* Completed testing on Rocky Linux.
* Integrated the project into Git and GitHub.

---

# Strengths

## Readability

The script is organised into clearly defined sections using reusable helper functions and consistent formatting.

This structure improves readability and simplifies future maintenance.

---

## Defensive Design

The dashboard continues executing even when individual monitoring commands encounter expected issues.

This ensures administrators receive a complete health report whenever possible.

---

## Safety

The project performs only read-only monitoring.

It does not restart services, terminate processes, install packages, modify users, or alter system configuration.

This makes the dashboard suitable for execution on production systems.

---

## Report Structure

The generated report progresses logically from an executive summary through detailed health information before presenting recommendations and an overall assessment.

This structure supports both rapid health checks and more detailed troubleshooting.

---

## Professional Workflow

Development followed a structured workflow using:

* Visual Studio Code
* Git
* GitHub
* Rocky Linux

Testing was completed on a Rocky Linux virtual machine following Git synchronisation from the Windows development environment.

---

# Challenges

Several technical challenges were addressed during development, including:

* Designing a concise but informative health dashboard.
* Handling differences between Linux environments.
* Producing consistent report formatting.
* Managing cross-platform development between Windows and Rocky Linux.
* Maintaining a clean Git history throughout development.

Resolving these challenges strengthened both Linux administration and software development skills.

---

# Skills Developed

This project improved practical experience with:

* Linux system monitoring
* CPU analysis
* Memory management
* Storage monitoring
* Process management
* Service administration
* Network monitoring
* Bash scripting
* Structured reporting
* Git
* GitHub
* Rocky Linux administration

---

# Future Enhancements

Potential future improvements include:

* HTML dashboard generation.
* JSON report output.
* Historical health comparison.
* Email notifications.
* Scheduled monitoring.
* Integration with enterprise monitoring platforms.
* Health scoring.
* Optional command-line arguments.

---

# Overall Assessment

The Linux System Health Dashboard project successfully delivers a practical and reusable Linux monitoring solution.

The project demonstrates Bash scripting, Linux system administration, structured monitoring, defensive programming, Git-based development, and real-world testing on Rocky Linux.

It provides a strong portfolio example for Linux Systems Administration, Infrastructure, Platform Engineering, and Operations roles while establishing a solid foundation for more advanced monitoring and observability projects.
