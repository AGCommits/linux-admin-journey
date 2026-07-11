# Design Document

## Project Name

Linux Network Administration

## Purpose

The purpose of this project is to create a reusable Bash script that performs a structured audit of a Linux system's network configuration and current network state.

The script collects information using standard Linux administration tools and writes the results to a timestamped text report.

The project is designed to demonstrate practical Linux networking knowledge, Bash scripting, troubleshooting, report generation, Git-based development, and testing on Rocky Linux.

## Objectives

The project objectives are to:

* Identify available network interfaces.
* Display interface state and hardware information.
* Collect IPv4 and IPv6 addresses.
* Inspect the system routing table.
* Identify the default gateway and outbound interface.
* Review DNS resolver configuration.
* Review NetworkManager devices and connection profiles.
* Identify listening TCP and UDP ports.
* Display established network connections.
* Test loopback connectivity.
* Test default-gateway connectivity.
* Test external IP connectivity.
* Test DNS name resolution.
* Generate a clear executive summary.
* Save the results in a timestamped report.
* Continue running when individual diagnostic commands fail.

## Design Goals

The script is designed to be:

* Readable
* Modular
* Professionally commented
* Safe to run
* Non-destructive
* Useful for troubleshooting
* Suitable for portfolio demonstration
* Compatible with Rocky Linux 9
* Capable of running without user input
* Resilient when the system is disconnected
* Clear enough to explain during a technical interview

## Target Platform

The primary target platform is:

```text
Rocky Linux 9
```

The script was developed in Visual Studio Code on Windows and tested on a Rocky Linux virtual machine.

Git and GitHub were used to transfer and synchronise the project between the development and testing environments.

## Development Workflow

The project follows this workflow:

```text
Windows and Visual Studio Code
        ↓
Bash syntax validation
        ↓
Git commit and push
        ↓
GitHub
        ↓
Rocky Linux git pull
        ↓
Real Linux execution and testing
        ↓
Representative sample report
```

This keeps Windows as the editing environment while Rocky Linux remains the real execution and validation platform.

## Project Structure

```text
linux-network-administration/
├── assets/
├── config/
├── documentation/
│   ├── design.md
│   ├── interview-notes.md
│   ├── lessons-learned.md
│   ├── project-notes.md
│   ├── project-review.md
│   ├── recovery-guide.md
│   └── testing.md
├── reports/
├── screenshots/
├── scripts/
│   └── network-audit.sh
├── .gitignore
└── README.md
```

## Input

The script does not require command-line arguments or interactive user input.

It inspects the local system on which it is executed.

The script relies on the current system configuration, including:

* Network interfaces
* Assigned addresses
* Routing information
* DNS configuration
* NetworkManager state
* Open sockets
* Connectivity state

## Output

Reports are stored under:

```text
reports/
```

The filename format is:

```text
network-audit-YYYY-MM-DD_HH-MM-SS.txt
```

A representative report is preserved as:

```text
network-audit-sample.txt
```

Timestamped runtime reports are ignored by Git to prevent the repository from accumulating unnecessary generated files.

## Script Architecture

The script is divided into the following logical areas:

1. Script configuration
2. Project paths
3. Audit state variables
4. Formatting functions
5. Utility functions
6. Data collection
7. Connectivity tests
8. Report generation
9. Diagnostic interpretation
10. Completion output

This structure separates data collection from report formatting and improves readability.

## Helper Functions

The script uses reusable functions to reduce duplicated code.

### `write_section`

Creates consistent report section headings.

### `write_subsection`

Creates smaller headings within report sections.

### `write_item`

Formats labelled values into aligned report output.

### `write_warning`

Displays warning messages in a consistent format.

### `write_success`

Displays successful diagnostic results.

### `command_exists`

Checks whether a required command is available before attempting to use it.

### `run_command`

Executes a diagnostic command and records a warning if the command fails.

### `get_operating_system`

Reads the operating system name from `/etc/os-release`.

### `get_default_route_details`

Extracts the default gateway and outbound interface from the IPv4 routing table.

### `get_primary_ipv4`

Identifies the first global IPv4 address assigned to the system.

### `collect_summary_counts`

Counts active interfaces and listening TCP and UDP ports.

### `perform_connectivity_tests`

Runs loopback, gateway, external IP, and DNS resolution tests.

## Report Sections

The generated report contains the following sections:

### 1. Report Header

Includes:

* Generation time
* Hostname
* Executing user
* Report location

### 2. Executive Summary

Includes:

* Primary IPv4 address
* Default gateway
* Default interface
* Active interface count
* Listening TCP port count
* Listening UDP port count
* Loopback test result
* Gateway test result
* External connectivity result
* DNS resolution result

### 3. System Information

Includes:

* Operating system
* Kernel version
* Architecture
* Hostname details
* Virtualisation information

### 4. Network Interfaces

Includes:

* Interface names
* Interface states
* MAC addresses
* MTU values
* Link flags
* Queue and hardware details

### 5. IP Address Information

Includes:

* Address summary
* IPv4 addresses
* IPv6 addresses
* Prefix lengths
* Address scope
* Associated interfaces

### 6. Routing Information

Includes:

* IPv4 routing table
* IPv6 routing table
* Default route
* Default gateway
* Outbound interface

### 7. DNS Configuration

Includes:

* `/etc/resolv.conf`
* Configured nameservers
* Search domains
* NetworkManager DNS information

### 8. NetworkManager Status

Includes:

* Device status
* Active connections
* Configured connection profiles

### 9. Listening Ports

Includes:

* Listening TCP ports
* Listening UDP ports
* Associated processes where permissions allow

### 10. Active Network Connections

Includes:

* Established TCP connections
* Socket statistics

### 11. Connectivity Tests

Includes:

* Local loopback test
* Default gateway test
* External IP test
* DNS resolution test

### 12. Diagnostic Interpretation

Converts the connectivity test results into readable success or warning messages.

## Core Commands

The project uses the following Linux commands:

* `ip`
* `ss`
* `nmcli`
* `hostname`
* `hostnamectl`
* `uname`
* `ping`
* `getent`
* `resolvectl`
* `cat`
* `awk`
* `grep`
* `wc`
* `date`
* `whoami`

## Error Handling

The script deliberately does not use:

```bash
set -e
```

Network commands may legitimately fail when:

* An interface is disconnected
* A default route is missing
* DNS is unavailable
* A gateway does not respond
* A required command is not installed

Instead of terminating the entire audit, the script:

* Checks whether commands exist
* Handles missing values
* Records warnings
* Continues collecting available information
* Completes the report even when individual checks fail

The script does use:

```bash
set -u
set -o pipefail
```

These options help identify undefined variables and pipeline failures while still allowing expected network-test failures to be handled explicitly.

## Safety Considerations

The script uses read-only diagnostic commands.

It does not:

* Change IP addresses
* Enable or disable interfaces
* Restart NetworkManager
* Modify DNS configuration
* Change firewall rules
* Add or remove routes
* Modify connection profiles
* Restart networking services
* Install or remove packages

This makes the script safe to run during routine troubleshooting.

## Permissions

Most sections can run as a standard user.

Some process information from commands such as:

```bash
ss -lntp
ss -lnup
```

may be incomplete without elevated privileges.

The script still produces a useful report when run without `sudo`.

## Git Strategy

The project uses `.gitignore` to exclude generated timestamped reports:

```text
reports/network-audit-*.txt
```

One representative report is preserved:

```text
reports/network-audit-sample.txt
```

The repository-level `.gitattributes` file enforces Linux LF line endings for shell scripts, Markdown files, and text reports.

## Design Decisions

### Use standard Linux tools

The project avoids external libraries and uses commands normally available on Rocky Linux.

### Use absolute project paths

The script calculates its project root from its own location. This allows it to run correctly from any working directory.

### Continue after failed diagnostics

A network audit should still complete when connectivity is unavailable. Expected failures are recorded rather than terminating the script.

### Separate summary from detailed evidence

The executive summary provides quick results, while later sections provide the full diagnostic evidence.

### Preserve one sample report

Keeping one representative report demonstrates the script output without filling the repository with generated files.

## Limitations

The project has the following limitations:

* Connectivity tests use fixed targets.
* ICMP may be blocked even when a destination is reachable.
* The script does not perform packet capture.
* The script does not analyse firewall rules in detail.
* It does not modify or repair network configuration.
* It does not discover devices elsewhere on the network.
* Socket process information may require elevated privileges.
* DNS behaviour may differ on systems using other resolver services.
* The script is designed primarily for Rocky Linux and similar distributions.

## Future Improvements

Potential future improvements include:

* Command-line options
* Configurable connectivity targets
* JSON or CSV report output
* Network latency measurements
* Packet-loss measurements
* Firewall rule analysis
* Interface traffic statistics
* Historical report comparison
* Email or webhook notifications
* Automated scheduled execution
* IPv6 connectivity testing
* Route-change detection

## Summary

The Linux Network Administration project provides a safe and reusable method for collecting network configuration and connectivity information from a Rocky Linux system.

The project demonstrates practical Linux networking, Bash scripting, defensive error handling, structured reporting, Git-based development, and real Linux testing.
