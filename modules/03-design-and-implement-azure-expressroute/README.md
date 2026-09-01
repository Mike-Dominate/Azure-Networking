# Module 3 — Design and implement Azure ExpressRoute

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-azure-expressroute/

**BlueHarbor project:** Upgrade BlueHarbor to enterprise private connectivity  
**Status:** NOT STARTED

Module 3 continues from Module 2. BlueHarbor already has VPN-based hybrid connectivity; the new requirement is to decide which mission-critical workloads need private enterprise connectivity with higher-bandwidth and resilience options.

The module is taught as one progressive project:

```text
VPN connectivity already works
        -> review enterprise requirements
        -> understand ExpressRoute
        -> design circuit/connectivity model
        -> configure Azure ExpressRoute gateway
        -> provision the logical circuit
        -> establish BGP peering / route exchange
        -> design resiliency and disaster recovery
        -> connect sites with Global Reach
        -> optimise selected paths with FastPath
        -> break the path and troubleshoot systematically
        -> architecture-board explain-back
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Explore Azure ExpressRoute
3. Design an ExpressRoute deployment
4. Exercise: Configure an ExpressRoute gateway
5. Exercise: Provision an ExpressRoute circuit
6. Configure peering for an ExpressRoute deployment
7. Design an ExpressRoute circuit for resiliency
8. Connect geographically dispersed networks with ExpressRoute global reach
9. Improve data path performance between networks with ExpressRoute FastPath
10. Troubleshoot ExpressRoute connection issues
11. Summary and resources

## Starting architecture

```text
BlueHarbor hybrid connectivity from Module 2

Brisbane HQ / Data Centre    172.16.0.0/16
Perth Manufacturing         172.17.0.0/16
Remote engineers            P2S VPN where needed

Azure
CoreServicesVnet            10.10.0.0/16
ManufacturingVnet           10.20.0.0/16
ResearchVnet                10.30.0.0/16
```

## Practicality rule

A personal Azure subscription cannot realistically reproduce every carrier/provider component of a production ExpressRoute deployment. Use real Azure-side configuration where safe, then use serious architecture, BGP, provider-handoff, routing and failure simulation for components that would otherwise require commercial connectivity or excessive cost.
