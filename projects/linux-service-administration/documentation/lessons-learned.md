# Lessons Learned

## What I Learned

- How systemd manages Linux services.
- How to create a custom service file.
- How to deploy scripts correctly.
- How to diagnose service failures.
- How journalctl complements application logs.
- How restart policies improve reliability.
- Why Linux services should be installed outside a user's home directory.
- The importance of testing before deployment.

---

## Challenges

The service initially failed with:

status=203/EXEC

Investigation using systemctl and journalctl identified that systemd could not execute the script from the original location.

Moving the executable to `/usr/local/bin` resolved the issue.

---

## Improvements

Possible future enhancements include:

- Configuration file support
- Log rotation
- Email alerting
- Health check API
- Multiple service instances
