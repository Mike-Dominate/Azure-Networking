# Programme Roadmap

## Purpose

Build real Azure networking engineering capability by following Microsoft's official AZ-700 Microsoft Learn learning path in its published module order, then deepen each lesson with Azure CLI, Terraform, troubleshooting, validation and rebuild documentation.

## Curriculum authority

Primary curriculum and sequence:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Coverage completeness check:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

Technical implementation authority:

Microsoft Azure product documentation for the service being implemented.

Rule:

```text
Microsoft Learn path = programme structure and order
AZ-700 study guide = make sure the matching module is complete
Azure product docs = exact implementation behaviour
```

## Official Microsoft Learn module sequence

| Module | Microsoft Learn module | Practical implementation in this repository | Status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | VNet/IP design, DNS/name resolution, peering, routing, NAT; study-guide extensions such as VNet Manager, Route Server and DNS Private Resolver stay inside this module | IN PROGRESS |
| 2 | Design and implement hybrid networking | VPN Gateway, Site-to-Site VPN, Point-to-Site VPN, Azure Virtual WAN and Virtual WAN hubs | NOT STARTED |
| 3 | Design and implement Azure ExpressRoute | ExpressRoute design, peering, Global Reach, FastPath, redundancy and BGP reasoning | NOT STARTED |
| 4 | Load balance non-HTTP(S) traffic in Azure | Azure Load Balancer and Azure Traffic Manager | COMPLETE |
| 5 | Load balance HTTP(S) traffic in Azure | Azure Application Gateway and Azure Front Door | NOT STARTED |
| 6 | Design and implement network security | Defender for Cloud recommendations, DDoS Protection, NSGs, Azure Firewall, Firewall Manager and WAF | NOT STARTED |
| 7 | Design and implement private access to Azure Services | Service endpoints, Private Link, private endpoints and private-endpoint DNS integration | NOT STARTED |
| 8 | Design and implement network monitoring | Azure Monitor, Network Watcher, Connection Monitor, Traffic Analytics, VNet flow logs and diagnostic logging | NOT STARTED |

## Module 1 — Introduction to Azure Virtual Networks

Microsoft Learn core units:

```text
Explore Azure Virtual Networks
Configure public IP services
Design and implement a virtual network
Design name resolution for your virtual network
Configure domain name server settings in Azure
Enable cross-virtual network connectivity with peering
Implement virtual network traffic routing
Configure internet access with Azure Virtual NAT
```

Our practical mapping:

| Existing practical lab | Microsoft Learn Module 1 alignment | Status |
|---|---|---|
| Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture | VNets, addressing and public IP services | COMPLETE |
| Lab 04 — Azure DNS, Private DNS & DNS Private Resolver | Name resolution and VNet DNS settings; DNS Private Resolver added only because the current AZ-700 study guide explicitly requires it | IN PROGRESS |
| Lab 05 — VNet Peering, Gateway Transit & Virtual Network Manager | Cross-VNet connectivity; VNet Manager is a study-guide extension within this connectivity section | NOT STARTED |
| Lab 06 — UDRs, Forced Tunnelling, NAT Gateway & NVA | Traffic routing and Azure NAT; forced tunnelling/service chaining are study-guide depth | NOT STARTED |
| Lab 07 — Azure Route Server & Dynamic Routing | Study-guide extension to the Module 1 routing section | NOT STARTED |

### Current Module 1 checkpoint

Lab 03 is complete. Lab 04 is the current work item.

Lab 04 must follow Microsoft's learning order:

```text
Microsoft Learn: Design name resolution for your virtual network
-> Microsoft Learn: Exercise / DNS server settings in Azure
-> AZ-700 study-guide additions that belong to name resolution
   - public DNS zones
   - private DNS zones
   - private DNS zone VNet links
   - Azure DNS Private Resolver
-> understanding check
-> practical lab design
-> manual Azure CLI deployment
-> validation and deliberate DNS failure
-> Terraform rebuild
-> evidence / teardown / explain-back
```

Do not expand Lab 04 into unrelated DNS or Private Link material. Private-endpoint DNS integration belongs primarily to Module 7.

## Module 2 — Design and implement hybrid networking

Practical mapping:

```text
Lab 09 — Site-to-Site VPN
Lab 10 — Point-to-Site VPN
Lab 12 — Azure Virtual WAN
```

The teaching order inside the module follows Microsoft Learn: VPN Gateway -> S2S -> P2S -> Virtual WAN / hubs.

## Module 3 — Design and implement Azure ExpressRoute

Practical mapping:

```text
Lab 11 — ExpressRoute Architecture & BGP
```

Full commercial circuit provisioning is not required if cost is unreasonable. Architecture, peering, BGP, resiliency, Global Reach, FastPath, route reasoning and troubleshooting must still be covered seriously.

## Module 4 — Load balance non-HTTP(S) traffic in Azure

Practical mapping:

```text
Lab 01 — Azure Load Balancer     COMPLETE
Lab 02 — Azure Traffic Manager   COMPLETE
```

These labs were completed before the programme was realigned to the Microsoft Learn order. Their work is retained and counts as Module 4 complete.

## Module 5 — Load balance HTTP(S) traffic in Azure

Practical mapping:

```text
Lab 13 — Azure Application Gateway
Lab 14 — Azure Front Door
```

## Module 6 — Design and implement network security

Practical mapping will be reorganized around the Microsoft Learn units rather than the old folder numbering:

```text
Microsoft Defender for Cloud network recommendations
Azure DDoS Protection
Network Security Groups
Azure Firewall
Azure Firewall Manager
Web Application Firewall
```

Existing placeholder material in Labs 08, 18, 19 and 20 may be reused only where it maps directly to these units. Their old numbering does not define the teaching sequence.

## Module 7 — Design and implement private access to Azure Services

Practical mapping:

```text
Lab 17 — Service Endpoints & Service Endpoint Policies
Lab 16 — Private Endpoint, Private Link & Private DNS
```

Teaching order follows Microsoft Learn: service endpoints -> Private Link/private endpoint -> private endpoint DNS integration.

## Module 8 — Design and implement network monitoring

Practical mapping:

```text
Lab 08 — Network Watcher / Azure Monitor / flow visibility
```

Only the monitoring portion belongs here. DDoS and Defender content moves conceptually to Module 6.

A final troubleshooting/capstone exercise can remain after Module 8 as programme synthesis, but it is not a ninth Microsoft Learn module.

## Existing folders and numbering

Historical lab folder numbers are retained to avoid destroying completed work and links. They are implementation artifacts, not the curriculum authority.

From this point forward:

```text
Always state the Microsoft Learn module first.
Then state the practical lab/folder being used to implement that module.
```

Example:

```text
Microsoft Learn Module 1 — Introduction to Azure Virtual Networks
Current practical: Lab 04 — Name resolution / Azure DNS
```

## Required engineering learning loop

For every practical implementation:

```text
Microsoft Learn tutorial / lesson
  -> mental model with everyday analogy
  -> visual architecture / traffic or query flow
  -> understanding check
  -> design our practical scenario
  -> manual Azure CLI implementation
  -> independent validation
  -> deliberate failure / troubleshooting
  -> Portal inspection where useful
  -> Terraform rebuild
  -> independent IaC validation
  -> evidence and rebuild documentation
  -> safe teardown
  -> learner explain-back
```

## Drift prevention

Do not introduce a new standalone lab topic merely because it appears in Azure documentation or is useful in production.

A topic enters the programme only when:

1. it is a Microsoft Learn module/unit in the official AZ-700 path, or
2. it is explicitly required by the current AZ-700 study guide and can be attached to the matching Learn module.
