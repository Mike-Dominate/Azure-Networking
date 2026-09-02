# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

Canonical Terraform root:

```text
blueharbor/terraform/
```

## Planning status

```text
STORY DESIGN                     COMPLETE
MODULE-TRANSITION AUDIT          COMPLETE — GATES 1–7 PASS
WHOLE-PROGRAMME CLOSEOUT         PASS
IMPLEMENTATION READY             YES
TERRAFORM BUILD                  NOT STARTED
AZURE DEPLOYMENT                 NOT STARTED
CURRENT CURRICULUM POSITION      M1 U01
```

## Final cumulative programme chain

```text
M1
VNets / blueharbor.internal / peerings / routing / NAT
  |
M2
classic VPN/P2S -> Virtual WAN
Core DNS Private Resolver
  |
M3
ExpressRoute on existing AUE hub
  |
M4
Telemetry TCP/9000
AUE/SEA Standard Load Balancers
Traffic Manager
  |
M5
Partner AUE/SEA VNets
regional Application Gateways
Front Door
  |
M6
secured Virtual WAN
AUE/SEA Azure Firewall
DDoS / NSG / ASG / WAF
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

Storage-account naming examples:

```text
stbhitfstate<suffix>
stbhimfgarchive<suffix>
stbhiflowaue<suffix>
stbhiflowsea<suffix>
```

See [`WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md`](WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md) for full addressing, subnet and lifecycle contracts.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story/audit status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | **IN PROGRESS — Unit 01 current** | DESIGNED / AUDITED / CLOSEOUT PASS |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / AUDITED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED / AUDITED |

## Execution rule

The planning phase is finished. Begin at Module 1 Unit 01 and continue in Microsoft Learn order.

Do not pre-build future resources simply because their final address/name is already known. The closeout is a dependency contract, not permission to skip the progressive story.
