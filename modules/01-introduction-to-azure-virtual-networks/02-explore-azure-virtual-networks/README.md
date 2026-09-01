# Unit 02 — Explore Azure Virtual Networks

**BlueHarbor chapter:** Freeze the network contract before building  
**Status:** NOT STARTED

Design and approve the canonical non-overlapping VNet/subnet plan that later modules must inherit:

```text
Australia East
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24

Southeast Asia
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

Understand CIDR, non-overlap, subnet purpose and future growth before creating resources.

Later modules may add networks, but they must not rename/recreate these objects simply because the curriculum moves to a new module.
