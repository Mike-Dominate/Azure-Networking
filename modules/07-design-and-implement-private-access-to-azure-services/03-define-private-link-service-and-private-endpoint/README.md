# Unit 03 — Define Private Link Service and private endpoint

**BlueHarbor chapter:** Publish the existing telemetry service privately and create a real consumer  
**Status:** NOT STARTED

## Provider side — reuse Module 4

```text
lb-telemetry-aue
Standard Load Balancer
TCP/9000
NIC-backed backend pool
```

Add:

```text
bhi-vnet-mfg-aue
  snet-pls-nat 10.20.3.0/27

pls-telemetry-aue
 -> existing Load Balancer frontend
```

Use the current Private Link Service subnet policy requirements, including disabling Private Link Service network policies on the provider NAT subnet when required.

The telemetry backend NSG must allow the current documented PLS NAT-source path on TCP/9000.

## Consumer side — Core

Add:

```text
bhi-vnet-core-aue
  snet-private-endpoints 10.10.20.0/24
```

Create a Private Endpoint in Core to `pls-telemetry-aue`.

Private Endpoint network policies are enabled where required by BlueHarbor's secured Virtual WAN/NSG/route-table design.

## Hybrid dependency

```text
Brisbane / Perth
 -> VPN / ExpressRoute
 -> secured Virtual WAN
 -> Core consumer Private Endpoint
 -> Private Link Service
 -> existing telemetry service
```

This demonstrates that Private Link can publish BlueHarbor-owned services, not just Microsoft PaaS.
