# BlueHarbor Architecture & Terraform Dependency Audit

This is the running gate record for the progressive BlueHarbor project. Audit one transition at a time before any BlueHarbor Azure deployment begins.

## Gate status

| Gate | Transition | Status |
|---:|---|---|
| 1 | Module 1 -> Module 2 | **PASS — corrected and approved** |
| 2 | Module 2 -> Module 3 | **PASS — corrected and approved** |
| 3 | Module 3 -> Module 4 | **PASS — corrected and approved** |
| 4 | Module 4 -> Module 5 | **PASS — corrected and approved** |
| 5 | Module 5 -> Module 6 | **NEXT** |
| 6 | Module 6 -> Module 7 | PENDING |
| 7 | Module 7 -> Module 8 | PENDING |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS

Canonical Module 1 network:

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

Module 1 carries DNS, direct peerings, routing and explicit NAT-managed outbound connectivity on `snet-mfg-app`.

Classic Module 2 edge:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26
```

Hybrid DNS resolver endpoint subnets are anchored in Core:

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

Active AUE hub:

```text
bhi-vhub-aue   10.200.0.0/22
```

Initially connected to Core, Manufacturing and Research plus Brisbane/Perth/remote connectivity.

Reserved during Gate 2:

```text
bhi-vhub-sea   10.200.4.0/22
```

Module 3 adds ExpressRoute to `bhi-vhub-aue`, not another Core VNet gateway topology. Global Reach reuses Brisbane + Perth. FastPath eligibility remains tied to the actual Module 3 circuit/gateway model.

---

# Gate 3 — Module 3 -> Module 4

**Status:** PASS

Module 4 explicitly introduces:

```text
BlueHarbor Device Telemetry Ingest
TCP/9000
```

Australia East reuses:

```text
bhi-vnet-mfg-aue / snet-mfg-app
 -> telemetry backends
 -> public Standard lb-telemetry-aue
 -> existing Module 1 NAT outbound
```

Southeast Asia reuses `bhi-vnet-research-sea` and adds:

```text
snet-telemetry-dr   10.30.3.0/24
 -> telemetry DR backends
 -> public Standard lb-telemetry-sea
```

Traffic Manager is added only after both regional endpoints exist:

```text
Priority 1 -> AUE
Priority 2 -> SEA
monitor TCP/9000
```

Availability distinction:

```text
backend failure  -> regional Load Balancer
regional failure -> Traffic Manager DNS selection
```

Transport architecture remains unchanged.

---

# Gate 4 — Module 4 -> Module 5

**Status:** PASS

## Problem resolved

Module 5 correctly introduces Partner Hub as a different HTTP(S) application, but the original story created an unexplained app VNet, used a Europe origin inconsistent with BlueHarbor's canonical regions, pointed Front Door at vague origins, and still contained disposable-lab/teardown language.

Approved correction: Partner Hub gets explicit regional application landing zones that join the existing Virtual WAN estate, and Front Door is created only after two real regional Application Gateway origins exist.

## Partner Hub remains distinct from telemetry

```text
Module 4
Device Telemetry Ingest -> TCP/9000 -> Load Balancer / Traffic Manager

Module 5
Partner Hub -> HTTP(S) -> Application Gateway / Front Door
```

No telemetry resource is relabelled as Partner Hub infrastructure.

## Australia East Partner landing zone

Add in Module 5:

```text
bhi-vnet-partner-aue   10.40.0.0/16
  snet-appgw           10.40.1.0/24
  snet-partner-app     10.40.2.0/24
```

Connect `bhi-vnet-partner-aue` to the existing `bhi-vhub-aue`.

Add explicit app-subnet egress through `nat-partner-aue` and deploy:

```text
Partner Hub AUE backends
appgw-partner-aue   Standard_v2
```

The Application Gateway subnet is dedicated and intentionally `/24` for v2 growth/maintenance headroom.

## Activate the reserved SEA hub

Module 5 Unit 05 provides the first requirement to deploy:

```text
bhi-vhub-sea   10.200.4.0/22
```

The Virtual WAN then has regional AUE and SEA hubs.

## Research VNet hub ownership — INTENTIONAL CHANGE

Research cannot be treated as connected to both Virtual WAN hubs simultaneously with no ownership change.

Terraform deliberately changes the Virtual Hub connection:

```text
old: bhi-vnet-research-sea -> bhi-vhub-aue
new: bhi-vnet-research-sea -> bhi-vhub-sea
```

The Research VNet, subnets and Module 4 telemetry DR resources remain intact. The original Core <-> Research global VNet peering remains until a later routing/security requirement explicitly changes it.

## Southeast Asia Partner landing zone

Add:

```text
bhi-vnet-partner-sea   10.50.0.0/16
  snet-appgw           10.50.1.0/24
  snet-partner-app     10.50.2.0/24
```

Connect it to `bhi-vhub-sea`, add `nat-partner-sea`, Partner Hub SEA backends and:

```text
appgw-partner-sea   Standard_v2
```

Europe is removed from the BlueHarbor origin design. Southeast Asia is the canonical secondary Azure region.

## Front Door origins — REAL RESOURCES

Azure Front Door is added only after both Application Gateways exist:

```text
Front Door Standard
  |
  +-- appgw-partner-aue public origin
  +-- appgw-partner-sea public origin
```

Front Door remains in the HTTP(S) data path; Traffic Manager remains DNS-based and separate.

## Explicit outbound design

Partner application subnets use deliberate regional NAT-managed egress. The architecture does not rely on implicit/default outbound behaviour.

Module 6 may later reroute selected outbound traffic through Azure Firewall as an intentional security evolution.

## Security progression — PRESERVED

Module 5 starts with:

```text
Application Gateway Standard_v2
Front Door Standard
```

Module 6 must decide and implement the justified WAF tier/policy/origin-hardening design against these real resources. Security is not pre-solved in Module 5.

## Hostname/TLS guardrail

`portal.blueharbor.example` is narrative documentation, not a domain BlueHarbor's lab claims to own.

Use Azure-generated reachable hostnames/endpoints in the practical unless the learner later provides a real public domain they control.

## Terraform lifecycle — FIXED

Remove the old "build fresh", "Terraform where appropriate" and "safe teardown" model.

Module 5 is:

```text
existing Modules 1–4 state
+
AUE Partner landing zone / Application Gateway
+
SEA Virtual Hub activation
+
Research hub-connection migration
+
SEA Partner landing zone / Application Gateway
+
Front Door
=
same Terraform state lineage
```

No routine teardown follows.

## Gate 4 verdict

```text
Partner Hub distinct from telemetry     PASS
AUE app placement                       PASS
Application Gateway subnet              PASS
Virtual WAN integration                 PASS
SEA origin / canonical region           PASS
SEA hub reservation use                 PASS
Research hub ownership                  PASS — intentional connection migration
Front Door origins                      PASS
Explicit backend egress                 PASS
Terraform continuity                    PASS
Security/WAF handoff                     PASS
Narrative hostname/TLS guardrail        PASS
```

---

# Gate 5 — Module 5 -> Module 6

**Status:** NEXT

Audit next:

- which existing public IP-backed VNets/services DDoS Protection should actually apply to;
- how NSG/ASG segmentation extends the real Manufacturing and Partner application subnets without conflicting with existing functional NSGs;
- whether central Azure Firewall belongs in the already-sized `bhi-vhub-aue`, both regional hubs, or another topology;
- how securing Virtual WAN changes route propagation/intent and whether old direct peerings bypass inspection;
- how Module 1 NAT and Module 5 Partner NAT paths evolve when selected egress is routed through Firewall;
- Application Gateway Standard_v2 -> WAF_v2 implications;
- Front Door Standard -> security-capable tier/policy design where required;
- how direct Application Gateway origin access is restricted so Front Door cannot simply be bypassed;
- how all security changes remain cumulative without deleting the Module 4 telemetry or Module 5 Partner Hub delivery stacks.
