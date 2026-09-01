# Module 2 — Design and implement hybrid networking

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-hybrid-networking/

**BlueHarbor project:** Connect BlueHarbor's real-world networks to Azure  
**Status:** NOT STARTED

Module 2 continues directly from the Azure network built conceptually in Module 1. BlueHarbor still has on-premises sites, factories and remote engineers that cannot yet reach the Azure private network.

The module is taught as one progressive project:

```text
Azure is isolated from BlueHarbor sites
        -> design Azure VPN Gateway
        -> deploy the Azure gateway
        -> connect Brisbane with Site-to-Site VPN
        -> connect an individual remote engineer with Point-to-Site VPN
        -> grow to many sites/users
        -> introduce Azure Virtual WAN
        -> validate a Virtual WAN hub
        -> understand NVA / SD-WAN integration
        -> architecture review and explain-back
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

## Starting architecture

```text
Azure
  CoreServicesVnet       10.10.0.0/16
  ManufacturingVnet      10.20.0.0/16
  ResearchVnet           10.30.0.0/16

BlueHarbor external networks
  Brisbane HQ            172.16.0.0/16
  Perth Manufacturing    172.17.0.0/16
  Remote engineers       variable client networks
```

Exact deployment details remain subject to cost, subscription capability and the Microsoft exercise when Module 2 is started. Simulated on-premises infrastructure must always be labelled as simulation.
