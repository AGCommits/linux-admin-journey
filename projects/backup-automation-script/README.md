# Backup Automation Script

## Overview

The Backup Automation Script is a Linux Systems Administration project focused on automating compressed backups using Bash.

The project was created using Rocky Linux 9.7 and demonstrates practical skills in Bash scripting, backup creation, file compression, timestamped filenames, backup verification, and logging.

This project forms part of my Linux Systems Administration portfolio.

---

## Objectives

The objectives of this project were to:

- Create a simple Linux backup workflow
- Generate timestamped backup files
- Compress directories using `tar`
- Store backups in a dedicated backup directory
- Verify backup contents after creation
- Write backup activity to a log file
- Document the process clearly

---

## Project Scenario

A simulated source directory was created to represent files that require regular backups.

The project includes a Bash script that:

- Reads from a source directory
- Creates a compressed `.tar.gz` archive
- Stores the archive inside a backup directory
- Verifies the archive contents
- Records successful backup activity in a log file

---

## Project Structure

```text
backup-automation-script
├── documentation
│   └── project-notes.md
├── README.md
└── scripts
    └── backup.sh