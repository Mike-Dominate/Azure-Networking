# BlueHarbor Industries — Module 2 Project Story

## Project — Connect BlueHarbor's real-world networks to Azure

**Microsoft Learn module:** Design and implement hybrid networking  
**Status:** NOT STARTED  
**Company:** BlueHarbor Industries (BHI)  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 1

Module 1 is already deployed and remains present:

```text
Australia East
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24

Southeast Asia
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24

+ private DNS architecture / links
+ Core <-> Manufacturing peering
+ Core <-> Research global peering
+ routing
+ selected NAT
```

Nothing above is renamed or recreated for Module 2.

BlueHarbor still operates:

```text
Brisbane HQ / Data Centre        172.16.0.0/16
Perth Manufacturing Site         172.17.0.0/16
Remote engineers                 home / hotel / customer networks
Reserved P2S client pool         172.31.240.0/24
```

The business problem is:

> The Azure estate works internally. Now connect BlueHarbor's physical locations and individual remote users into that same private network.

---

## Chapter 01 — Introduction: Azure is an island

Brisbane/Perth have no hybrid route into the Terraform-managed Azure environment.

```text
Brisbane 172.16.0.0/16             BlueHarbor Azure 10.x
       |                                  |
       X ---------- no path ------------- X
```

Establish requirements for office/factory network connectivity, individual-device access and larger branch-scale connectivity.

---

## Chapter 02 — Design Azure VPN Gateway: add a dedicated connectivity edge

Management approves encrypted Internet-based hybrid connectivity.

Instead of inserting the gateway into `bhi-vnet-core-aue`, add a dedicated connectivity VNet:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16

  snet-dns-inbound          10.100.10.0/28
  snet-dns-outbound         10.100.10.16/28
  GatewaySubnet             10.100.255.0/26
```

The DNS subnets are reserved for the hybrid DNS requirement later in this module. `GatewaySubnet` is reserved solely for the virtual network gateway service.

Concepts:

- VPN Gateway
- `GatewaySubnet`
- gateway SKU / availability
- gateway public IP
- route-based versus policy-based concepts
- throughput / resiliency
- address-space non-overlap
- dedicated connectivity VNet versus workload VNets

---

## Chapter 03 — Exercise: create the virtual network gateway

Extend the same Terraform stack with:

```text
bhi-vnet-connectivity-aue
GatewaySubnet
VPN Gateway public IP
Azure VPN Gateway
```

Then create directional peerings between the connectivity VNet and the existing workload VNets.

For classic VPN gateway transit, explicitly reason about settings such as:

```text
connectivity side:
  allow_gateway_transit
  allow_forwarded_traffic where required

workload side:
  use_remote_gateways
  allow_forwarded_traffic where required
```

Do not assume VNet peering is transitive.

Validate that no Module 1 resource was unexpectedly destroyed/replaced by the Terraform plan.

---

## Chapter 04 — Site-to-Site VPN: Brisbane HQ joins the existing Azure estate

Add Azure's representation of Brisbane and the VPN connection:

```text
Brisbane HQ 172.16.0.0/16
       |
on-premises VPN device/simulation
       |
   IPsec/IKE
       |
Azure VPN Gateway
bhi-vnet-connectivity-aue
       |
explicit gateway transit
       |
Core / Manufacturing / Research
```

Persistent Terraform additions include the Local Network Gateway and Connection resource plus any required in-place peering changes.

### Critical mental model

The Local Network Gateway is Azure's representation of the remote VPN endpoint/prefixes. It is not the physical router.

### Hybrid DNS extension

IP connectivity and name resolution are tested separately.

When Brisbane must resolve BlueHarbor private Azure names, extend the Module 1 DNS design rather than replace it.

The reserved resolver subnets allow Azure DNS Private Resolver endpoints/forwarding configuration to be added when required.

Validation questions:

```text
Can Brisbane reach the Azure private IP?
Can Brisbane resolve the Azure private name?
Can Azure resolve required on-premises names if that requirement is enabled?
```

---

## Chapter 05 — Point-to-Site VPN: a remote engineer needs access

An individual remote engineer needs private access without connecting an entire hotel/customer network.

```text
remote laptop
     |
client VPN
     |
Azure VPN Gateway
     |
existing BlueHarbor Azure estate
```

Use the reserved client address pool:

```text
172.31.240.0/24
```

Cover client protocol/authentication choices, route presentation and DNS behaviour while connected.

Validate failure before connection and successful private access after connection.

---

## Chapter 06 — Azure Virtual WAN: branch scale creates a new architecture question

BlueHarbor grows beyond a few direct relationships.

Virtual WAN is introduced because branch/user connectivity is becoming an operational architecture problem, not because Module 2 starts over.

Potential estate now includes:

```text
Brisbane HQ
Perth factory
future branches
remote engineers
Azure Australia
Azure Southeast Asia
```

Introduce:

- Azure Virtual WAN
- Virtual Hub
- sites
- VNet connections
- hub routing
- S2S/P2S integration
- transitive connectivity concepts

### Important audit guardrail

Do not assume the existing workload VNets can simultaneously keep classic `use_remote_gateways` peering behaviour and be attached to Virtual WAN with no design change.

The exact coexistence/migration approach must be decided before implementation and is a primary Gate 2 audit item.

---

## Chapter 07 — Exercise: create a Virtual WAN

Add the approved Virtual WAN proof/evolution to the **same Terraform state**.

Do not destroy the classic VPN edge merely to make the exercise easier.

Before connecting an existing workload VNet to a Virtual Hub, verify the gateway/remote-gateway constraints and deliberately document any Terraform in-place changes required to migrate that VNet's gateway ownership.

The exercise must therefore show architecture evolution, not a disconnected Virtual WAN sandbox.

---

## Chapter 08 — NVA in a virtual hub

BlueHarbor already uses partner SD-WAN/security technology at some locations.

Understand how a supported partner NVA can participate in the Virtual WAN design and how routing/security responsibility changes.

Where licensing/provider dependencies prevent a real deployment, keep the architecture object relationships in the cumulative story and use rigorous route/failure analysis rather than inventing an unrelated lab.

---

## Chapter 09 — Summary

Explain:

```text
Brisbane server
 -> remote VPN device
 -> IPsec/IKE
 -> Azure VPN Gateway
 -> connectivity VNet
 -> gateway-transit relationship
 -> Module 1 workload VNet
```

and:

```text
remote engineer
 -> client authentication
 -> P2S tunnel
 -> P2S client address
 -> Azure route / DNS path
 -> permitted workload
```

and explain what problem Virtual WAN solves as BlueHarbor scales.

## Module 2 end-state question for the next audit

Module 3 introduces ExpressRoute.

Before implementation begins, the Module 2 -> Module 3 audit must decide exactly how these coexist/evolve:

```text
classic connectivity VNet + VPN Gateway
Virtual WAN / Virtual Hub
workload VNet gateway-transit settings
ExpressRoute gateway/circuit design
```

The objective is one coherent Terraform dependency graph, not three independent connectivity demos.
