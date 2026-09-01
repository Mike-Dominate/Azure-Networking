# BlueHarbor Industries — Module 3 Project Story

## Project — Upgrade BlueHarbor to enterprise private connectivity

**Microsoft Learn module:** Design and implement Azure ExpressRoute  
**Status:** NOT STARTED  
**Company:** BlueHarbor Industries (BHI)

## Starting point from Module 2

BlueHarbor already has working hybrid connectivity:

```text
Brisbane HQ      -- Site-to-Site VPN --\
Perth Site       -- Site-to-Site VPN ---+--> BlueHarbor Azure
Remote Engineers -- Point-to-Site VPN --/
```

The company can reach Azure. The new problem is no longer basic connectivity.

BlueHarbor now runs mission-critical engineering, manufacturing, ERP and shared-service workloads that require a more predictable enterprise connectivity model.

The Module 3 business question is:

> Which workloads should move from Internet-based VPN as the primary path to private enterprise connectivity through Microsoft and a connectivity provider?

The Microsoft Learn unit order remains authoritative. Each unit below is the next chapter of this same project.

---

## Chapter 01 — Introduction: VPN works, so why change it?

BlueHarbor's VPN architecture from Module 2 remains valid, but several workloads have become business-critical.

### Business requirement

Review whether Internet-based VPN should remain the primary path for:

- large engineering and PLM transfers;
- manufacturing systems;
- ERP workloads;
- latency-sensitive services;
- critical shared services.

### Decision to understand

```text
Site-to-Site VPN
- encrypted over the public Internet
- relatively simple and flexible
- appropriate for many hybrid workloads

ExpressRoute
- private provider connectivity to Microsoft
- enterprise bandwidth and resiliency options
- BGP-based routing
- higher cost and design complexity
```

A key mental model for the entire module:

> Private connectivity and encryption are different properties. ExpressRoute is private connectivity, but privacy alone does not automatically mean end-to-end encryption.

---

## Chapter 02 — Explore Azure ExpressRoute: Understand the private path

Architecture asks what ExpressRoute actually consists of before BlueHarbor commits to it.

### Architecture introduced

```text
BlueHarbor network
       |
Customer edge router
       |
Connectivity provider
       |
ExpressRoute peering location
       |
Microsoft network
       |
Azure
```

### Concepts to master

- ExpressRoute circuit
- connectivity provider
- peering location
- Microsoft Enterprise Edge / Microsoft network edge concepts
- private enterprise connectivity
- circuit versus physical connection
- provider versus Microsoft versus customer responsibilities

### Engineering question

For every component in the path, be able to explain who owns it, what it does and what failure of that component would mean.

---

## Chapter 03 — Design an ExpressRoute deployment: Decide what BlueHarbor is actually buying

Procurement asks for an implementable design instead of the instruction 'buy ExpressRoute'.

### Business requirement

Design private connectivity for BlueHarbor's critical workloads between its physical estate and Azure Australia, while considering future Southeast Asia requirements.

### Design decisions

- connectivity model
- connectivity provider
- peering location
- bandwidth
- SKU / tier
- gateway architecture
- regional and global reach requirements
- redundancy
- disaster recovery
- ExpressRoute Direct concepts where appropriate
- VPN coexistence / backup strategy

### Engineering scenario

```text
Brisbane HQ
   |
critical ERP / engineering / manufacturing traffic
   v
Australia East Azure

Singapore research office
   |
future private-connectivity requirement
   v
Southeast Asia Azure
```

The learner should be able to justify the design from requirements rather than from memorised defaults.

---

## Chapter 04 — Exercise: Configure an ExpressRoute gateway

The circuit design is approved. BlueHarbor now prepares its Azure VNets to participate in ExpressRoute connectivity.

### Architecture introduced

```text
ExpressRoute circuit
        |
ExpressRoute Gateway
        |
CoreServicesVnet
        |
        +-- Manufacturing
        +-- Research
```

### Critical distinction

```text
ExpressRoute circuit
!=
ExpressRoute gateway
```

The circuit represents the private connectivity service toward Microsoft's edge. The gateway connects a VNet to that ExpressRoute connectivity architecture.

### BlueHarbor engineering extension

After the Microsoft exercise, inspect and explain:

- the `GatewaySubnet`;
- gateway type and SKU;
- VNet-to-circuit relationship;
- gateway role in control/data-plane behaviour;
- how this differs from the VPN gateway work in Module 2.

---

## Chapter 05 — Exercise: Provision an ExpressRoute circuit

BlueHarbor now orders the logical Azure circuit that the connectivity provider will provision against.

### Provisioning flow

```text
BlueHarbor creates ExpressRoute circuit
        |
        v
Azure provides service key
        |
        v
Connectivity provider receives key
        |
        v
Provider provisions connectivity
        |
        v
Circuit progresses through provisioning state
```

### Concepts to master

- service provider
- peering location
- bandwidth
- SKU / tier
- billing model
- service key
- provider provisioning state
- Azure circuit state

### Mental model

The service key is the identifier the provider uses to associate its provisioning work with the correct Azure ExpressRoute circuit.

### Practicality rule

Do not incur carrier-level costs just to claim completion. Use safe Azure-side configuration and serious provider/BGP simulation where a real provider handoff is impractical.

---

## Chapter 06 — Configure peering: The private path needs routes

The circuit exists, but BlueHarbor and Microsoft still need a routing relationship so each side knows which prefixes are reachable.

### Routing story

```text
BlueHarbor advertises
172.16.0.0/16
172.17.0.0/16

Azure side provides reachability for
10.10.0.0/16
10.20.0.0/16
10.30.0.0/16
```

### Concepts to master

- BGP
- ASN
- neighbor / peer
- BGP session
- prefix advertisement
- learned route
- Azure private peering
- Microsoft peering
- route advertisements

### Core mental model

> The private transport path is the road; BGP exchanges the maps that tell each side which destinations are reachable through that road.

Azure private peering should be anchored first as the path between BlueHarbor private networks and Azure private addresses.

---

## Chapter 07 — Design an ExpressRoute circuit for resiliency

Management asks a production question:

> What happens if a fibre, router, provider path or peering location fails?

### Business requirement

Loss of one component must not unnecessarily isolate critical BlueHarbor production workloads.

### Resiliency progression

```text
single path
   -> dual physical paths
   -> redundant BGP sessions
   -> provider diversity
   -> peering-location diversity
   -> circuit diversity
   -> regional disaster-recovery strategy
```

### Concepts to master

- ExpressRoute built-in redundancy concepts
- dual BGP sessions
- active/active path reasoning
- multiple circuits
- provider diversity
- peering-location diversity
- disaster recovery
- Bidirectional Forwarding Detection (BFD) concepts
- encryption-over-ExpressRoute design considerations
- VPN as an alternate path where appropriate

The learner must learn to identify shared failure domains instead of assuming that two lines on a diagram equal resilience.

---

## Chapter 08 — ExpressRoute Global Reach: Connect BlueHarbor sites through Microsoft's backbone

BlueHarbor now has multiple physical locations connected through compatible ExpressRoute circuits and asks whether those sites can communicate privately through Microsoft's network.

### Architecture

```text
Brisbane on-premises
        |
   ExpressRoute
        |
Microsoft backbone
        |
   ExpressRoute
        |
Singapore on-premises
```

### Business requirement

Provide private site-to-site connectivity between supported BlueHarbor on-premises locations without making Azure workloads the destination of every flow.

### Mental model

```text
Normal ExpressRoute
on-premises -> Microsoft/Azure

Global Reach
on-premises -> Microsoft backbone -> other on-premises
```

The learner should be able to distinguish Global Reach from VNet peering, VPN and ordinary ExpressRoute VNet connectivity.

---

## Chapter 09 — ExpressRoute FastPath: Shorten selected data paths

A latency-sensitive BlueHarbor manufacturing or engineering workload requires a more direct data path.

### Normal mental model

```text
On-premises
   |
ExpressRoute
   |
ExpressRoute Gateway
   |
Azure workload
```

### FastPath mental model

```text
Control / route architecture
still includes the ExpressRoute gateway

Supported data path
On-premises
   |
ExpressRoute
   +----------> Azure workload
       FastPath
```

### Concepts to master

- FastPath purpose
- control-plane versus data-plane reasoning
- supported traffic/path behaviour
- why 'FastPath is faster' is an incomplete explanation

The learner should be able to explain what changes in the data path and what architectural role the gateway still retains.

---

## Chapter 10 — Troubleshoot ExpressRoute connection issues: Production incident

At 09:15 on Monday, BlueHarbor Manufacturing reports that an Azure ERP service is unreachable from Brisbane.

The learner must troubleshoot the path methodically rather than restart components randomly.

### Troubleshooting chain

```text
Application / destination
        |
Azure NIC / VNet route
        |
ExpressRoute Gateway
        |
BGP learned route
        |
ExpressRoute peering
        |
Circuit state
        |
Provider path
        |
BlueHarbor edge router
```

### Deliberate failure candidates

- BGP session down
- incorrect ASN
- incorrect peer addressing
- expected prefix not advertised
- route filtering problem
- provider provisioning problem
- gateway not connected as expected
- route preference issue
- asymmetric routing
- single-path/provider failure

### Troubleshooting principle

```text
circuit
 -> peering
 -> BGP
 -> learned routes
 -> gateway / VNet
 -> workload
```

BGP depth for this module should be practical rather than certification-detour depth: ASN, neighbor, session, prefix, advertisement, learned route and preferred path.

---

## Chapter 11 — Summary and resources: BlueHarbor Architecture Review Board

The learner presents the complete enterprise-connectivity design and answers questions without relying on the Portal.

### Explain-back questions

- Why ExpressRoute instead of relying only on Site-to-Site VPN?
- What useful role can VPN still retain?
- What is an ExpressRoute circuit?
- What is an ExpressRoute gateway?
- What is ExpressRoute peering?
- What routes does BGP exchange?
- What happens when a provider path or circuit fails?
- Why and when would BlueHarbor use Global Reach?
- Why and when would BlueHarbor use FastPath?
- Does private ExpressRoute connectivity automatically mean encrypted traffic?
- Where would encryption be introduced when required?
- How would you troubleshoot an outage from provider edge to Azure workload?

## Definition of done for Module 3

The learner can design, explain and troubleshoot:

- the ExpressRoute end-to-end ownership model;
- connectivity model, SKU/tier and peering-location choices;
- circuit versus gateway;
- provider provisioning and service key flow;
- Azure private and Microsoft peering concepts;
- BGP route exchange;
- redundancy and disaster recovery;
- Global Reach;
- FastPath;
- common ExpressRoute failure scenarios.

## Carry-forward into Module 4

BlueHarbor now has mature network connectivity, but application availability introduces the next question:

> How should client traffic be distributed across healthy service endpoints when one backend, region or endpoint becomes unavailable?

That leads into Module 4 — Load balance non-HTTP(S) traffic in Azure.
