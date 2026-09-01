# BlueHarbor Industries — Module 1 Project Story

## Project brief

BlueHarbor Industries (BHI) is moving selected systems into Azure gradually. You are the Azure Network Engineer responsible for building the network foundation and explaining how names, addresses and packets move through it.

**Primary region:** Australia East  
**Secondary region:** Southeast Asia  
**Terraform model:** first practical establishes the single cumulative `blueharbor/terraform/` state lineage

The project begins with no finished Azure network. Each Microsoft Learn unit introduces the next business requirement, and no pre-story practical counts as completion credit.

## Canonical network contract

The address/subnet plan below is the contract carried into every later module.

### Australia East

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24
```

### Southeast Asia

```text
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

Later modules may add VNets/subnets, but they must not rename or recreate these objects simply because a new module starts.

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

BlueHarbor appoints you to design its Azure network. Understand the business, responsibilities and learning objectives. No Azure deployment is required.

**Current programme position: here.**

## Chapter 02 — Divide the cloud estate properly

**Unit 02 — Explore Azure Virtual Networks**

Design and approve the canonical VNet/subnet contract above. Understand CIDR, non-overlap, subnet purpose and growth before deployment.

## Chapter 03 — One controlled public-facing test service

**Unit 03 — Configure public IP services**

Operations needs a controlled external test endpoint. This creates the reason to understand private/public IPs, static/dynamic assignment and exposure decisions.

Any persistent resource used for the BlueHarbor project is represented in the cumulative Terraform stack.

## Chapter 04 — Build the approved network foundation

**Unit 04 — Exercise: Design and implement a virtual network in Azure**

Create the canonical BlueHarbor VNets and subnets through the cumulative Terraform root. Preserve Microsoft's exercise objective, then independently inspect the resulting Azure state with CLI/Portal.

This is the first major persistent infrastructure checkpoint. Later units modify this same code/state rather than create new lab copies.

## Chapter 05 — Nobody wants to memorise IP addresses

**Unit 05 — Design name resolution for your virtual network**

As workloads grow, changing IPs become an operational problem. Stable names introduce DNS naturally.

Teach Azure DNS behaviour and the matching study-guide depth, including the role of Azure DNS Private Resolver, but do not deploy hybrid resolver endpoints before the hybrid business requirement exists.

## Chapter 06 — Build the internal directory

**Unit 06 — Exercise: Configure domain name servers settings in Azure**

Extend the existing Terraform environment with BlueHarbor's internal/private DNS design and VNet links. Prove it with real DNS queries and deliberately break one DNS path.

The resulting DNS architecture is carried into Module 2; hybrid DNS capability will extend it rather than replace it.

## Chapter 07 — Manufacturing needs Core Services

**Unit 07 — Enable cross-virtual network connectivity with peering**

Manufacturing needs an internal service in Core/Shared Services.

Create the regional peering relationship:

```text
bhi-vnet-mfg-aue <-> bhi-vnet-core-aue
```

DNS may resolve the destination, but separate VNets still need a network path.

```text
DNS success != connectivity success
```

## Chapter 08 — Research must reach Core across regions

**Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering**

Preserve Microsoft's global-peering objective with the existing BlueHarbor VNets:

```text
bhi-vnet-core-aue <-> bhi-vnet-research-sea
```

Prove isolation first, create the global peering through Terraform, then prove the changed connectivity.

## Chapter 09 — Connectivity exists, but the path must be controlled

**Unit 09 — Implement virtual network traffic routing**

Security asks where packets actually travel. Introduce system routes, UDRs, next-hop choice and effective routes using the existing BlueHarbor subnets. Include a deliberate route failure.

Do not design generic routing logic that automatically attaches the same route table to every future special-purpose subnet.

## Chapter 10 — Remove unnecessary public IPs

**Unit 10 — Configure internet access with Azure Virtual NAT**

Selected private Manufacturing workload subnet(s) need outbound Internet access without individual public IPs.

Add NAT Gateway to explicitly selected workload subnets only.

```text
outbound Internet access != unsolicited inbound access
```

Do not create Terraform logic that implicitly associates NAT Gateway with every subnet added later.

## Chapter 11 — Architecture review

**Unit 11 — Summary**

Explain the complete Module 1 network from any workload: IP/subnet/VNet, DNS path, cross-VNet path, effective route, outbound Internet path and likely failure points.

## Module 1 end state carried into Module 2

The following are deployed, Terraform-managed and remain in the same state:

```text
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-research-sea
canonical subnets
private DNS architecture / VNet links
Core <-> Manufacturing peering
Core <-> Research global peering
routing configuration
selected NAT Gateway association(s)
```

Module 2 starts from this exact environment and adds hybrid connectivity. It does not rename, rebuild or conceptually recreate the Module 1 network.
