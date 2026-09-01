# Unit 04 — Exercise: Configure an ExpressRoute gateway

**BlueHarbor chapter:** Prepare Azure VNets for ExpressRoute  
**Status:** NOT STARTED

## Business event

The ExpressRoute design is approved. BlueHarbor now prepares the Azure VNet side of the architecture.

## Architecture

```text
ExpressRoute circuit
        |
ExpressRoute Gateway
        |
BlueHarbor VNet(s)
```

## Critical distinction

```text
Circuit != Gateway
```

The circuit represents the private connectivity service. The ExpressRoute gateway connects Azure VNets into that connectivity architecture.

## BlueHarbor engineering extension

After completing the Microsoft exercise, inspect and explain the `GatewaySubnet`, gateway SKU/type, VNet relationship and how this differs from the VPN gateway learned in Module 2.
