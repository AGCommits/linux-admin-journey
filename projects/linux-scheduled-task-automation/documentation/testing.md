# Testing

## Testing Objective

The objective of testing was to verify that the Linux Scheduled Task Automation project correctly collected maintenance information, generated a structured maintenance report, handled expected failures gracefully, and remained safe to execute on a Rocky Linux system.

Testing also confirmed that the script could be executed repeatedly without modifying the operating system, making it suitable for scheduled automation.

All validation was performed on a Rocky Linux virtual machine after Git synchronisation from Visual Studio Code.

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
bash -n scripts/maintenance.sh
```

## Expected Result

No output should be produced.

## Result

Passed.

---

# Test 2 — Script Execution

## Command

```bash
bash scripts/maintenance.sh
```

## Expected Result

The script should complete successfully and generate a timestamped maintenance report.

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
maintenance-run-YYYY-MM-DD_HH-MM-SS.txt
```

## Result

Passed.

---

# Test 4 — Executive Summary

Verified successful generation of:

* Maintenance summary
* Failed service count
* Package update count
* Filesystem status
* Overall assessment

## Result

Passed.

---

# Test 5 — System Information

Verified successful collection of:

* Hostname
* Operating system
* Kernel version
* Architecture

## Result

Passed.

---

# Test 6 — Uptime

Verified successful collection of:

* Current uptime
* Load averages

## Result

Passed.

---

# Test 7 — Filesystem Usage

Verified successful collection of:

* Mounted filesystems
* Capacity usage
* Available space

## Result

Passed.

---

# Test 8 — Failed Services

Verified successful collection of failed systemd services.

Expected warning messages were generated when failed services existed.

## Result

Passed.

---

# Test 9 — Package Updates

Verified successful detection of available package updates.

The report correctly handled systems with updates available and systems already fully updated.

## Result

Passed.

---

# Test 10 — Recent System Errors

Verified successful collection of recent error entries from the system journal.

## Result

Passed.

---

# Test 11 — Maintenance Recommendations

Verified that recommendations were produced based on detected findings.

## Result

Passed.

---

# Test 12 — Git Workflow

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

| Test                        | Status |
| --------------------------- | ------ |
| Syntax Validation           | PASS   |
| Script Execution            | PASS   |
| Report Generation           | PASS   |
| Executive Summary           | PASS   |
| System Information          | PASS   |
| Uptime                      | PASS   |
| Filesystem Usage            | PASS   |
| Failed Services             | PASS   |
| Package Updates             | PASS   |
| Recent System Errors        | PASS   |
| Maintenance Recommendations | PASS   |
| Git Workflow                | PASS   |

---

# Conclusion

All planned functionality was successfully validated.

The Linux Scheduled Task Automation project consistently generated structured maintenance reports while remaining read-only and suitable for scheduled execution.

No defects requiring code changes were identified during final validation.
