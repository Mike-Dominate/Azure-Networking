# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the progressive BlueHarbor project. Audit one transition at a time before any BlueHarbor Azure deployment begins.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | **PASS — corrected and approved** |
| 3 | Module 3 -> Module 4 | **PASS — corrected and approved** |
| 4 | Module 4 -> Module 5 | **NEXT** |
| 5 | Module 5 -> Module 6 | PENDING |
| 6 | Module 6 -> Module 7 | PENDING |
| 7 | Module 7 -> Module 8 | PENDING |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS

## Canonical Module 1 network contract

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24

bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

Module 1 also carries DNS, direct peerings, routing and selected workload NAT.

### Gate 3 NAT clarification

The selected NAT contract is now explicit:

```text
snet-mfg-app
 -> nat-mfg-aue
 -> explicit NAT public-IP resource
```

This remains deployed and is reused by the Module 4 AUE telemetry backends.

## Classic Module 2 addition

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26
```

plus classic VPN/S2S/P2S learning resources.

Hybrid DNS resolver endpoint subnets belong in `bhi-vnet-core-aue`:

```text
snet-dns-inbound    10.10.10.0/28
snet-dns-outbound   10.10.10.16/28
```

---

# Gate 2 — Module 2 -> Module 3

**Status:** PASS

Approved progression:

```text
classic VPN edge
 -> S2S / P2S / gateway-transit learning
 -> Virtual WAN becomes active production transit
 -> ExpressRoute is added to that SAME Virtual WAN hub
 -> ExpressRoute preferred for approved critical routes
 -> VPN retained as alternate path
```

Canonical active Module 2 transit:

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       +-- Brisbane 172.16.0.0/16
       +-- Perth    172.17.0.0/16
       +-- approved remote users
       +-- Core / Manufacturing / Research VNet connections
```

Reserved:

```text
bhi-vhub-sea   10.200.4.0/22
```

Module 3 adds the Virtual WAN ExpressRoute gateway/circuit/private-peering/BGP design to `bhi-vhub-aue`; it does not create another Core VNet gateway topology.

Global Reach reuses Brisbane + Perth. FastPath eligibility remains an internal Module 3 design dependency tied to the actual circuit/gateway model.

---

# Gate 3 — Module 3 -> Module 4

**Status:** PASS

## Problem resolved

Module 4 previously referred to a telemetry backend that had never been created and later assumed multiple regional endpoints existed without introducing the second region's service.

Approved correction: Module 4 explicitly introduces a new non-HTTP production workload and builds each regional endpoint in sequence on the existing BlueHarbor network.

## New workload introduced in Module 4

```text
BlueHarbor Device Telemetry Ingest
Protocol: TCP
Service port: 9000
```

This workload did not exist in Module 3. It is the new Module 4 business event.

## Australia East placement

Reuse:

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
```

Add:

```text
vm-telemetry-aue-01
vm-telemetry-aue-02
backend NICs
minimal functional NSG
pip-telemetry-aue
lb-telemetry-aue   Standard / public
TCP/9000 rule
TCP/9000 health probe
```

The existing Module 1 NAT association on `snet-mfg-app` remains the explicit backend-initiated outbound path. Module 4 does not add a second AUE outbound design merely because a public Load Balancer exists.

## Public frontend decision — FIXED

The telemetry producers include field/customer equipment outside BlueHarbor's private WAN, so the regional telemetry services are intentionally Internet facing.

A public Standard Load Balancer also provides an appropriate real regional endpoint for later Traffic Manager monitoring/selection.

## Minimal security boundary

Module 4 adds only enough NSG policy to permit the required TCP/9000 service traffic and Azure Load Balancer health-probe traffic. Full segmentation/security architecture remains Module 6 scope.

## Backend failure semantics — FIXED

```text
one backend unhealthy
 -> regional Load Balancer removes it from new-flow eligibility
 -> regional service can remain healthy
```

This is distinct from complete regional service failure.

## Southeast Asia DR endpoint — ADDED DELIBERATELY

Reuse:

```text
bhi-vnet-research-sea   10.30.0.0/16
```

Add in Module 4 Unit 05:

```text
snet-telemetry-dr       10.30.3.0/24
vm-telemetry-sea-01
vm-telemetry-sea-02
minimal functional NSG
pip-telemetry-sea
lb-telemetry-sea   Standard / public
TCP/9000 rule/probe
```

No second regional VNet is invented.

## Traffic Manager endpoints — FIXED

Traffic Manager is added only after both regional public telemetry services exist.

Approved BlueHarbor policy:

```text
tm-telemetry-global
  |
  +-- Priority 1 -> Australia East public telemetry endpoint
  +-- Priority 2 -> Southeast Asia public telemetry endpoint

monitor -> TCP/9000
```

Regional public IPs use valid unique DNS labels as required by the selected endpoint model.

## Health versus policy eligibility — EXPLICIT

While AUE is healthy:

```text
AUE = healthy + selected
SEA = healthy + enabled + not selected because lower priority
```

This gives a concrete distinction between endpoint health and routing-policy selection.

## Two-level availability model

```text
BACKEND FAILURE
one AUE backend fails
 -> AUE Load Balancer keeps service available
 -> Traffic Manager continues selecting AUE

REGIONAL SERVICE FAILURE
AUE regional service becomes unhealthy
 -> Traffic Manager changes DNS selection to SEA
 -> DNS TTL/resolver/client caching affects observed cutover
```

## Transport architecture — PRESERVED

Module 4 does not redesign:

```text
VPN
Virtual WAN
bhi-vhub-aue
ExpressRoute
hybrid DNS
Core connectivity
```

It is an application-availability delta on top of the existing transport.

## Gate 3 resulting dependency chain

```text
END MODULE 3
network / hybrid / ExpressRoute estate
        |
        +
        v
MODULE 4
AUE telemetry service in existing Manufacturing subnet
        +
SEA telemetry DR service in existing Research VNet
        +
Traffic Manager Priority failover
```

## Gate 3 verdict

```text
Story transition                  PASS
Application workload existence    PASS
AUE backend placement             PASS
Load Balancer frontend choice     PASS — public Standard
Non-HTTP workload                 PASS — TCP/9000
Terraform continuity              PASS
Module 1 NAT reuse                PASS
Regional second endpoint          PASS
SEA address plan                  PASS — 10.30.3.0/24
Traffic Manager targets           PASS
Traffic Manager policy            PASS — Priority
Traffic Manager health protocol   PASS — TCP/9000
Failure hierarchy                 PASS
Transport architecture            PASS — unchanged
```

---

# Gate 4 — Module 4 -> Module 5

**Status:** NEXT

Audit next:

- Partner Hub is a distinct HTTP(S) application, not a relabelled telemetry service;
- where the Partner Hub application backends live in the existing address plan;
- whether Application Gateway needs a dedicated subnet planned before deployment;
- whether Australia East and Southeast Asia both need Partner Hub origins for Front Door;
- how Front Door origins map to the actual Application Gateway/app resources;
- whether TLS/DNS/public endpoint decisions are consistent with Module 6 WAF and Module 7 private-access requirements;
- what Module 5 adds without disturbing the Module 4 telemetry service.
