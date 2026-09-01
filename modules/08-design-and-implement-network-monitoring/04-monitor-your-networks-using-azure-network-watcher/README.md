# Unit 04 — Monitor your networks using Azure Network Watcher

**BlueHarbor chapter:** Diagnose the complete enterprise path with evidence  
**Status:** NOT STARTED

## Reconcile Network Watcher ownership

Australia East and Southeast Asia may already have auto-enabled Network Watcher instances because BlueHarbor VNets have existed since earlier modules.

Before Terraform attempts to manage them:

```text
discover regional Network Watchers
 -> reference/import/reconcile existing instances as appropriate
 -> create only if truly absent
```

Do not blindly duplicate service-managed regional Network Watcher resources.

## Network Insights

Use Azure Monitor Network Insights to inspect topology, resource health and dependencies across the existing environment. It is an operational experience over deployed resources, not a separate appliance/VNet to provision.

## NetOps source

Add:

```text
bhi-vnet-core-aue
  snet-management 10.10.1.0/24
    vm-netops-aue
```

Configure the current Connection Monitor source dependency/extension.

## Connection Monitor tests

Use real critical paths, for example:

```text
vm-netops-aue -> Front Door endpoint             TCP/443
vm-netops-aue -> Partner SQL Private Endpoint    TCP/1433
vm-netops-aue -> telemetry PLS private service   TCP/9000
vm-netops-aue -> Brisbane representative target  when a real target exists
```

Do not claim Brisbane itself is a continuous Connection Monitor source unless a real supported source/agent is deployed there.

## Security decision

Use IP Flow Verify/effective-rule diagnostics where applicable to answer a concrete question such as whether an intended Manufacturing flow is allowed or denied and by which rule.

## Routing decision

For a private workload that should traverse Azure Firewall, inspect effective routes/next hop/BGP evidence. Do not infer the actual path solely from Terraform intent.

## VNet flow logs / Traffic Analytics

Use VNet flow logs for all six BlueHarbor VNets with region-local Storage and central Traffic Analytics.

Do not create new NSG flow logs.

VNet flow logs do not substitute for Virtual WAN hub/gateway metrics or logs.

## Packet capture

Use packet capture only after higher-level evidence fails to isolate the issue.

Authoritative troubleshooting ladder:

```text
1. Alert / service health
2. Metrics
3. DNS result
4. Connection Monitor / connectivity test
5. NSG / Firewall decision
6. Effective route / next hop / BGP
7. VNet flow logs / Traffic Analytics
8. Resource-specific logs
9. Packet capture when justified
```
