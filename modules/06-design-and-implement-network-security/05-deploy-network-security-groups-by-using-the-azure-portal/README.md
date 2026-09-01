# Unit 05 — Deploy Network Security Groups by using the Azure portal

**BlueHarbor chapter:** Turn minimal functional rules into deliberate segmentation  
**Status:** NOT STARTED

## Manufacturing target

Module 4 already created telemetry/application resources in:

```text
snet-mfg-app   10.20.1.0/24
```

Add a small internal controlled test data target in the already-existing:

```text
snet-mfg-data  10.20.2.0/24
```

Canonical identities:

```text
asg-mfg-app
asg-mfg-data
vm-mfg-data-01 / controlled test data service
```

Policy intent:

```text
asg-mfg-app -> asg-mfg-data on approved test-data port   ALLOW
unnecessary lateral access                              DENY
management                                               approved source only
```

The existing minimal telemetry NSG is evolved rather than discarded.

## Partner target

Harden `snet-partner-app` in both regions so backend access is limited to the intended Application Gateway/application flows and unnecessary lateral traffic is denied.

## Concepts to master

- NSG association/scope;
- stateful behaviour;
- priorities;
- subnet vs NIC association;
- ASGs;
- effective rules;
- IP Flow Verify / equivalent diagnostics;
- VNet flow-log concepts at the current product level.

Deliberately introduce one priority conflict and prove the winning rule with evidence.
