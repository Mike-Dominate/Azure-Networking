# Module 8 — Design and implement network monitoring

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-network-monitoring/

**BlueHarbor project:** Build the operations and observability layer for the complete enterprise network  
**Status:** NOT STARTED

Module 8 is the final operational layer of the BlueHarbor project. It does not create a separate monitoring lab. It observes, validates and troubleshoots the exact cumulative environment built through Modules 1–7.

```text
Modules 1–7
network + hybrid + delivery + security + private access
        |
        + Azure Monitor
        + Log Analytics / diagnostics
        + alerts
        + Connection Monitor
        + VNet flow logs / Traffic Analytics
        + Network Watcher troubleshooting
        v
same BlueHarbor Terraform stack and state lineage
```

The core business question is:

> Configuration tells us what the network should do. How do we prove what this complete environment is actually doing?

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Monitor your networks using Azure Monitor
3. Exercise: Monitor a load balancer resource using Azure monitor
4. Monitor your networks using Azure Network Watcher
5. Summary

## Cumulative Terraform rule

All persistent monitoring configuration extends:

```text
blueharbor/terraform/
```

Do not build replacement VNets, VMs or Load Balancers solely to satisfy monitoring exercises when the corresponding BlueHarbor resources already exist.

Module 8 should attach monitoring to real project resources such as:

- the existing Module 4 Load Balancer;
- the VNets and routing paths from Module 1;
- hybrid connectivity from Modules 2–3;
- Azure Firewall and security controls from Module 6;
- critical application/private endpoint paths from Modules 5–7.

Azure CLI, Portal and diagnostic tools are used to inspect evidence and troubleshoot the Terraform-managed environment.

## Current-product note

For new flow-log design, use **VNet flow logs** rather than designing new NSG flow-log deployments. Current Microsoft guidance has moved new implementations toward VNet flow logs.
