---

## Test 1 - Manual Script Test

### Objective

Verify that the monitoring script writes heartbeat messages before using systemd.

### Result

Passed.

The script wrote timestamped heartbeat entries to:

```text
reports/service-monitor.log

---

## Test 3 - Automatic Restart

### Objective

Verify that systemd automatically restarts the service after an unexpected failure.

### Commands Used

```bash
systemctl status service-monitor.service
sudo kill <PID>
journalctl -u service-monitor.service -n 20
```

### Result

Passed.

The service process was terminated manually.

systemd detected the failure and automatically restarted the service after five seconds.

A new process ID was assigned.

### Skills Demonstrated

- Service monitoring
- Automatic recovery
- Restart policies
- Failure verification
