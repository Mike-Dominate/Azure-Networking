# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the progressive BlueHarbor project. Audit one transition at a time before any BlueHarbor Azure deployment begins.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | **PASS — corrected and approved** |
| 3 | Module 3 -> Module 4 | **NEXT** |
| 4 | Module 4 -> Module 5 | PENDING |
| 5 | Module 5 -> Module 6 | PENDING |
| 6 | Module 6 -> Module 7 | PENDING |
| 7 | Module 7 -> Module 8 | PENDING |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS

## Module 1 end-state contract

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

Carry forward DNS, direct peerings, routing, selected workload NAT and the same Terraform state.

## Classic Module 2 addition

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26

VPN Gateway
Brisbane S2S
classic P2S pool 172.31.240.0/24
classic gateway-transit relationships during the early VPN stage
```

### Gate 2 revision to Gate 1 DNS reservation

The original Gate 1 draft placed future DNS Private Resolver endpoint subnets in the connectivity VNet. Gate 2 corrected this before deployment.

Canonical placement is now:

```text
bhi-vnet-core-aue
  snet-dns-inbound    10.10.10.0/28
  snet-dns-outbound   10.10.10.16/28
```

Reason: hybrid DNS belongs with Core/Shared Services and must not be coupled to the legacy classic VPN-gateway VNet that cannot become an ordinary Virtual WAN spoke.

## Guardrails retained from Gate 1

- canonical resource names only;
- Module 2 starts from deployed Module 1 code/state/resources;
- no blind NAT/NSG/UDR application to special-purpose subnets;
- IP reachability and DNS resolution validated independently;
- gateway transit explicitly configured rather than assumed;
- no new Terraform root/state per module.

---

# Gate 2 — Module 2 -> Module 3

**Status:** PASS

## Problem resolved

Module 2 teaches classic VPN Gateway first, then introduces Virtual WAN. Module 3 introduces ExpressRoute. Without an explicit transition, these could become three disconnected hub designs.

Approved progression:

```text
classic VPN edge
 -> learn S2S / P2S / gateway transit
 -> scale problem appears
 -> Virtual WAN becomes active production transit
 -> ExpressRoute is added to that SAME Virtual WAN hub
 -> ExpressRoute preferred for approved critical routes
 -> VPN retained as alternate path
```

## Canonical Module 2 end state

Module 1 resources remain deployed.

Classic resources also remain in Terraform:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
GatewaySubnet               10.100.255.0/26
classic VPN Gateway
classic S2S/P2S Azure objects
```

They represent the first hybrid stage but no longer own the workload VNets' production transit after Virtual WAN migration.

### Active production transit

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       |
       +-- Brisbane 172.16.0.0/16
       +-- Perth    172.17.0.0/16
       +-- approved remote users
       +-- VNet connections
            +-- bhi-vnet-core-aue
            +-- bhi-vnet-mfg-aue
            +-- bhi-vnet-research-sea
```

Reserve for future use without deploying yet:

```text
bhi-vhub-sea   10.200.4.0/22
```

The `/22` hub contract is deliberately chosen early enough for later secured-hub/Azure Firewall requirements.

## Intentional classic -> Virtual WAN migration

Workload VNets cannot be treated as though classic `use_remote_gateways` and Virtual WAN gateway ownership coexist with no change.

When Virtual Hub VNet connections are activated:

```text
classic workload-side remote-gateway dependency
 -> intentionally disabled/changed

Virtual Hub VNet connections
 -> added
```

Terraform must show these as reviewed in-place/configuration changes. Direct Module 1 VNet peerings remain unless a later requirement explicitly changes them.

## Perth continuity — FIXED

Perth no longer appears magically at the start of Module 3.

It becomes the first scale-out branch in Module 2 Unit 06/07 and participates in the Virtual WAN end state.

## Hybrid DNS placement — FIXED

DNS Private Resolver endpoint subnets are added to `bhi-vnet-core-aue`, not `bhi-vnet-connectivity-aue`.

This lets hybrid DNS remain part of the shared-services architecture as connectivity evolves from VPN to Virtual WAN to ExpressRoute.

## Module 3 ExpressRoute topology — FIXED

Do not create another Core VNet ExpressRoute gateway as BlueHarbor's persistent architecture.

Microsoft's classic VNet ExpressRoute gateway model is learned and compared, but BlueHarbor implements:

```text
ExpressRoute circuit
        |
Virtual WAN ExpressRoute Gateway
        |
bhi-vhub-aue
        |
existing workload VNet connections
```

No `CoreServicesVnet` alias and no second hub topology.

## VPN coexistence / resiliency contract

Target production intent:

```text
ExpressRoute = preferred for approved critical routes
VPN          = alternate / recovery path
```

The exact current Virtual WAN routing preference/propagation settings must be explicitly verified during implementation. Do not rely on an unstated default.

## Global Reach continuity — FIXED

Use established physical sites:

```text
Brisbane <-> ExpressRoute Global Reach concept <-> Perth
```

Do not invent a Singapore physical office. Southeast Asia remains an Azure-region requirement unless a later business event explicitly creates a site there.

## FastPath — internal Module 3 dependency, not Gate 2 blocker

Unit 03 must record the chosen provider/ExpressRoute Direct and gateway design. Unit 09 must test that choice against current FastPath eligibility.

If the cumulative design is not eligible, teach the supported architecture and explain the gap; do not create a separate ExpressRoute environment merely to claim FastPath.

## Gate 2 resulting dependency chain

```text
END MODULE 2

Module 1 estate
+ classic VPN edge retained
+ bhi-vwan
+ bhi-vhub-aue 10.200.0.0/22
+ Brisbane / Perth / remote users
+ workload VNet connections
+ hybrid DNS in Core
        |
        +
        v
MODULE 3

ExpressRoute design
+ Virtual WAN ExpressRoute Gateway
+ ExpressRoute circuit/provider boundary
+ private peering / BGP
+ route preference / resiliency
+ Global Reach using Brisbane + Perth
+ FastPath eligibility analysis
```

## Gate 2 verdict

```text
Story transition                 PASS
Perth continuity                 PASS
Canonical naming                 PASS
Classic VPN -> vWAN evolution    PASS
Hybrid DNS placement             PASS
Virtual Hub sizing               PASS
ExpressRoute gateway topology    PASS
VPN / ExpressRoute coexistence   PASS with explicit routing validation
Global Reach site continuity     PASS
FastPath                         TRACKED INSIDE MODULE 3
```

---

# Gate 3 — Module 3 -> Module 4

**Status:** NEXT

Audit next:

- what exact application/service workload exists by the end of Module 3;
- whether Module 4's Load Balancer backends already exist or appear magically;
- where the regional Load Balancer lives and which VNet/subnet it reuses;
- whether public/internal frontend choices fit the security and later Module 5 story;
- how Traffic Manager endpoints map to real regional services;
- whether Southeast Asia needs a real application deployment by this point;
- what Terraform resources Module 4 adds without changing the transport architecture unnecessarily.
