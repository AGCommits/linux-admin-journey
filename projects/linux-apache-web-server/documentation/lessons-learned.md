# Lessons Learned

## Overview

The Linux Apache Web Server project strengthened my understanding of Linux web server administration, Apache configuration, Bash scripting, and structured deployment procedures.

By developing both a deployment script and an audit script, I gained practical experience in configuring services while also validating that the deployment met expected standards.

---

# Apache Administration

This project improved my understanding of:

* Apache HTTP Server
* Virtual Hosts
* Website document roots
* Apache configuration validation
* Apache service management
* Apache logging
* HTTP connectivity
* Website deployment

I gained a better appreciation of how Apache components work together to deliver web content reliably.

---

# Linux Administration

The project provided practical experience using common Linux administration commands, including:

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

These commands are commonly used when deploying and maintaining Linux web servers.

---

# Bash Scripting

The project reinforced several important Bash scripting techniques, including:

* Creating reusable helper functions
* Organising large scripts into logical sections
* Defensive scripting
* Error handling
* Report generation
* Variable management
* Structured output formatting

These techniques improved both readability and long-term maintainability.

---

# Deployment and Validation

One of the most valuable lessons was separating deployment from validation.

Using one script to configure Apache and another to audit the completed installation makes troubleshooting simpler and follows good administrative practice.

---

# Error Handling

The project demonstrated the importance of continuing to collect information even when some components are unavailable.

Examples include:

* Missing Virtual Host configuration
* Empty Apache logs
* Firewall not configured
* Apache service stopped

Rather than terminating execution, the audit script records findings and continues gathering useful information.

---

# Firewall Administration

The project improved my understanding of how Apache interacts with Linux firewall configuration.

I learned how web server availability depends not only on Apache itself but also on allowing HTTP traffic through the firewall.

---

# Git Workflow

Developing the project across Windows and Rocky Linux strengthened my understanding of:

* Git commits
* GitHub synchronisation
* Rebasing
* Cross-platform development
* Version control best practices

This workflow closely mirrors professional software development practices.

---

# Documentation

Producing professional documentation alongside the code reinforced the importance of recording:

* Design decisions
* Testing procedures
* Recovery guidance
* Lessons learned
* Project reviews

Comprehensive documentation makes projects easier to maintain and explain during interviews.

---

# Future Improvements

Potential future improvements include:

* HTTPS configuration using Let's Encrypt
* Multiple Virtual Hosts
* Reverse proxy configuration
* Performance tuning
* Automated certificate renewal
* JSON report generation
* HTML deployment reports

---

# Summary

This project significantly improved my confidence in Linux web server administration, Apache configuration, Bash scripting, and structured deployment validation.

It also demonstrated the value of separating deployment from auditing while producing professional documentation and repeatable administration procedures.
