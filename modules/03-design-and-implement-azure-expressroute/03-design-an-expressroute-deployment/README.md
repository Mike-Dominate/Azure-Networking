# Unit 03 — Design an ExpressRoute deployment

**BlueHarbor chapter:** Decide what the company is actually buying  
**Status:** NOT STARTED

## Business event

Procurement requires an implementable ExpressRoute design for critical BlueHarbor workloads rather than a generic instruction to 'use ExpressRoute'.

## Design decisions

- connectivity model
- provider
- peering location
- bandwidth
- SKU / tier
- ExpressRoute gateway design
- redundancy
- disaster recovery
- ExpressRoute Direct concepts where applicable
- VPN coexistence / backup strategy

## Scenario

Primary private-connectivity requirement:

```text
Brisbane HQ
 -> ERP / engineering / manufacturing
 -> Australia East
```

Future requirement:

```text
Singapore research
 -> Southeast Asia
```

The learner must justify each design choice from workload, geography, availability and growth requirements.
