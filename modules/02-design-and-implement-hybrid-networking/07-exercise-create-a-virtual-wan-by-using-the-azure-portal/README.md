# Unit 07 — Exercise: Create a Virtual WAN by using the Azure portal

**BlueHarbor chapter:** Make Virtual WAN the active production transit  
**Status:** NOT STARTED

Preserve Microsoft's Virtual WAN exercise objective, but implement BlueHarbor's persistent architecture through the cumulative Terraform stack.

## Build on what already exists

Do not destroy the Module 1 VNets or the classic Module 2 VPN edge.

Add/configure:

```text
bhi-vwan
bhi-vhub-aue   10.200.0.0/22
Brisbane branch/site connectivity
Perth branch/site connectivity
approved remote-user connectivity where practical
VNet connections for Core / Manufacturing / Research
```

## Intentional migration

Before a workload VNet is attached to `bhi-vhub-aue`, change any classic `use_remote_gateways` dependency that conflicts with Virtual WAN gateway ownership.

Terraform must show this as an understood architecture delta, not accidental drift.

The direct Module 1 peerings can remain; Virtual WAN becomes the active hybrid transit layer.

## End-state rule

At the end of this unit:

```text
Virtual WAN = active production transit
classic VPN edge = still deployed / historical first-stage architecture
```

The state lineage remains continuous.
