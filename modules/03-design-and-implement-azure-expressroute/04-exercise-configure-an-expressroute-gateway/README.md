# Unit 04 — Exercise: Configure an ExpressRoute gateway

**BlueHarbor chapter:** Add ExpressRoute capability to the existing Virtual WAN hub  
**Status:** NOT STARTED

## Microsoft exercise baseline

Understand the classic Microsoft model:

```text
ExpressRoute circuit
 -> ExpressRoute virtual network gateway
 -> GatewaySubnet
 -> VNet
```

That model remains important AZ-700 knowledge.

## BlueHarbor persistent implementation

Do not create a second transit VNet or a new `CoreServicesVnet` just to reproduce the exercise topology.

Extend the cumulative architecture:

```text
ExpressRoute circuit
        |
Virtual WAN ExpressRoute Gateway
        |
bhi-vhub-aue
        |
existing Core / Manufacturing / Research VNet connections
```

Terraform must add the hub ExpressRoute-gateway capability without rebuilding Module 1/2 resources.

## Explain-back

Be able to compare:

- classic VNet ExpressRoute Gateway;
- Virtual WAN ExpressRoute Gateway;
- ExpressRoute circuit;
- the role of `GatewaySubnet` in the classic model versus the managed Virtual Hub gateway model used by BlueHarbor.
