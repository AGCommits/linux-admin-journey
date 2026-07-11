# Project Notes

## Purpose

The purpose of this project was to develop a reusable Bash solution for deploying, validating, and auditing an Apache HTTP Server installation on Rocky Linux.

The project combines Apache web server administration, Linux service management, firewall configuration, Bash scripting, and structured report generation into a practical administration exercise.

The completed solution demonstrates the deployment of a functioning web server together with an automated auditing tool capable of validating the installation.

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Apache HTTP Server administration
* Bash scripting
* Linux service management
* Virtual Host configuration
* Website deployment
* Firewall administration
* HTTP validation
* Network port verification
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

Windows was used for editing and version control, while Rocky Linux was used for deployment, validation, and testing.

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
Apache deployment
        ↓
Apache validation
        ↓
Audit report generation
```

This workflow reflects a professional development process by separating development from testing.

---

## Project Components

The project contains two primary scripts:

### Apache Deployment Script

Responsible for:

* Installing Apache (if required)
* Deploying the demonstration website
* Configuring the Virtual Host
* Enabling the Apache service
* Validating configuration
* Starting Apache

### Apache Audit Script

Responsible for reviewing:

* Apache installation
* Apache version
* Service status
* Virtual Host configuration
* Website files
* Listening ports
* Firewall configuration
* HTTP connectivity
* Apache logs
* Overall deployment status

---

## Report Structure

The generated audit report includes:

1. Executive Summary
2. System Information
3. Apache Installation
4. Apache Service Status
5. Virtual Host Configuration
6. Website Files
7. Listening Ports
8. Firewall Status
9. HTTP Validation
10. Apache Logs
11. Recommendations
12. Overall Assessment

---

## Linux Commands Used

The project makes use of standard Linux administration commands including:

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

These commands are commonly used when deploying and maintaining Apache web servers.

---

## Deployment

The deployment script prepares the Apache environment by:

* Validating Apache installation
* Creating required directories
* Deploying the website
* Installing the Virtual Host configuration
* Reloading Apache
* Verifying successful startup

The deployment process is designed to be repeatable and straightforward.

---

## Validation

The audit script verifies that:

* Apache is installed
* The service is active
* The configuration is valid
* The Virtual Host exists
* Website files are present
* Apache is listening on the expected ports
* HTTP requests succeed
* Firewall configuration supports HTTP access

---

## Error Handling

The project was designed to continue execution where possible.

Examples include:

* Missing Virtual Host
* Empty Apache logs
* Missing firewall configuration
* Apache not running

Rather than terminating execution, the script records findings and continues gathering information.

---

## Safety

The deployment script performs only the configuration required for this project.

The audit script is entirely read-only.

Neither script performs unnecessary modifications to the operating system.

---

## Testing Summary

Testing included:

* Bash syntax validation
* Apache deployment
* Apache configuration validation
* Website accessibility testing
* Firewall verification
* Audit report generation
* GitHub synchronisation
* Rocky Linux execution

---

## Outcome

The completed project provides a practical Apache deployment and auditing solution suitable for Linux Systems Administration portfolios.

The project strengthened practical understanding of Apache administration, Bash scripting, Linux services, firewall configuration, structured reporting, and professional software development workflows.
