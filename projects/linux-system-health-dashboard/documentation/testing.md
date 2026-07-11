# Testing

## Testing Objective

The objective of testing was to verify that the Linux System Health Dashboard project successfully collected system health information, generated a structured dashboard report, handled expected failures gracefully, and remained safe to execute on Rocky Linux.

Testing also confirmed that the script consistently produced a readable point-in-time health assessment without modifying the operating system.

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
bash -n scripts/system-health-dashboard.sh
```

## Expected Result

No output should be produced.

## Result

Passed.

---

# Test 2 — Script Execution

## Command

```bash
bash scripts/system-health-dashboard.sh
```

## Expected Result

The script should complete successfully and generate a timestamped health report.

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
system-health-YYYY-MM-DD_HH-MM-SS.txt
```

## Result

Passed.

---

# Test 4 — Executive Summary

Verified successful generation of:

* Overall health summary
* CPU status
* Memory status
* Storage status
* Failed service count
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

# Test 6 — CPU Monitoring

Verified successful collection of:

* CPU architecture
* Processor information
* Current load averages

## Result

Passed.

---

# Test 7 — Memory Monitoring

Verified successful collection of:

* Total memory
* Used memory
* Free memory
* Swap utilisation

## Result

Passed.

---

# Test 8 — Storage Monitoring

Verified successful collection of:

* Mounted filesystems
* Capacity usage
* Available space

## Result

Passed.

---

# Test 9 — Service Monitoring

Verified successful collection of failed systemd services.

Expected warning messages were generated when failed services existed.

## Result

Passed.

---

# Test 10 — User and Network Monitoring

Verified successful collection of:

* Logged-in users
* Network interface information

## Result

Passed.

---

# Test 11 — Process Monitoring

Verified successful collection of running process information.

## Result

Passed.

---

# Test 12 — Recommendations

Verified that health recommendations were generated based on detected findings.

## Result

Passed.

---

# Test 13 — Git Workflow

Verified successful workflow:

Visual Studio Code

↓

Git Commit

↓

GitHub Push

↓

Rocky Linux Git Pull

↓

Dashboard execution

↓

Health report generation

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
| CPU Monitoring              | PASS   |
| Memory Monitoring           | PASS   |
| Storage Monitoring          | PASS   |
| Service Monitoring          | PASS   |
| User and Network Monitoring | PASS   |
| Process Monitoring          | PASS   |
| Recommendations             | PASS   |
| Git Workflow                | PASS   |

---

# Conclusion

All planned functionality was successfully validated.

The Linux System Health Dashboard project consistently generated a structured health report while remaining read-only and suitable for routine monitoring and troubleshooting.

No defects requiring code changes were identified during final validation.
