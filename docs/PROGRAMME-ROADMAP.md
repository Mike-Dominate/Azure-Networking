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
| 7 | M7 -> M8 | **PASS** |

All module-transition gates pass. One whole-programme closeout remains before deployment.

## Approved cumulative architecture through Module 8

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
regional Application Gateways
Front Door
  |
M6
secured Virtual WAN
AUE/SEA Azure Firewall
DDoS / NSG / ASG
Front Door Premium + WAF
Application Gateway WAF_v2
  |
M7
Storage Service Endpoint
App Service Private Endpoint + VNet Integration
Azure SQL Private Endpoint
telemetry Private Link Service
Front Door -> App Gateway Private Link
  |
M8
law-bhi-netops-aue
regional VNet flow-log Storage
all-six-VNet VNet flow logs + Traffic Analytics
regional Network Watcher reconciliation
vm-netops-aue + Connection Monitor
diagnostic settings / alerts / deterministic capstone
```

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story/audit status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first execution point after closeout | DESIGNED / AUDITED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / AUDITED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED / AUDITED |

## Current phase

```text
STORY DESIGN                 COMPLETE
MODULE-TRANSITION AUDIT      COMPLETE — GATES 1–7 PASS
WHOLE-PROGRAMME CLOSEOUT     NEXT
TERRAFORM BUILD              NOT STARTED
AZURE DEPLOYMENT             NOT STARTED
```

Do not begin the BlueHarbor build until the closeout checks the combined contracts and passes.
