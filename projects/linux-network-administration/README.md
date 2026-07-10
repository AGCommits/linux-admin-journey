# Linux Network Administration

## Overview

The Linux Network Administration project is a practical Linux systems administration project developed using Rocky Linux.

The project focuses on collecting, analysing, and reporting essential Linux networking information using standard command-line tools and Bash scripting.

The finished project will include a reusable network audit script that gathers information about network interfaces, IP addresses, routing, DNS configuration, listening ports, active connections, and basic connectivity.

## Objectives

The objectives of this project are to:

- Inspect Linux network interfaces.
- Identify assigned IPv4 and IPv6 addresses.
- Examine the system routing table.
- Identify the default gateway.
- Inspect DNS resolver configuration.
- Display listening TCP and UDP ports.
- Review active network connections.
- Test local and external connectivity.
- Test DNS name resolution.
- Produce a timestamped network audit report.
- Document testing, troubleshooting, and recovery procedures.

## Core Tools

The project will use:

- `ip`
- `ss`
- `nmcli`
- `hostnamectl`
- `ping`
- `getent`
- `resolvectl`
- `cat`
- `grep`
- `awk`
- Bash scripting
- Git and GitHub

## Planned Project Structure

```text
linux-network-administration/
├── assets/
├── config/
├── documentation/
│   ├── design.md
│   ├── interview-notes.md
│   ├── lessons-learned.md
│   ├── project-notes.md
│   ├── project-review.md
│   ├── recovery-guide.md
│   └── testing.md
├── reports/
├── screenshots/
├── scripts/
│   └── network-audit.sh
├── .gitignore
└── README.md