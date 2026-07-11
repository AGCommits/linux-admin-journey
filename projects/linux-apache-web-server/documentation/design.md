# Design Document

## Project Name

Linux Apache Web Server

## Purpose

The purpose of this project is to create a reusable Bash solution for deploying, validating, and auditing an Apache HTTP Server installation on Rocky Linux.

The project demonstrates practical Linux web server administration, Apache configuration, Bash scripting, service management, firewall administration, structured reporting, and Git-based software development.

## Objectives

The project objectives are to:

* Deploy Apache HTTP Server.
* Configure a custom virtual host.
* Deploy a simple demonstration website.
* Validate Apache configuration.
* Review Apache service status.
* Review listening ports.
* Review virtual host configuration.
* Review website accessibility.
* Review firewall configuration.
* Generate a structured audit report.
* Produce deployment and audit scripts.
* Demonstrate safe Linux administration practices.

## Design Goals

The project is designed to be:

* Modular
* Readable
* Professionally documented
* Safe to execute
* Repeatable
* Suitable for troubleshooting
* Suitable for portfolio demonstration
* Compatible with Rocky Linux 9

## Target Platform

The project targets Rocky Linux 9.

Development is completed in Visual Studio Code on Windows.

Testing and validation are performed on a Rocky Linux virtual machine.

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
Apache deployment
        ↓
Apache audit report
```

## Project Structure

```text
linux-apache-web-server/
├── assets/
├── config/
├── documentation/
├── reports/
├── screenshots/
├── scripts/
│   ├── apache-deploy.sh
│   └── apache-audit.sh
├── site/
├── .gitignore
└── README.md
```

## Input

The deployment and audit scripts require no interactive user input.

They inspect and validate the local Apache installation.

## Output

Deployment produces a configured Apache web server.

Audit reports are written to:

```text
reports/
```

using timestamped filenames.

Generated reports are ignored through `.gitignore`, while one representative sample report is retained.

## Report Structure

The generated audit report contains:

1. Executive Summary
2. System Information
3. Apache Installation
4. Service Status
5. Virtual Host Configuration
6. Website Files
7. Listening Ports
8. Firewall Status
9. HTTP Validation
10. Recommendations
11. Overall Assessment

## Core Commands

The project uses standard Linux administration commands including:

* httpd
* apachectl
* systemctl
* ss
* firewall-cmd
* curl
* hostnamectl
* rpm
* grep
* awk

## Error Handling

The scripts continue execution where appropriate and record meaningful information when optional components are unavailable.

## Safety

The audit script is read-only.

The deployment script performs only the configuration required for this project and avoids unnecessary system changes.

## Design Decisions

Key design decisions include:

* Separate deployment and audit scripts.
* Timestamped audit reports.
* Structured reporting.
* Reusable helper functions.
* Defensive error handling.
* Simple demonstration website.

## Limitations

The project focuses on Apache administration.

It does not include HTTPS, reverse proxy configuration, load balancing, or PHP application deployment.

## Future Improvements

Possible future enhancements include:

* HTTPS using Let's Encrypt.
* Multiple virtual hosts.
* Reverse proxy configuration.
* Performance tuning.
* Automated certificate renewal.
* JSON audit reports.

## Summary

The Linux Apache Web Server project demonstrates practical Linux web server deployment, Apache administration, Bash scripting, structured auditing, and professional documentation.
