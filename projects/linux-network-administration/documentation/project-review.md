# Interview Notes

## Project Summary

The Linux Network Administration project is a Bash-based network auditing tool developed for Rocky Linux.

Its purpose is to collect key networking information from a Linux system, perform basic connectivity tests, and generate a structured report suitable for troubleshooting and routine administration.

The project was developed using Visual Studio Code on Windows, version controlled with Git and GitHub, and tested on a Rocky Linux virtual machine.

---

# Why I Built This Project

I wanted to improve my practical Linux networking skills while developing a reusable administration tool.

The project also allowed me to gain experience using common Linux networking utilities, Bash scripting, structured reporting, and Git-based development workflows.

---

# What the Project Does

The script automatically collects:

* System information
* Network interfaces
* IPv4 and IPv6 addresses
* Routing tables
* Default gateway information
* DNS configuration
* NetworkManager status
* Listening TCP and UDP ports
* Active network connections
* Connectivity test results

The information is written to a timestamped report for later review.

---

# Linux Commands Used

During development I gained practical experience using commands including:

* `ip`
* `ss`
* `nmcli`
* `hostnamectl`
* `ping`
* `getent`
* `awk`
* `grep`
* `wc`
* `cat`

These are standard tools commonly used by Linux Systems Administrators.

---

# Design Decisions

Several design decisions were made during development:

* Keep the script read-only.
* Continue running when individual diagnostic commands fail.
* Produce a structured report rather than console output.
* Use reusable Bash functions to reduce duplicated code.
* Store reports using timestamped filenames.
* Preserve one representative report within the Git repository while ignoring generated reports.

---

# Challenges

Some challenges encountered included:

* Handling missing commands gracefully.
* Designing readable report formatting.
* Collecting information consistently across different network states.
* Maintaining compatibility with Rocky Linux.
* Managing Git synchronisation between Windows and Rocky Linux.

---

# What I Learned

This project improved my understanding of:

* Linux networking
* Network troubleshooting
* Bash scripting
* Defensive programming
* Structured report generation
* Git and GitHub workflows
* Professional documentation

---

# Possible Interview Questions

## Why did you build this project?

To gain practical Linux networking experience while creating a reusable administration tool that demonstrates Bash scripting and troubleshooting skills.

---

## Why did you avoid using `set -e`?

Diagnostic scripts should continue collecting information even when individual commands fail.

Using `set -e` could terminate the script prematurely and produce an incomplete report.

---

## Why is the script read-only?

Read-only scripts are safer to execute on production systems because they collect information without modifying the operating system.

---

## How did you test the project?

Testing included:

* Bash syntax validation
* Real execution on Rocky Linux
* Verification of generated reports
* Connectivity testing
* GitHub synchronisation
* Cross-platform validation between Windows and Rocky Linux

---

## What would you improve?

Possible future enhancements include:

* JSON output
* CSV export
* Historical report comparison
* Latency and packet-loss reporting
* Additional IPv6 diagnostics
* Firewall rule analysis
* Scheduled execution

---

# Key Takeaway

This project demonstrates practical Linux networking knowledge, Bash scripting, structured report generation, defensive programming, and professional development practices using Git and GitHub.
