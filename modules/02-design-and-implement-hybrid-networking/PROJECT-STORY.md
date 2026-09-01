# BlueHarbor Industries — Module 2 Project Story

## Project — Connect BlueHarbor's real-world networks to Azure

**Microsoft Learn module:** Design and implement hybrid networking  
**Status:** NOT STARTED  
**Company:** BlueHarbor Industries (BHI)

## Starting point from Module 1

BlueHarbor has completed the Azure network foundation conceptually:

```text
Azure

CoreServicesVnet       10.10.0.0/16
ManufacturingVnet      10.20.0.0/16
ResearchVnet           10.30.0.0/16

+ DNS
+ VNet connectivity
+ routing
+ controlled outbound internet access
```

But Azure is only part of the company. BlueHarbor still operates physical sites and supports remote engineers:

```text
Brisbane HQ / Data Centre        172.16.0.0/16
Perth Manufacturing Site         172.17.0.0/16
Remote engineers                 home / hotel / customer networks
Future branches                  additional sites expected
```

The Module 2 business problem is therefore:

> The Azure network works. Now connect BlueHarbor's existing locations and individual remote users to it securely, then evolve the design as the organisation grows.

The Microsoft Learn unit order is authoritative. Each unit below is the next chapter of this same project.

---

## Chapter 01 — Introduction: Azure is an island

BlueHarbor's Azure VNets can communicate according to the Module 1 design, but the Brisbane and Perth networks have no path into Azure.

```text
Brisbane HQ                         Azure
172.16.0.0/16                         10.x.x.x
     |                                   |
     X -------- no hybrid path -------- X
```

### Engineering question

What connectivity models are appropriate for:

- an entire office or factory network;
- one remote user's device;
- many branches at larger scale?

This chapter establishes the hybrid-networking requirements before any gateway is deployed.

---

## Chapter 02 — Design and implement Azure VPN Gateway: Build the Azure edge

Management approves encrypted connectivity over the public Internet between BlueHarbor sites and Azure.

Before building a tunnel, Azure needs a managed VPN termination point.

```text
Brisbane HQ
172.16.0.0/16
      |
      | encrypted IPsec/IKE tunnel
      v
Azure VPN Gateway
      |
      v
BlueHarbor Azure VNets
```

### Business requirement

Design an Azure VPN edge capable of connecting BlueHarbor networks securely and with appropriate availability and throughput.

### Concepts this requirement introduces

- VPN Gateway
- `GatewaySubnet`
- gateway SKU selection
- public IP used by the gateway
- route-based versus policy-based VPN concepts
- active-active versus active-standby considerations
- throughput and resiliency
- non-overlapping address-space planning

### Engineering questions

- Which prefixes exist on both sides?
- Do any overlap?
- What availability is required?
- What throughput is required?
- What VPN capabilities exist at the remote site?
- Which routes must be exchanged or made reachable?

---

## Chapter 03 — Exercise: Create and configure a virtual network gateway

Architecture approves the Azure-side design.

BlueHarbor now builds the gateway infrastructure in the Azure network.

```text
CoreServicesVnet
10.10.0.0/16
|
+-- ManagementSubnet
+-- SharedServicesSubnet
+-- GatewaySubnet
        |
        v
 Azure VPN Gateway
        |
   Gateway public IP
```

### Project objective

Complete the Microsoft exercise, then inspect the result as an engineer rather than treating a successful deployment as sufficient evidence.

### BlueHarbor engineering extension

- inspect the `GatewaySubnet`;
- inspect gateway type and SKU;
- inspect the gateway public IP;
- understand that the service is Microsoft managed rather than a VM we administer;
- capture the Azure-side architecture before connecting a remote network.

---

## Chapter 04 — Site-to-Site VPN: Brisbane HQ joins Azure

The Azure gateway exists. Infrastructure now requires a permanent network-to-network connection from Brisbane HQ.

```text
BlueHarbor Brisbane HQ
172.16.0.0/16
      |
On-premises VPN device
      |
      | IPsec/IKE over Internet
      v
Azure VPN Gateway
      |
      v
CoreServices / Manufacturing / Research
```

### Business requirement

Servers and users at Brisbane HQ must reach permitted Azure private addresses without each user manually starting a VPN session.

### Concepts this introduces

- Site-to-Site VPN
- IPsec / IKE
- Local Network Gateway
- Azure VPN Connection resource
- remote-site prefixes
- tunnel establishment
- route reachability

### Key mental model

The Azure **Local Network Gateway** is not the physical router. It is Azure's representation of the remote network, including the remote VPN endpoint and address prefixes.

```text
Azure VPN Gateway
        <->
Connection
        <->
Local Network Gateway
        <->
BlueHarbor remote VPN device/network
```

### Practical approach

Where a physical data centre is unavailable, create a clearly labelled **on-premises simulation** for learning. Do not pretend an Azure-hosted simulation is literally an on-premises facility. The goal is to observe authentic tunnel, routing and validation behaviour at acceptable cost.

---

## Chapter 05 — Point-to-Site VPN: A remote engineer needs access

A BlueHarbor engineer is working from a hotel/customer site and needs access to Azure administration services.

Connecting the entire hotel or customer network to BlueHarbor would make no sense. Only the engineer's device needs secure access.

```text
Remote engineer laptop
        |
        | client VPN over Internet
        v
Azure VPN Gateway
        |
        v
Permitted BlueHarbor Azure networks
```

### Business requirement

Provide secure individual-device connectivity into Azure without creating a Site-to-Site relationship for every location a user visits.

### Concepts this introduces

- Point-to-Site VPN
- Azure VPN Client
- OpenVPN / IKEv2 / SSTP concepts where applicable
- client address pool
- Entra ID authentication concepts
- RADIUS / AD authentication concepts
- routes presented to the client
- DNS behaviour while connected

### Key distinction

```text
Site-to-Site
network <-> network

Point-to-Site
individual device <-> Azure network
```

### Validation goal

Prove that the Azure private destination is unreachable before the client VPN is established, then reachable through the intended VPN path afterward.

---

## Chapter 06 — Azure Virtual WAN: BlueHarbor grows beyond a few tunnels

BlueHarbor expands:

```text
Brisbane HQ
Perth factory
Melbourne warehouse
Singapore research office
remote engineers
Azure Australia
Azure Southeast Asia
```

Operations now sees growing numbers of individual connectivity relationships and asks whether this is still the correct operational model.

### Business requirement

Create a scalable connectivity architecture for branches, remote users and Azure VNets without independently managing every relationship as a separate design problem.

### Concepts this introduces

- Azure Virtual WAN
- Virtual Hub
- sites
- hub VNet connections
- hub routing
- branch connectivity
- Site-to-Site and Point-to-Site integration
- transitive connectivity concepts

### Evolution of the architecture

```text
Earlier
site -> individual VPN relationship -> Azure

Growth stage
many sites/users -> Virtual WAN hub -> Azure networks
```

Virtual WAN is introduced only after the simpler VPN model has become operationally harder to scale, so its purpose is clear.

---

## Chapter 07 — Exercise: Create a Virtual WAN

BlueHarbor architecture approves a central WAN proof of concept for future branch growth.

### Project objective

Complete the Microsoft Virtual WAN exercise, then inspect the objects and routing relationships created.

### BlueHarbor engineering extension

- inspect the Virtual WAN;
- inspect virtual hub address space;
- inspect VNet connections;
- inspect hub routing concepts;
- document which relationships the hub simplifies;
- keep billable resources short-lived where appropriate.

---

## Chapter 08 — NVA in a virtual hub: Integrate existing SD-WAN/security technology

Procurement and the network team reveal that BlueHarbor already uses partner SD-WAN/security appliances at some branches.

The company does not want to discard the existing WAN investment simply because Azure Virtual WAN has been introduced.

```text
Branch
  |
existing SD-WAN / CPE
  |
  v
Azure Virtual WAN
  |
partner NVA in virtual hub
  |
  v
BlueHarbor Azure networks
```

### Business requirement

Understand how an approved partner network virtual appliance can participate in the Virtual WAN architecture and how traffic is expected to flow through the hub.

### Concepts this introduces

- NVA in a Virtual WAN hub
- managed partner integration concepts
- SD-WAN integration
- routing through the virtual hub
- native Azure VPN versus partner-appliance design trade-offs

### Practicality rule

Do not purchase or deploy a commercial appliance merely to claim completion. Where cost or licensing makes deployment unreasonable, use serious architecture, route-flow, configuration and failure analysis instead.

---

## Chapter 09 — Summary: BlueHarbor hybrid-network architecture review

The Architecture Review Board now asks for an end-to-end explanation of the hybrid environment.

The learner must be able to trace scenarios such as:

```text
Brisbane server 172.16.x.x
        -> remote VPN device
        -> IPsec/IKE tunnel
        -> Azure VPN Gateway
        -> Azure route
        -> destination 10.x.x.x
```

and:

```text
Remote laptop
        -> client authentication
        -> Point-to-Site tunnel
        -> client VPN address
        -> Azure route
        -> permitted private workload
```

and explain why an organisation with many branches may choose Virtual WAN instead of managing a growing set of individual VPN relationships.

## Definition of done for Module 2

The learner can explain, design and troubleshoot:

- why BlueHarbor needs hybrid connectivity;
- the purpose of `GatewaySubnet` and Azure VPN Gateway;
- Site-to-Site packet/tunnel flow;
- the role of the Local Network Gateway and Connection resources;
- Point-to-Site client connectivity and authentication concepts;
- the difference between network-to-network and device-to-network VPN;
- why Virtual WAN becomes useful as branch/user connectivity scales;
- how an NVA can fit into a Virtual WAN hub architecture;
- the routes, endpoints and failure domains involved in each scenario.

## Carry-forward into Module 3

At the end of Module 2, BlueHarbor has a working hybrid-connectivity model. The next business question is no longer *how can we reach Azure?* but:

> Which mission-critical workloads now require a more predictable private enterprise connectivity model than Internet-based VPN as the primary path?

That question starts Module 3 — Azure ExpressRoute.
