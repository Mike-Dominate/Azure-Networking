# Unit 02 — Design Azure Application Gateway

**BlueHarbor chapter:** Create the Australia East Partner Hub landing zone and regional web entrance  
**Status:** NOT STARTED

## New application VNet

Add deliberately:

```text
bhi-vnet-partner-aue   10.40.0.0/16
  snet-appgw           10.40.1.0/24
  snet-partner-app     10.40.2.0/24
```

Do not place Partner Hub inside Manufacturing, Core or the Module 4 telemetry service.

Connect `bhi-vnet-partner-aue` to the existing `bhi-vhub-aue` so it participates in the cumulative enterprise network.

## Dedicated gateway subnet

`snet-appgw` is dedicated to Application Gateway. The `/24` allocation deliberately leaves Application Gateway v2 scale/maintenance headroom.

## Explicit application egress

`snet-partner-app` receives a regional NAT-managed outbound path (`nat-partner-aue`) rather than relying on implicit/default outbound connectivity.

## Regional architecture

```text
Internet
   |
HTTP(S)
   |
appgw-partner-aue   Standard_v2
   |
   +-- Engineering pool
   +-- Orders pool
   +-- Support pool
   |
snet-partner-app
```

Design listeners, rules, pools, backend settings, probes and TLS from the application requirement.

WAF is deliberately deferred to Module 6.
