# Unit 01 — Introduction

**BlueHarbor chapter:** The network is up, but Device Telemetry Ingest is down  
**Status:** NOT STARTED

## Starting estate

Modules 1–3 are already deployed and remain in the cumulative Terraform state.

## New workload introduced here

```text
BlueHarbor Device Telemetry Ingest
TCP/9000
```

The first pilot has a single backend. Its failure demonstrates:

```text
network reachability
!=
application availability
```

Module 4 solves service availability without redesigning the existing VPN, Virtual WAN or ExpressRoute transport.
