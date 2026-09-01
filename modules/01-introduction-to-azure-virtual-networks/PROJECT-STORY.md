# BlueHarbor Industries — Module 1 Project Story

## Project brief

BlueHarbor Industries (BHI) is moving selected systems into Azure gradually. You are the Azure Network Engineer responsible for building the network foundation and explaining how names, addresses and packets move through it.

**Primary region:** Australia East  
**Secondary region:** Southeast Asia

The project begins with **no finished Azure network**. Each Microsoft Learn unit introduces the next business requirement, and no pre-story practical counts as completion credit.

## Business divisions

```text
BlueHarbor Industries
|
+-- Core / Shared Services
|   +-- management
|   +-- DNS / common services
|   +-- internal applications
|
+-- Manufacturing
|   +-- production applications
|   +-- operational data
|
+-- Research
    +-- development
    +-- experimental workloads
```

## Chapter 01 — Migration brief

**Unit 01 — Introduction**

BlueHarbor appoints you to design its Azure network. First understand the business, final responsibilities and learning objectives. No Azure deployment is required.

**Current programme position: here.**

## Chapter 02 — Divide the cloud estate properly

**Unit 02 — Explore Azure Virtual Networks**

BlueHarbor wants separate network boundaries with room to grow.

```text
Australia East
bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16

Southeast Asia
bhi-vnet-research-sea   10.30.0.0/16
```

Design subnets, understand CIDR/non-overlap and reserve growth before deployment.

## Chapter 03 — One controlled public-facing test service

**Unit 03 — Configure public IP services**

Operations needs a temporary external test endpoint. This creates the reason to understand private/public IPs, static/dynamic assignment and exposure decisions.

## Chapter 04 — Build the approved network foundation

**Unit 04 — Exercise: Design and implement a virtual network in Azure**

Deploy the BlueHarbor VNet/subnet plan from this story and validate actual Azure state with CLI. Do not reuse the old pre-story VNet practical.

## Chapter 05 — Nobody wants to memorise IP addresses

**Unit 05 — Design name resolution for your virtual network**

As workloads grow, changing IPs become an operational problem. Stable names introduce DNS naturally. Teach Microsoft Learn DNS behaviour first, then attach current study-guide depth such as Azure DNS Private Resolver inside the matching objective.

## Chapter 06 — Build the internal directory

**Unit 06 — Exercise: Configure domain name servers settings in Azure**

Implement BlueHarbor's internal naming strategy and prove it with real DNS queries. Deliberately break one DNS path and diagnose it.

## Chapter 07 — Manufacturing needs Core Services

**Unit 07 — Enable cross-virtual network connectivity with peering**

DNS may resolve the destination but separate VNets still lack a network path. This makes peering necessary and reinforces `DNS success != connectivity success`.

## Chapter 08 — Prove isolation, then connect

**Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering**

Show failure before peering, create the Microsoft exercise connectivity, then prove success. Distinguish DNS, route and application results.

## Chapter 09 — Connectivity exists, but the path must be controlled

**Unit 09 — Implement virtual network traffic routing**

Security asks where packets actually travel. Introduce system routes, UDRs, next-hop choice and effective routes. Include a deliberate route failure.

## Chapter 10 — Remove unnecessary public IPs

**Unit 10 — Configure internet access with Azure Virtual NAT**

Private workloads need outbound updates/services without individual public IPs. Introduce NAT Gateway and outbound SNAT while distinguishing outbound initiation from unsolicited inbound access.

## Chapter 11 — Architecture review

**Unit 11 — Summary**

Explain the complete Module 1 network from any workload: IP/subnet/VNet, DNS path, cross-VNet path, effective route, outbound Internet path and likely failure points.

## Handoff to Module 2

The Azure network now works. BlueHarbor's physical sites and remote engineers still need secure connectivity into it, which begins Module 2.
