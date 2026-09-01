# BlueHarbor Industries — Progressive AZ-700 Engineering Project

## Purpose

This repository follows Microsoft's AZ-700 Microsoft Learn path using one continuous fictional business story instead of unrelated labs.

**Company:** BlueHarbor Industries (BHI)  
**Role:** Azure Network Engineer  
**Primary Azure region:** Australia East  
**Secondary Azure region:** Southeast Asia

BlueHarbor is an industrial technology manufacturer with corporate services, manufacturing systems and a growing research division. The company moves into Azure gradually while retaining physical sites and remote users.

## Story-first continuity rule

Microsoft Learn module and unit order is the programme structure. The BlueHarbor story gives every Microsoft concept a business reason to appear.

```text
Microsoft Learn unit
  -> new BlueHarbor requirement
  -> design decision
  -> implementation
  -> validation
  -> failure / troubleshooting
  -> Terraform where appropriate
  -> evidence
  -> architecture carries forward
```

The story does not reset between units or modules.

**Legacy work does not outrank story continuity.** Practical labs created before this progressive story are not treated as completed BlueHarbor chapters. If their assumptions, names, topology or order would dilute the narrative, they are rebuilt from scratch at the correct story point. Git history may retain them for reference, but the active repository teaches only the progressive project.

## Progressive story across the eight Microsoft Learn modules

### Module 1 — Introduction to Azure Virtual Networks

BlueHarbor begins its Azure migration. Design and build the cloud network foundation for shared services, manufacturing and research. Add addressing, public IP concepts, DNS, VNet connectivity, routing policy and controlled outbound Internet access.

**End state:** a multi-VNet Azure foundation that can be explained packet-by-packet and query-by-query.

### Module 2 — Design and implement hybrid networking

BlueHarbor still operates Brisbane/Perth sites and supports remote engineers. Connect the physical estate to the Module 1 Azure network using VPN Gateway, Site-to-Site VPN, Point-to-Site VPN and Virtual WAN concepts.

**End state:** understood hybrid paths between Azure, sites and individual remote devices.

### Module 3 — Design and implement Azure ExpressRoute

Mission-critical engineering, ERP and manufacturing traffic now needs an enterprise private-connectivity design. Introduce ExpressRoute, provider/circuit concepts, peering, BGP, resiliency, Global Reach, FastPath and troubleshooting.

**End state:** a private-connectivity architecture with clear ownership, route and failure-domain reasoning.

### Module 4 — Load balance non-HTTP(S) traffic in Azure

The network path is healthy, but backend and regional failures can still take services down. Build regional Layer 4 availability with Azure Load Balancer, then global DNS-based endpoint selection with Traffic Manager.

**End state:** the learner can distinguish regional backend distribution from global DNS steering and explain health, policy and failover timing.

### Module 5 — Load balance HTTP(S) traffic in Azure

BlueHarbor launches customer and partner web applications. HTTP(S)-specific requirements introduce Application Gateway and Azure Front Door.

### Module 6 — Design and implement network security

BlueHarbor's security team formalises controls with Defender for Cloud recommendations, DDoS Protection, NSGs, Azure Firewall, Firewall Manager and WAF.

### Module 7 — Design and implement private access to Azure Services

Application teams adopt Azure PaaS. BlueHarbor reduces unnecessary public exposure using service endpoints, Private Link/private endpoints and private DNS integration.

### Module 8 — Design and implement network monitoring

Operations requires visibility and evidence across the finished network using Azure Monitor, Network Watcher and the monitoring capabilities required by Microsoft Learn and the current AZ-700 study guide.

## Engineering principle

Every new Azure service must answer a problem already visible in the story.

```text
people depend on changing IP addresses
    -> DNS

separate VNets need a permitted path
    -> peering

default routing does not meet policy
    -> UDR / routing controls

private servers need outbound Internet
    -> NAT Gateway

physical sites need Azure connectivity
    -> hybrid VPN

VPN is no longer the desired primary enterprise path
    -> ExpressRoute

one backend can fail
    -> Azure Load Balancer

regional endpoints need global selection
    -> Traffic Manager
```

The goal is to understand **why** a component exists before learning how to deploy it.
