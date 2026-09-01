# Unit 05 — Exercise: Provision an ExpressRoute circuit

**BlueHarbor chapter:** Order the logical circuit  
**Status:** NOT STARTED

## Business event

BlueHarbor now provisions the logical Azure ExpressRoute circuit that the selected connectivity provider will work against.

## Provisioning flow

```text
create circuit
 -> receive service key
 -> provider uses service key
 -> provider provisions connectivity
 -> circuit provisioning progresses
```

## Concepts to master

- provider
- peering location
- bandwidth
- SKU / tier
- billing model
- service key
- provisioning state

## Practicality rule

Do not incur carrier-level costs merely to complete the lab. Use safe Azure-side objects and serious provider/BGP simulation where a commercial handoff is impractical.
