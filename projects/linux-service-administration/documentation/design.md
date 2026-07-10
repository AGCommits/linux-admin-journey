# Linux Service Administration - Design

## Project Objective

Create and manage a custom Linux service using systemd.

The project will demonstrate how Linux services are created, started, stopped, enabled, disabled, logged, and troubleshooted.

---

## Problem Being Solved

Linux administrators often need to run scripts or applications as background services.

Leaving a terminal open is not reliable.

A systemd service allows Linux to manage the process properly.

---

## Service Design

The project will use a custom Bash script that writes timestamped health check messages to a log file.

systemd will manage this script as a service.

---

## Architecture

```text
systemd
   |
   | starts and manages
   v
custom service file
   |
   | runs
   v
scripts/service-monitor.sh
   |
   | writes output to
   v
reports/service-monitor.log

---

## Automatic Service Recovery

The service uses systemd's automatic restart capability.

Configuration:

```ini
Restart=always
RestartSec=5
```

### Purpose

If the service exits unexpectedly, systemd automatically starts it again after five seconds.

This improves service availability without administrator intervention.
