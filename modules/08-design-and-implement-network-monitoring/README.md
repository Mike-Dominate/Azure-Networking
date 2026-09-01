# Module 8 — Design and implement network monitoring

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-network-monitoring/

**BlueHarbor project:** Operate and troubleshoot the complete BlueHarbor enterprise network  
**Status:** NOT STARTED

Module 8 is the operations layer for the exact cumulative environment built through Modules 1–7. It does not create a separate monitoring lab.

## Starting estate

Operations must observe a real multi-region environment containing:

```text
Core / Manufacturing / Research / Partner VNets
AUE + SEA Virtual WAN hubs
VPN + ExpressRoute
AUE + SEA Azure Firewall
DDoS / NSG / ASG / WAF
AUE + SEA telemetry Load Balancers + Traffic Manager
Front Door Premium + Private Link to regional App Gateway WAF_v2 origins
Storage service endpoint
Azure SQL + App Service Private Endpoints
App Service VNet Integration
BlueHarbor telemetry Private Link Service
Core DNS Private Resolver / hybrid DNS
```

The business question is:

> Configuration tells us what should happen. How do we prove what the network is actually doing before users become our monitoring system?

## Canonical monitoring platform

One central Log Analytics workspace:

```text
rg-bhi-monitoring-aue
  law-bhi-netops-aue
```

Appropriate diagnostic logs from both regions land in that workspace so investigations can correlate the complete service path.

Flow logs have a different locality constraint. Use region-local Storage:

```text
Australia East
  st-bhi-flow-aue-<unique>

Southeast Asia
  st-bhi-flow-sea-<unique>
```

Enable **VNet flow logs** for all six BlueHarbor VNets and feed Traffic Analytics into `law-bhi-netops-aue`.

Do not create new NSG flow logs.

## Regional Network Watcher ownership

Azure normally auto-enables Network Watcher when VNets are created/updated in a region. Therefore Module 8 must first discover the Australia East and Southeast Asia Network Watcher instances and reconcile them with Terraform ownership/reference as appropriate.

Do not blindly create duplicate regional Network Watcher resources.

## NetOps synthetic probe

Give the existing management subnet an operational purpose:

```text
bhi-vnet-core-aue
  snet-management 10.10.1.0/24
    vm-netops-aue
```

`vm-netops-aue` becomes the Azure source for Connection Monitor and controlled synthetic tests.

Representative tests include:

```text
Front Door endpoint               TCP/443
Partner SQL Private Endpoint      TCP/1433
telemetry PLS private service     TCP/9000
Brisbane representative target    where a real reachable target exists
```

Do not pretend an on-premises source is continuously monitored unless the required real/Arc-enabled source exists.

## Load Balancer monitoring exercise

Use the existing primary service:

```text
lb-telemetry-aue
```

Correlate at least:

```text
Health Probe Status / DipAvailability
Data Path Availability / VipAvailability
```

The first answers whether backends are responding. The second answers whether the Load Balancer data path is available.

## Alerting

Create:

```text
ag-bhi-netops
```

The actual notification receiver is supplied through ignored/sensitive Terraform input, not committed to the public repository.

Keep the first alert set small and meaningful: Load Balancer health/data path, Connection Monitor failures, critical firewall/gateway/connectivity conditions, application-delivery health, DDoS attack/mitigation signals and Resource Health where appropriate.

## Diagnostics

Centralize appropriate logs for Tier-1 resources such as:

```text
azfw-bhi-aue / azfw-bhi-sea
appgw-partner-aue / appgw-partner-sea
Front Door Premium
active VPN / Virtual WAN gateway resources
ExpressRoute resources where live
subscription Activity Log
```

Use current resource-specific logging modes/tables where supported. Revalidate diagnostic categories at implementation time rather than freezing stale category names into the curriculum.

## Microsoft Learn units

1. Introduction
2. Monitor your networks using Azure Monitor
3. Exercise: Monitor a load balancer resource using Azure monitor
4. Monitor your networks using Azure Network Watcher
5. Summary

All persistent monitoring configuration extends the same `blueharbor/terraform/` root and state lineage.
