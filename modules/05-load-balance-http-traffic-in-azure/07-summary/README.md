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

## Canonical Partner Hub end state for Module 5

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

Research uses `bhi-vhub-sea`; Core/Manufacturing/Partner AUE remain on the AUE hub.

The Module 4 telemetry Load Balancer/Traffic Manager architecture remains deployed and separate.

## Forward dependency

This is not the final security/private-access state. Module 6 upgrades/hardens the web edge. Module 7 converts Front Door Premium's origin path to Application Gateway Private Link while retaining the same regional application architecture.

Be able to explain why an architecture can be correct for one business stage and intentionally evolve later without that earlier stage having been a mistake.
