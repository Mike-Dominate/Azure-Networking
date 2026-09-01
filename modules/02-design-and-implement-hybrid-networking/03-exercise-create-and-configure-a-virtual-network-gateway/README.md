# Unit 03 — Exercise: Create and configure a virtual network gateway

**BlueHarbor chapter:** Build the approved Azure gateway and connect it to the existing estate  
**Status:** NOT STARTED

## Microsoft objective, cumulative implementation

Preserve Microsoft's gateway exercise objective while extending the existing Terraform environment.

Expected Terraform additions:

```text
bhi-vnet-connectivity-aue
GatewaySubnet 10.100.255.0/26
VPN Gateway public IP
Azure VPN Gateway
connectivity <-> workload VNet peerings
```

## Gateway-transit requirement

Do not assume peering is transitive.

When the classic VPN gateway is intended to provide hybrid reachability for a workload VNet, explicitly configure and understand directional gateway-transit settings such as `allow_gateway_transit`, `use_remote_gateways` and forwarded-traffic behaviour.

## Validation

Inspect:

- special-purpose subnet placement;
- gateway type/SKU/public IP;
- peering direction/settings;
- effective routes after a connection exists;
- Terraform plan for unexpected Module 1 replacement/destruction.

A successful deployment alone is not sufficient evidence.
