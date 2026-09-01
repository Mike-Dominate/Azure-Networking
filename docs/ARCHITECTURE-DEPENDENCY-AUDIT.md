# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the full progressive project.

The audit is intentionally performed one transition at a time before any new BlueHarbor Azure resources are deployed.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | PENDING |
| 3 | Module 3 -> Module 4 | PENDING |
| 4 | Module 4 -> Module 5 | PENDING |
| 5 | Module 5 -> Module 6 | PENDING |
| 6 | Module 6 -> Module 7 | PENDING |
| 7 | Module 7 -> Module 8 | PENDING |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity all agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS  
**Decision:** Module 2 must start from the exact deployed Terraform state produced by Module 1.

## Canonical Module 1 end-state contract

### Australia East

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24
```

### Southeast Asia

```text
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

### Module 1 capabilities that remain deployed

```text
three canonical VNets/subnets
private DNS architecture and VNet links
Core <-> Manufacturing peering
Core <-> Research global peering
routing / UDR learning configuration
selected workload NAT Gateway association(s)
all Terraform code and the same state lineage
```

## Canonical Module 2 additions

Module 2 does not place the classic VPN Gateway inside a workload VNet.

It adds a dedicated connectivity VNet:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  snet-dns-inbound          10.100.10.0/28   reserved for hybrid DNS requirement
  snet-dns-outbound         10.100.10.16/28  reserved for hybrid DNS requirement
  GatewaySubnet             10.100.255.0/26
```

Then add, in Microsoft Learn order as requirements appear:

```text
VPN Gateway public IP
Azure VPN Gateway
connectivity-VNet peerings
Gateway Transit / Use Remote Gateways where required
Brisbane Local Network Gateway
Site-to-Site VPN connection
Point-to-Site configuration
P2S client pool 172.31.240.0/24
hybrid DNS resolver/forwarding components when the hybrid DNS requirement appears
Virtual WAN / Virtual Hub later in Module 2
```

## Corrections made by this audit

### 1. Naming drift — FIXED

Do not use `CoreServicesVnet`, `ManufacturingVnet` or `ResearchVnet` as alternate resource names.

Canonical names remain:

```text
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-research-sea
```

### 2. "Conceptual" Module 1 starting state — FIXED

Module 2 no longer assumes Module 1 merely exists conceptually.

The rule is:

```text
Module 1 code + state + deployed Azure resources
        |
        + Module 2 Terraform delta
        v
same cumulative environment
```

### 3. Workload VNet gateway placement — FIXED

The classic VPN Gateway goes into `bhi-vnet-connectivity-aue`, not `bhi-vnet-core-aue`.

This keeps Core/Manufacturing/Research as workload VNets and avoids unnecessarily coupling the first workload VNet to the classic gateway.

### 4. Gateway transit — ADDED

Site-to-Site reachability to the workload VNets is not assumed to be transitive merely because peering exists.

The Module 2 design must explicitly reason about directional peering settings such as:

```text
connectivity VNet side:
  allow_gateway_transit = true
  allow_forwarded_traffic = true where required

workload VNet side:
  use_remote_gateways = true when using the classic VPN edge
  allow_forwarded_traffic = true where required
```

The exact Terraform properties will be validated against current AzureRM provider behaviour during implementation.

### 5. NAT guardrail — ADDED

NAT Gateway is attached only to explicitly selected workload subnets.

Do not implement Terraform logic that blindly attaches NAT, NSGs or workload UDRs to every subnet. Special-purpose subnets such as `GatewaySubnet` and DNS Private Resolver endpoint subnets must be handled explicitly.

### 6. Hybrid DNS continuity — ADDED

Module 1 creates the Azure-internal DNS foundation.

Module 2 extends it when on-premises/private clients need name resolution across the hybrid path. It does not create a second unrelated DNS design.

Validation is split into two independent questions:

```text
Can Brisbane reach the Azure private IP?
Can Brisbane resolve the Azure private name correctly?
```

### 7. P2S addressing — RESERVED

```text
172.31.240.0/24
```

is reserved for the Module 2 P2S client pool and must remain non-overlapping with:

```text
Brisbane 172.16.0.0/16
Perth    172.17.0.0/16
Azure    10.0.0.0/8 allocations used by BlueHarbor
```

## Gate 1 resulting dependency chain

```text
END MODULE 1

bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-research-sea
subnets
DNS
peerings
routes
selected NAT
same Terraform state
        |
        +
        v
MODULE 2

bhi-vnet-connectivity-aue
GatewaySubnet
VPN Gateway
hybrid peerings / gateway transit
S2S
P2S
hybrid DNS
later Virtual WAN
```

## Deliberately carried into Gate 2

The next audit must resolve the **evolution from the classic VPN Gateway/transit model into Virtual WAN and then ExpressRoute**.

Specifically check:

- a VNet configured to use a remote gateway through peering cannot simply be assumed to use a Virtual WAN hub as another remote gateway simultaneously;
- whether Virtual WAN is introduced alongside the classic VPN design, becomes a migration target, or is used for new branches first;
- which workload VNets connect to the Virtual WAN hub and at what point;
- how the Module 3 ExpressRoute design attaches without creating contradictory gateway ownership;
- whether any peering flags need an intentional in-place change rather than an accidental redesign.

This is **not** an unresolved Gate 1 failure. It is the primary question for Gate 2 because it concerns the Module 2 end state and Module 3 starting state.
