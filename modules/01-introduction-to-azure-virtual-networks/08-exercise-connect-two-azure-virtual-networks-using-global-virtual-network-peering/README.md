# Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering

**BlueHarbor chapter:** Research must reach Core across regions  
**Status:** NOT STARTED

Preserve Microsoft's global-peering objective with the canonical BlueHarbor VNets:

```text
bhi-vnet-core-aue <-> bhi-vnet-research-sea
```

First prove the relevant workloads are isolated, then add the global VNet peering through the same Terraform root and prove the changed connectivity.

```text
before peering -> expected failure
after peering  -> expected success
```

This peering remains part of the environment carried into Module 2. Do not create a second Research VNet later to satisfy hybrid examples.
