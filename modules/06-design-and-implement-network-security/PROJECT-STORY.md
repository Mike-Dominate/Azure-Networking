# BlueHarbor Industries — Module 6 Project Story

## Project — Harden the BlueHarbor enterprise network

**Microsoft Learn module:** Design and implement network security  
**Status:** NOT STARTED  
**Terraform model:** extend and intentionally harden the same cumulative `blueharbor/terraform/` state

## Starting point from Module 5

The network and applications work. Security now has real resources to protect:

```text
GLOBAL WEB
Front Door Standard
  -> appgw-partner-aue Standard_v2
  -> appgw-partner-sea Standard_v2

PUBLIC NON-HTTP
lb-telemetry-aue
lb-telemetry-sea
Traffic Manager

TRANSIT
bhi-vwan
  -> bhi-vhub-aue 10.200.0.0/22
  -> bhi-vhub-sea 10.200.4.0/22
  -> VPN / ExpressRoute / VNet connections

EXPLICIT OUTBOUND
nat-mfg-aue
nat-telemetry-sea
nat-partner-aue
nat-partner-sea
```

The security team asks:

> You have proved that everything can communicate. Now prove that only the right things communicate, that public services are protected at the correct layer, and that security routing cannot be bypassed accidentally.

---

## Chapter 01 — Connectivity is not security

Review required versus excessive reachability.

```text
Can A reach B?          networking
Should A reach B?       security
Through which path?     architecture
Which control decides?  enforcement
```

---

## Chapter 02 — Defender for Cloud: observe posture before changing enforcement

Use Defender for Cloud to understand recommendations, Secure Score, attack-path context and Cloud Security Explorer concepts required by the current study guide.

Defender for Cloud is a posture/recommendation layer, not the packet-processing firewall.

---

## Chapter 03 — DDoS Protection: protect actual Internet-facing VNet resources

Create one Terraform-managed BlueHarbor DDoS Network Protection plan, for example:

```text
ddos-bhi-network
```

Associate it with the eligible BlueHarbor VNets that contain protected public-IP-backed services, including the Manufacturing, Research and Partner landing-zone VNets. Evaluate the classic connectivity VNet/public gateway against the current service eligibility when implementation is reached rather than assuming unsupported coverage.

Front Door is not attached to this VNet plan; its edge service has its own platform protection model. The origin VNets remain the relevant VNet DDoS scope.

Do not attempt to attach the VNet DDoS plan to the Virtual WAN secured hubs themselves.

Core distinction:

```text
DDoS Protection
 -> network/infrastructure availability

WAF
 -> HTTP(S) request protection
```

---

## Chapter 04 — Configure and verify DDoS scope

Preserve the Microsoft exercise objective, but apply the persistent configuration to the real BlueHarbor VNets/public services.

Validation includes:

- which VNet is associated with the plan;
- which eligible public IP-backed service is protected through that VNet;
- what a network-layer attack looks like conceptually;
- which metrics/logs/alerts would later prove mitigation activity;
- what DDoS Protection does not solve.

No routine teardown follows.

---

## Chapter 05 — NSG/ASG segmentation against workloads that really exist

Module 4 already added a minimal functional telemetry NSG. Module 6 evolves it rather than replacing it.

The Manufacturing data subnet now gets a small internal test data target so segmentation is concrete:

```text
bhi-vnet-mfg-aue

snet-mfg-app  10.20.1.0/24
  -> telemetry/application identities
  -> asg-mfg-app

snet-mfg-data 10.20.2.0/24
  -> vm-mfg-data-01 / controlled test data service
  -> asg-mfg-data
```

Policy intent:

```text
asg-mfg-app -> asg-mfg-data on approved test-data port   ALLOW
unnecessary lateral access                              DENY
management                                               approved source only
```

Also harden Partner application subnets so backend access comes from the intended Application Gateway path and unnecessary lateral access is denied.

Deliberately create one rule-priority conflict and prove the result using effective rules/IP flow diagnostics rather than guessing.

---

## Chapter 06 — Design Azure Firewall inside the existing Virtual WAN

Do not build a standalone parallel hub/firewall topology.

BlueHarbor already reserved and deployed `/22` Virtual WAN hubs specifically so the security chapter can evolve them:

```text
bhi-vhub-aue 10.200.0.0/22
bhi-vhub-sea 10.200.4.0/22
```

Target:

```text
fwpol-bhi-global
  |
  +-- azfw-bhi-aue in/for bhi-vhub-aue
  +-- azfw-bhi-sea in/for bhi-vhub-sea
```

Learn the classic Azure Firewall VNet/subnet model from Microsoft's unit where required, but the persistent BlueHarbor implementation uses the existing Virtual WAN secured-hub architecture.

### Critical routing design

A firewall only enforces traffic that actually traverses it.

But public ingress also needs a valid symmetric return path. Therefore the design separates:

```text
PRIVATE / INTERNAL BACKEND SUBNETS
 -> secured-hub/firewall routing where approved

PUBLIC APPLICATION GATEWAY SUBNETS
 -> explicit supported Internet return-path exception

PUBLIC TELEMETRY LB BACKEND SUBNETS
 -> explicit Internet/NAT return-path exception
```

Do not blindly apply `0.0.0.0/0 -> Firewall` to every subnet.

---

## Chapter 07 — Deploy AUE firewall first and prove policy

Preserve the Microsoft Azure Firewall exercise objectives: rules, policy, route path, allowed flow, denied flow and troubleshooting.

The persistent BlueHarbor delta secures the existing AUE hub first:

```text
bhi-vhub-aue
  +-- azfw-bhi-aue
  +-- fwpol-bhi-global initial policy
```

Use a selected private workload path to prove:

```text
route/path correct + allow rule -> success
route/path correct + deny rule  -> blocked
wrong route                     -> firewall never sees packet
```

Public Application Gateway and telemetry subnets are excluded from any default-route change that would break their required public return path.

No teardown follows; the AUE firewall remains for Units 08–11.

---

## Chapter 08 — Firewall Manager: centralise one policy before the second region

BlueHarbor now has a real AUE enforcement point and a second Virtual WAN region waiting to be secured.

Use Firewall Manager / Firewall Policy as the management-plane layer:

```text
fwpol-bhi-global
        |
        +-- azfw-bhi-aue
        +-- later azfw-bhi-sea
```

Distinguish:

```text
Azure Firewall
= packet enforcement

Firewall Manager / Firewall Policy
= central management, policy and secured-hub governance
```

---

## Chapter 09 — Secure both Virtual WAN hubs and remove bypass paths

Extend the security architecture to Southeast Asia:

```text
bhi-vhub-sea
  +-- azfw-bhi-sea
  +-- fwpol-bhi-global
```

Then configure the current supported Virtual WAN routing-intent/secured-hub model for the approved security requirements, including Internet and private traffic policies where appropriate.

### Route-state guardrail

Before enabling routing intent:

```text
capture current hub/VNet route state
 -> terraform plan
 -> identify intended route-table changes
 -> apply
 -> verify effective routes and test flows
```

Unexpected route mutation means STOP and investigate.

### Public-ingress exceptions

Keep deliberate exceptions for public-service subnets:

```text
snet-appgw AUE/SEA
 -> supported explicit Internet return path

snet-mfg-app
 -> Internet/NAT path through nat-mfg-aue for public telemetry service symmetry

snet-telemetry-dr
 -> Internet/NAT path through nat-telemetry-sea for public telemetry service symmetry
```

The exact UDR/service constraints are verified against current Azure documentation at implementation time.

### Partner application NAT evolution

The Partner backend subnets are private and can now use controlled firewall egress.

Intentional evolution:

```text
BEFORE MODULE 6
snet-partner-app -> nat-partner-aue / nat-partner-sea

AFTER SECURED-HUB EGRESS
snet-partner-app -> secured Virtual WAN -> Azure Firewall -> approved Internet
```

Retire the Partner app NAT associations/resources when the firewall path is proven. This is an architectural replacement, not end-of-lab teardown.

### Retire direct peering bypasses

Module 1 direct peerings were useful when the estate was small. Once the policy requires centrally inspected private transit, direct peerings can bypass the secured Virtual WAN path.

Intentionally remove:

```text
Core <-> Manufacturing direct peering
Core <-> Research global peering
```

only after the secured-hub route path is proven. Workload VNets remain intact; the production transit changes.

---

## Chapter 10 — WAF and Front Door origin hardening

Module 5 deliberately created delivery before WAF.

Upgrade/harden the actual Partner Hub stack:

```text
Front Door Standard
        -> Front Door Premium
        -> waf-partner-edge

appgw-partner-aue Standard_v2
        -> WAF_v2
        -> regional WAF policy

appgw-partner-sea Standard_v2
        -> WAF_v2
        -> regional WAF policy
```

Terraform plan must be inspected for in-place versus replacement behaviour with the current provider before applying any tier/SKU change.

### Detection to Prevention progression

Start with controlled Detection-mode validation where useful, inspect rule matches/false positives, then move the production intent to Prevention after the policy is understood.

### Prevent direct Front Door bypass

WAF alone does not stop a client from addressing a public Application Gateway origin directly.

Harden each origin with two concepts:

1. Restrict inbound HTTPS source to the supported Azure Front Door backend service-tag path while preserving required Application Gateway infrastructure traffic.
2. Validate the unique `X-Azure-FDID` value for BlueHarbor's Front Door profile using the current supported Application Gateway/WAF mechanism.

Conceptual path:

```text
allowed
user -> Front Door Premium/WAF -> regional App Gateway WAF_v2 -> Partner backend

blocked
user -------------------------> regional App Gateway public origin directly
```

Exact service-tag/NSG infrastructure rules and header-validation implementation are verified against current Azure documentation at build time.

---

## Chapter 11 — Security architecture review

Final layered model:

```text
Defender for Cloud
 -> posture / recommendations

DDoS Network Protection
 -> eligible public-IP VNet resources

NSG / ASG
 -> distributed segmentation

Azure Firewall in secured Virtual WAN hubs
 -> central routed enforcement

Firewall Manager / Firewall Policy
 -> central governance

Front Door Premium + WAF
 -> global HTTP(S) request protection

Application Gateway WAF_v2
 -> regional HTTP(S) protection / origin boundary
```

The learner must explain why the route path matters, why public ingress needs symmetry exceptions, why Partner NAT egress is replaced but telemetry NAT remains, why direct peerings are retired, and why WAF does not replace DDoS/NSG/Azure Firewall.

## Carry-forward into Module 7

BlueHarbor now has an inspected and hardened network. The next question is narrower:

> If Partner Hub or Manufacturing only needs a managed Azure service privately, why should that service remain exposed through a public endpoint at all?
