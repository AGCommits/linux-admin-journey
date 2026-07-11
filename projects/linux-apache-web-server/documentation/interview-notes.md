# Interview Notes

## Project Summary

The Linux Apache Web Server project is a Bash-based deployment and auditing solution developed for Rocky Linux.

Its purpose is to automate the deployment of an Apache HTTP Server, validate the installation, and generate a structured audit report suitable for routine administration and troubleshooting.

The project was developed using Visual Studio Code on Windows, version controlled with Git and GitHub, and validated on a Rocky Linux virtual machine.

---

# Why I Built This Project

I wanted to improve my practical Linux web server administration skills while developing a reusable deployment and auditing solution.

The project also provided practical experience with Apache configuration, Linux services, firewall administration, and Bash scripting.

---

# What the Project Does

The project consists of two scripts.

### Apache Deployment Script

The deployment script:

* Installs Apache if required.
* Configures the demonstration website.
* Deploys the Virtual Host configuration.
* Enables the Apache service.
* Starts Apache.
* Validates the Apache configuration.

### Apache Audit Script

The audit script reviews:

* Apache installation
* Apache version
* Service status
* Virtual Host configuration
* Website files
* Listening ports
* Firewall configuration
* HTTP accessibility
* Apache logs
* Overall deployment status

A timestamped audit report is generated for later review.

---

# Linux Commands Used

During development I gained practical experience using commands including:

* `httpd`
* `apachectl`
* `systemctl`
* `ss`
* `firewall-cmd`
* `curl`
* `rpm`
* `hostnamectl`
* `grep`
* `awk`

These commands are commonly used during Linux web server administration.

---

# Design Decisions

Several important design decisions were made during development:

* Separate deployment and auditing into different scripts.
* Keep the audit script read-only.
* Generate timestamped reports.
* Use reusable helper functions.
* Continue execution where possible if non-critical checks fail.
* Preserve one representative audit report while ignoring generated reports.

---

# Challenges

Some challenges encountered included:

* Deploying Apache consistently.
* Validating Virtual Host configuration.
* Handling systems where firewall configuration differed.
* Producing readable audit reports.
* Managing Git synchronisation between Windows and Rocky Linux.

---

# What I Learned

This project improved my understanding of:

* Apache administration
* Linux services
* Virtual Hosts
* HTTP validation
* Firewall administration
* Bash scripting
* Structured reporting
* Professional documentation

---

# Possible Interview Questions

## Why did you build this project?

To improve my Linux web server administration skills while developing a reusable deployment and auditing solution.

---

## Why separate deployment from auditing?

Keeping deployment and auditing separate makes troubleshooting easier and allows administrators to validate existing installations without making changes.

---

## Why is the audit script read-only?

A validation tool should collect information without modifying the operating system.

This makes it safe to execute repeatedly on production systems.

---

## How did you validate Apache?

I validated:

* Apache configuration using `apachectl configtest`
* Apache service status
* HTTP connectivity using `curl`
* Listening ports
* Firewall configuration
* Website accessibility

---

## How did you test the project?

Testing included:

* Bash syntax validation
* Apache deployment
* Configuration validation
* Website accessibility
* Audit report generation
* GitHub synchronisation
* Cross-platform validation

---

## What would you improve?

Possible future improvements include:

* HTTPS support
* Let's Encrypt certificates
* Reverse proxy configuration
* Performance tuning
* Multiple Virtual Hosts
* JSON reports
* HTML reporting

---

# Key Takeaway

This project demonstrates practical Linux web server administration, Apache deployment, Bash scripting, structured validation, defensive programming, and professional Git-based development practices.
