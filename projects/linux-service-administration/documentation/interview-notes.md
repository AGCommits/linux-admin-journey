# Interview Talking Points

## Explain the Project

I created a custom Linux service using Bash and systemd.

The project included deployment, service management, troubleshooting, automatic recovery, and documentation.

---

## Skills Demonstrated

- systemctl
- journalctl
- Bash scripting
- Service management
- Linux troubleshooting
- Process monitoring

---

## Biggest Challenge

The service initially failed with status=203/EXEC because systemd could not execute the script from the user's home directory.

I investigated the issue using journalctl and relocated the executable to `/usr/local/bin`.

---

## Key Learning

A working Bash script is not automatically production-ready.

Deployment location, permissions, and service configuration all influence how systemd executes applications.
