# Module 8 — Design and implement network monitoring

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-network-monitoring/

**BlueHarbor project:** Operate and troubleshoot the complete BlueHarbor enterprise network  
**Status:** NOT STARTED

Module 8 observes the exact cumulative environment built through Modules 1–7.

## Canonical monitoring platform

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
ag-bhi-netops
```

Appropriate diagnostics from both Azure regions land in the central Log Analytics workspace.

VNet flow-log Storage remains regional and follows valid Storage-account naming rules:

```text
Australia East
  stbhiflowaue<global_suffix>

Southeast Asia
  stbhiflowsea<global_suffix>
```

Enable VNet flow logs on all six BlueHarbor VNets and feed Traffic Analytics into `law-bhi-netops-aue`.

Do not create new NSG flow logs.

## Network Watcher ownership

Discover/reconcile the regional Network Watcher instances that Azure may already have auto-enabled. Do not blindly create duplicates.

## NetOps probe

```text
bhi-vnet-core-aue
  snet-management 10.10.1.0/24
    vm-netops-aue
```

Representative Connection Monitor tests include Front Door TCP/443, Partner SQL PE TCP/1433, telemetry PLS private service TCP/9000 and a real Brisbane target when available.

## Load Balancer exercise

Use:

```text
lb-telemetry-aue
```

and correlate backend Health Probe Status with Load Balancer Data Path Availability.

## Diagnostics/alerts

Centralize appropriate Tier-1 diagnostics for Azure Firewall, App Gateway WAF, Front Door, active hybrid gateways/Virtual WAN and ExpressRoute where live. Use a small explainable alert set rather than alert spam.

Persistent monitoring changes extend the same Terraform root/state.
