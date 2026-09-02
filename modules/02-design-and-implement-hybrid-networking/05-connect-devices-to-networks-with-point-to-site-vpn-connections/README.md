# Unit 05 — Connect devices to networks with Point-to-site VPN connections

**BlueHarbor chapter:** Give an individual remote engineer private access  
**Status:** NOT STARTED

## Classic P2S client pool

```text
172.31.240.0/24
```

This pool is non-overlapping with Brisbane (`172.16.0.0/16`), Perth (`172.17.0.0/16`) and all BlueHarbor Azure `10.x` allocations.

## Forward reservation

Virtual WAN User VPN later uses a **different** pool:

```text
172.31.241.0/24
```

Do not reuse `172.31.240.0/24` for the Virtual WAN client configuration while the classic P2S architecture remains deployed.

## Mental model

```text
Site-to-Site
network <-> network

Point-to-Site
individual device <-> Azure network
```

Cover client protocols/authentication, routes and DNS behaviour. Prove a private destination is unavailable before the tunnel and reachable through the intended path afterwards.
