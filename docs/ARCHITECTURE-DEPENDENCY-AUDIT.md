# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the progressive BlueHarbor project. The transition gates are now complete; a final whole-programme closeout is required before implementation begins.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | **PASS — corrected and approved** |
| 3 | Module 3 -> Module 4 | **PASS — corrected and approved** |
| 4 | Module 4 -> Module 5 | **PASS — corrected and approved** |
| 5 | Module 5 -> Module 6 | **PASS — corrected and approved** |
| 6 | Module 6 -> Module 7 | **PASS — corrected and approved** |
| 7 | Module 7 -> Module 8 | **PASS — corrected and approved** |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gates 1–6 — approved contracts

The earlier gates establish one cumulative architecture:

```text
M1
Core / Manufacturing / Research VNets
DNS / routing / initial NAT

M2
classic VPN learning -> Virtual WAN production transit

M3
ExpressRoute added to the existing AUE Virtual WAN hub

M4
Telemetry TCP/9000
AUE/SEA Standard Load Balancers
Traffic Manager

M5
Partner AUE/SEA VNets
regional Application Gateways
Front Door

M6
DDoS / NSG / ASG
AUE + SEA secured Virtual WAN / Azure Firewall
WAF / origin hardening

M7
Storage service endpoint
Azure SQL + App Service Private Endpoints
App Service VNet Integration
telemetry Private Link Service
Front Door -> Application Gateway Private Link
```

Backward corrections discovered by later gates remain authoritative, including:

- hybrid DNS resolver subnets in Core;
- AUE/SEA Virtual Hub `/22` sizing;
- `nat-telemetry-sea` explicit outbound;
- NIC-backed `lb-telemetry-aue` backend membership;
- retirement of direct peerings after secured private transit is proven.

---

# Gate 7 — Module 7 -> Module 8

**Status:** PASS

## Problem resolved

Module 8 correctly intended to monitor the cumulative estate but left workspace topology, flow-log Storage, Network Watcher ownership, monitored paths, alerting and the final incident too vague.

The approved correction turns Module 8 into an explicit operations architecture.

## Central Log Analytics — FIXED

Create:

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
```

Appropriate diagnostic logs from AUE and SEA resources land in the same workspace for cross-service correlation.

## Regional flow-log Storage — FIXED

VNet flow logs use region-local Storage:

```text
AUE  st-bhi-flow-aue-<unique>
SEA  st-bhi-flow-sea-<unique>
```

VNet flow logs are enabled on all six BlueHarbor VNets:

```text
AUE
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-connectivity-aue
bhi-vnet-partner-aue

SEA
bhi-vnet-research-sea
bhi-vnet-partner-sea
```

Traffic Analytics feeds the central Log Analytics workspace.

New NSG flow logs are prohibited in the BlueHarbor design.

## Traffic Analytics ownership — FIXED

Terraform owns the workspace, flow-log Storage, VNet flow-log resources/configuration and Traffic Analytics enablement.

Do not manage Azure service-created `NWTA*` DCR/DCE internals.

## Regional Network Watcher ownership — FIXED

Network Watcher may already be auto-enabled because earlier VNets exist in both regions.

Module 8 must:

```text
discover
 -> reference/import/reconcile existing regional instances
 -> create only if genuinely absent
```

No blind duplicate Network Watcher creation.

## Network Insights — FIXED

Use Azure Monitor Network Insights as an operational topology/health experience over existing network resources. It does not introduce a new BlueHarbor VNet/appliance.

## NetOps probe / Connection Monitor — FIXED

Add a real source in the existing Core management subnet:

```text
vm-netops-aue
 -> snet-management 10.10.1.0/24
```

Representative Connection Monitor tests:

```text
Front Door endpoint               TCP/443
Partner SQL Private Endpoint      TCP/1433
telemetry PLS private service     TCP/9000
Brisbane target                   where a real reachable target exists
```

Do not claim continuous Brisbane-source monitoring unless a supported real/Arc-enabled source exists.

## Microsoft Load Balancer exercise — FIXED

Exact target:

```text
lb-telemetry-aue
```

Correlate:

```text
Health Probe Status / DipAvailability
Data Path Availability / VipAvailability
```

A single failed backend should degrade backend-health evidence without necessarily making the whole regional service/data path unavailable.

## Alerting — FIXED

Create:

```text
ag-bhi-netops
```

Notification receiver values remain sensitive/ignored inputs.

Initial alerts focus on explainable Tier-1 signals such as Load Balancer health, Connection Monitor failures, critical hybrid/firewall/app-delivery conditions, DDoS signals and Resource Health.

## Diagnostic scope — FIXED

Centralize appropriate diagnostic logs for at least:

```text
AUE + SEA Azure Firewall
AUE + SEA Application Gateway WAF_v2
Front Door Premium
active VPN / Virtual WAN gateway resources
ExpressRoute where live
subscription Activity Log
```

Use current resource-specific logging modes/categories and validate them at implementation time.

## DNS operations — FIXED

DNS Private Resolver metrics show resolver health/activity but do not prove a particular critical name resolves correctly.

Operations combines resolver metrics with synthetic DNS tests, especially comparing Azure and Brisbane answers for Partner SQL private access.

## Final incident — FIXED

The final deterministic incident contains two independent faults:

```text
Fault A
Brisbane SQL namespace forwarding broken
 -> hybrid DNS problem

Fault B
one lb-telemetry-aue backend unhealthy
 -> backend-health problem
```

The learner must isolate both with evidence rather than being told which product is broken.

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

## Gate 7 verdict

```text
M7 -> M8 story                     PASS
Monitoring existing estate         PASS
Central Log Analytics              PASS
Regional flow-log Storage          PASS
VNet flow-log scope                PASS — all six VNets
New NSG flow logs                  PASS — prohibited
Traffic Analytics ownership        PASS
Network Watcher ownership          PASS — discover/reconcile
Network Insights                   PASS
Connection Monitor                 PASS — real NetOps source + real targets
Load Balancer exercise             PASS — lb-telemetry-aue
LB health metrics                  PASS
Alert model                        PASS
Hybrid monitoring honesty         PASS
DNS synthetic evidence             PASS
Final deterministic incident       PASS
Terraform continuity               PASS
```

---

# Transition-audit result

```text
GATE 1  PASS
GATE 2  PASS
GATE 3  PASS
GATE 4  PASS
GATE 5  PASS
GATE 6  PASS
GATE 7  PASS
```

## Next gate

There is no Gate 8.

Before implementation, perform one **whole-programme architecture closeout** that checks the combined final contracts for:

```text
IP overlap / subnet reservations
canonical names / regions
resource dependency order
intentional replacements and retirements
special subnet policies
Terraform ownership/import boundaries
DNS-zone/link/forwarding consistency
routing/security exceptions
monitoring dependencies
```

If that closeout passes, formal execution begins at **Module 1, Unit 01**.
