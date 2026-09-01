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
| 6 | Module 6 -> Module 7 | **NEXT** |
| 7 | Module 7 -> Module 8 | PENDING |

A gate passes only when story continuity, Azure architecture continuity and Terraform/state continuity agree.

---

# Gate 1 — Module 1 -> Module 2

**Status:** PASS

Canonical network contracts:

```text
bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16
bhi-vnet-research-sea   10.30.0.0/16
```

Module 1 establishes DNS, direct peerings, routing and `nat-mfg-aue` on `snet-mfg-app`.

Module 2 adds a classic VPN edge, then evolves production transit into `bhi-vwan` / `bhi-vhub-aue` while hybrid DNS is anchored in Core.

---

# Gate 2 — Module 2 -> Module 3

**Status:** PASS

Approved progression:

```text
classic VPN learning
 -> Virtual WAN production transit
 -> ExpressRoute added to same AUE hub
 -> ExpressRoute preferred for approved critical routes
 -> VPN retained as alternate path
```

AUE hub:

```text
bhi-vhub-aue   10.200.0.0/22
```

SEA hub CIDR reserved:

```text
10.200.4.0/22
```

---

# Gate 3 — Module 3 -> Module 4

**Status:** PASS

Module 4 introduces Device Telemetry Ingest on TCP/9000.

AUE:

```text
snet-mfg-app
 -> telemetry backends
 -> lb-telemetry-aue
 -> nat-mfg-aue
```

SEA:

```text
snet-telemetry-dr 10.30.3.0/24
 -> telemetry backends
 -> lb-telemetry-sea
 -> nat-telemetry-sea
```

### Gate 5 correction to Gate 3

`nat-telemetry-sea` is now explicit. The original Gate 3 design omitted SEA backend outbound/return-path ownership. This is corrected before deployment.

Traffic Manager provides Priority DNS failover AUE -> SEA.

---

# Gate 4 — Module 4 -> Module 5

**Status:** PASS

Partner Hub is a separate HTTP(S) application.

AUE:

```text
bhi-vnet-partner-aue 10.40.0.0/16
  snet-appgw       10.40.1.0/24
  snet-partner-app 10.40.2.0/24
  nat-partner-aue
  appgw-partner-aue Standard_v2
  connection -> bhi-vhub-aue
```

SEA:

```text
bhi-vhub-sea 10.200.4.0/22

bhi-vnet-partner-sea 10.50.0.0/16
  snet-appgw       10.50.1.0/24
  snet-partner-app 10.50.2.0/24
  nat-partner-sea
  appgw-partner-sea Standard_v2
  connection -> bhi-vhub-sea
```

Research Virtual WAN connection moves from AUE to SEA hub; the Research VNet itself remains intact.

Global web:

```text
Front Door Standard
 -> appgw-partner-aue
 -> appgw-partner-sea
```

---

# Gate 5 — Module 5 -> Module 6

**Status:** PASS

## Problem resolved

The original Module 6 mixed standalone firewall/UDR language with a later secured-Virtual-WAN exercise, contained cost-driven teardown logic, left DDoS/NSG targets vague, and did not account for public Load Balancer/Application Gateway return-path symmetry.

Approved correction: security hardens the exact cumulative estate and makes the existing Virtual WAN the central enforcement architecture.

## Terraform lifecycle — FIXED

No routine security-resource teardown.

```text
existing Modules 1–5 state
+
security controls / intentional route changes / tier changes
=
same state lineage
```

A resource may be retired only because an approved architecture replaces its function.

## DDoS scope — FIXED

Create one BlueHarbor DDoS Network Protection plan and associate it with eligible VNets that contain public-IP-backed services, especially:

```text
bhi-vnet-mfg-aue
bhi-vnet-research-sea
bhi-vnet-partner-aue
bhi-vnet-partner-sea
```

Evaluate other public-gateway VNets against current service eligibility at implementation time.

Front Door is not associated with this VNet DDoS plan. Do not attach the plan to Virtual WAN secured hubs.

## NSG/ASG target — FIXED

Module 6 Unit 05 adds a real controlled data target in the existing Manufacturing data subnet:

```text
snet-mfg-app  10.20.1.0/24 -> asg-mfg-app
snet-mfg-data 10.20.2.0/24 -> vm-mfg-data-01 / asg-mfg-data
```

The existing Module 4 functional NSG is evolved. Partner application subnets are also segmented around intended Application Gateway/backend flows.

## Firewall topology — FIXED

Do not build a separate hub/spoke firewall VNet.

Use:

```text
fwpol-bhi-global
  |
  +-- azfw-bhi-aue -> bhi-vhub-aue
  +-- azfw-bhi-sea -> bhi-vhub-sea
```

Unit 07 secures AUE first and proves policy. Unit 08 centralises policy/governance. Unit 09 adds SEA enforcement and the production routing-intent model.

## Routing Intent — ADDED

Configure the current supported secured-Virtual-WAN routing model for approved Internet and Private traffic requirements.

Before apply:

```text
capture routes
 -> terraform plan
 -> inspect intended changes
 -> apply
 -> validate effective routes / representative flows
```

Unexpected route mutation means STOP.

## Public-ingress symmetry — CRITICAL FIX

Do not force every subnet through the firewall.

Preserve the current supported explicit Internet-return design for:

```text
AUE/SEA snet-appgw
AUE snet-mfg-app + nat-mfg-aue
SEA snet-telemetry-dr + nat-telemetry-sea
```

The exact UDR/service requirements are verified against current Azure documentation during implementation.

## Partner NAT evolution — APPROVED REPLACEMENT

Module 5 Partner app subnets begin with NAT-managed egress.

After secured-hub firewall egress is proven:

```text
retire nat-partner-aue / nat-partner-sea associations/resources
snet-partner-app -> secured Virtual WAN -> Azure Firewall -> approved Internet
```

This is an architectural replacement, not cleanup.

## Direct peering bypass — FIXED

Once centrally inspected Private routing is active and validated, retire:

```text
Core <-> Manufacturing direct peering
Core <-> Research global peering
```

These peerings were correct earlier but would bypass the new inspected-transit policy. VNets/workloads remain intact.

## WAF/tier progression — FIXED

```text
Front Door Standard
 -> Premium
 -> edge WAF policy

appgw-partner-aue Standard_v2
 -> WAF_v2 + regional policy

appgw-partner-sea Standard_v2
 -> WAF_v2 + regional policy
```

Terraform plan must prove whether each provider change is in-place or requires controlled migration/replacement.

## Front Door origin bypass — FIXED

Regional Application Gateway origins remain public, but direct arbitrary Internet access is restricted using the current supported combination of:

```text
AzureFrontDoor.Backend source restriction
+
BlueHarbor X-Azure-FDID validation
```

while preserving required Application Gateway infrastructure traffic.

## Gate 5 verdict

```text
Story transition                     PASS
Terraform lifecycle                  PASS
DDoS target scope                    PASS with current-eligibility verification
NSG/ASG concrete target              PASS
Existing functional NSG evolution    PASS
Azure Firewall topology              PASS — existing Virtual WAN
AUE/SEA firewall progression         PASS
Routing Intent                       PASS
Public App Gateway symmetry          PASS with explicit exception
Public Load Balancer symmetry        PASS with explicit NAT/Internet exception
SEA telemetry outbound               PASS — nat-telemetry-sea added
Partner NAT evolution                PASS — intentional replacement
Direct peering bypass                PASS — retire after secured path verified
Front Door managed-WAF tier          PASS — Premium progression
Regional Application Gateway WAF     PASS — WAF_v2 progression
Origin bypass restriction            PASS
Existing applications                PASS — preserved
```

---

# Gate 6 — Module 6 -> Module 7

**Status:** NEXT

Audit next:

- which exact PaaS services Partner Hub and Manufacturing will consume;
- where service endpoints are used versus where private endpoints are used;
- whether private endpoints belong in Partner/Manufacturing/Core and which dedicated subnets/CIDRs are required;
- how private DNS zones link into the existing Core DNS Private Resolver/hybrid-DNS design;
- how Brisbane/Perth/ExpressRoute/VPN clients reach private endpoints through the now-secured Virtual WAN;
- whether service endpoint policies are practical against the chosen Storage service;
- whether Private Link Service reuses the real Module 4 Standard Load Balancer and what producer/consumer topology is justified;
- whether App Service VNet Integration is needed at all or remains a comparison concept;
- how Module 7 private access interacts with Azure Firewall routing, NSGs and the removed direct peerings.
