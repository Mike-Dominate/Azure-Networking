# Unit 07 — Design an ExpressRoute circuit for resiliency

**BlueHarbor chapter:** Make private connectivity survive failures while keeping VPN as an alternate path  
**Status:** NOT STARTED

## Starting state

The existing Virtual WAN architecture can now contain both the established VPN path and the new ExpressRoute path.

## Target intent

```text
approved critical routes:
ExpressRoute = preferred
VPN          = alternate / recovery path
```

Do not rely on an assumed routing default. During implementation, explicitly verify the current Virtual WAN routing preference/propagation behaviour and prove failover with route evidence where practical.

## Concepts to master

- dual ExpressRoute paths/BGP sessions;
- provider and peering-location failure domains;
- circuit diversity;
- BFD concepts;
- VPN coexistence / disaster recovery;
- asymmetric-route risks;
- encryption-over-ExpressRoute design considerations.

Two lines on a diagram are not resilience until shared failure domains and route preference are understood.
