# Lessons Learned

## Overview

The Linux Security Audit project significantly improved my practical understanding of Linux security administration, Bash scripting, and defensive system auditing.

By combining several security-related administration tasks into a single automated report, I gained a better understanding of how different Linux security controls work together to protect a system.

---

# Linux Security

This project improved my understanding of:

* User account security
* Privileged access
* UID 0 accounts
* Sudo configuration
* Password policies
* Password ageing
* PAM password quality
* SSH security
* Firewall configuration
* SELinux
* Authentication logging
* File permissions
* SUID and SGID files
* World-writable files
* Linux services

I also gained a better understanding of how these areas contribute to the overall security posture of a Linux system.

---

# Bash Scripting

The project reinforced several important Bash scripting techniques, including:

* Creating reusable helper functions
* Organising large scripts into logical sections
* Capturing and formatting command output
* Defensive scripting
* Error handling
* Generating structured reports
* Maintaining readable code

---

# Security Auditing

One of the most valuable lessons was learning that a security audit should collect as much information as possible without changing the system.

Rather than attempting to fix issues automatically, the script focuses on identifying potential security concerns and presenting them clearly for further investigation.

---

# Read-Only Design

Designing the script to be read-only reinforced the importance of separating information gathering from system modification.

This makes the project suitable for use on production systems where unexpected changes must be avoided.

---

# Error Handling

The project demonstrated that security scripts should continue collecting information even when some commands fail.

Examples include:

* Missing packages
* Restricted permissions
* Empty authentication logs
* Disabled services

Handling these situations gracefully produces a more useful report than terminating execution early.

---

# Linux Administration

The project provided practical experience using common Linux administration commands, including:

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

These commands are widely used by Linux Systems Administrators during security reviews and troubleshooting.

---

# Git Workflow

Developing the project across Windows and Rocky Linux strengthened my understanding of:

* Git commits
* GitHub synchronisation
* Rebasing
* Merge conflict resolution
* SSH authentication
* Cross-platform development

This workflow closely reflects professional software development practices.

---

# Documentation

Producing professional documentation alongside the code reinforced the importance of recording:

* Design decisions
* Testing procedures
* Recovery guidance
* Lessons learned
* Project reviews

Well-structured documentation improves maintainability and makes projects easier to explain during interviews.

---

# Future Improvements

Possible future enhancements include:

* CIS benchmark comparisons
* Security scoring
* JSON report output
* Compliance reporting
* Historical audit comparison
* Email notifications
* Optional command-line arguments
* HTML report generation

---

# Summary

This project significantly improved my confidence in Linux security administration and defensive Bash scripting.

It also demonstrated the importance of building safe, well-documented diagnostic tools that can assist administrators in assessing the security posture of Linux systems without introducing risk.
