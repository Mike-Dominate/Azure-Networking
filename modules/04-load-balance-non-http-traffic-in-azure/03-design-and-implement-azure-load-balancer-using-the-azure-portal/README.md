# Unit 03 — Design and implement Azure load balancer using the Azure portal

**BlueHarbor chapter:** Design the Australia East telemetry service  
**Status:** NOT STARTED

## Reuse the existing network

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
         +-- telemetry backends
```

Do not create another VNet.

## Approved regional design

```text
Internet
  |
TCP/9000
  |
pip-telemetry-aue
  |
lb-telemetry-aue   Standard / public
  |
  +-- vm-telemetry-aue-01
  +-- vm-telemetry-aue-02
```

Use a TCP/9000 health probe so the practical remains explicitly non-HTTP(S).

The existing Module 1 NAT association on `snet-mfg-app` remains the explicit backend-initiated outbound path.

Add only the minimal NSG policy required for approved TCP/9000 service traffic and Azure Load Balancer probe traffic. Module 6 provides the deeper security design later.
