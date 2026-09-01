# Microsoft Learn AZ-700 Unit Map

This file is the authoritative teaching sequence for the repository.

Primary source:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

## Rule

The programme follows Microsoft Learn in this exact hierarchy:

```text
Learning Path
-> Module
-> Unit
-> Microsoft exercise where present
-> our deeper CLI / validation / troubleshooting / Terraform implementation
```

Do not invent a parallel lab sequence. Historical numbered lab folders are retained as evidence and implementation assets only.

---

## Module 1 — Introduction to Azure Virtual Networks

1. Introduction
2. Explore Azure Virtual Networks
3. Configure public IP services
4. Exercise: Design and implement a virtual network in Azure
5. Design name resolution for your virtual network
6. Exercise: Configure domain name servers settings in Azure
7. Enable cross-virtual network connectivity with peering
8. Exercise: Connect two Azure virtual networks using global virtual network peering
9. Implement virtual network traffic routing
10. Configure internet access with Azure Virtual NAT
11. Summary

### Current position

```text
Units 2-4: prior practical evidence exists in Lab 03
Unit 5: CURRENT
Unit 6: NEXT
Units 7-11: NOT STARTED in Microsoft Learn sequence
```

Study-guide additions are inserted only inside the matching unit. For name resolution, Azure DNS public/private zones and Azure DNS Private Resolver are covered as depth within Units 5-6, not as a separate independent curriculum.

---

## Module 2 — Design and implement hybrid networking

1. Introduction
2. Design and implement Azure VPN Gateway
3. Exercise: Create and configure a virtual network gateway
4. Connect networks with Site-to-site VPN connections
5. Connect devices to networks with Point-to-site VPN connections
6. Connect remote resources by using Azure Virtual WANs
7. Exercise: Create a Virtual WAN by using the Azure portal
8. Create a network virtual appliance (NVA) in a virtual hub
9. Summary

---

## Module 3 — Design and implement Azure ExpressRoute

1. Introduction
2. Explore Azure ExpressRoute
3. Design an ExpressRoute deployment
4. Exercise: Configure an ExpressRoute gateway
5. Exercise: Provision an ExpressRoute circuit
6. Configure peering for an ExpressRoute deployment
7. Design an ExpressRoute circuit for resiliency
8. Connect geographically dispersed networks with ExpressRoute global reach
9. Improve data path performance between networks with ExpressRoute FastPath
10. Troubleshoot ExpressRoute connection issues
11. Summary and resources

---

## Module 4 — Load balance non-HTTP(S) traffic in Azure

1. Introduction
2. Explore load balancing
3. Design and implement Azure load balancer using the Azure portal
4. Exercise: Create and configure an Azure load balancer
5. Explore Azure Traffic Manager
6. Exercise: Create a Traffic Manager profile using the Azure portal
7. Summary

Existing Labs 01 and 02 contain strong practical evidence for the Load Balancer and Traffic Manager units. When the programme reaches Module 4 in sequence, review the Microsoft Learn units in order, map the existing evidence, and fill any gaps rather than automatically redeploying everything.

---

## Module 5 — Load balance HTTP(S) traffic in Azure

1. Introduction
2. Design Azure Application Gateway
3. Configure Azure Application Gateway
4. Exercise: Deploy Azure Application Gateway
5. Design and configure Azure Front Door
6. Exercise: Create a Front Door for a highly available web application
7. Summary

---

## Module 6 — Design and implement network security

1. Introduction
2. Get network security recommendations with Microsoft Defender for Cloud
3. Deploy Azure DDoS Protection by using the Azure portal
4. Exercise: Configure DDoS Protection on a virtual network using the Azure portal
5. Deploy Network Security Groups by using the Azure portal
6. Design and implement Azure Firewall
7. Exercise: Deploy and configure Azure Firewall using the Azure portal
8. Secure your networks with Azure Firewall Manager
9. Exercise: Secure your Virtual Hub using Azure Firewall Manager
10. Implement a Web Application Firewall
11. Summary and resources

---

## Module 7 — Design and implement private access to Azure Services

1. Introduction
2. Explain virtual network service endpoints
3. Define Private Link Service and private endpoint
4. Integrate private endpoint with Domain Name Service
5. Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal
6. Exercise: Create an Azure private endpoint using Azure PowerShell
7. Summary

---

## Module 8 — Design and implement network monitoring

1. Introduction
2. Monitor your networks using Azure Monitor
3. Exercise: Monitor a load balancer resource using Azure monitor
4. Monitor your networks using Azure Network Watcher
5. Summary

The module learning objectives also include Connection Monitor, Traffic Analytics, VNet flow logs and diagnostic logging. Cover those inside the Microsoft Learn monitoring units as required by the module objectives and current AZ-700 study guide.

---

## Our extension pattern

For every Microsoft Learn unit, use the same learning pattern:

```text
1. Read / teach the Microsoft Learn unit
2. Explain with an everyday analogy where useful
3. Draw the Azure architecture / packet / query flow
4. Check understanding
5. Complete the Microsoft exercise where one exists
6. Rebuild the same objective manually with Azure CLI where practical
7. Validate independently
8. Break one relevant component and troubleshoot it
9. Rebuild with Terraform where appropriate
10. Capture evidence and rebuild notes
11. Tear down safely
```

Extensions may deepen a Microsoft objective, but they may not change the order or create a separate curriculum.
