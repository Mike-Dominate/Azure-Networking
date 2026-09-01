# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

Canonical Terraform root:

```text
blueharbor/terraform/
```

## Architecture audit status

| Gate | Transition | Status |
|---:|---|---|
| 1 | M1 -> M2 | **PASS** |
| 2 | M2 -> M3 | **PASS** |
| 3 | M3 -> M4 | **PASS** |
| 4 | M4 -> M5 | **PASS** |
| 5 | M5 -> M6 | **PASS** |
| 6 | M6 -> M7 | **PASS** |
| 7 | M7 -> M8 | **NEXT** |

Do not begin BlueHarbor deployment until Gate 7 and the audit closeout pass.

## Approved cumulative architecture through Module 7

```text
M1
VNets / DNS / routing / NAT
  |
M2
VPN -> Virtual WAN
  |
M3
ExpressRoute on existing hub
  |
M4
Telemetry TCP/9000
AUE/SEA Standard Load Balancers
Traffic Manager
  |
M5
Partner AUE/SEA application VNets
Application Gateway Standard_v2
Front Door Standard
  |
M6
secured Virtual WAN
AUE/SEA Azure Firewall
DDoS / NSG / ASG
Front Door Premium + WAF
Application Gateway WAF_v2
  |
M7 Manufacturing
Storage Service Endpoint + service-side restriction/policy
  |
M7 Partner
App Service Private Endpoint + VNet Integration
Azure SQL Private Endpoint
private DNS / hybrid DNS
  |
M7 BlueHarbor-owned private service
existing AUE telemetry LB -> Private Link Service
Core consumer Private Endpoint
  |
M7 global web origin privacy
Front Door Premium -> Private Link -> AUE/SEA App Gateway WAF_v2
```

Module 7 adds no new VNet or transit hub.

## Canonical Module 7 subnet additions

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

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / AUDITED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED / GATE 7 NEXT |

## Current phase

```text
STORY DESIGN        COMPLETE
AUDIT GATES 1–6     PASS
AUDIT GATE 7        NEXT
TERRAFORM BUILD     NOT STARTED
```
