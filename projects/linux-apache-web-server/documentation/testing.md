# Testing

## Testing Objective

The objective of testing was to verify that the Linux Apache Web Server project successfully deployed an Apache HTTP Server, validated its configuration, generated a structured audit report, and remained reliable when executed on Rocky Linux.

Testing also confirmed that both deployment and audit scripts behaved as expected under normal operating conditions.

All validation was performed on a Rocky Linux virtual machine following Git synchronisation from Visual Studio Code.

---

# Test Environment

Operating System:

```text
Rocky Linux 9
```

Shell:

```text
Bash
```

Development Environment:

```text
Visual Studio Code
Git
GitHub
```

Execution Environment:

```text
Rocky Linux Virtual Machine
```

---

# Test 1 — Bash Syntax Validation

## Commands

```bash
bash -n scripts/apache-deploy.sh

bash -n scripts/apache-audit.sh
```

## Expected Result

No output should be produced.

## Result

Passed.

---

# Test 2 — Apache Deployment

## Command

```bash
sudo bash scripts/apache-deploy.sh
```

## Expected Result

Apache should be installed (if required), configured, started, and enabled successfully.

## Result

Passed.

---

# Test 3 — Apache Configuration Validation

## Command

```bash
sudo apachectl configtest
```

## Expected Result

Apache should report:

```text
Syntax OK
```

## Result

Passed.

---

# Test 4 — Apache Service Status

Verified:

* Apache service installed
* Apache service active
* Apache service enabled

## Result

Passed.

---

# Test 5 — Website Deployment

Verified that the demonstration website was successfully deployed and available within the configured document root.

## Result

Passed.

---

# Test 6 — Virtual Host Configuration

Verified:

* Virtual Host configuration present
* Apache successfully loaded the configuration
* No configuration errors detected

## Result

Passed.

---

# Test 7 — Listening Ports

Verified Apache was listening on the expected HTTP port.

The audit correctly identified active listening sockets.

## Result

Passed.

---

# Test 8 — Firewall Verification

Verified that HTTP traffic was permitted through firewalld where applicable.

The audit correctly reported firewall status.

## Result

Passed.

---

# Test 9 — HTTP Validation

Verified successful HTTP access using:

```bash
curl
```

The expected web page was successfully returned.

## Result

Passed.

---

# Test 10 — Audit Report Generation

Verified successful generation of:

* Executive Summary
* Apache installation details
* Service status
* Virtual Host review
* Website validation
* Listening ports
* Firewall review
* Recommendations
* Overall assessment

## Result

Passed.

---

# Test 11 — Git Workflow

Verified successful workflow:

Visual Studio Code

↓

Git Commit

↓

GitHub Push

↓

Rocky Linux Git Pull

↓

Apache deployment

↓

Apache audit

## Result

Passed.

---

# Test Summary

| Test                     | Status |
| ------------------------ | ------ |
| Syntax Validation        | PASS   |
| Apache Deployment        | PASS   |
| Configuration Validation | PASS   |
| Service Status           | PASS   |
| Website Deployment       | PASS   |
| Virtual Host             | PASS   |
| Listening Ports          | PASS   |
| Firewall                 | PASS   |
| HTTP Validation          | PASS   |
| Audit Report             | PASS   |
| Git Workflow             | PASS   |

---

# Conclusion

All planned functionality was successfully validated.

The Linux Apache Web Server project consistently deployed, validated, and audited the Apache HTTP Server installation while generating a structured report suitable for routine administration and troubleshooting.

No defects requiring code changes were identified during final validation.
