# Linux Admin Journey Progress Log

---

## 2026-05-27

### Completed
- Installed Git
- Installed VS Code
- Installed Obsidian
- Created GitHub repository
- Cloned repository locally
- Began Linux administration setup

### Current Focus
- Rocky Linux VM setup
- GitHub workflow
- Linux documentation habits

### Notes
Beginning Linux systems administration journey from scratch with focus on:
- consistency
- terminal usage
- documentation
- hands-on projects

### Rocky Linux Setup Progress
- Installed Rocky Linux 9.7 in VirtualBox
- Began using Linux terminal
- Practiced filesystem navigation
- Created first Linux project directory structure
- Learned basic Linux commands:
  - pwd
  - ls
  - ls -la
  - mkdir
  - touch
  - rm
  - mv
- Created initial VM snapshot

# Daily Linux Log - 2026-05-28

---

# Session Goals
- Continue Linux administration fundamentals
- Learn numeric Linux permissions
- Practice user and group management
- Improve Bash scripting understanding
- Continue GitHub workflow practice

---

# Topics Covered

## Numeric Permissions

Learned how Linux converts symbolic permissions into numeric values.

### Permission Values

| Permission | Numeric Value |
|---|---|
| r | 4 |
| w | 2 |
| x | 1 |

### Common Permission Sets

| Numeric | Symbolic | Common Usage |
|---|---|---|
| 755 | rwxr-xr-x | Scripts/directories |
| 644 | rw-r--r-- | Text/config files |
| 700 | rwx------ | Private directories/scripts |
| 600 | rw------- | Sensitive/private files |

### Commands Practiced

```bash
chmod 700 permission-test.txt
chmod 644 permission-test.txt
chmod +x system-info.sh
ls -l
```

### Important Lessons
- Linux permissions are a major security mechanism
- Scripts are not executable by default
- Directories use execute permissions differently than files
- Numeric permissions are heavily used in Linux administration

---

# Bash Scripting

## Created First Bash Script

Script Name:
```text
system-info.sh
```

### Features
- Displays current user
- Displays hostname
- Displays IP address
- Displays current directory
- Displays uptime

### Commands Used

```bash
nano system-info.sh
chmod +x system-info.sh
./system-info.sh
```

### Bash Concepts Learned
- Shebang (`#!/bin/bash`)
- Script execution
- Terminal automation
- File permissions for scripts

### Important Lesson
Linux automation begins with simple Bash scripts combining multiple commands together.

---

# Users And Groups Management

## Investigated Linux User Accounts

Commands used:

```bash
cat /etc/passwd
grep $(whoami) /etc/passwd
id
groups
```

### Important Concepts Learned
- Linux stores user information in `/etc/passwd`
- Not all Linux users are human accounts
- Many service accounts exist for daemons/applications
- Linux security relies heavily on user separation

---

# User Management Practice

## Created Users

```bash
sudo useradd testuser
sudo useradd -m analyst
```

### Important Observation
- `useradd` does not always create home directories automatically
- `-m` creates a home directory

---

# Password Management

Commands used:

```bash
sudo passwd testuser
sudo passwd analyst
```

### Important Lesson
Linux hides password input completely during typing.

---

# Switching Users

Commands used:

```bash
su - analyst
whoami
exit
```

### Problem Encountered

```text
su: Authentication failure
```

### Cause
Password had not yet been configured for `analyst`.

### Resolution

```bash
sudo passwd analyst
```

### Important Lesson
Authentication troubleshooting is a normal Linux administration task.

---

# Group Management

## Created Group

```bash
sudo groupadd developers
```

## Added User To Group

```bash
sudo usermod -aG developers analyst
```

## Verified Membership

```bash
groups analyst
```

### Important Concepts Learned
- Groups simplify permission management
- Linux heavily uses group-based access control
- `-aG` appends supplementary groups

---

# GitHub Workflow

## Updated GitHub Repository

### Workflow Practiced

```bash
git status
git add .
git commit -m "commit message"
git push
```

### Important Lessons
- Git tracks file changes locally
- Commits create history snapshots
- Push uploads commits to GitHub
- VS Code is used for editing files
- Git Bash is used for Git operations

---

# VM Improvements

## Adjusted Rocky Linux Power Settings

- Disabled automatic screen lock
- Disabled aggressive screen timeout behaviour

### Reason
Improves workflow while:
- documenting notes
- switching between VM and Windows
- studying Linux commands

---

# Key Concepts Reinforced Today

- Linux permissions
- User separation
- Privilege management
- Bash scripting
- Authentication troubleshooting
- Group management
- Git workflow consistency

---

# Overall Reflection

Today's session felt significantly more like real Linux administration work rather than isolated command practice.

The connection between:
- permissions
- users
- groups
- scripting
- GitHub documentation

