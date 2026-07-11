# Recovery Guide

## Purpose

This document provides recovery procedures for the Linux Security Audit project.

The project is intentionally designed as a read-only security auditing tool. It does not modify system configuration, user accounts, services, firewall rules, or SELinux settings.

Recovery procedures therefore focus on resolving environmental issues that may prevent the audit from completing successfully.

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
chmod +x scripts/security-audit.sh
```

or execute it directly with Bash:

```bash
bash scripts/security-audit.sh
```

---

## Bash Syntax Errors

### Symptoms

The script exits immediately or reports a syntax error.

### Resolution

Validate the script before execution:

```bash
bash -n scripts/security-audit.sh
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

Run the audit again.

---

## Permission Denied Errors

### Symptoms

Certain sections of the report are incomplete or display permission errors.

### Resolution

Execute the audit with elevated privileges:

```bash
sudo bash scripts/security-audit.sh
```

Some files, logs and services require administrative access.

---

## SSH Information Missing

### Resolution

Verify the SSH service:

```bash
systemctl status sshd
```

Inspect the configuration:

```bash
sudo cat /etc/ssh/sshd_config
```

---

## Firewall Information Missing

### Resolution

Verify firewalld:

```bash
systemctl status firewalld
```

Check its status:

```bash
firewall-cmd --state
```

---

## SELinux Information Missing

### Resolution

Verify SELinux:

```bash
getenforce
sestatus
```

---

## Failed Login History Unavailable

### Resolution

Verify the authentication database:

```bash
sudo lastb
```

If no failed logins exist, an empty result is expected.

---

## Package Information Missing

### Resolution

Verify DNF:

```bash
dnf check-update
```

The command may return:

* No updates available.
* Updates available.
* Repository unavailable.

All three outcomes are handled by the audit.

---

## Journal Information Missing

### Resolution

Inspect recent logs directly:

```bash
sudo journalctl --since "24 hours ago"
```

If journald is unavailable or restricted, the script records this and continues.

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

Recovery consists of correcting the underlying system issue and rerunning the audit.

---

# Verification

Following recovery, rerun:

```bash
sudo bash scripts/security-audit.sh
```

Confirm that:

* The report is generated.
* Security sections are populated.
* Recommendations are present.
* The audit completes successfully.

---

# Summary

The Linux Security Audit project is intentionally non-destructive.

Recovery focuses on restoring the execution environment rather than reversing system changes, making the script safe to execute repeatedly during routine security assessments.
