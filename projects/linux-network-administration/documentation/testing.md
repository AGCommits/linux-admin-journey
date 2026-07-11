# Testing

## Testing Objective

The objective of testing was to verify that the Linux Network Administration project correctly collected network information, generated a structured report, handled expected failures gracefully, and remained safe to execute on a Rocky Linux system.

All testing was performed using a Rocky Linux virtual machine after development and Git synchronisation from Visual Studio Code.

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

---

# Test 1 — Bash Syntax Validation

## Command

```bash
bash -n scripts/network-audit.sh
```

## Expected Result

No output should be produced.

## Result

Passed.

---

# Test 2 — Script Execution

## Command

```bash
bash scripts/network-audit.sh
```

## Expected Result

The script should complete successfully and generate a timestamped report inside the reports directory.

## Result

Passed.

---

# Test 3 — Report Generation

## Verification

Confirmed that the generated report existed inside:

```text
reports/
```

The filename followed the expected format:

```text
network-audit-YYYY-MM-DD_HH-MM-SS.txt
```

## Result

Passed.

---

# Test 4 — Executive Summary

Verified that the report correctly displayed:

* Primary IPv4 address
* Default gateway
* Default interface
* Active interface count
* Listening TCP ports
* Listening UDP ports
* Connectivity test results

## Result

Passed.

---

# Test 5 — Network Interface Collection

Verified that the report collected:

* Interface names
* Interface state
* MAC addresses
* Interface flags

## Result

Passed.

---

# Test 6 — IP Address Collection

Verified successful collection of:

* IPv4 addresses
* IPv6 addresses
* Prefix lengths

## Result

Passed.

---

# Test 7 — Routing Information

Verified successful collection of:

* IPv4 routing table
* IPv6 routing table
* Default route
* Outbound interface

## Result

Passed.

---

# Test 8 — DNS Configuration

Verified successful collection of:

* /etc/resolv.conf
* NetworkManager DNS configuration
* Nameservers

## Result

Passed.

---

# Test 9 — NetworkManager Information

Verified collection of:

* Device status
* Active connections
* Connection profiles

## Result

Passed.

---

# Test 10 — Listening Ports

Verified successful collection of:

* TCP listeners
* UDP listeners

## Result

Passed.

---

# Test 11 — Active Connections

Verified that established TCP sessions and socket statistics were successfully reported.

## Result

Passed.

---

# Test 12 — Connectivity Tests

Verified successful testing of:

* Loopback interface
* Default gateway
* External IP connectivity
* DNS resolution

All tests completed successfully.

## Result

Passed.

---

# Test 13 — Diagnostic Interpretation

Verified that successful connectivity tests produced the expected success messages.

## Result

Passed.

---

# Test 14 — Git Workflow

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

| Test                      | Status |
| ------------------------- | ------ |
| Syntax Validation         | PASS   |
| Script Execution          | PASS   |
| Report Generation         | PASS   |
| Executive Summary         | PASS   |
| Interface Collection      | PASS   |
| IP Address Collection     | PASS   |
| Routing Information       | PASS   |
| DNS Configuration         | PASS   |
| NetworkManager Status     | PASS   |
| Listening Ports           | PASS   |
| Active Connections        | PASS   |
| Connectivity Tests        | PASS   |
| Diagnostic Interpretation | PASS   |
| Git Workflow              | PASS   |

---

# Conclusion

All planned functionality was successfully tested.

The project generated a complete, structured network audit report and behaved as expected throughout development and testing.

No defects requiring code changes were identified during final validation.
