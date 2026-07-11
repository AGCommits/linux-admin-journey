# Recovery Guide

## Purpose

This document provides recovery procedures for the Linux System Health Dashboard project.

The project is intentionally designed as a read-only monitoring tool. It collects health information without modifying the operating system, making recovery primarily focused on resolving environmental issues that may prevent successful execution.

---

# Common Issues

## Script Will Not Execute

### Symptoms

```text
Permission denied
```

### Resolution

Make the script executable:

```bash
chmod +x scripts/system-health-dashboard.sh
```

or execute it directly with Bash:

```bash
bash scripts/system-health-dashboard.sh
```

---

## Bash Syntax Errors

### Symptoms

The script exits immediately or reports a syntax error.

### Resolution

Validate the script before execution:

```bash
bash -n scripts/system-health-dashboard.sh
```

Correct any reported syntax errors before continuing.

---

## Report Not Generated

### Symptoms

No report appears inside the reports directory.

### Resolution

Verify that the reports directory exists:

```bash
ls -la reports
```

If necessary, recreate it:

```bash
mkdir -p reports
```

Run the dashboard again.

---

## CPU Information Missing

### Resolution

Verify CPU information manually:

```bash
lscpu
```

If the command is unavailable, ensure the required package is installed.

---

## Memory Information Missing

### Resolution

Verify memory information manually:

```bash
free -h
```

Confirm that memory statistics are displayed correctly.

---

## Storage Information Missing

### Resolution

Verify filesystem information:

```bash
df -h
```

Ensure mounted filesystems are accessible.

---

## Failed Service Information Missing

### Resolution

Verify systemd status:

```bash
systemctl --failed
```

If no failed services are present, this section of the report may legitimately be empty.

---

## Network Information Missing

### Resolution

Verify available network interfaces:

```bash
ip addr
```

Inspect routing information if required:

```bash
ip route
```

---

## Process Information Missing

### Resolution

Verify running processes manually:

```bash
ps aux
```

If process information cannot be collected, confirm that the system is operating normally and rerun the dashboard.

---

## Git Synchronisation Issues

### Resolution

Verify repository status:

```bash
git status
git pull --rebase origin main
git push origin main
```

Resolve any merge conflicts before continuing.

---

# Safe Recovery

Because the dashboard performs only read-only monitoring, no rollback procedures are required.

Recovery consists of correcting the underlying system issue and rerunning the dashboard.

---

# Verification

Following recovery, rerun:

```bash
bash scripts/system-health-dashboard.sh
```

Confirm that:

* The report is generated.
* CPU information is present.
* Memory information is present.
* Storage information is present.
* Failed service information is displayed.
* Network information is displayed.
* Running process information is included.
* Recommendations are generated.
* The dashboard completes successfully.

---

# Summary

The Linux System Health Dashboard project is intentionally non-destructive.

Recovery focuses on restoring the execution environment rather than reversing system changes, making the dashboard safe for repeated execution during routine monitoring and troubleshooting.
