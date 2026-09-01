# Unit 07 — Summary

**BlueHarbor chapter:** HTTP(S) application-delivery architecture review  
**Status:** NOT STARTED

## Four distinct services

```text
Azure Load Balancer
-> regional Layer 4 TCP/UDP

Traffic Manager
-> global DNS-based endpoint selection

Application Gateway
-> regional Layer 7 HTTP(S)

Azure Front Door
-> global Layer 7 HTTP(S) edge/proxy
```

## Canonical Partner Hub end state

```text
                    Global users
                         |
                         v
                Azure Front Door Standard
                         |
              +----------+----------+
              |                     |
              v                     v
        Australia East         Southeast Asia
              |                     |
 appgw-partner-aue        appgw-partner-sea
 Standard_v2              Standard_v2
              |                     |
              v                     v
bhi-vnet-partner-aue     bhi-vnet-partner-sea
10.40.0.0/16             10.50.0.0/16
              |                     |
              v                     v
        bhi-vhub-aue          bhi-vhub-sea
```

Research now uses `bhi-vhub-sea`; Core/Manufacturing/Partner AUE remain on the AUE hub. The existing Core <-> Research global peering remains unless changed by a later approved routing/security requirement.

The Module 4 telemetry Load Balancer/Traffic Manager architecture remains deployed and separate.

## Explain-back

Be able to explain:

- why Partner Hub received dedicated application VNets;
- why Application Gateway needs a dedicated subnet;
- Layer 4 versus Layer 7 routing;
- path/host routing and health probes;
- Application Gateway versus Front Door;
- Traffic Manager versus Front Door;
- why the SEA Virtual Hub is activated here;
- why moving the Research Virtual WAN connection does not mean rebuilding the Research VNet;
- why `.example` is narrative rather than a fake live DNS domain;
- why Module 6 still has real security work to do.
