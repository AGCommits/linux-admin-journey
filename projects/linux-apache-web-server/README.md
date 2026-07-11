# Linux Apache Web Server Administration

## Overview

This project demonstrates deployment, configuration, management, validation, and auditing of the Apache HTTP Server on Rocky Linux.

It includes a custom website, a named virtual host, an automated deployment script, and a read-only Apache auditing script.

## Objectives

- Install and manage Apache using `dnf` and `systemctl`.
- Deploy a custom website.
- Configure a named Apache virtual host.
- Validate Apache configuration before restarting the service.
- Enable HTTP access through firewalld.
- Apply SELinux-aware website file contexts.
- Verify listening ports and HTTP availability.
- Review Apache access, error, and systemd logs.
- Produce a structured Apache audit report.
- Back up managed configuration files before replacement.

## Project Components

### `apache-deploy.sh`

Performs the controlled system deployment.

### `apache-audit.sh`

Performs a read-only Apache health and configuration audit.

### `linux-admin-site.conf`

Defines the `linux-admin.local` virtual host.

### `index.html`

Provides the website deployed by the project.

## Target URL

```text
http://linux-admin.local/