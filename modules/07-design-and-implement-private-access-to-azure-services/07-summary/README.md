# Unit 07 — Summary

**BlueHarbor chapter:** Private-access architecture review  
**Status:** NOT STARTED

## Five distinct patterns

```text
Service Endpoint
 -> Manufacturing subnet identity -> restricted Azure Storage

Private Endpoint
 -> Azure SQL / App Service represented by private IPs in Partner AUE

App Service VNet Integration
 -> `/orders` App Service outbound into the Partner VNet

Private Link Service
 -> existing BlueHarbor telemetry service published privately

Front Door Private Link
 -> Front Door Premium reaches existing regional App Gateway WAF_v2 origins privately
```

## Canonical address additions

```text
CORE AUE
snet-private-endpoints   10.10.20.0/24

MFG AUE
snet-pls-nat             10.20.3.0/27

PARTNER AUE
snet-private-endpoints   10.40.3.0/24
snet-appsvc-integration  10.40.4.0/26
snet-appgw-pl            10.40.5.0/27

PARTNER SEA
snet-appgw-pl            10.50.3.0/27
```

No new VNet or hub was required.

## Hybrid explain-back

Be able to trace:

```text
Brisbane DNS
 -> Core DNS Private Resolver
 -> private zone
 -> Private Endpoint IP
 -> secured Virtual WAN route
 -> service
```

and identify when a same-VNet PE flow remains local rather than traversing Azure Firewall.

## Handoff to Module 8

The complete estate now contains public delivery, private delivery, hybrid routing, secured hubs, DNS Private Resolver, service endpoints, Private Endpoints, Private Link Service, WAF and multi-region applications.

Module 8 must monitor **this exact environment** rather than creating a small monitoring demo.
