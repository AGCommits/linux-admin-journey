# Testing

## Testing Objective

The objective of testing was to verify that the Linux Security Audit project correctly collected security-related information, generated a structured report, handled expected failures gracefully, and remained safe to execute on a Rocky Linux system.

Testing also confirmed that the script continued running when individual audit commands encountered missing data or restricted permissions.

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

## Command

```bash
bash -n scripts/security-audit.sh
```

## Expected Result

No output should be produced.

## Result

Passed.

---

# Test 2 — Script Execution

## Command

```bash
sudo bash scripts/security-audit.sh
```

## Expected Result

The script should complete successfully and generate a timestamped report.

## Result

Passed.

---

# Test 3 — Report Generation

## Verification

Confirmed that the generated report was written to:

```text
reports/
```

using the expected filename format:

```text
security-audit-YYYY-MM-DD_HH-MM-SS.txt
```

## Result

Passed.

---

# Test 4 — Executive Summary

Verified successful generation of:

* Security summary
* Overall assessment
* Warning counts
* Review counts
* Failed checks

## Result

Passed.

---

# Test 5 — User Security

Verified successful collection of:

* Local users
* Interactive users
* UID 0 accounts
* Administrative groups

## Result

Passed.

---

# Test 6 — Password Policy

Verified successful review of:

* Password ageing
* Password quality configuration
* Root password status

## Result

Passed.

---

# Test 7 — SSH Security

Verified successful inspection of:

* SSH service
* SSH configuration
* Root login policy
* Password authentication

## Result

Passed.

---

# Test 8 — Firewall

Verified successful collection of:

* firewalld status
* Active zones
* Active services

## Result

Passed.

---

# Test 9 — SELinux

Verified successful collection of:

* SELinux mode
* SELinux status

## Result

Passed.

---

# Test 10 — Failed Login Review

Verified successful inspection of:

* Recent failed login records
* Authentication activity

## Result

Passed.

---

# Test 11 — Permission Auditing

Verified successful inspection of:

* Critical system files
* World-writable files
* World-writable directories
* SUID files
* SGID files

## Result

Passed.

---

# Test 12 — Service Review

Verified successful collection of:

* Failed services
* Enabled services
* Listening services

## Result

Passed.

---

# Test 13 — Security Logs

Verified successful collection of recent authentication and security-related journal entries.

## Result

Passed.

---

# Test 14 — Recommendations

Verified that the report generated recommendations appropriate to the findings.

## Result

Passed.

---

# Test 15 — Git Workflow

Verified successful workflow:

Visual Studio Code

↓

Git Commit

↓

GitHub Push

↓

Rocky Linux Git Pull

↓

Successful execution

## Result

Passed.

---

# Test Summary

| Test                | Status |
| ------------------- | ------ |
| Syntax Validation   | PASS   |
| Script Execution    | PASS   |
| Report Generation   | PASS   |
| Executive Summary   | PASS   |
| User Security       | PASS   |
| Password Policy     | PASS   |
| SSH Security        | PASS   |
| Firewall            | PASS   |
| SELinux             | PASS   |
| Failed Login Review | PASS   |
| Permission Auditing | PASS   |
| Service Review      | PASS   |
| Security Logs       | PASS   |
| Recommendations     | PASS   |
| Git Workflow        | PASS   |

---

# Conclusion

All planned functionality was successfully validated.

The Linux Security Audit project consistently generated a structured, professional security report while remaining read-only and suitable for routine administration.

No defects requiring code changes were identified during final testing.
