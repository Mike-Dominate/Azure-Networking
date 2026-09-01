# Unit 01 — Introduction

**BlueHarbor chapter:** Azure-hosted does not automatically mean privately reachable  
**Status:** NOT STARTED

Module 7 begins with three real requirements:

```text
Manufacturing archive
 -> Azure Storage access restricted to approved subnet identity

Partner Hub data
 -> Azure SQL privately reachable through a VNet private IP

BlueHarbor telemetry
 -> publish BlueHarbor's own service privately to selected consumers
```

These requirements deliberately lead to different technologies rather than using every feature everywhere.

The existing secured Virtual WAN, hybrid DNS, WAF, DDoS, NSGs and applications remain intact.
