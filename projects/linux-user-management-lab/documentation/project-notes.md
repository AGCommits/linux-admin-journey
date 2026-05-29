# Project Notes

## Purpose

The purpose of this project was to gain practical experience with Linux user and group management within a simulated business environment.

---

## Users Created

* alice
* bob
* charlie

---

## Groups Created

* finance
* hr
* it

---

## Directory Structure

Department directories were created for:

* Finance
* Human Resources
* Information Technology

---

## Ownership Configuration

Department directories were assigned to their corresponding Linux groups using:

```bash
chown
```

This ensures that ownership aligns with department responsibilities.

---

## Permission Configuration

Directory permissions were configured using:

```bash
chmod 770
```

Permission breakdown:

* Owner: Read, Write, Execute
* Group: Read, Write, Execute
* Others: No Access

---

## Access Verification

The following checks were performed:

* Verified group membership
* Verified ownership settings
* Verified permissions
* Confirmed access restrictions between departments

---

## Audit Script

A Bash script named:

```text
user-audit.sh
```

was created to automate verification tasks.

The script reports:

* Date and time
* Hostname
* Current user
* User group membership
* Department directory permissions
* Project structure

---

## Key Skills Developed

* Linux user administration
* Linux group administration
* Ownership management
* Permission management
* Access control
* Bash scripting
* Troubleshooting
* Documentation
