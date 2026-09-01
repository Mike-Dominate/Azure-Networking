# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the progressive BlueHarbor project. Audit one transition at a time before any BlueHarbor Azure deployment begins.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | **PASS — corrected and approved** |
| 3 | Module 3 -> Module 4 | **PASS — corrected and approved** |
| 4 | Module 4 -> Module 5 | **PASS — corrected and approved** |
| 5 | Module 5 -> Module 6 | **PASS — corrected and approved** |
| 6 | Module 6 -> Module 7 | **PASS — corrected and approved** |
| 7 | Module 7 -> Module 8 | **NEXT** |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS

Module 1 creates the canonical Core, Manufacturing and Research VNets plus DNS, routing, initial peerings and explicit Manufacturing NAT. Module 2 adds classic hybrid connectivity and then evolves production transit to Virtual WAN.

---

# Gate 2 — Module 2 -> Module 3

**Status:** PASS

ExpressRoute is added to the existing Virtual WAN architecture rather than creating a second hub. Brisbane and Perth are the physical-site continuity anchors.

---

# Gate 3 — Module 3 -> Module 4

**Status:** PASS

Device Telemetry Ingest is introduced as TCP/9000 with AUE/SEA public Standard Load Balancers and Traffic Manager Priority failover.

Gate 5 later made SEA outbound explicit with `nat-telemetry-sea`.

### Gate 6 backward compatibility correction

`lb-telemetry-aue` must use NIC-backed backend-pool membership. Module 7 reuses the exact Load Balancer as a Private Link Service provider, so an incompatible Load Balancer backend-pool model would create an unnecessary rebuild.

---

# Gate 4 — Module 4 -> Module 5

**Status:** PASS

Partner Hub is a separate HTTP(S) application with AUE/SEA Partner VNets, regional Application Gateways and global Front Door. Module 5's public Front Door origins are a real intermediate stage.

### Gate 6 forward evolution note

Module 6 hardens the public origins. Module 7 then migrates Front Door Premium to Private-Link-enabled Application Gateway origins using new provider-side Private Link subnets. The original public origin group is not treated as the final architecture.

---

# Gate 5 — Module 5 -> Module 6

**Status:** PASS

Module 6 hardens the actual cumulative estate using DDoS, NSG/ASG, Azure Firewall in both existing Virtual WAN hubs, Firewall Policy, secured-hub routing intent, WAF and origin-bypass restrictions.

Partner backend NAT egress is intentionally replaced by firewall egress. Telemetry NAT remains for public Load Balancer symmetry. Direct Module 1 peerings are retired once they would bypass centrally inspected private transit.

---

# Gate 6 — Module 6 -> Module 7

**Status:** PASS

## Problem resolved

The original Module 7 described generic "Storage / SQL / App Service" possibilities and optional Private Link Service/App Service integration. That was too ambiguous for a cumulative build.

Gate 6 fixes exact workloads, subnets, DNS ownership and migration paths.

## Service Endpoint target — FIXED

Manufacturing uses the existing data subnet:

```text
snet-mfg-data 10.20.2.0/24
 -> Microsoft.Storage service endpoint
 -> restricted Azure Storage archive account
 -> Storage service endpoint policy where supported
```

Do not use `snet-mfg-app`; that subnet carries the public telemetry Load Balancer service and has different routing constraints.

## Azure SQL Private Endpoint target — FIXED

Partner AUE adds:

```text
snet-private-endpoints 10.40.3.0/24
```

Canonical PaaS target:

```text
Azure SQL logical server + Partner database
 -> SQL Private Endpoint
 -> privatelink.database.windows.net
```

After private application/hybrid validation, disable SQL public network access according to the current service model.

## App Service VNet Integration — MADE REAL

Partner `/orders` migrates to App Service.

Add:

```text
snet-appsvc-integration 10.40.4.0/26
```

with the current required App Service subnet delegation.

Flow:

```text
Application Gateway WAF_v2
 -> App Service Private Endpoint
 -> App Service `/orders`
 -> VNet Integration
 -> SQL Private Endpoint
```

This preserves the distinction between App Service outbound VNet Integration and private inbound/service reachability via Private Endpoint.

## Private Link Service — MADE REAL

Reuse:

```text
lb-telemetry-aue Standard
TCP/9000
NIC-backed backend membership
```

Provider addition:

```text
snet-pls-nat 10.20.3.0/27
pls-telemetry-aue
```

Consumer addition:

```text
bhi-vnet-core-aue
snet-private-endpoints 10.10.20.0/24
consumer PE -> pls-telemetry-aue
```

Use `services.blueharbor.internal` for the BlueHarbor-owned private service naming path.

Brisbane/Perth consume the service through the existing hybrid network and Core DNS resolver path.

## Private DNS / hybrid forwarding — FIXED

Private zones include the current service-specific zones such as:

```text
privatelink.database.windows.net
privatelink.azurewebsites.net
```

Hybrid DNS uses the existing Core DNS Private Resolver. For Azure SQL, on-premises conditional forwarding targets the appropriate public service namespace (for example `database.windows.net`) toward Azure so Azure DNS can follow the CNAME into the linked private zone.

## PE routing in secured Virtual WAN — FIXED

Private Endpoint subnets use the current network-policy mode required for NSG/route-table enforcement and symmetric hybrid routing.

Do not claim Azure Firewall automatically sees same-VNet Private Endpoint traffic. Same-VNet flows require explicit local subnet/NSG/UDR reasoning.

For branch/on-premises -> PE flows, validate route and return-path behaviour through the secured Virtual WAN.

## Front Door origin privacy — ADDED

Module 6 left Front Door Premium with hardened public Application Gateway origins. Module 7 progresses to Private Link.

Add:

```text
AUE snet-appgw-pl 10.40.5.0/27
SEA snet-appgw-pl 10.50.3.0/27
```

Migration:

```text
public origin group
 -> create private-link origin group
 -> approve AUE/SEA private connections
 -> validate health
 -> switch route
 -> validate end-to-end
 -> retire public origin data path after rollback window
```

Do not mix public and Private-Link-enabled origins in a single origin group when current service behaviour does not support that combination.

## Canonical Module 7 address delta

```text
CORE AUE
10.10.20.0/24   snet-private-endpoints

MFG AUE
10.20.3.0/27    snet-pls-nat

PARTNER AUE
10.40.3.0/24    snet-private-endpoints
10.40.4.0/26    snet-appsvc-integration
10.40.5.0/27    snet-appgw-pl

PARTNER SEA
10.50.3.0/27    snet-appgw-pl
```

No new VNet/hub is introduced.

## Gate 6 verdict

```text
Story handoff                         PASS
Service Endpoint target               PASS — Manufacturing data -> Storage
Service endpoint policy               PASS — Storage-specific design
Private Endpoint target               PASS — Azure SQL
Private Endpoint subnet               PASS
Secured-vWAN PE routing               PASS with network-policy/route validation
Hybrid PE DNS                         PASS
SQL public exposure                   PASS — disable after private proof
App Service VNet Integration          PASS — real `/orders` modernization
App Service integration subnet        PASS
Private Link Service                  PASS — existing telemetry LB
PLS NAT subnet                        PASS
Module 4 LB compatibility             PASS — NIC-backed pool contract
PLS hybrid/on-prem integration        PASS — Core consumer PE
Front Door Private Link               PASS — private AppGW origin migration
Terraform continuity                  PASS
```

---

# Gate 7 — Module 7 -> Module 8

**Status:** NEXT

Audit next:

- which exact resources receive diagnostic settings and where logs/metrics land;
- whether one or multiple Log Analytics workspaces are justified;
- how Azure Monitor Network Insights represents the real multi-hub estate;
- exact Connection Monitor source/destination pairs across VNet, branch, PaaS PE and public service paths;
- where VNet flow logs are enabled and how Traffic Analytics is connected;
- how Network Watcher automatic regional enablement is represented in Terraform without duplicate-resource conflicts;
- which Load Balancer is used by the Microsoft monitoring exercise;
- alert rules for backend health, firewall/network conditions and key private-path failures;
- whether DDoS, WAF, Firewall, Front Door, Application Gateway, Private Endpoint and DNS evidence all land in an observable operating model;
- how the final incident/capstone proves troubleshooting across the complete cumulative environment.
