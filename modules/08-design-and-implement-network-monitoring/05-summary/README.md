# Unit 05 — Summary

**BlueHarbor chapter:** Final production incident and programme operations review  
**Status:** NOT STARTED

## Deterministic multi-fault incident

Operations receives two concurrent symptoms. The learner is not told that they are separate root causes.

### Fault A — Brisbane private-data access

Break the Brisbane conditional-forwarding path for the Partner Azure SQL namespace.

Expected evidence:

```text
Azure workload
  database.windows.net -> SQL private IP

Brisbane engineer
  database.windows.net -> wrong/public answer or resolution failure
```

Required conclusion:

```text
PE exists
Azure private DNS works
Azure route works
Brisbane answer differs
 -> hybrid DNS fault domain
```

Do not recreate the Private Endpoint merely because a Brisbane application says SQL is unavailable.

### Fault B — AUE telemetry degradation

Make one backend behind `lb-telemetry-aue` unhealthy.

Expected evidence:

```text
one backend unhealthy
TCP/9000 service still available through healthy backend
Health Probe Status degrades
Data Path Availability may remain healthy
alert/metric identifies backend condition
```

The learner must prove that this failure is unrelated to the Brisbane DNS issue.

## Evidence-led investigation

Use the operating ladder:

```text
1. Alert / service health
2. Metrics
3. DNS
4. Connection Monitor / connectivity test
5. NSG / Firewall decision
6. Effective route / next hop / BGP
7. VNet flow logs / Traffic Analytics
8. Resource-specific logs
9. Packet capture when justified
```

## Explain-back

Be able to explain:

- central Log Analytics versus regional flow-log Storage;
- metrics versus logs versus flow data;
- Load Balancer backend health versus data-path availability;
- Network Insights versus Network Watcher troubleshooting tools;
- why auto-created regional Network Watchers must be reconciled rather than duplicated;
- why synthetic DNS validation is still required even when DNS Private Resolver metrics are healthy;
- why Connection Monitor source capability must be real, especially for on-premises sources;
- why VNet flow logs do not represent Virtual WAN hub telemetry;
- why Traffic Analytics service-managed internals are outside BlueHarbor Terraform ownership;
- how to isolate a hybrid-DNS fault from an application/backend-health fault.

## Programme end state

```text
M1 network foundation
 -> M2 hybrid connectivity
 -> M3 enterprise private connectivity
 -> M4 service availability
 -> M5 HTTP(S) delivery
 -> M6 security
 -> M7 private access
 -> M8 observability / operations
```

All persistent project infrastructure belongs to the same `blueharbor/terraform/` root and one state lineage.

## Next step after the architecture audit

The seven module-transition gates are audited before implementation begins. After the short whole-programme closeout confirms naming, addressing and cross-gate consistency, formal execution starts at:

```text
Module 1
Unit 01 — Introduction
```
