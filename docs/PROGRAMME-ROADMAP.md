# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

## Cumulative rule

```text
previous code + state + Azure resources
        + next BlueHarbor requirement
        = next project state
```

Canonical Terraform root:

```text
blueharbor/terraform/
```

No disposable Terraform root per lab and no routine destroy at module boundaries.

## Story-design status

Modules 1–8: **DESIGNED**.

## Architecture audit status

| Gate | Transition | Status |
|---:|---|---|
| 1 | M1 -> M2 | **PASS** |
| 2 | M2 -> M3 | **PASS** |
| 3 | M3 -> M4 | **PASS** |
| 4 | M4 -> M5 | **PASS** |
| 5 | M5 -> M6 | **PASS** |
| 6 | M6 -> M7 | **NEXT** |
| 7 | M7 -> M8 | PENDING |

Do not start the BlueHarbor Terraform deployment until all gates pass.

## Approved cumulative architecture through Module 6

```text
M1
Core / Manufacturing / Research VNets
DNS / routing / initial direct peerings
nat-mfg-aue
  |
M2
classic VPN learning -> Virtual WAN
bhi-vhub-aue 10.200.0.0/22
  |
M3
ExpressRoute added to AUE hub
  |
M4
Telemetry TCP/9000
AUE public LB + nat-mfg-aue
SEA public LB + nat-telemetry-sea
Traffic Manager
  |
M5
Partner AUE/SEA VNets
Application Gateway Standard_v2 in both regions
bhi-vhub-sea 10.200.4.0/22 activated
Front Door Standard
  |
M6 distributed security
DDoS Network Protection
NSG / ASG segmentation
  |
M6 central security
azfw-bhi-aue + azfw-bhi-sea
fwpol-bhi-global
secured Virtual WAN routing intent
retire direct peering bypasses
replace Partner NAT egress with firewall egress
  |
M6 web security
Front Door Premium + WAF
Application Gateway WAF_v2 + regional WAF
Front Door origin-bypass restrictions
```

Public Application Gateway and telemetry Load Balancer paths retain deliberate direct-return/NAT exceptions so central firewall routing does not create asymmetric ingress failures.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / GATE 6 NEXT |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED |

## Current phase

```text
STORY DESIGN        COMPLETE
AUDIT GATES 1–5     PASS
AUDIT GATE 6        NEXT
TERRAFORM BUILD     NOT STARTED
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the decision record.
