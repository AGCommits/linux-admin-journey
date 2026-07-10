# Linux Service Administration - Service Lifecycle

## Purpose

This document records the commands used to manage Linux services with systemd.

---

## Start a Service

```bash
sudo systemctl start service-monitor.service
```

Starts the service if it is not already running.

---

## Stop a Service

```bash
sudo systemctl stop service-monitor.service
```

Stops the running service.

---

## Restart a Service

```bash
sudo systemctl restart service-monitor.service
```

Stops and immediately starts the service.

Useful after changing configuration.

---

## Reload a Service

```bash
sudo systemctl reload service-monitor.service
```

Reloads configuration without fully restarting the service.

Only works if the service supports reload.

---

## Check Service Status

```bash
systemctl status service-monitor.service
```

Displays:

- Current state
- Main process
- Recent log entries
- Exit codes

---

## Check if Running

```bash
systemctl is-active service-monitor.service
```

Possible values:

- active
- inactive
- failed

---

## Check if Enabled

```bash
systemctl is-enabled service-monitor.service
```

Possible values:

- enabled
- disabled
- static

---

## Enable at Boot

```bash
sudo systemctl enable service-monitor.service
```

Starts automatically when Linux boots.

---

## Disable at Boot

```bash
sudo systemctl disable service-monitor.service
```

Prevents automatic startup.
