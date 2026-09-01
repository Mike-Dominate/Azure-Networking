# BlueHarbor Industries — Module 8 Project Story

## Project — Build the BlueHarbor Network Operations Centre

**Microsoft Learn module:** Design and implement network monitoring  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 7

BlueHarbor now operates one substantial enterprise environment:

```text
M1 network foundation
M2 hybrid connectivity / Virtual WAN
M3 ExpressRoute
M4 telemetry availability / Load Balancer / Traffic Manager
M5 Partner Hub / Application Gateway / Front Door
M6 secured Virtual WAN / Azure Firewall / DDoS / WAF / segmentation
M7 service endpoints / Private Endpoints / Private Link / hybrid private DNS
```

Operations asks:

> If the network starts failing at 2 AM, how do we identify the failing layer before users tell us?

Module 8 changes the emphasis from configuration to evidence.

---

## Chapter 01 — We built it; can we operate it?

A Partner Hub complaint can originate from:

```text
DNS
VPN / ExpressRoute
Virtual WAN / routing
Azure Firewall / NSG
Front Door
Application Gateway
App Service
Private Endpoint
Azure SQL
application
```

Evidence categories:

```text
METRICS      numerical behaviour over time
LOGS         event/detail records
FLOW DATA    observed communications
HEALTH       component/service availability
TOPOLOGY     resource relationships
CONNECTION   synthetic/repeated reachability evidence
PACKETS      deep evidence when higher layers are insufficient
```

---

## Chapter 02 — Azure Monitor: establish one operational telemetry layer

Create a dedicated monitoring resource group and central workspace:

```text
rg-bhi-monitoring-aue
  law-bhi-netops-aue
```

Both regions send appropriate diagnostic logs to the central workspace.

### Regional flow-log storage

VNet flow-log Storage remains region-local:

```text
st-bhi-flow-aue-<unique>
st-bhi-flow-sea-<unique>
```

AUE flow-log target VNets:

```text
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-connectivity-aue
bhi-vnet-partner-aue
```

SEA flow-log target VNets:

```text
bhi-vnet-research-sea
bhi-vnet-partner-sea
```

Enable VNet flow logs and Traffic Analytics. During the learning programme use a short supported processing interval, such as 10 minutes, so experiments become visible without excessive waiting.

Do not create new NSG flow logs.

### Traffic Analytics ownership boundary

Terraform manages:

```text
workspace
regional flow-log Storage
VNet flow-log configuration
Traffic Analytics enablement
```

Do not take ownership of service-managed Traffic Analytics implementation objects such as Azure-created `NWTA*` DCR/DCE resources.

### Diagnostic settings

Send appropriate resource logs to `law-bhi-netops-aue` for Tier-1 resources including:

```text
AUE + SEA Azure Firewall
AUE + SEA Application Gateway WAF_v2
Front Door Premium
active VPN / Virtual WAN gateway resources
ExpressRoute where live
subscription Activity Log
```

Use resource-specific structured logs where the current service supports them. Diagnostic categories are revalidated during implementation.

### Alerting

Add:

```text
ag-bhi-netops
```

Notification addresses/receivers are supplied by sensitive/ignored Terraform input and are never committed to the public repository.

Start with alerts that have a clear operational explanation rather than creating dozens for coverage credit.

---

## Chapter 03 — Monitor the Load Balancer we already built

Use:

```text
lb-telemetry-aue
```

No replacement Load Balancer is created.

Track the distinction between:

```text
Health Probe Status / DipAvailability
 -> are backend instances responding?

Data Path Availability / VipAvailability
 -> is the Load Balancer data path itself available?
```

Controlled incident:

```text
telemetry-aue-01  HEALTHY
telemetry-aue-02  HEALTHY

stop/break telemetry-aue-02

telemetry-aue-01  HEALTHY
telemetry-aue-02  UNHEALTHY
```

Expected operational lesson:

```text
backend health degrades
service may remain available
alert/evidence identifies the backend problem
```

A successful `terraform apply` is not monitoring evidence. Generate the failure and observe the signal.

---

## Chapter 04 — Network Watcher: isolate where the path is failing

### Reconcile regional Network Watchers first

By Module 8, Azure may already have regional Network Watcher instances because VNets have existed in Australia East and Southeast Asia since earlier modules.

Implementation sequence:

```text
discover existing regional Network Watchers
 -> reference/import/reconcile as appropriate
 -> create only if genuinely absent and required
```

Do not create duplicate service-managed regional instances.

### Network Insights

Use Azure Monitor Network Insights as the operational topology/health experience over the existing resources. Do not invent a separate Terraform appliance called Network Insights.

### NetOps synthetic probe

Add one real NOC source:

```text
bhi-vnet-core-aue
  snet-management 10.10.1.0/24
    vm-netops-aue
```

Install/configure the current monitoring dependency required by Connection Monitor.

Representative Connection Monitor tests:

```text
vm-netops-aue -> Front Door endpoint            TCP/443
vm-netops-aue -> Partner SQL Private Endpoint   TCP/1433
vm-netops-aue -> telemetry private service      TCP/9000
vm-netops-aue -> Brisbane target                 when a real target exists
```

If no real Arc-enabled/agent-capable Brisbane source exists, do not claim continuous Brisbane -> Azure Connection Monitor coverage. Perform controlled Brisbane client tests and correlate them with Azure-side monitoring instead.

### Security/effective-rule test

Use a real flow such as Manufacturing to an approved internal destination and inspect the NSG/security decision with the current supported Network Watcher diagnostic.

### Route test

For a private workload expected to use Azure Firewall, inspect the effective route/next hop rather than assuming routing intent/UDRs are correct.

### VNet flow logs and Traffic Analytics

Use the six real BlueHarbor VNets. VNet flow logs do not represent Virtual WAN hub packet capture; Virtual WAN gateways/hubs retain their own metrics/logs/Insights evidence.

### Packet capture

Use packet capture only after higher-level health, DNS, route, security and flow evidence has failed to isolate the fault.

Authoritative escalation ladder:

```text
1. Alert / service health
2. Metrics
3. DNS result
4. Connection Monitor / connectivity test
5. NSG / Firewall decision
6. Effective route / next hop / BGP
7. VNet flow logs / Traffic Analytics
8. Resource-specific logs
9. Packet capture only when still necessary
```

---

## Chapter 05 — Final deterministic production incident

Do not use a vague or random capstone. Create two known faults in the complete cumulative environment without telling the learner which layer is responsible.

### Fault A — hybrid DNS

Break/misconfigure the Brisbane forwarding path for the Azure SQL service namespace.

Expected evidence pattern:

```text
Azure workload
  database.windows.net -> Partner SQL private IP

Brisbane engineer
  database.windows.net -> wrong/public answer or resolution failure
```

The learner must prove:

```text
Private Endpoint exists
Azure-side route is valid
Azure-side private DNS is valid
Brisbane answer differs
        -> hybrid DNS fault domain
```

### Fault B — telemetry backend health

Make one `lb-telemetry-aue` backend unhealthy.

Expected pattern:

```text
one backend unhealthy
regional TCP/9000 service remains available through healthy backend
Health Probe Status degrades
Data Path Availability can remain healthy
alert/evidence identifies backend fault
```

The learner must separate the DNS incident from the backend-health incident rather than assuming one common failure.

## DNS operations principle

DNS Private Resolver platform metrics help prove resolver availability/activity, but they do not prove a given name resolves to the correct private destination.

Use:

```text
resolver/platform metrics
+
synthetic name-resolution tests
```

for critical names such as the Partner SQL service.

---

## Module 8 Terraform progression

The existing Modules 1–7 resources remain deployed.

Module 8 adds only the operations layer and the intentional NetOps probe:

```text
law-bhi-netops-aue
regional flow-log Storage
VNet flow logs / Traffic Analytics
resource diagnostic settings
alerts / action group
Connection Monitor
vm-netops-aue
```

Expected plan rule:

```text
unexpected destruction/replacement of application/network resources
 -> STOP AND INVESTIGATE
```

## Programme end state

```text
ONE BLUEHARBOR STORY
ONE AZURE ENVIRONMENT
ONE TERRAFORM ROOT
ONE STATE LINEAGE

M1 foundation
 -> M2 hybrid
 -> M3 ExpressRoute
 -> M4 L4 availability
 -> M5 L7 delivery
 -> M6 security
 -> M7 private access
 -> M8 operations
```

## What happens after this module

The module-to-module dependency audit is completed **before** implementation starts. After Gate 7 and the whole-programme closeout are approved, the formal execution position returns to:

```text
Module 1
Unit 01 — Introduction
```

No BlueHarbor Terraform deployment begins until that closeout is recorded.
