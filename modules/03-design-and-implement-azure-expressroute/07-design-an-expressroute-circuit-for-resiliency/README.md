# Unit 07 — Design an ExpressRoute circuit for resiliency

**BlueHarbor chapter:** Make private connectivity survive failures  
**Status:** NOT STARTED

## Business event

Management asks what happens when a fibre, router, provider path, peering location or circuit fails.

## Resiliency progression

```text
single path
 -> redundant paths / BGP sessions
 -> provider diversity
 -> peering-location diversity
 -> circuit diversity
 -> disaster-recovery design
```

## Concepts to master

- built-in ExpressRoute redundancy concepts
- dual BGP sessions
- multiple circuits
- provider / location failure domains
- BFD concepts
- disaster recovery
- VPN coexistence / alternate-path thinking
- encryption-over-ExpressRoute design considerations

Do not treat two lines on a diagram as resilience until the shared failure domains are understood.
