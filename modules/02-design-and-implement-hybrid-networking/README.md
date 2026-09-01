# Module 2 — Design and implement hybrid networking

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-hybrid-networking/

**BlueHarbor project:** Connect BlueHarbor's real-world networks to the existing Azure estate  
**Status:** NOT STARTED

Module 2 starts from the **deployed Terraform-managed Module 1 environment**, not a conceptual copy.

## Starting architecture inherited unchanged

```text
Australia East
bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16

Southeast Asia
bhi-vnet-research-sea   10.30.0.0/16

+ canonical subnets
+ private DNS architecture
+ Core <-> Manufacturing peering
+ Core <-> Research global peering
+ routing configuration
+ selected NAT Gateway association(s)
+ same Terraform state lineage
```

BlueHarbor external networks:

```text
Brisbane HQ             172.16.0.0/16
Perth Manufacturing     172.17.0.0/16
P2S client pool          172.31.240.0/24
Remote engineers         variable physical networks
```

## Module 2 connectivity addition

The classic Azure VPN Gateway is placed in a dedicated connectivity VNet rather than inside a workload VNet:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  snet-dns-inbound          10.100.10.0/28
  snet-dns-outbound         10.100.10.16/28
  GatewaySubnet             10.100.255.0/26
```

The DNS endpoint subnets are reserved until the hybrid DNS requirement is implemented. Do not attach generic workload NAT/NSG/UDR configuration to these special-purpose subnets.

## Progressive story

```text
existing Azure estate cannot reach physical sites
        -> design dedicated Azure VPN edge
        -> deploy connectivity VNet / GatewaySubnet / VPN Gateway
        -> peer workload VNets to connectivity VNet
        -> configure gateway transit deliberately
        -> connect Brisbane with Site-to-Site VPN
        -> prove IP reachability and hybrid DNS separately
        -> connect an individual remote engineer with Point-to-Site VPN
        -> grow to many sites/users
        -> introduce Azure Virtual WAN
        -> understand NVA / SD-WAN integration
        -> architecture review
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Design and implement Azure VPN Gateway
3. Exercise: Create and configure a virtual network gateway
4. Connect networks with Site-to-site VPN connections
5. Connect devices to networks with Point-to-site VPN connections
6. Connect remote resources by using Azure Virtual WANs
7. Exercise: Create a Virtual WAN by using the Azure portal
8. Create a network virtual appliance (NVA) in a virtual hub
9. Summary

## Cumulative Terraform rule

All Module 2 resources are added to:

```text
blueharbor/terraform/
```

No Module 1 VNet is renamed/recreated. No fresh state is started.

The exact Virtual WAN coexistence/migration relationship with the classic remote-gateway design is an explicit dependency to resolve in the Module 2 -> Module 3 architecture audit before implementation begins.
