# Recovery Guide

## Purpose

This document provides recovery procedures for the Linux Network Administration project.

The project is designed to be read-only and does not intentionally modify the operating system. Recovery is therefore primarily concerned with resolving environmental issues rather than undoing configuration changes.

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
chmod +x scripts/network-audit.sh
```

or execute it directly with Bash:

```bash
bash scripts/network-audit.sh
```

---

## Bash Syntax Errors

### Symptoms

The script exits immediately or reports a syntax error.

### Resolution

Validate the script before execution:

```bash
bash -n scripts/network-audit.sh
```

Correct any reported syntax errors before continuing.

---

## Report Not Generated

### Symptoms

No report appears in the reports directory.

### Resolution

Verify the reports directory exists:

```bash
ls -la reports
```

If necessary, recreate it:

```bash
mkdir -p reports
```

Run the script again.

---

## Missing Network Information

### Symptoms

Some report sections are incomplete.

### Possible Causes

* Network disconnected
* Required command unavailable
* Interface not configured
* Service unavailable

### Resolution

Verify connectivity:

```bash
ip address
ip route
nmcli device status
```

---

## Connectivity Tests Fail

### Symptoms

Loopback, gateway or external connectivity tests fail.

### Resolution

Check:

```bash
ping 127.0.0.1
ping <gateway>
ping 1.1.1.1
getent hosts github.com
```

Failures should be investigated individually before rerunning the audit.

---

## NetworkManager Information Missing

### Resolution

Verify NetworkManager is running:

```bash
systemctl status NetworkManager
```

---

## DNS Resolution Failure

### Resolution

Inspect:

```bash
cat /etc/resolv.conf
nmcli device show
```

Verify configured nameservers are reachable.

---

## Listening Ports Missing

### Resolution

Check:

```bash
ss -lnt
ss -lnu
```

If executed as a standard user, some process information may be unavailable.

---

## Git Synchronisation Issues

### Symptoms

Unable to push or pull changes.

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

Because the project performs only diagnostic operations, recovery generally consists of correcting the underlying system issue and rerunning the script.

No rollback procedures are required because the project does not modify networking configuration.

---

# Verification

Following recovery, rerun:

```bash
bash scripts/network-audit.sh
```

Confirm:

* Report generated successfully
* Executive summary populated
* Connectivity tests completed
* No unexpected warnings present

---

# Summary

The Linux Network Administration project is intentionally non-destructive.

Recovery focuses on restoring the operating environment rather than reversing script actions, making the project safe for repeated execution during troubleshooting.
