# BlueHarbor Industries — Module 8 Project Story

## Project — Build the BlueHarbor Network Operations Centre

**Status:** NOT STARTED  
**Terraform:** same cumulative state

## Central telemetry

Create:

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
ag-bhi-netops
```

Both regions send appropriate resource diagnostics to the central workspace.

Regional VNet flow-log Storage:

```text
AUE  stbhiflowaue<global_suffix>
SEA  stbhiflowsea<global_suffix>
```

AUE VNet flow logs:

```text
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-connectivity-aue
bhi-vnet-partner-aue
```

SEA VNet flow logs:

```text
bhi-vnet-research-sea
bhi-vnet-partner-sea
```

Traffic Analytics feeds `law-bhi-netops-aue`. Do not manage service-created `NWTA*` DCR/DCE internals.

## Network Watcher / Insights

Discover and reconcile existing AUE/SEA Network Watcher instances rather than duplicating them. Use Network Insights as an operational view over existing topology, not a new appliance.

## NetOps probe

```text
vm-netops-aue
 -> snet-management 10.10.1.0/24
```

Use Connection Monitor for real public/private/hybrid destinations where a supported endpoint exists. Do not invent a Brisbane monitoring source if no real supported source is deployed there.

## Load Balancer monitoring

Target:

```text
lb-telemetry-aue
```

Distinguish:

```text
Health Probe Status / DipAvailability
Data Path Availability / VipAvailability
```

A single failed backend can degrade backend health while the regional service/data path remains available.

## Final deterministic incident

Fault A:

```text
Brisbane Azure SQL namespace forwarding broken
 -> hybrid DNS failure
```

Fault B:

```text
one lb-telemetry-aue backend unhealthy
 -> backend health failure
```

The learner must isolate both with evidence.

## Authoritative troubleshooting ladder

```text
1. Alert / service health
2. Metrics
3. DNS result
4. Connection Monitor / connectivity test
5. NSG / Firewall decision
6. Effective route / next hop / BGP
7. VNet flow logs / Traffic Analytics
8. Resource-specific logs
9. Packet capture when justified
```

## Programme end

Module 8 adds the operations layer to the same cumulative environment. No replacement network is created.
