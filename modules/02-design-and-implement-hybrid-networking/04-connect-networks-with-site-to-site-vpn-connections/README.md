# Unit 04 — Connect networks with Site-to-site VPN connections

**BlueHarbor chapter:** Brisbane HQ joins the existing Azure estate  
**Status:** NOT STARTED

## Business event

Brisbane HQ (`172.16.0.0/16`) must continuously reach permitted private resources in the existing Core, Manufacturing and Research VNets.

## Architecture

```text
Brisbane HQ
172.16.0.0/16
    |
on-prem VPN device/simulation
    |
IPsec/IKE
    |
Azure VPN Gateway
bhi-vnet-connectivity-aue
    |
explicit gateway transit / routes
    |
existing BlueHarbor workload VNets
```

## Concepts to master

- Site-to-Site VPN
- IPsec / IKE
- Local Network Gateway
- Connection resource
- remote prefixes
- tunnel state
- route reachability
- gateway transit through VNet peering

## Hybrid DNS requirement

Prove IP connectivity and DNS separately.

When Brisbane needs Azure-private name resolution, extend the DNS architecture from Module 1 using the reserved resolver subnets in the connectivity VNet where appropriate.

```text
Can Brisbane reach the private IP?
Can Brisbane resolve the intended private name?
```

Do not treat successful tunnel status as proof that hybrid DNS works.
