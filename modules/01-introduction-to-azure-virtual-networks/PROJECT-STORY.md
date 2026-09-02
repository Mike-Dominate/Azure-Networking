# BlueHarbor Industries — Module 1 Project Story

## Project brief

BlueHarbor Industries is moving selected systems into Azure gradually. You are the Azure Network Engineer responsible for building the network foundation and explaining how names, addresses and packets move through it.

**Primary region:** Australia East  
**Secondary region:** Southeast Asia  
**Terraform model:** first persistent practical establishes the single cumulative `blueharbor/terraform/` state lineage

The project begins with no finished Azure network. Each Microsoft Learn unit introduces the next business requirement, and no pre-story practical counts as completion credit.

## Canonical network contract

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

## Canonical private namespace

BlueHarbor-owned private DNS begins with one parent zone:

```text
blueharbor.internal
```

Later BlueHarbor-owned records such as `telemetry.services.blueharbor.internal` remain beneath this namespace. Microsoft Private Link service zones remain separate because Microsoft owns those namespaces.

## Chapter 01 — Migration brief

**Unit 01 — Introduction**

Understand the company, role, module outcomes and progressive engineering method. No Azure or Terraform deployment is required.

**Current programme position: here.**

## Chapter 02 — Divide the cloud estate properly

**Unit 02 — Explore Azure Virtual Networks**

Design and approve the canonical VNet/subnet contract. Understand CIDR, non-overlap, subnet purpose and growth before deployment.

## Chapter 03 — Understand public IP services before exposing anything

**Unit 03 — Configure public IP services**

Operations needs you to understand how a future Azure service can be exposed safely. Learn public versus private IPs, static/dynamic allocation, SKU/availability concepts and exposure decisions.

Do **not** create a throwaway persistent public endpoint just for this concept unit. Public IP resources will appear naturally later when the persistent story requires VPN gateways, Load Balancers and Application Gateways.

## Chapter 04 — Build the approved network foundation

**Unit 04 — Exercise: Design and implement a virtual network in Azure**

This is the first persistent BlueHarbor infrastructure checkpoint.

Before/within the practical, establish the project `global_suffix`, bootstrap the Azure Blob Terraform backend and migrate the single state lineage, then create the canonical VNets/subnets through the same Terraform root.

Independently inspect Azure state with CLI/Portal after apply.

## Chapter 05 — Nobody wants to memorise IP addresses

**Unit 05 — Design name resolution for your virtual network**

Stable names introduce DNS naturally. Teach Azure-provided DNS, Azure Private DNS and DNS Private Resolver concepts, but do not deploy hybrid resolver endpoints before the hybrid business requirement exists.

Canonical BlueHarbor-owned namespace:

```text
blueharbor.internal
```

## Chapter 06 — Build the internal directory

**Unit 06 — Exercise: Configure domain name servers settings in Azure**

Extend the living Terraform environment with:

```text
Azure Private DNS zone: blueharbor.internal
required VNet links
representative internal records/autoregistration behaviour where appropriate
```

Prove resolution using real queries and deliberately break/recover one DNS path.

Hybrid DNS in Module 2 extends this design; it does not replace it.

## Chapter 07 — Manufacturing needs Core Services

**Unit 07 — Enable cross-virtual network connectivity with peering**

Create:

```text
bhi-vnet-mfg-aue <-> bhi-vnet-core-aue
```

```text
DNS success != connectivity success
```

## Chapter 08 — Research must reach Core across regions

**Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering**

Create:

```text
bhi-vnet-core-aue <-> bhi-vnet-research-sea
```

Prove isolation before and connectivity after the Terraform change.

## Chapter 09 — Connectivity exists, but the path must be controlled

**Unit 09 — Implement virtual network traffic routing**

Learn system routes, UDRs, next-hop choice and effective routes using existing subnets. Do not attach generic route tables to every future special-purpose subnet.

## Chapter 10 — Remove unnecessary public IPs

**Unit 10 — Configure internet access with Azure Virtual NAT**

Make `snet-mfg-app` an explicit NAT-managed workload subnet:

```text
snet-mfg-app
 -> nat-mfg-aue
 -> explicit NAT public IP resource
```

This outbound path is retained for the later public telemetry Load Balancer architecture.

Do not blanket-associate NAT to every subnet.

## Chapter 11 — Architecture review

Explain IP/subnet/VNet placement, DNS resolution, cross-VNet connectivity, effective routing and outbound Internet behaviour from any workload.

## Module 1 end state carried into Module 2

```text
three canonical VNets/subnets
blueharbor.internal private DNS architecture / links
Core <-> Manufacturing peering
Core <-> Research global peering
routing configuration
nat-mfg-aue association to snet-mfg-app
one Azure Blob Terraform state lineage
```

Module 2 starts from this exact environment.
