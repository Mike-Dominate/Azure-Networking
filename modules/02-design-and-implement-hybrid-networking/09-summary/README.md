# Unit 09 — Summary

**BlueHarbor chapter:** Hybrid-network architecture review  
**Status:** NOT STARTED

## Explain the progression

```text
Module 1 Azure estate
  -> classic connectivity VNet
  -> classic VPN Gateway
  -> Brisbane S2S
  -> remote-user P2S
  -> branch scale problem
  -> Virtual WAN
  -> Perth joins
  -> workload transit migrates to bhi-vhub-aue
```

## Canonical end state

Active transit:

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
       +-- Brisbane
       +-- Perth
       +-- remote users
       +-- Core / Manufacturing / Research VNet connections
```

Still present in the same Terraform state:

```text
bhi-vnet-connectivity-aue
GatewaySubnet
classic VPN Gateway
classic S2S/P2S Azure objects
```

Hybrid DNS is extended from `bhi-vnet-core-aue`, not tied to the legacy gateway VNet.

## Handoff to Module 3

ExpressRoute must attach to the existing `bhi-vhub-aue`. The production design becomes ExpressRoute-preferred with VPN retained as an alternate path according to the routing design validated at implementation time.
