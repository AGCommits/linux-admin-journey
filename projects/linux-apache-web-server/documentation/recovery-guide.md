# Recovery Guide

## Purpose

This document provides recovery procedures for the Linux Apache Web Server project.

The project consists of a deployment script and an audit script. The deployment script installs and configures Apache for this project, while the audit script performs read-only validation of the completed deployment.

Recovery procedures focus on restoring the Apache service and validating the web server after configuration changes.

---

# Common Issues

## Deployment Script Will Not Execute

### Symptoms

```text
Permission denied
```

### Resolution

Make the deployment script executable:

```bash
chmod +x scripts/apache-deploy.sh
```

or execute it directly with Bash:

```bash
bash scripts/apache-deploy.sh
```

---

## Audit Script Will Not Execute

### Resolution

Run:

```bash
chmod +x scripts/apache-audit.sh
```

or

```bash
bash scripts/apache-audit.sh
```

---

## Bash Syntax Errors

Validate both scripts:

```bash
bash -n scripts/apache-deploy.sh
bash -n scripts/apache-audit.sh
```

Correct any reported syntax errors before continuing.

---

## Apache Service Not Running

### Resolution

Verify service status:

```bash
systemctl status httpd
```

Start the service:

```bash
sudo systemctl start httpd
```

Enable Apache during boot:

```bash
sudo systemctl enable httpd
```

---

## Apache Configuration Errors

### Resolution

Validate the configuration:

```bash
sudo apachectl configtest
```

If errors are reported, review the affected configuration file and rerun the validation until Apache reports:

```text
Syntax OK
```

---

## Website Not Accessible

### Resolution

Verify Apache is listening:

```bash
ss -lnt
```

Verify the service:

```bash
systemctl status httpd
```

Test locally:

```bash
curl http://localhost
```

---

## Virtual Host Problems

### Resolution

Confirm the Virtual Host configuration exists inside:

```text
/etc/httpd/conf.d/
```

Validate the configuration:

```bash
sudo apachectl configtest
```

Restart Apache if required:

```bash
sudo systemctl restart httpd
```

---

## Firewall Problems

### Resolution

Verify firewalld:

```bash
systemctl status firewalld
```

Check the current configuration:

```bash
firewall-cmd --list-all
```

If HTTP traffic is blocked, update the firewall configuration as required before rerunning the audit.

---

## Audit Report Not Generated

### Resolution

Verify the reports directory:

```bash
ls -la reports
```

If necessary:

```bash
mkdir -p reports
```

Run the audit again:

```bash
bash scripts/apache-audit.sh
```

---

## Git Synchronisation Issues

### Resolution

Verify repository status:

```bash
git status
git pull --rebase origin main
git push origin main
```

Resolve any merge conflicts before continuing.

---

# Safe Recovery

The deployment script performs only the configuration required for this project.

The audit script is read-only.

Recovery generally consists of correcting the Apache configuration or service state before rerunning the audit.

---

# Verification

Following recovery, verify:

```bash
sudo apachectl configtest

systemctl status httpd

curl http://localhost

bash scripts/apache-audit.sh
```

Confirm:

* Apache is running.
* Configuration is valid.
* Website loads successfully.
* Audit report is generated.
* Overall assessment is successful.

---

# Summary

The Linux Apache Web Server project provides straightforward recovery procedures by validating Apache configuration, confirming service status, and rerunning the deployment or audit scripts where necessary.
