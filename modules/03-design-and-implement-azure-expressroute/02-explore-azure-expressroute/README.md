# Unit 02 — Explore Azure ExpressRoute

**BlueHarbor chapter:** Understand the private path  
**Status:** NOT STARTED

## Business event

Architecture wants to know what BlueHarbor would actually be connecting to before approving ExpressRoute.

## End-to-end path

```text
BlueHarbor network
 -> customer edge
 -> connectivity provider
 -> ExpressRoute peering location
 -> Microsoft network
 -> Azure
```

## Concepts to master

- ExpressRoute circuit
- connectivity provider
- peering location
- Microsoft network edge concepts
- private enterprise connectivity
- circuit versus physical connection
- customer/provider/Microsoft responsibilities

## Engineering check

For every component, explain who owns it, what it does and what failure of that component means to BlueHarbor connectivity.
