# Linux Log Analysis

## Overview

This project was created to practise Linux system log analysis on Rocky Linux.

The project uses standard Linux administration tools to investigate:

- System logs
- Login activity
- Failed login attempts
- SSH activity
- System errors

A Bash script was created to automate collection of useful log information.

## Tools Used

- Rocky Linux 9
- journalctl
- grep
- last
- lastb
- Bash

## Project Structure

```text
linux-log-analysis/
├── documentation
├── reports
├── scripts
└── README.md
```

## Script

The main script is:

```text
scripts/log-analyzer.sh
```

The script collects:

- Recent logins
- Failed logins
- Recent system errors
- SSH activity

## Skills Demonstrated

- Linux administration
- Log analysis
- Troubleshooting
- Bash scripting
- Report generation
