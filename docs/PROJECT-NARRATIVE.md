# BlueHarbor Industries — Progressive AZ-700 Engineering Project

## Purpose

This repository follows Microsoft's AZ-700 Microsoft Learn path using one continuous fictional business story instead of unrelated labs.

**Company:** BlueHarbor Industries (BHI)  
**Role:** Azure Network Engineer  
**Primary Azure region:** Australia East  
**Secondary Azure region:** Southeast Asia

BlueHarbor is an industrial technology manufacturer with corporate services, manufacturing systems and a growing research division. The company is moving workloads into Azure gradually while retaining part of its existing on-premises estate.

The Microsoft Learn module and unit order remains authoritative. The BlueHarbor story exists only to give every Microsoft concept a reason to be introduced.

## Programme rule

```text
Microsoft Learn unit
  -> new BlueHarbor business requirement
  -> design decision
  -> implementation
  -> validation
  -> deliberate failure / troubleshooting
  -> Terraform where appropriate
  -> evidence
  -> carry the architecture forward
```

We do not reset the story after each unit. Network foundations persist conceptually across the module. Costly compute can be ephemeral, but the architecture evolves rather than restarting as an unrelated lab.

## Progressive story across the eight Microsoft Learn modules

### Module 1 — Introduction to Azure Virtual Networks

BlueHarbor begins its Azure migration. Build the cloud network foundation for shared services, manufacturing and research. Add public/private addressing, DNS, VNet connectivity, routing policy and controlled outbound internet access.

End state: a multi-VNet Azure network that the learner can explain packet-by-packet and query-by-query.

### Module 2 — Design and implement hybrid networking

BlueHarbor still operates servers and industrial systems on-premises. Connect the existing estate to the Azure network built in Module 1 using VPN Gateway, Site-to-Site VPN, Point-to-Site VPN and Virtual WAN concepts.

End state: Azure and BlueHarbor's remote/on-premises networks can communicate through understood hybrid paths.

### Module 3 — Design and implement Azure ExpressRoute

The business now classifies several workloads as mission-critical. Internet-based VPN alone is no longer the desired primary enterprise connectivity model. Design ExpressRoute, peering, resiliency, Global Reach, FastPath and BGP behaviour.

End state: an enterprise private-connectivity design with clear route and redundancy reasoning.

### Module 4 — Load balance non-HTTP(S) traffic in Azure

BlueHarbor must distribute regional service traffic and make global DNS-based endpoint decisions. Existing Azure Load Balancer and Traffic Manager engineering work is mapped into this module and reviewed in Microsoft Learn order.

### Module 5 — Load balance HTTP(S) traffic in Azure

BlueHarbor launches customer and partner web applications. Design Application Gateway and Front Door for regional and global HTTP(S) delivery.

### Module 6 — Design and implement network security

BlueHarbor's security team formalises network controls. Add Defender for Cloud recommendations, DDoS Protection, NSGs, Azure Firewall, Firewall Manager and WAF.

### Module 7 — Design and implement private access to Azure Services

Application teams begin adopting Azure PaaS services. Remove unnecessary public service exposure using service endpoints, Private Link and private endpoints, including DNS integration.

### Module 8 — Design and implement network monitoring

Operations requires evidence, alerting and troubleshooting visibility across the completed network. Implement Azure Monitor, Network Watcher and the monitoring capabilities required by the module and AZ-700 study guide.

## Engineering principle

Every new Azure service must answer a business or technical problem already visible in the story.

Examples:

```text
Users memorising IPs
    -> DNS becomes necessary

Two VNets cannot communicate
    -> peering becomes necessary

Default path does not satisfy policy
    -> routing becomes necessary

Private servers need outbound internet without public IPs
    -> NAT Gateway becomes necessary

On-premises systems must reach Azure
    -> hybrid networking becomes necessary
```

The goal is to understand why a networking component exists before learning how to deploy it.
