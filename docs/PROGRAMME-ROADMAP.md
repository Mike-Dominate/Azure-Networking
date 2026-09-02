# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

Canonical Terraform root:

```text
blueharbor/terraform/
```

## Planning status

```text
STORY DESIGN                         COMPLETE
MODULE-TRANSITION AUDIT              COMPLETE — GATES 1–7 PASS
WHOLE-PROGRAMME CLOSEOUT             PASS
JULY-2026 STUDY-GUIDE COVERAGE       COMPLETE
FINAL CURRICULUM / ARCHITECTURE QA   PASS
IMPLEMENTATION READY                 YES
TERRAFORM BUILD                      NOT STARTED
AZURE DEPLOYMENT                     NOT STARTED
CURRENT CURRICULUM POSITION          M1 U01
```

## Final cumulative programme chain

```text
M1
VNets / blueharbor.internal / peerings / routing / NAT
+ current-study-guide core networking extensions
  |
M2
classic VPN/P2S -> Virtual WAN
Core DNS Private Resolver
+ current-study-guide hybrid extensions
  |
M3
ExpressRoute on existing AUE hub
Brisbane + Perth two-circuit Global Reach stage
exact vWAN FastPath eligibility
  |
M4
Telemetry TCP/9000
AUE/SEA Standard Load Balancers
Traffic Manager
+ Load Balancer study-guide extensions
  |
M5
Partner AUE/SEA VNets
regional Application Gateways
Front Door
+ rewrite/caching/rules/TLS study-guide extensions
  |
M6
secured Virtual WAN
AUE/SEA Azure Firewall
DDoS / NSG / ASG / WAF
retire private-transit bypasses including Global Reach
  |
M7
Storage Service Endpoint
App Service Private Endpoint + VNet Integration
Azure SQL Private Endpoint
telemetry Private Link Service
Front Door -> App Gateway Private Link
  |
M8
central Log Analytics
regional VNet flow-log Storage
VNet flow logs / Traffic Analytics
Connection Monitor / diagnostics / alerts
```

## Final cross-programme contracts

```text
Classic P2S pool       172.31.240.0/24
vWAN User VPN pool     172.31.241.0/24
Private DNS zone       blueharbor.internal
Remote state           Azure Blob / one migrated state lineage
Global unique names    one persistent six-character suffix
```

## Coverage control

Microsoft Learn remains the execution sequence. Before each unit, use:

[`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)

to add the current July 27, 2026 study-guide objectives inside the matching unit without creating a parallel curriculum.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story/audit status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | **IN PROGRESS — Unit 01 current** | DESIGNED / AUDITED / QA PASS |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED / AUDITED / QA PASS |

## Execution rule

The planning/QA phase is finished. Begin at Module 1 Unit 01 and continue in Microsoft Learn order.

Do not pre-build future resources simply because their final address/name is already known. The closeout/coverage maps are dependency contracts, not permission to skip the progressive story.
