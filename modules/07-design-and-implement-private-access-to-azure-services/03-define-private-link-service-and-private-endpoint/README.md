# Unit 03 — Define Private Link Service and private endpoint

**BlueHarbor chapter:** Give sensitive services a private network identity  
**Status:** NOT STARTED

## Business event

The Partner Hub data tier needs a stronger network-access model: approved BlueHarbor and hybrid clients should reach the managed service through a private IP rather than rely on its public service endpoint.

## Private Endpoint mental model

```text
existing BlueHarbor VNet
        |
Private Endpoint NIC
private IP
        |
Azure Private Link
        |
        v
supported Azure service
```

A Private Endpoint represents the target supported service through a private IP in the selected VNet/subnet.

## Progressive dependency

The endpoint does not replace Modules 1–3. Routing and hybrid connectivity already exist and must carry approved traffic to the private IP.

```text
Brisbane / Perth / approved client
        |
existing VPN / ExpressRoute design
        |
existing Azure routes
        |
Private Endpoint
```

## Private Link Service

Where appropriate, extend the existing Module 4 regional service:

```text
existing Standard Load Balancer
        |
Private Link Service
        |
consumer Private Endpoint
```

This demonstrates private consumption of BlueHarbor-owned services without inventing a disconnected application.
