# Module 3 — Design and implement Azure ExpressRoute

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-azure-expressroute/

**BlueHarbor project:** Add enterprise private connectivity to the existing Virtual WAN transit  
**Status:** NOT STARTED

Module 3 does not build a new hub. It starts from the Module 2 production transit:

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       +-- Brisbane / Perth branch connectivity
       +-- approved remote-user connectivity
       +-- Core / Manufacturing / Research VNet connections
```

The classic VPN edge from early Module 2 is also still present in Terraform, but Virtual WAN owns the workload estate's active hybrid transit.

The Module 3 business problem is:

> Which mission-critical paths should use ExpressRoute as the preferred enterprise transport while VPN remains available as an alternate path?

## Progressive Module 3 architecture

```text
existing Virtual WAN / VPN connectivity
        -> understand ExpressRoute ownership and transport
        -> design circuit/provider/BGP/resiliency
        -> learn the classic ExpressRoute VNet-gateway model
        -> implement BlueHarbor's ExpressRoute Gateway in bhi-vhub-aue
        -> provision/connect the Brisbane circuit/path where practical
        -> configure private peering/BGP
        -> make route preference/failover behaviour explicit
        -> add a distinct Perth circuit/provider path for Global Reach learning
        -> evaluate FastPath against the exact Virtual WAN support rules
        -> troubleshoot the complete path
```

## ExpressRoute circuit contract

Global Reach requires two ExpressRoute circuits/provider paths. BlueHarbor therefore treats them explicitly:

```text
Brisbane
 -> ExpressRoute circuit/provider path A

Perth
 -> ExpressRoute circuit/provider path B
```

The exact external carrier provisioning may be simulated where commercial dependencies are unavailable, but the logical two-circuit requirement is not hand-waved.

## Global Reach lifecycle

Module 3 uses Global Reach as a real learning stage:

```text
Brisbane ER circuit A
        |
Global Reach
        |
Perth ER circuit B
```

This is **not** the final Module 6 security path. When Module 6 later requires centrally inspected private transit through secured Virtual WAN hubs, Global Reach is intentionally disabled because its circuit-to-circuit traffic bypasses the secured hub/firewall path.

That retirement is an approved architecture evolution, not cleanup.

## Virtual WAN FastPath rule

For BlueHarbor's persistent Virtual WAN architecture, FastPath is considered active only when the current support conditions are met:

```text
ExpressRoute Direct
+
Virtual WAN ExpressRoute Gateway >= 5 scale units
```

Under the current service model, this is automatically enabled for supported traffic. A normal provider ExpressRoute circuit is not treated as FastPath-enabled in Virtual WAN.

If the lab uses a provider circuit, Unit 09 teaches the exact eligibility gap instead of creating a disconnected second architecture.

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

## Important implementation rule

Microsoft's Unit 04 teaches the classic VNet ExpressRoute gateway model. BlueHarbor must understand that model, but its persistent Terraform implementation uses the **existing Virtual WAN hub ExpressRoute gateway** so the cumulative architecture does not fork into a second transit design.

## Practicality rule

Provider/carrier dependencies may prevent a complete live ExpressRoute transport. Build all useful Azure-side objects through the cumulative Terraform stack and use rigorous provider/BGP/route/failure analysis where an external service-provider handoff is genuinely required.
