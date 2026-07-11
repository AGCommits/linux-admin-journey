# Interview Notes

## Project Summary

The Linux Scheduled Task Automation project is a Bash-based automation solution developed for Rocky Linux.

Its purpose is to automate routine Linux maintenance tasks by collecting system information, reviewing key maintenance indicators, and generating a structured maintenance report suitable for routine administration.

The project was developed using Visual Studio Code on Windows, version controlled with Git and GitHub, and validated on a Rocky Linux virtual machine.

---

# Why I Built This Project

I wanted to improve my practical Linux automation skills while creating a reusable maintenance tool that demonstrates Bash scripting, scheduled execution, and structured reporting.

The project also provided experience in reducing repetitive administrative work through automation.

---

# What the Project Does

The script automatically reviews:

* System information
* System uptime
* Filesystem usage
* Failed services
* Available package updates
* Recent system errors
* Maintenance recommendations

It generates a timestamped report that can be reviewed by a system administrator or scheduled to run automatically.

---

# Linux Commands Used

During development I gained practical experience using commands including:

* `uptime`
* `df`
* `systemctl`
* `dnf`
* `journalctl`
* `hostnamectl`
* `date`
* `whoami`
* `awk`
* `grep`

These commands are commonly used during routine Linux administration.

---

# Design Decisions

Several design decisions were made during development:

* Keep the script read-only.
* Continue running if individual maintenance checks fail.
* Produce structured reports rather than console output.
* Use reusable helper functions.
* Generate timestamped reports.
* Design the script for scheduled execution using cron.

---

# Challenges

Some challenges encountered included:

* Designing the script for unattended execution.
* Handling missing package updates gracefully.
* Formatting maintenance reports consistently.
* Managing Git synchronisation between Windows and Rocky Linux.
* Ensuring the script remained non-destructive.

---

# What I Learned

This project improved my understanding of:

* Linux automation
* Cron scheduling
* Routine system maintenance
* Bash scripting
* Defensive programming
* Report generation
* Git and GitHub workflows
* Professional documentation

---

# Possible Interview Questions

## Why did you build this project?

To improve my Linux automation skills while creating a reusable maintenance tool suitable for routine administration.

---

## Why is the script read-only?

Routine maintenance reporting should gather information without modifying the operating system.

This makes the script safe to execute repeatedly, including through scheduled tasks.

---

## Why did you avoid using `set -e`?

Maintenance scripts should continue gathering information even when individual commands encounter expected issues.

Stopping execution early could result in incomplete maintenance reports.

---

## Why use scheduled automation?

Scheduling repetitive maintenance tasks improves consistency, reduces manual effort, and ensures reports are generated regularly without administrator intervention.

---

## How did you test the project?

Testing included:

* Bash syntax validation
* Rocky Linux execution
* Maintenance report verification
* GitHub synchronisation
* Cross-platform validation between Windows and Rocky Linux

---

## What would you improve?

Possible future enhancements include:

* HTML reports
* JSON export
* Email notifications
* Historical report comparison
* Maintenance scoring
* Automatic scheduling examples
* Optional command-line arguments

---

# Key Takeaway

This project demonstrates practical Linux automation, Bash scripting, scheduled maintenance, defensive programming, structured reporting, and professional Git-based development practices.
