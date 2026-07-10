# Linux Service Administration - Service Logging

## Purpose

This document explains how service logs can be viewed using journalctl.

---

## View Complete Service Log

```bash
journalctl -u service-monitor.service
```

---

## View Recent Entries

```bash
journalctl -u service-monitor.service -n 20
```

---

## View Logs Without Pagination

```bash
journalctl -u service-monitor.service --no-pager
```

---

## Follow Logs Live

```bash
journalctl -u service-monitor.service -f
```

---

## View Logs Since Boot

```bash
journalctl -u service-monitor.service -b
```

---

## Why journalctl?

journalctl provides a central logging system for services managed by systemd.

Instead of every application writing its own log format, administrators have one consistent location for investigating services.

---

## Log Comparison

### systemd Journal

The command:

```bash
journalctl -u service-monitor.service -n 15 --no-pager
