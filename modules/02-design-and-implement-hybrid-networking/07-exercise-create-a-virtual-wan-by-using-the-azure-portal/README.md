# Unit 07 — Exercise: Create a Virtual WAN by using the Azure portal

**BlueHarbor chapter:** Make Virtual WAN the active production transit  
**Status:** NOT STARTED

Preserve Microsoft's exercise objective but implement the persistent BlueHarbor architecture through the cumulative Terraform stack.

Add/configure:

```text
bhi-vwan
bhi-vhub-aue   10.200.0.0/22
Brisbane branch connectivity
Perth branch connectivity
Virtual WAN User VPN pool 172.31.241.0/24
VNet connections for Core / Manufacturing / Research
```

## Intentional migration

Before a workload VNet is attached to `bhi-vhub-aue`, remove/change any classic workload-side `use_remote_gateways` dependency that conflicts with Virtual WAN ownership.

The direct Module 1 peerings remain for now; Virtual WAN becomes the active enterprise/hybrid transit layer.

## Classic edge after cutover

Do not destroy the classic connectivity VNet, VPN Gateway or earlier S2S/P2S objects.

But after the validated cutover:

```text
Virtual WAN branch path = active production
classic branch path      = non-production / inactive
```

Do not accidentally create an unexplained dual-active production topology. If a later exercise needs failback, design the route preference and activation explicitly.

The state lineage remains continuous.
