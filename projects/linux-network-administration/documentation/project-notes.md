# Project Notes

## Purpose

The purpose of this project was to develop a reusable Bash script capable of auditing the network configuration and current network state of a Rocky Linux system.

The project builds on previous Linux administration projects by focusing specifically on networking concepts commonly encountered by Linux Systems Administrators during troubleshooting and routine system maintenance.

The completed script generates a structured, timestamped report that can be used to quickly assess the operational state of a system's networking configuration.

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Bash scripting
* Linux networking
* IPv4 and IPv6 addressing
* Routing tables
* Network interfaces
* DNS configuration
* NetworkManager
* Socket inspection
* Connectivity testing
* Structured report generation
* Defensive scripting
* Git and GitHub workflow
* Rocky Linux administration

---

## Development Environment

Development was completed using:

* Visual Studio Code (Windows)
* Git
* GitHub
* Rocky Linux 9 virtual machine
* Bash

Windows was used for editing while Rocky Linux remained the primary testing platform.

---

## Report Structure

The generated report includes:

1. Executive Summary
2. System Information
3. Network Interfaces
4. IP Address Information
5. Routing Information
6. DNS Configuration
7. NetworkManager Status
8. Listening Ports
9. Active Network Connections
10. Connectivity Tests
11. Diagnostic Interpretation

This structure allows administrators to begin with a concise overview before reviewing progressively more detailed information.

---

## Linux Commands Used

The project makes use of standard Linux networking utilities including:

* ip
* ss
* nmcli
* hostnamectl
* uname
* ping
* getent
* awk
* grep
* wc
* cat
* date
* whoami

These commands were selected because they are commonly available on enterprise Linux distributions such as Rocky Linux.

---

## Error Handling

The project was designed to continue collecting information even if individual commands fail.

Examples include:

* Missing network connectivity
* Missing default gateway
* DNS resolution failures
* Missing utilities
* Interfaces without addresses

Rather than terminating execution, the script records warnings and completes the remainder of the audit.

---

## Safety

The project performs only read-only diagnostic operations.

It does not:

* Change IP addresses
* Restart networking services
* Modify DNS settings
* Change routing tables
* Edit NetworkManager profiles
* Configure firewall rules

This allows the script to be safely executed on production systems.

---

## Testing Summary

Testing was completed on Rocky Linux.

Validation included:

* Bash syntax checking
* Successful report generation
* Network connectivity validation
* DNS resolution testing
* Gateway testing
* Report formatting verification
* GitHub synchronisation
* Linux execution after Git pull

---

## Outcome

The completed project provides a reusable network auditing tool suitable for routine administration and troubleshooting.

The project also strengthened practical understanding of Linux networking, Bash scripting, structured report generation and professional software development practices.
