# Unit 04 — Connect networks with Site-to-site VPN connections

**BlueHarbor chapter:** Brisbane HQ joins Azure  
**Status:** NOT STARTED

## Business event

Brisbane HQ (`172.16.0.0/16`) must communicate with permitted BlueHarbor Azure private networks continuously without individual users starting VPN sessions.

## Architecture

```text
Brisbane HQ network
        |
on-prem VPN device
        |
   IPsec/IKE
        |
Azure VPN Gateway
        |
Azure private networks
```

## Concepts to master

- Site-to-Site VPN
- IPsec / IKE tunnel
- Local Network Gateway
- Connection resource
- remote prefixes
- tunnel state
- route reachability

## Critical mental model

The Local Network Gateway is Azure's representation of the remote VPN endpoint and remote address spaces. It is not the physical router itself.

## Practical rule

If a physical data centre is unavailable, use a clearly labelled on-premises simulation. Validate real routing/tunnel behaviour without misrepresenting the simulation as a physical site.
