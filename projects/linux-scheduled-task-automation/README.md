# Linux Scheduled Task Automation

## Overview

This project demonstrates scheduled task administration on Rocky Linux using both cron and systemd timers.

It includes a safe maintenance snapshot script, a scheduling audit script, an example cron entry, and hardened systemd service and timer units.

## Objectives

- Create a reusable scheduled maintenance script.
- Generate timestamped maintenance reports.
- Record persistent execution logs.
- Prevent overlapping script executions.
- Configure a systemd oneshot service.
- Configure a persistent systemd timer.
- Provide an equivalent cron example.
- Audit cron and systemd scheduling.
- Review execution history and scheduling failures.
- Compare cron with systemd timers.

## Project Components

### `maintenance-task.sh`

Collects:

- System information
- Filesystem usage
- Memory usage
- System load
- Failed services
- Available package updates
- Recent high-priority journal messages

### `scheduled-task-audit.sh`

Audits:

- `crond` status
- User crontab entries
- System cron directories
- Installed systemd timers
- Failed timers
- Unit-file validity
- Maintenance execution history

### systemd units

The project includes:

- `linux-admin-maintenance.service`
- `linux-admin-maintenance.timer`

### Cron example

The project also includes a documented cron equivalent. Cron and the systemd timer should not be enabled simultaneously for the same task.

## Safety

The maintenance and audit scripts are read-only. They do not install updates, restart services, remove files, or modify system configuration.

## Current Status

Development files created. Rocky Linux installation and testing are pending.