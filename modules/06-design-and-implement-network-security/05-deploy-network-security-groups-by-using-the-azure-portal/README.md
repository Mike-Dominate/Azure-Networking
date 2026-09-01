# Unit 05 — Deploy Network Security Groups by using the Azure portal

**BlueHarbor chapter:** Enforce segmentation close to workloads  
**Status:** NOT STARTED

## Business event

Manufacturing applications need selected access to data and shared services, while management and lateral traffic must be restricted.

## Scenario

```text
Manufacturing application subnet  10.20.1.0/24
Manufacturing data subnet         10.20.2.0/24
```

## Concepts to master

- NSG scope and association
- source / destination
- protocol
- source / destination ports
- priority
- allow / deny
- default rules
- stateful behaviour
- subnet versus NIC association
- Application Security Groups (ASGs)

## Deliberate failure

Reason through conflicting rules:

```text
priority 200  deny broad Manufacturing -> Data
priority 300  allow App -> required database port
```

Inspect rule priority and effective configuration rather than guessing why the flow is blocked.

## Study-guide depth

Attach relevant ASG, IP flow verification, VNet flow-log, Bastion/NSG and Virtual Network Manager security-control concepts here where they match the current AZ-700 objective.
