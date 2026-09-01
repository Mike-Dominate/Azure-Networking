# BlueHarbor Industries — Module 1 Project Story

## Project brief

BlueHarbor Industries (BHI) is moving selected business systems into Azure. The migration is intentionally gradual: the network must evolve safely as new requirements appear.

You are the Azure Network Engineer responsible for the design, implementation, validation and troubleshooting of the cloud network.

**Primary region:** Australia East  
**Secondary region:** Southeast Asia

## Initial business divisions

```text
BlueHarbor Industries
|
+-- Shared Services
|   +-- management
|   +-- DNS / common services
|   +-- internal applications
|
+-- Manufacturing
|   +-- production applications
|   +-- operational data systems
|
+-- Research
    +-- development workloads
    +-- experimental systems
```

The project begins with no finished Azure architecture. Each Microsoft Learn unit introduces the next business requirement.

---

## Chapter 01 — Migration brief

**Microsoft Learn Unit 01 — Introduction**

BlueHarbor appoints you to build the Azure networking foundation. Your job is not simply to create resources; you must be able to explain how names, addresses and packets move through the final environment.

No Azure deployment is required for this orientation chapter.

---

## Chapter 02 — Divide the cloud estate properly

**Microsoft Learn Unit 02 — Explore Azure Virtual Networks**

BlueHarbor wants Shared Services, Manufacturing and Research separated into distinct network boundaries with room to grow.

Proposed conceptual design:

```text
Australia East

bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16

Southeast Asia

bhi-vnet-research-sea   10.30.0.0/16
```

Example subnet plan:

```text
bhi-vnet-core-aue
  10.10.1.0/24  management
  10.10.2.0/24  shared-services

bhi-vnet-mfg-aue
  10.20.1.0/24  manufacturing-app
  10.20.2.0/24  manufacturing-data

bhi-vnet-research-sea
  10.30.1.0/24  research-app
  10.30.2.0/24  research-data
```

Teaching goal: understand VNet boundaries, subnets, CIDR planning, non-overlap and growth before deployment.

---

## Chapter 03 — BlueHarbor needs one public-facing test service

**Microsoft Learn Unit 03 — Configure public IP services**

Operations needs one temporary test workload reachable from outside Azure.

This creates a reason to understand:

```text
private IP vs public IP
static vs dynamic assignment
public exposure vs private-only workloads
```

The early architecture is intentionally simple so we can later improve it.

---

## Chapter 04 — Build the approved network foundation

**Microsoft Learn Unit 04 — Exercise: Design and implement a virtual network in Azure**

The network design is approved. Build the Azure VNets/subnets and validate the resulting address plan.

Prior practical evidence from the original VNet/IP lab is preserved under this unit's `practical/` folder.

Engineering requirement: provisioning state alone is not enough. Validate actual address spaces and subnet definitions from Azure CLI.

---

## Chapter 05 — Nobody wants to memorise IP addresses

**Microsoft Learn Unit 05 — Design name resolution for your virtual network**

The environment is growing. Teams are passing addresses around in tickets and documentation:

```text
10.10.2.4
10.20.1.7
10.30.1.5
```

Those addresses can change. BlueHarbor wants stable names instead.

This business problem introduces DNS naturally:

```text
name
  -> DNS resolution
  -> IP address
```

The unit teaches the Microsoft Learn name-resolution model first, including Azure public/private DNS concepts and VNet DNS behaviour. Current AZ-700 study-guide depth such as Azure DNS Private Resolver is attached only after the core Microsoft unit is understood.

**Current programme position: here.**

---

## Chapter 06 — Build the internal directory

**Microsoft Learn Unit 06 — Exercise: Configure domain name servers settings in Azure**

BlueHarbor now implements and validates its internal naming strategy.

The practical must prove DNS with real queries, not merely a successful Azure deployment.

Expected learning progression:

```text
create/configure DNS capability
-> link/configure participating VNet
-> query from a workload
-> inspect returned answer
-> deliberately break one DNS path
-> diagnose and restore it
```

---

## Chapter 07 — Manufacturing needs Shared Services

**Microsoft Learn Unit 07 — Enable cross-virtual network connectivity with peering**

Manufacturing needs access to an internal service hosted in the Core/Shared Services VNet.

DNS may know the destination address, but the two VNets are still separate networks.

This creates an important lesson:

```text
name resolution success
!=
network connectivity success
```

VNet peering becomes necessary because of a visible business requirement rather than because it is next on a checklist.

---

## Chapter 08 — Prove isolation, then connect the networks

**Microsoft Learn Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering**

The engineering test should show:

```text
BEFORE peering
connection fails as expected

CREATE peering

AFTER peering
connection succeeds
```

Where the Microsoft exercise uses global peering, keep the exercise objective intact and map it into the BlueHarbor regions.

Validation should distinguish DNS, route and application-layer results.

---

## Chapter 09 — Connectivity exists, but the path must be controlled

**Microsoft Learn Unit 09 — Implement virtual network traffic routing**

Security reviews the environment and asks a different question:

> Just because two networks can communicate, should every destination use Azure's default path?

This introduces:

```text
system routes
user-defined routes
next-hop selection
effective routes
route-based failure analysis
```

A deliberate route failure should be part of the practical so the learner must inspect the effective route rather than guess.

---

## Chapter 10 — Remove unnecessary public IPs

**Microsoft Learn Unit 10 — Configure internet access with Azure Virtual NAT**

Private Manufacturing workloads need operating-system updates and access to approved Internet services, but Security does not want an individual public IP on every VM.

This creates the NAT Gateway requirement:

```text
private workload
    |
    v
subnet
    |
    v
NAT Gateway
    |
    v
Internet
```

Teaching goal: understand outbound SNAT and why outbound connectivity does not imply unsolicited inbound connectivity.

---

## Chapter 11 — Architecture review

**Microsoft Learn Unit 11 — Summary**

BlueHarbor's architecture review board asks you to explain the completed Module 1 network without relying on the Portal.

You should be able to answer from any workload:

```text
What is its private address?
Which subnet and VNet contain it?
How does it resolve a destination name?
How can another VNet reach it?
Which route will its packet use?
How does outbound Internet traffic leave?
What breaks if DNS, peering, a route or NAT is misconfigured?
```

Module 1 is complete only when the learner can explain those paths and reproduce the applicable infrastructure from the rebuild evidence.

## Handoff to Module 2

The Azure network now works, but BlueHarbor still has systems outside Azure.

Module 2 begins with the next business problem:

> How do BlueHarbor's on-premises and remote networks securely connect to the Azure network we just built?

That question leads directly into Microsoft Learn Module 2 — Design and implement hybrid networking.
