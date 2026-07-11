# Interview Notes

## Project Summary

The Linux System Health Dashboard project is a Bash-based monitoring solution developed for Rocky Linux.

Its purpose is to provide a consolidated snapshot of overall system health by collecting information about CPU usage, memory utilisation, storage, services, processes, networking, uptime, and logged-in users.

The project generates a structured, timestamped report that can be used for routine system monitoring and troubleshooting.

The project was developed using Visual Studio Code on Windows, version controlled with Git and GitHub, and validated on a Rocky Linux virtual machine.

---

# Why I Built This Project

I wanted to strengthen my practical Linux monitoring and Bash scripting skills by creating a reusable dashboard capable of providing administrators with an immediate overview of system health.

The project also allowed me to combine techniques learned throughout the earlier Linux administration projects into a single monitoring solution.

---

# What the Project Does

The dashboard automatically reviews:

* System information
* CPU status
* Memory utilisation
* Storage utilisation
* System uptime
* Failed services
* Active users
* Network status
* Running processes

It then generates recommendations and an overall health assessment.

---

# Linux Commands Used

During development I gained practical experience using commands including:

* `uptime`
* `free`
* `df`
* `lscpu`
* `systemctl`
* `ps`
* `ip`
* `who`
* `hostnamectl`
* `awk`
* `grep`

These are commonly used during Linux system monitoring and troubleshooting.

---

# Design Decisions

Several important design decisions were made during development:

* Keep the dashboard read-only.
* Continue running if individual monitoring commands fail.
* Produce structured reports rather than console output.
* Use reusable helper functions.
* Generate timestamped reports.
* Preserve one representative report while ignoring generated reports with `.gitignore`.

---

# Challenges

Some challenges encountered included:

* Designing a dashboard that provides useful information without becoming cluttered.
* Handling systems with different configurations.
* Formatting reports consistently.
* Managing Git synchronisation between Windows and Rocky Linux.
* Producing meaningful recommendations without modifying the system.

---

# What I Learned

This project improved my understanding of:

* Linux system monitoring
* CPU and memory analysis
* Storage monitoring
* Service monitoring
* Process management
* Network monitoring
* Bash scripting
* Defensive programming
* Professional documentation

---

# Possible Interview Questions

## Why did you build this project?

To improve my Linux monitoring skills while developing a reusable dashboard suitable for routine system administration.

---

## Why is the dashboard read-only?

Monitoring tools should observe and report the current state of a system without introducing changes.

Keeping the dashboard read-only makes it safe to execute repeatedly, including on production systems.

---

## Why did you avoid using `set -e`?

Monitoring scripts should continue collecting information even if one individual command fails.

Stopping early could result in an incomplete health assessment.

---

## How did you test the project?

Testing included:

* Bash syntax validation
* Rocky Linux execution
* Report verification
* Health information review
* GitHub synchronisation
* Cross-platform validation

---

## What would you improve?

Possible future enhancements include:

* HTML dashboards
* JSON output
* Historical comparisons
* Email notifications
* Scheduled monitoring
* Health scoring
* Integration with monitoring platforms

---

# Key Takeaway

This project demonstrates practical Linux monitoring, Bash scripting, defensive programming, structured reporting, and professional Git-based development practices while producing a reusable dashboard suitable for routine administration.
