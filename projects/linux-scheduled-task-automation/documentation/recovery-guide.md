# Recovery Guide

## Purpose

This document provides recovery procedures for the Linux Scheduled Task Automation project.

The project is intentionally designed as a read-only maintenance tool. It gathers maintenance information without modifying the operating system, making recovery primarily concerned with resolving environmental issues rather than reversing configuration changes.

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
chmod +x scripts/maintenance.sh
```

or execute it directly with Bash:

```bash
bash scripts/maintenance.sh
```

---

## Bash Syntax Errors

### Symptoms

The script exits immediately or reports a syntax error.

### Resolution

Validate the script before execution:

```bash
bash -n scripts/maintenance.sh
```

Correct any reported syntax errors before continuing.

---

## Report Not Generated

### Symptoms

No maintenance report appears inside the reports directory.

### Resolution

Verify that the reports directory exists:

```bash
ls -la reports
```

If necessary, recreate it:

```bash
mkdir -p reports
```

Run the script again.

---

## Filesystem Information Missing

### Resolution

Verify filesystem information manually:

```bash
df -h
```

Confirm that mounted filesystems are accessible.

---

## Failed Service Information Missing

### Resolution

Verify systemd status:

```bash
systemctl --failed
```

If no failed services are present, this section of the report may be empty.

---

## Package Update Information Missing

### Resolution

Verify package repositories:

```bash
dnf check-update
```

Possible outcomes include:

* No updates available
* Updates available
* Repository unavailable

The script handles all three outcomes.

---

## Journal Information Missing

### Resolution

Inspect the journal directly:

```bash
journalctl -p err -n 25
```

If journald is unavailable or restricted, the script records the condition and continues.

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

Because the project performs only diagnostic operations, no rollback procedures are required.

Recovery consists of correcting the underlying system issue and rerunning the maintenance script.

---

# Verification

Following recovery, rerun:

```bash
bash scripts/maintenance.sh
```

Confirm that:

* The maintenance report is generated.
* System information is populated.
* Filesystem information is present.
* Failed services are reported correctly.
* Package update information is displayed.
* Recommendations are generated.
* The script completes successfully.

---

# Summary

The Linux Scheduled Task Automation project is intentionally non-destructive.

Recovery focuses on restoring the execution environment rather than reversing system changes, making the script safe for repeated automated execution.
