# Project Review

## Overview

The Linux Apache Web Server project successfully achieved its primary objective of creating a reusable Bash-based deployment and auditing solution for Apache HTTP Server on Rocky Linux.

The completed solution automates Apache deployment, validates the installation, and generates a structured audit report suitable for routine administration and troubleshooting.

The project demonstrates practical Linux web server administration, Apache configuration, Bash scripting, structured reporting, and professional software development practices.

---

# Objectives Achieved

The project successfully achieved the following objectives:

* Developed a reusable Apache deployment script.
* Developed a reusable Apache audit script.
* Installed Apache HTTP Server.
* Configured a demonstration website.
* Configured a Virtual Host.
* Validated Apache configuration.
* Verified Apache service status.
* Verified listening ports.
* Reviewed firewall configuration.
* Verified HTTP connectivity.
* Generated timestamped audit reports.
* Completed testing on Rocky Linux.
* Integrated the project into Git and GitHub.

---

# Strengths

## Readability

Both scripts are organised into clearly defined sections using reusable helper functions and consistent formatting.

This structure improves readability and simplifies future maintenance.

---

## Separation of Responsibilities

The deployment and audit tasks are intentionally separated.

This allows administrators to validate existing Apache installations without making configuration changes.

---

## Safety

The deployment script performs only the configuration required for the project.

The audit script is entirely read-only.

This separation makes the audit script suitable for repeated execution on production systems.

---

## Report Structure

The audit report progresses logically from an executive summary through detailed Apache configuration and validation before presenting recommendations and an overall assessment.

This structure supports both quick reviews and detailed troubleshooting.

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

* Configuring Apache consistently.
* Validating Virtual Host configuration.
* Verifying firewall configuration.
* Producing structured audit reports.
* Managing cross-platform development between Windows and Rocky Linux.
* Maintaining a clean Git history throughout development.

Resolving these challenges strengthened both Linux administration and software development skills.

---

# Skills Developed

This project improved practical experience with:

* Apache HTTP Server
* Virtual Hosts
* Linux service administration
* Firewall administration
* HTTP validation
* Bash scripting
* Structured reporting
* Git
* GitHub
* Rocky Linux administration

---

# Future Enhancements

Potential future improvements include:

* HTTPS using Let's Encrypt.
* Multiple Virtual Hosts.
* Reverse proxy configuration.
* Performance optimisation.
* Automated certificate renewal.
* JSON report generation.
* HTML reporting.
* Apache performance monitoring.

---

# Overall Assessment

The Linux Apache Web Server project successfully delivers a practical and reusable Apache deployment and auditing solution.

The project demonstrates Bash scripting, Linux web server administration, structured validation, defensive programming, Git-based development, and real-world testing on Rocky Linux.

It provides a strong portfolio example for Linux Systems Administration, Infrastructure, and Platform Engineering roles while establishing a solid foundation for more advanced web server administration projects.
