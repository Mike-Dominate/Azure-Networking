# BlueHarbor Industries — Module 2 Project Story

## Project — Connect BlueHarbor's real-world networks to Azure

**Microsoft Learn module:** Design and implement hybrid networking  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point

Module 1 remains deployed: Core, Manufacturing and Research VNets, `blueharbor.internal`, direct peerings, routing and `nat-mfg-aue`.

External address contract:

```text
Brisbane HQ / Data Centre         172.16.0.0/16
Perth Manufacturing Site          172.17.0.0/16
Classic VPN P2S pool              172.31.240.0/24
Reserved Virtual WAN User VPN     172.31.241.0/24
```

The two client pools are deliberately separate and non-overlapping.

## Chapter 01 — Azure is an island

Establish requirements for network-to-network, individual-device and branch-scale connectivity.

## Chapter 02 — Build the first hybrid edge

Add:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26
```

The classic VPN Gateway belongs here rather than in workload VNets.

## Chapter 03 — Create the classic gateway

Add the classic VPN Gateway public IP/gateway and peering relationships. Understand gateway transit explicitly and stop on unexpected Terraform replacement.

## Chapter 04 — Brisbane joins Azure by Site-to-Site VPN

```text
Brisbane 172.16.0.0/16
 -> IPsec/IKE
 -> classic VPN Gateway
 -> workload estate
```

Hybrid DNS is added to Core only when Brisbane needs private name resolution:

```text
bhi-vnet-core-aue
  snet-dns-inbound    10.10.10.0/28
  snet-dns-outbound   10.10.10.16/28
```

Add DNS Private Resolver/forwarding as an extension of `blueharbor.internal`, not a replacement DNS design.

## Chapter 05 — Remote engineer Point-to-Site access

Classic P2S uses:

```text
172.31.240.0/24
```

Teach protocol/authentication, route presentation and DNS behaviour.

## Chapter 06 — Virtual WAN scales the design

Introduce:

```text
bhi-vwan
bhi-vhub-aue   10.200.0.0/22
```

Reserve:

```text
bhi-vhub-sea   10.200.4.0/22
```

Perth (`172.17.0.0/16`) becomes real here.

Virtual WAN User VPN uses its own reserved pool:

```text
172.31.241.0/24
```

Do not reuse the classic P2S pool while the classic gateway/client configuration remains deployed.

## Chapter 07 — Make Virtual WAN the active production transit

Migrate workload production transit to the Virtual WAN hub.

Intentional deltas include changing classic workload `use_remote_gateways` relationships and adding Virtual Hub VNet connections.

Direct Module 1 peerings remain until Module 6 security requires centrally inspected transit.

### Classic edge lifecycle

Keep the classic connectivity VNet, VPN Gateway and earlier S2S/P2S objects in Terraform for architecture continuity and learning history.

After the Virtual WAN cutover, however:

```text
Virtual WAN branch path = active production transit
classic branch path      = non-production / inactive
```

Do not imply unsupported/undocumented dual-active routing. A later explicit failback test may reactivate the classic path only when its route preference/behaviour is deliberately designed.

## Chapter 08 — NVA in a virtual hub

Integrate or model an approved NVA/SD-WAN capability against the existing AUE hub. Do not create another hub architecture merely for the concept.

## Module 2 end state

```text
bhi-vwan
  +-- bhi-vhub-aue 10.200.0.0/22
       +-- Brisbane production branch path
       +-- Perth production branch path
       +-- approved User VPN path 172.31.241.0/24
       +-- Core / Manufacturing / Research VNet connections
```

Hybrid DNS is anchored in Core. Classic edge resources remain deployed but are not the normal production branch path after cutover.

## Carry-forward into Module 3

Module 3 adds ExpressRoute to the existing Virtual WAN hub; it does not create a second enterprise hub.
