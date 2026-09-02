# Microsoft Learn AZ-700 Unit Map

This file is the authoritative **execution sequence** for the repository.

Primary source:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Completeness source:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

Current study-guide baseline: **skills measured effective July 27, 2026**.

Objective-by-objective coverage lives in:

[`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)

## Rule

```text
Microsoft Learn learning path
 -> module
 -> unit
 -> Microsoft exercise where present
 -> matching current study-guide extensions
 -> BlueHarbor engineering requirement
 -> incremental change to SAME Terraform environment when infrastructure is required
```

No parallel lab sequence and no legacy-practical completion credit.

A study-guide extension is inserted **inside the nearest matching Learn unit**. It does not change module/unit numbering.

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

**Current position:** Unit 01 — Introduction.

Study-guide extensions embedded here include Public IP Prefix/BYOIP design, public DNS depth, Azure Virtual Network Manager connectivity concepts and Azure Route Server. Route Server is not allowed to be deployed into a VNet that is/will be connected to the BlueHarbor Virtual WAN merely for exam coverage.

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

Study-guide extensions here include HA VPN design, explicit IKE/IPsec policy, Azure Extended Network, RADIUS/Entra P2S authentication, Always On VPN and Azure Network Adapter requirements.

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

Study-guide extensions here include Microsoft peering, route advertisement, encryption-over-ER and BFD. Global Reach explicitly uses two circuit/provider paths and is later retired in Module 6 if it would bypass secured-hub inspection. vWAN FastPath uses the current Direct + minimum-5-scale-unit rule.

## Module 4 — Load balance non-HTTP(S) traffic in Azure

1. Introduction
2. Explore load balancing
3. Design and implement Azure load balancer using the Azure portal
4. Exercise: Create and configure an Azure load balancer
5. Explore Azure Traffic Manager
6. Exercise: Create a Traffic Manager profile using the Azure portal
7. Summary

Study-guide extensions include public/internal and regional/cross-region decisions, Gateway Load Balancer, inbound NAT rules and explicit outbound-rule/SNAT comparison with the canonical NAT Gateway design.

## Module 5 — Load balance HTTP(S) traffic in Azure

1. Introduction
2. Design Azure Application Gateway
3. Configure Azure Application Gateway
4. Exercise: Deploy Azure Application Gateway
5. Design and configure Azure Front Door
6. Exercise: Create a Front Door for a highly available web application
7. Summary

Study-guide extensions include Application Gateway autoscale/rewrite rules and Front Door TLS, caching, acceleration, rules, rewrite and redirect. Private Link origin security is completed in Module 7 after Premium/WAF hardening in Module 6.

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

Study-guide extensions include Azure Bastion remote-admin design and Azure Virtual Network Manager security-admin concepts. Module 6 also removes private-transit bypasses, including Global Reach when centrally inspected ER-to-ER transit becomes the requirement.

## Module 7 — Design and implement private access to Azure Services

1. Introduction
2. Explain virtual network service endpoints
3. Define Private Link Service and private endpoint
4. Integrate private endpoint with Domain Name Service
5. Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal
6. Exercise: Create an Azure private endpoint using Azure PowerShell
7. Summary

The study-guide Private Link Service/on-prem integration and Front Door origin Private Link objectives are implemented against the real telemetry and Partner Hub architectures. End-to-end TLS to a Private-Link-enabled App Gateway origin is conditional on a real trusted domain/certificate.

## Module 8 — Design and implement network monitoring

1. Introduction
2. Monitor your networks using Azure Monitor
3. Exercise: Monitor a load balancer resource using Azure monitor
4. Monitor your networks using Azure Network Watcher
5. Summary

Module 8 includes Connection Monitor, Azure Monitor Network Insights, VNet flow logs, Traffic Analytics, resource diagnostics, DDoS/Defender evidence and the deterministic final incident.

## Standard extension/execution pattern

```text
1. Teach the exact Microsoft Learn unit
2. State the BlueHarbor business problem
3. Check AZ700-STUDY-GUIDE-COVERAGE.md for required extensions
4. Explain mental model / analogy
5. Trace architecture / packet / query flow
6. Check understanding
7. Determine the delta from the CURRENT BlueHarbor estate
8. Modify the SAME Terraform root when persistent infrastructure is required
9. terraform fmt / init / validate / plan
10. inspect plan for intended incremental delta
11. apply
12. validate independently with CLI / Portal / protocol tools
13. break/troubleshoot one relevant component
14. reconcile permanent infrastructure fixes into Terraform
15. capture evidence and Git checkpoint
16. carry exact code/state/deployed environment forward
```
