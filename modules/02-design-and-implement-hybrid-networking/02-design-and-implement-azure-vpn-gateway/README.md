# Unit 02 — Design and implement Azure VPN Gateway

**BlueHarbor chapter:** Build the Azure hybrid-network edge  
**Status:** NOT STARTED

## Business event

Management approves encrypted Internet-based connectivity between BlueHarbor sites and Azure.

## Problem to solve

Azure needs a managed termination point for hybrid VPN traffic before a Site-to-Site connection can exist.

## Architecture introduced

```text
Remote BlueHarbor network
        |
    IPsec/IKE
        |
Azure VPN Gateway
        |
BlueHarbor Azure VNets
```

## Concepts to master

- `GatewaySubnet`
- Azure VPN Gateway
- gateway SKU selection
- gateway public IP
- route-based versus policy-based concepts
- availability / active-active considerations
- throughput and resiliency
- non-overlapping address spaces

## Engineering check

Before deployment, be able to explain the networks, prefixes, availability, throughput, remote VPN capability and route requirements driving the design.
