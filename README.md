# Linux Administration Portfolio

A practical Linux Systems Administration portfolio containing 12 hands-on projects developed with Rocky Linux, Bash, Git, GitHub, and Visual Studio Code.

[![Linux](https://img.shields.io/badge/Linux-Systems%20Administration-FCC624?logo=linux\&logoColor=black)](https://www.linux.org/)
[![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-9-10B981?logo=rockylinux\&logoColor=white)](https://rockylinux.org/)
[![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnubash\&logoColor=white)](https://www.gnu.org/software/bash/)
[![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git\&logoColor=white)](https://git-scm.com/)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?logo=github\&logoColor=white)](https://github.com/AGCommits)
[![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-Development-007ACC?logo=visualstudiocode\&logoColor=white)](https://code.visualstudio.com/)

---

## Overview

This repository demonstrates practical Linux administration skills through a structured collection of projects built and tested on Rocky Linux.

The portfolio covers core areas expected in junior Linux Systems Administrator, Linux Support, Infrastructure Support, and Operations roles, including:

* Linux system information and troubleshooting
* User, group, ownership, and permission management
* Backup automation
* Log analysis
* Service administration
* Storage administration
* Package management
* Network administration
* Security auditing
* Cron and systemd timer automation
* Apache web server deployment
* System health monitoring

Each project includes working Bash scripts, testing evidence, recovery guidance, lessons learned, interview notes, and a project review.

---

## About Me

I am a BSc Digital Forensics & Cyber Security graduate developing a career in Linux Systems Administration and infrastructure support.

My academic background introduced me to operating systems, digital evidence, security, scripting, and technical investigation. I created this portfolio to convert that knowledge into practical Linux administration experience using repeatable projects, real command-line work, structured testing, and professional documentation.

I am particularly interested in roles involving:

* Linux Systems Administration
* Linux Support Engineering
* Infrastructure Support
* Systems Operations
* Platform Support
* Cloud Support
* Technical Support with a Linux focus

---

## Portfolio Highlights

| Area                    |                            Portfolio Evidence |
| ----------------------- | --------------------------------------------: |
| Completed projects      |                                            12 |
| Primary platform        |                                 Rocky Linux 9 |
| Main scripting language |                                          Bash |
| Version control         |                                Git and GitHub |
| Development environment |                 Visual Studio Code on Windows |
| Testing environment     |                   Rocky Linux virtual machine |
| Documentation           | Design, testing, recovery, lessons and review |
| Administration style    |           Safe, repeatable and evidence-based |

---

## Technical Skills Demonstrated

| Skill Area          | Practical Evidence                                                       |
| ------------------- | ------------------------------------------------------------------------ |
| Linux command line  | Daily administration using Bash and standard Linux utilities             |
| Bash scripting      | Reusable scripts, functions, validation, logging and report generation   |
| User administration | Users, groups, ownership, permissions and access control                 |
| Service management  | `systemctl`, service status, failed services and custom unit files       |
| Storage             | Block devices, mounts, filesystem usage, capacity and inode monitoring   |
| Networking          | Interfaces, addressing, routing, DNS, NetworkManager and sockets         |
| Security            | SSH, firewalld, SELinux, privileged files and authentication auditing    |
| Automation          | Backup scripts, cron examples, systemd services and systemd timers       |
| Web administration  | Apache installation, virtual hosts, firewall access and logs             |
| Monitoring          | CPU, memory, swap, storage, services, networking and system logs         |
| Logging             | `journalctl`, authentication logs, application logs and audit reports    |
| Version control     | Branch synchronisation, rebasing, conflict resolution and clean commits  |
| Documentation       | Design notes, testing records, recovery guides and interview preparation |

---

## Project Portfolio

### 1. System Information Script

**Location:** [`projects/system-info-script`](projects/system-info-script)

A Bash script that collects essential information about a Linux system.

**Skills demonstrated:**

* Bash fundamentals
* Variables and command substitution
* Operating system identification
* CPU and memory information
* Disk usage
* Script permissions and execution

---

### 2. Linux User Management Lab

**Location:** [`projects/linux-user-management-lab`](projects/linux-user-management-lab)

A simulated business environment used to practise Linux user, group, ownership, and permission administration.

**Skills demonstrated:**

* User creation
* Group management
* Department-based access control
* Ownership and permissions
* Audit scripting
* Administrative documentation

---

### 3. Backup Automation Script

**Location:** [`projects/backup-automation-script`](projects/backup-automation-script)

A reusable Bash backup solution using compressed archives, timestamped filenames, verification, statistics, and execution logging.

**Skills demonstrated:**

* Backup automation
* Archive creation
* Timestamped output
* Logging
* Error handling
* Backup verification

---

### 4. Linux Log Analysis

**Location:** [`projects/linux-log-analysis`](projects/linux-log-analysis)

A structured log-analysis project that collects system, login, service, SSH, resource, and error information.

**Skills demonstrated:**

* `journalctl`
* Login and failed-login analysis
* Service failure investigation
* SSH activity review
* System resource reporting
* Troubleshooting documentation

---

### 5. Linux Service Administration

**Location:** [`projects/linux-service-administration`](projects/linux-service-administration)

A service-management project covering service status, lifecycle operations, logging, custom systemd units, and service monitoring.

**Skills demonstrated:**

* `systemctl`
* systemd unit files
* Service lifecycle management
* Service logging
* Failure investigation
* Monitoring scripts

---

### 6. Linux Storage Administration

**Location:** [`projects/linux-storage-administration`](projects/linux-storage-administration)

A storage auditing project that reports block devices, mounted filesystems, disk utilisation, inode usage, and storage health.

**Skills demonstrated:**

* `lsblk`
* `df`
* Mounted filesystem inspection
* Capacity monitoring
* Inode monitoring
* Storage health assessment
* Timestamped reports

---

### 7. Linux Package Management

**Location:** [`projects/linux-package-management`](projects/linux-package-management)

A practical Rocky Linux package-management project covering repository inspection, package queries, installation records, and update awareness.

**Skills demonstrated:**

* `dnf`
* RPM package queries
* Repository management
* Package installation and removal concepts
* Update inspection
* Package troubleshooting

---

### 8. Linux Network Administration

**Location:** [`projects/linux-network-administration`](projects/linux-network-administration)

A comprehensive network audit tool that collects interfaces, IP addresses, routes, DNS configuration, listening ports, active connections, and connectivity results.

**Skills demonstrated:**

* `ip`
* `ss`
* `nmcli`
* IPv4 and IPv6
* Routing tables
* DNS configuration
* Gateway and internet testing
* Network troubleshooting

---

### 9. Linux Security Audit

**Location:** [`projects/linux-security-audit`](projects/linux-security-audit)

A read-only Linux security auditing tool that reviews account security, privileged access, SSH, firewalld, SELinux, file permissions, failed logins, and services.

**Skills demonstrated:**

* User and privilege auditing
* SSH security review
* firewalld
* SELinux
* SUID and SGID discovery
* World-writable file analysis
* Authentication logs
* Security recommendations

---

### 10. Linux Scheduled Task Automation

**Location:** [`projects/linux-scheduled-task-automation`](projects/linux-scheduled-task-automation)

A scheduled maintenance project using Bash, cron concepts, a systemd oneshot service, a persistent systemd timer, execution logging, and scheduling audits.

**Skills demonstrated:**

* Cron syntax
* systemd services
* systemd timers
* Persistent scheduling
* Execution locking with `flock`
* Maintenance reports
* Timer auditing

---

### 11. Apache Web Server Administration

**Location:** [`projects/linux-apache-web-server`](projects/linux-apache-web-server)

An Apache deployment and auditing project containing a custom website, named virtual host, deployment automation, firewall configuration, SELinux-aware file handling, and web-service validation.

**Skills demonstrated:**

* Apache HTTP Server
* Virtual hosts
* `apachectl configtest`
* systemd service management
* firewalld
* SELinux contexts
* HTTP testing with `curl`
* Access and error log review

---

### 12. Linux System Health Monitoring Dashboard

**Location:** [`projects/linux-system-health-dashboard`](projects/linux-system-health-dashboard)

A capstone Bash dashboard that combines system, CPU, memory, swap, filesystem, service, network, package, security, and journal information into one health report.

**Skills demonstrated:**

* CPU and load monitoring
* Memory and swap analysis
* Storage and inode monitoring
* Failed-service analysis
* Network health checks
* Firewall and SELinux status
* Package update awareness
* System health assessment

---

## Development Workflow

Projects were developed using a consistent cross-platform workflow:

```text
Windows and Visual Studio Code
            ↓
Bash syntax validation
            ↓
Git staging and commit
            ↓
GitHub push
            ↓
Rocky Linux git pull
            ↓
Execution on the target platform
            ↓
Report and output validation
            ↓
Documentation and project review
```

This workflow allowed development to remain efficient in Visual Studio Code while ensuring that each Linux script was tested in its intended Rocky Linux environment.

---

## Documentation Standard

Projects include documentation appropriate to their scope.

The later portfolio projects use the following consistent structure:

```text
documentation/
├── design.md
├── interview-notes.md
├── lessons-learned.md
├── project-notes.md
├── project-review.md
├── recovery-guide.md
└── testing.md
```

### Design

Explains the purpose, objectives, architecture, design decisions, safety considerations, limitations, and potential improvements.

### Project Notes

Records implementation details, commands, workflow, important behaviour, and project outcomes.

### Testing

Documents syntax checks, functional tests, expected results, and validation performed on Rocky Linux.

### Recovery Guide

Provides troubleshooting and recovery procedures for common execution and environment problems.

### Lessons Learned

Records the technical and professional knowledge developed during the project.

### Interview Notes

Converts project experience into concise explanations and answers suitable for technical interviews.

### Project Review

Evaluates whether the objectives were achieved and identifies strengths, limitations, and possible future improvements.

---

## Repository Structure

```text
linux-admin-journey/
├── projects/
│   ├── backup-automation-script/
│   ├── linux-apache-web-server/
│   ├── linux-log-analysis/
│   ├── linux-network-administration/
│   ├── linux-package-management/
│   ├── linux-scheduled-task-automation/
│   ├── linux-security-audit/
│   ├── linux-service-administration/
│   ├── linux-storage-administration/
│   ├── linux-system-health-dashboard/
│   ├── linux-user-management-lab/
│   └── system-info-script/
├── LICENSE
├── progress-log.md
└── README.md
```

---

## Tools and Technologies

### Operating Systems and Virtualisation

* Rocky Linux 9
* Windows 11
* Oracle VirtualBox

### Development and Version Control

* Bash
* Git
* GitHub
* Visual Studio Code
* Git Bash

### Linux Administration

* systemd
* NetworkManager
* firewalld
* SELinux
* DNF and RPM
* Apache HTTP Server
* cron and systemd timers
* journald

### Documentation

* Markdown
* Obsidian
* GitHub documentation
* Structured text reports

---

## What Makes This Portfolio Different

This repository contains more than isolated command examples.

The projects demonstrate a complete administration workflow:

* A practical administration problem is identified.
* The solution is designed before implementation.
* Bash scripts are organised and professionally commented.
* Safety and error-handling requirements are considered.
* The project is version controlled with Git.
* Execution is validated on Rocky Linux.
* Representative output is preserved.
* Testing and recovery procedures are documented.
* Lessons and interview explanations are recorded.
* The completed project is reviewed against its objectives.

This creates evidence not only of Linux knowledge, but also of structured working practices, troubleshooting, documentation, and maintainability.

---

## Selected Administration Commands

The portfolio includes practical use of commands and tools such as:

```text
awk
cat
chage
chmod
chown
curl
df
dnf
find
firewall-cmd
free
getent
getenforce
grep
hostnamectl
ip
journalctl
last
lastb
lsblk
lscpu
nmcli
passwd
ping
ps
restorecon
rpm
ss
sestatus
systemctl
systemd-analyze
tar
tree
uname
uptime
who
```

---

## Future Development

The portfolio will continue to evolve alongside job applications and professional development.

Planned areas include:

* ShellCheck and Bash static analysis
* Consistent README templates across all projects
* Additional screenshots and terminal evidence
* Ansible
* Docker and Podman
* Python administration tooling
* CI/CD
* Cloud infrastructure
* Infrastructure as Code
* Centralised monitoring and observability
* A dedicated portfolio website

---

## Career Objective

I am seeking an opportunity where I can apply and continue developing my Linux, infrastructure, automation, troubleshooting, and security skills.

Roles of particular interest include:

* Junior Linux Systems Administrator
* Linux Support Engineer
* Infrastructure Support Engineer
* Systems Support Engineer
* Platform Support Engineer
* Cloud Support Engineer
* Operations Engineer
* Linux-focused Technical Support Engineer

---

## Contact

* GitHub: [AGCommits](https://github.com/AGCommits)
* Repository: [linux-admin-journey](https://github.com/AGCommits/linux-admin-journey)

---

## Licence

This repository is licensed under the terms contained in the [`LICENSE`](LICENSE) file.
