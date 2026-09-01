# Unit 05 — Connect devices to networks with Point-to-site VPN connections

**BlueHarbor chapter:** Give an individual remote engineer private access  
**Status:** NOT STARTED

## Business event

A BlueHarbor engineer working from a hotel/customer site needs private access without creating a network-to-network relationship for the location.

## Reserved client pool

```text
172.31.240.0/24
```

This pool is deliberately non-overlapping with Brisbane (`172.16.0.0/16`), Perth (`172.17.0.0/16`) and the BlueHarbor Azure `10.x` allocations.

## Mental model

```text
Site-to-Site
network <-> network

Point-to-Site
individual device <-> Azure network
```

Cover client VPN protocols/authentication, client routes and DNS behaviour.

Validate that the chosen private destination is unavailable before the tunnel and reachable through the intended path afterward.

Persistent gateway/client configuration changes belong in the same cumulative Terraform stack where supported; client-side operational steps are documented separately.
