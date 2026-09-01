# Unit 03 — Design an ExpressRoute deployment

**BlueHarbor chapter:** Decide what the company is actually buying and how it attaches to the existing hub  
**Status:** NOT STARTED

## Existing dependency

`bhi-vhub-aue` already provides production transit for Brisbane, Perth, remote users and the BlueHarbor workload VNets.

## Design decisions

- connectivity provider/model;
- peering location;
- bandwidth;
- SKU/tier;
- Virtual WAN ExpressRoute gateway design;
- private peering/BGP;
- resiliency and disaster recovery;
- VPN coexistence/alternate path;
- provider versus ExpressRoute Direct where appropriate;
- FastPath eligibility for the chosen model.

## Scenario

```text
Brisbane / Perth critical traffic
  -> ExpressRoute
  -> bhi-vhub-aue
  -> existing Azure workload VNets
```

Do not invent a Singapore office. Southeast Asia is currently an Azure-region requirement, not a physical-site requirement.

The design decision made here must be carried into Unit 09; FastPath may only be claimed if the chosen circuit/gateway model actually supports it.
