# Module 5 — Load balance HTTP(S) traffic in Azure

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/load-balancing-https-traffic-azure/

**BlueHarbor project:** Launch the BlueHarbor Partner Hub globally  
**Status:** NOT STARTED

Module 5 continues from the exact Terraform code, state and deployed Azure estate produced by Modules 1–4.

The Module 4 telemetry service remains a separate non-HTTP workload:

```text
Device Telemetry Ingest
TCP/9000
AUE + SEA public Standard Load Balancers
Traffic Manager Priority failover
```

Module 5 introduces a different application whose routing decisions depend on HTTP(S) hostnames, URL paths, TLS and application health.

## New application

Narrative hostname:

```text
portal.blueharbor.example
```

Example paths:

```text
/engineering/*
/orders/*
/support/*
```

`.example` is documentation-only. The practical initially uses Azure-generated reachable hostnames/endpoints unless the learner later supplies a real public domain that they control.

## Australia East application landing zone

Module 5 Units 01–04 add:

```text
bhi-vnet-partner-aue   10.40.0.0/16
  snet-appgw           10.40.1.0/24
  snet-partner-app     10.40.2.0/24
```

`bhi-vnet-partner-aue` is connected to the existing `bhi-vhub-aue` Virtual WAN hub.

The application subnet gets explicit Terraform-managed outbound connectivity through a regional NAT design. The Application Gateway has its own dedicated subnet.

Regional delivery:

```text
Internet
  |
appgw-partner-aue   Standard_v2
  |
  +-- /engineering/*
  +-- /orders/*
  +-- /support/*
  |
Partner Hub backends in snet-partner-app
```

## Southeast Asia expansion

When the Partner Hub becomes multi-region in Unit 05, activate the Virtual WAN hub reserved during Gate 2:

```text
bhi-vhub-sea   10.200.4.0/22
```

Then add:

```text
bhi-vnet-partner-sea   10.50.0.0/16
  snet-appgw           10.50.1.0/24
  snet-partner-app     10.50.2.0/24
```

The existing `bhi-vnet-research-sea` Virtual WAN connection is intentionally migrated from `bhi-vhub-aue` to `bhi-vhub-sea`; the Research VNet itself is not replaced.

`bhi-vnet-partner-sea` connects to `bhi-vhub-sea` and receives its own explicit NAT-managed application-subnet egress.

## Global HTTP(S) delivery

Unit 06 adds Azure Front Door Standard only after both regional Application Gateway origins exist:

```text
Azure Front Door Standard
  |
  +-- appgw-partner-aue
  +-- appgw-partner-sea
```

Front Door is in the HTTP(S) application path. This is intentionally different from Module 4 Traffic Manager, which makes a DNS decision and then leaves the application data path.

## Security handoff

Module 5 establishes delivery first:

```text
Application Gateway Standard_v2
Front Door Standard
```

Module 6 will audit/harden that real architecture, including WAF placement/tier changes and origin-bypass controls where justified. Do not pre-solve the security module here.

## Microsoft Learn units

1. Introduction
2. Design Azure Application Gateway
3. Configure Azure Application Gateway
4. Exercise: Deploy Azure Application Gateway
5. Design and configure Azure Front Door
6. Exercise: Create a Front Door for a highly available web application
7. Summary

Persistent infrastructure is implemented through the same `blueharbor/terraform/` root. There is no routine teardown at the end of this module.
