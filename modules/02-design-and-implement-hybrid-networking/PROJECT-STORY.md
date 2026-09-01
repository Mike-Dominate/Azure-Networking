# BlueHarbor Industries — Module 2 Project Story

## Project — Connect BlueHarbor's real-world networks to Azure

**Microsoft Learn module:** Design and implement hybrid networking  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 1

Module 1 is deployed and remains present:

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

BlueHarbor also has:

```text
Brisbane HQ / Data Centre        172.16.0.0/16
Perth Manufacturing Site         172.17.0.0/16
Remote engineers                 variable networks
Reserved P2S client pool         172.31.240.0/24
```

The business problem is:

> The Azure estate works internally. Connect BlueHarbor's sites and remote users into that same network, then evolve the design when individually managed connectivity stops scaling.

---

## Chapter 01 — Introduction: Azure is an island

Brisbane and Perth have no hybrid route into Azure. Establish requirements for network-to-network, individual-device and branch-scale connectivity.

---

## Chapter 02 — Design Azure VPN Gateway: build the first hybrid edge

Add a dedicated connectivity VNet:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26
```

The classic VPN Gateway belongs here rather than inside Core/Manufacturing/Research.

Teach gateway SKU/availability, public IP, route-based concepts, throughput, resiliency and non-overlap.

---

## Chapter 03 — Exercise: create the classic virtual network gateway

Extend the same Terraform stack with:

```text
bhi-vnet-connectivity-aue
GatewaySubnet
VPN Gateway public IP
Azure VPN Gateway
connectivity-VNet peerings
```

During this stage, explicitly configure and understand classic gateway transit:

```text
connectivity side:
  allow_gateway_transit
  allow_forwarded_traffic where required

workload side:
  use_remote_gateways
  allow_forwarded_traffic where required
```

Do not assume peering is transitive. Stop if Terraform proposes unexpected replacement of Module 1 resources.

---

## Chapter 04 — Site-to-Site VPN: Brisbane joins Azure

Add:

```text
Brisbane 172.16.0.0/16
 -> remote VPN device/simulation
 -> IPsec/IKE
 -> classic Azure VPN Gateway
 -> gateway transit
 -> existing BlueHarbor workload VNets
```

Persistent additions include the Local Network Gateway and VPN Connection.

### Hybrid DNS extension

IP reachability and DNS are tested separately.

When Brisbane must resolve private BlueHarbor names, add resolver endpoint subnets to the **existing Core/Shared Services VNet**:

```text
bhi-vnet-core-aue
  snet-dns-inbound    10.10.10.0/28
  snet-dns-outbound   10.10.10.16/28
```

Then add Azure DNS Private Resolver/forwarding components only when the requirement is reached.

Validation:

```text
Can Brisbane reach the Azure private IP?
Can Brisbane resolve the private Azure name?
Can Azure resolve required on-premises names when that requirement is enabled?
```

---

## Chapter 05 — Point-to-Site VPN: a remote engineer needs access

Use the reserved client pool:

```text
172.31.240.0/24
```

Teach client protocol/authentication, route presentation and DNS behaviour. Prove failure before the tunnel and successful access after it.

---

## Chapter 06 — Virtual WAN: scale forces an architecture evolution

BlueHarbor now has Brisbane, more remote users and a Perth manufacturing site that must come online. The number of relationships is becoming an operational problem.

Introduce:

```text
bhi-vwan
bhi-vhub-aue   10.200.0.0/22
```

Reserve for future regional expansion:

```text
bhi-vhub-sea   10.200.4.0/22
```

The Southeast Asia hub is only a reserved address contract at this point; it is not deployed without a later business requirement.

### Why `/22`

The Australia East hub is deliberately sized now for later secured-hub/Azure Firewall requirements so Module 6 does not force an avoidable redesign.

### Perth becomes real here

Perth (`172.17.0.0/16`) is the first new branch proving why Virtual WAN exists. It must not magically appear at the start of Module 3.

---

## Chapter 07 — Exercise: create Virtual WAN and migrate production transit

Preserve Microsoft's Virtual WAN exercise objective, but implement the persistent BlueHarbor architecture through the same Terraform root.

The target end state is:

```text
Brisbane ----\
              \
Perth --------> bhi-vhub-aue ---- Core
               |                 Manufacturing
Remote users ->|                 Research
```

### Intentional Terraform migration

The workload VNets must not simultaneously rely on the classic peered remote gateway and the Virtual WAN hub as if there were no ownership conflict.

When their Virtual Hub VNet connections become active:

```text
classic workload-side use_remote_gateways
  -> intentionally disabled/changed

Virtual Hub VNet connections
  -> added
```

Any associated peering changes are reviewed as intentional plan deltas.

The existing direct Module 1 peerings remain unless another requirement explicitly removes them.

### Classic edge remains

Do **not** delete:

```text
bhi-vnet-connectivity-aue
GatewaySubnet
classic VPN Gateway
classic S2S/P2S Azure objects
```

They remain in Terraform as the architecture BlueHarbor built first. After migration, however, Virtual WAN is the active production transit for the workload estate.

Where practical, migrate approved remote-user connectivity into the Virtual WAN user-VPN model while preserving the earlier classic P2S objects as the learned first stage.

---

## Chapter 08 — NVA in a virtual hub

BlueHarbor may integrate approved partner SD-WAN/security technology with the existing `bhi-vhub-aue`. Do not create a separate hub just to demonstrate NVA concepts.

If licensing/provider dependencies prevent real deployment, retain rigorous route/control-plane/failure analysis in this same architecture.

---

## Chapter 09 — Summary: Module 2 end state

Active production transit at the end of Module 2:

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       |
       +-- Brisbane S2S / branch path
       +-- Perth S2S / branch path
       +-- approved remote-user VPN path
       +-- VNet connections
            +-- bhi-vnet-core-aue
            +-- bhi-vnet-mfg-aue
            +-- bhi-vnet-research-sea
```

Hybrid DNS is anchored in Core/Shared Services. The classic connectivity VNet and gateway remain deployed in the same Terraform state as the earlier hybrid stage.

## Carry-forward into Module 3

The business question becomes:

> VPN and Virtual WAN now connect the company. Which mission-critical paths should use ExpressRoute as the preferred enterprise transport while VPN remains available as an alternate path?

Module 3 must add ExpressRoute to the **existing Virtual WAN hub**, not create a second hub architecture.
