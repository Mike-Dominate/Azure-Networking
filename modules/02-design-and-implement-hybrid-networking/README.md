# Module 2 — Design and implement hybrid networking

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-hybrid-networking/

**BlueHarbor project:** Connect BlueHarbor's real-world networks to the Module 1 Azure estate  
**Status:** NOT STARTED

Module 2 starts from the exact Terraform code, state and deployed Azure resources produced by Module 1.

## Canonical starting estate

```text
Australia East
bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16

Southeast Asia
bhi-vnet-research-sea   10.30.0.0/16

+ Module 1 DNS
+ peerings
+ routing
+ selected NAT
```

Nothing above is renamed or recreated.

## Progressive hybrid story

```text
Azure is isolated from physical sites
        -> build a classic VPN edge in a dedicated connectivity VNet
        -> connect Brisbane with S2S VPN
        -> connect a remote engineer with P2S VPN
        -> branch/user scale becomes an operational problem
        -> introduce Virtual WAN
        -> bring Perth online as the first scale-out branch
        -> migrate workload transit to the Virtual WAN hub
        -> keep the classic VPN edge in Terraform as the earlier stage
        -> finish with Virtual WAN as the active production transit
```

## Canonical classic-connectivity resources

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  GatewaySubnet             10.100.255.0/26
```

The classic VPN Gateway is deployed here, not in a workload VNet.

## Hybrid DNS extension

When hybrid name resolution becomes required, extend the existing Core/Shared Services VNet:

```text
bhi-vnet-core-aue
  snet-dns-inbound    10.10.10.0/28
  snet-dns-outbound   10.10.10.16/28
```

These subnets are reserved for Azure DNS Private Resolver endpoints/forwarding when introduced. DNS is not coupled to the legacy VPN-gateway VNet.

## Canonical Virtual WAN end state

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       |
       +-- S2S / branch connectivity
       |    +-- Brisbane 172.16.0.0/16
       |    +-- Perth    172.17.0.0/16
       |
       +-- P2S / User VPN for approved remote users
       |
       +-- VNet connections
            +-- bhi-vnet-core-aue
            +-- bhi-vnet-mfg-aue
            +-- bhi-vnet-research-sea
```

Reserve but do not deploy until a later requirement needs it:

```text
bhi-vhub-sea   10.200.4.0/22
```

The `/22` reservation avoids a later redesign when the security module secures the hub with Azure Firewall.

## Migration rule

The workload VNets may use classic gateway-transit settings during the early VPN chapters. When Virtual WAN becomes the active transit, those remote-gateway settings are intentionally changed and the workload VNets are connected to the Virtual Hub.

The existing direct Module 1 VNet peerings remain unless a later architecture requirement explicitly changes them.

The classic connectivity VNet, VPN Gateway and earlier VPN objects stay in the Terraform state as the earlier architecture stage, but they no longer own the workload VNets' production gateway path after the Virtual WAN migration.

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

Persistent BlueHarbor changes are implemented through `blueharbor/terraform/`; Azure CLI/Portal are used for inspection, validation and troubleshooting.
