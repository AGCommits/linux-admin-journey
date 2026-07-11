# Linux System Health Monitoring Dashboard

## Overview

This project provides a comprehensive Bash-based system health dashboard for Rocky Linux.

The dashboard combines system, CPU, memory, storage, service, network, package, security, and log information into one structured report.

It acts as the capstone project in the Linux Admin Journey portfolio by reusing skills developed across the previous administration projects.

## Objectives

- Collect system identity and uptime information.
- Review CPU utilisation and load averages.
- Review memory and swap usage.
- Review filesystem capacity and inode usage.
- Identify failed systemd services.
- Review listening ports and network connectivity.
- Check firewall and SELinux status.
- Review package-update availability.
- Inspect recent high-priority logs.
- Produce an overall health assessment.
- Generate a timestamped report.
- Provide clear warnings and recommendations.
- Operate as a read-only diagnostic tool.

## Health Categories

The dashboard reports:

1. Executive summary
2. System information
3. CPU health
4. Memory health
5. Storage health
6. Filesystem inode health
7. Service health
8. Network health
9. Security health
10. Package status
11. Recent system errors
12. Overall system assessment
13. Recommendations

## Safety

The script is read-only.

It does not:

- Restart services.
- Install updates.
- Delete files.
- Modify network configuration.
- Change firewall rules.
- Change SELinux mode.
- Modify users or permissions.

## Current Status

Development files created. Rocky Linux testing is pending.