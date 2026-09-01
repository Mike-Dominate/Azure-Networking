# Unit 05 — Design and configure Azure Front Door

**BlueHarbor chapter:** Activate Southeast Asia and make Partner Hub multi-region  
**Status:** NOT STARTED

## New requirement

Partner Hub needs multiple real HTTP(S) origins and global web delivery.

## Activate the reserved regional hub

Deploy the address contract reserved in Gate 2:

```text
bhi-vhub-sea   10.200.4.0/22
```

The Standard Virtual WAN now contains AUE and SEA hubs.

## Intentional Research VNet migration

`bhi-vnet-research-sea` currently has a Virtual WAN connection to `bhi-vhub-aue` because AUE was the only deployed hub when Module 2 was built.

Change that connection deliberately:

```text
old: research-sea -> vhub-aue
new: research-sea -> vhub-sea
```

Do not replace the Research VNet or its Module 4 telemetry DR resources. The original Core <-> Research global VNet peering remains until a later routing/security requirement deliberately changes it.

## Add the SEA Partner landing zone

```text
bhi-vnet-partner-sea   10.50.0.0/16
  snet-appgw           10.50.1.0/24
  snet-partner-app     10.50.2.0/24
```

Connect it to `bhi-vhub-sea` and add explicit app-subnet outbound connectivity through `nat-partner-sea`.

Add:

```text
appgw-partner-sea   Standard_v2
Partner Hub SEA backends
```

No Europe origin is introduced.

## Front Door model

```text
Global users
   |
Azure Front Door
   |
+-- appgw-partner-aue
+-- appgw-partner-sea
```

Critical distinction:

```text
Traffic Manager = DNS-based selection; not in application data path
Front Door      = global HTTP(S) service; remains in application data path
```

Module 5 uses delivery tiers first; Module 6 decides WAF/origin-hardening changes.
