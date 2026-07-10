# Service Failure Investigation

## Date

2026-06-06

## Failed Services Found

### mcelog.service

Status:

Failed

Initial Assessment:

Likely related to running Rocky Linux inside a VirtualBox virtual machine where physical CPU hardware monitoring is unavailable.

---

### vboxadd.service

Status:

Failed

Initial Assessment:

Related to VirtualBox Guest Additions installation issues.

Previous troubleshooting identified kernel version mismatches and missing Guest Additions components.

---

### vboxadd-service.service

Status:

Failed

Initial Assessment:

Related to VirtualBox Guest Additions installation issues.

Requires further investigation and potential reinstallation after matching kernel-devel packages.
