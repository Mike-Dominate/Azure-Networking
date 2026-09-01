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
  -> extend the existing Terraform architecture
  -> validate the incremental change
  -> failure / troubleshooting
  -> evidence / Git checkpoint
  -> code + state + deployed architecture carry forward
```

The story does not reset between units or modules.

## Infrastructure continuity rule

The project is cumulative in **four dimensions at the same time**:

```text
1. business story
2. architecture
3. Terraform code
4. Terraform state / deployed Azure environment
```

The canonical Terraform root is:

```text
blueharbor/terraform/
```

There is one continuous Terraform state lineage from the first real Azure deployment to the final Module 8 environment.

A later unit does not rebuild an earlier unit independently. It starts from the infrastructure already managed by Terraform and adds or changes only what the new BlueHarbor requirement demands.

Example:

```text
M1 VNet foundation
   + DNS
   + peering
   + routing
   + NAT
   + M2 VPN / Virtual WAN
   + M3 ExpressRoute architecture
   + M4 load balancing
   + M5 HTTP delivery
   + M6 security controls
   + M7 private PaaS access
   + M8 monitoring
   = final BlueHarbor enterprise environment
```

No routine teardown occurs between labs. Git history is the historical checkpoint mechanism; we do not duplicate complete Terraform roots for each lab.

Persistent Azure infrastructure changes are made through Terraform. Azure CLI, Portal and diagnostic tools are used primarily to inspect, validate and troubleshoot the Terraform-managed environment.

**Legacy work does not outrank story continuity.** Practical labs created before this progressive story are not treated as completed BlueHarbor chapters. If their assumptions, names, topology or order would dilute the narrative, they are rebuilt at the correct story point. Git history may retain them for reference, but the active repository teaches only the progressive project.

## Progressive story across the eight Microsoft Learn modules

### Module 1 — Introduction to Azure Virtual Networks

BlueHarbor begins its Azure migration. Design and build the cloud network foundation for shared services, manufacturing and research. Add addressing, public IP concepts, DNS, VNet connectivity, routing policy and controlled outbound Internet access.

**End state:** the first persistent portion of the cumulative Terraform environment — a multi-VNet Azure foundation that can be explained packet-by-packet and query-by-query.

### Module 2 — Design and implement hybrid networking

BlueHarbor still operates Brisbane/Perth sites and supports remote engineers. Extend the **same Module 1 Terraform environment** with VPN Gateway, Site-to-Site VPN, Point-to-Site VPN and Virtual WAN concepts.

**End state:** the original Azure foundation plus understood hybrid paths between Azure, sites and individual remote devices.

### Module 3 — Design and implement Azure ExpressRoute

Mission-critical engineering, ERP and manufacturing traffic now needs an enterprise private-connectivity design. Extend the existing environment with the Azure-side ExpressRoute architecture that can be provisioned in the lab, plus provider/circuit, peering, BGP, resiliency, Global Reach, FastPath and troubleshooting knowledge.

**End state:** the same enterprise estate with a mature private-connectivity architecture and clear ownership, route and failure-domain reasoning.

### Module 4 — Load balance non-HTTP(S) traffic in Azure

The network path is healthy, but backend and regional failures can still take services down. Add regional Layer 4 availability with Azure Load Balancer, then global DNS-based endpoint selection with Traffic Manager to the environment already built.

### Module 5 — Load balance HTTP(S) traffic in Azure

BlueHarbor launches customer and partner web applications. Extend the existing environment with Application Gateway and Azure Front Door for HTTP(S)-specific delivery.

### Module 6 — Design and implement network security

BlueHarbor's security team hardens the infrastructure already built. Add Defender for Cloud recommendations, DDoS Protection, NSGs/ASGs, Azure Firewall, Firewall Manager and WAF without resetting the earlier architecture.

### Module 7 — Design and implement private access to Azure Services

Application teams adopt Azure PaaS. Extend the same estate with service endpoints, Private Link/private endpoints and private DNS integration so managed services participate in the existing network design.

### Module 8 — Design and implement network monitoring

Operations adds Azure Monitor, Network Watcher and required diagnostics to **the complete BlueHarbor environment built through Modules 1–7**.

The final module therefore observes and troubleshoots the same infrastructure whose networking, hybrid connectivity, application delivery, security and private-access layers were created progressively throughout the programme.

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

The goal is to understand **why** a component exists, add it to the living Terraform environment, prove it works and then carry it into the next requirement.
