# Linux User Management Lab

## Overview

The Linux User Management Lab is a hands-on Linux Systems Administration project created using Rocky Linux 9.7.

The project was designed to develop practical experience with Linux user management, group management, permissions, ownership, access control, Bash scripting, and documentation.

This project forms part of my Linux Systems Administration portfolio.

---

## Objectives

The objectives of this project were to:

* Create Linux user accounts
* Create Linux groups
* Configure directory ownership
* Configure permissions
* Verify access restrictions
* Create an automation script
* Document all activities and findings

---

## Project Scenario

A fictional company was created with three departments:

* Finance
* Human Resources (HR)
* Information Technology (IT)

Each department required:

* A dedicated Linux group
* A dedicated directory
* Controlled access using Linux permissions

---

## Project Structure

```text
linux-user-management-lab
├── backups
├── departments
│   ├── finance
│   ├── hr
│   └── it
├── documentation
│   └── project-notes.md
├── README.md
└── scripts
    └── user-audit.sh
```

---

## Skills Demonstrated

### User Management

Created Linux user accounts:

* alice
* bob
* charlie

### Group Management

Created Linux groups:

* finance
* hr
* it

### Ownership Management

Used `chown` to assign department ownership.

### Permission Management

Used `chmod 770` to restrict access to authorised users.

### Access Verification

Verified:

* Group membership
* Ownership settings
* Permission settings
* Access restrictions

### Bash Scripting

Created `user-audit.sh` to automate configuration checks.

---

## Technologies Used

* Rocky Linux 9.7
* Oracle VirtualBox
* Bash
* Git
* GitHub
* Obsidian
* Visual Studio Code

---

## Commands Practised

Examples include:

* useradd
* groupadd
* usermod
* passwd
* groups
* chmod
* chown
* ls
* tree
* nano
* cat
* echo

---

## Key Lessons Learned

* Linux permissions are based on users, groups, and ownership.
* Groups simplify access management.
* Verification is essential when implementing security controls.
* Bash scripting can automate repetitive administration tasks.
* Documentation improves maintainability and troubleshooting.

---

## Future Improvements

Future versions of this project may include:

* Additional users and departments
* Shared department resources
* Scheduled audits using cron
* Automated reporting
* Backup automation scripts

---

## Author

Ash

Created as part of my Linux Systems Administration learning journey and portfolio development.
