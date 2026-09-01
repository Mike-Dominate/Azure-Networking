# Unit 09 — Exercise: Secure your Virtual Hub using Azure Firewall Manager

**BlueHarbor chapter:** Make both Virtual WAN hubs the inspected enterprise transit  
**Status:** NOT STARTED

Module 2/5 already built the actual Virtual WAN topology. Secure that topology rather than creating a new hub.

## Add SEA enforcement

```text
bhi-vhub-sea
  +-- azfw-bhi-sea
  +-- fwpol-bhi-global
```

## Routing intent / secured-hub progression

Configure the current supported Virtual WAN security-routing model for approved requirements, including Internet and Private traffic policies where appropriate.

Before enabling it:

```text
capture hub/VNet route state
 -> terraform plan
 -> inspect intended route-table changes
 -> apply
 -> verify effective routes
 -> test representative flows
```

Unexpected route changes mean STOP and investigate.

## Public-service exceptions

Do not blindly inherit the firewall default into public-ingress subnets.

Preserve a supported explicit public return path for:

```text
snet-appgw in AUE and SEA
snet-mfg-app with nat-mfg-aue
snet-telemetry-dr with nat-telemetry-sea
```

Exact UDR and service-specific requirements are verified against current Azure documentation during implementation.

## Partner NAT replacement

After firewall egress is proven for the private Partner backend subnets:

```text
retire nat-partner-aue / nat-partner-sea associations/resources
snet-partner-app -> secured Virtual WAN -> Azure Firewall -> approved Internet
```

This is a deliberate architecture evolution, not end-of-lab cleanup.

## Retire bypass peerings

Once secured private transit is verified, remove the direct Module 1 peerings that would bypass central inspection:

```text
Core <-> Manufacturing
Core <-> Research
```

The VNets and workloads remain; only the production transit path changes.
