# BlueHarbor Industries — Module 8 Project Story

## Project — Build the Network Operations Centre

**Microsoft Learn module:** Design and implement network monitoring  
**Company:** BlueHarbor Industries (BHI)  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` stack  
**Status:** NOT STARTED

## Starting point from Module 7

BlueHarbor now has a substantial enterprise environment built progressively across seven modules:

```text
Module 1 -> VNets, DNS, peering, routing, NAT
Module 2 -> hybrid VPN / remote connectivity / Virtual WAN
Module 3 -> ExpressRoute enterprise-connectivity design
Module 4 -> Azure Load Balancer and Traffic Manager
Module 5 -> Application Gateway and Front Door
Module 6 -> DDoS, NSGs/ASGs, Azure Firewall, secured hub, WAF
Module 7 -> service endpoints, Private Endpoint/Private Link, private DNS integration
```

The architecture works, but Operations asks the final programme question:

> If the network starts failing at 2 AM, how will we know what failed before users tell us?

Module 8 changes the focus from **configuration** to **evidence**.

```text
What should the network do?
        -> configuration

What is the network actually doing?
        -> observability
```

---

## Chapter 01 — Introduction: We built it; can we operate it?

A user reports that the Partner Hub is slow.

That symptom could come from many layers:

```text
DNS
hybrid connectivity
routing
Azure Firewall / NSG
Front Door
Application Gateway
backend health
Private Endpoint
PaaS service
application
```

The operational goal is to stop guessing and instead gather evidence that narrows the fault domain.

### Evidence model

```text
METRICS
What is happening numerically?

LOGS
What events occurred?

FLOW DATA
Who communicated with whom?

HEALTH
Is the component available/healthy?

TOPOLOGY
How are resources related?

CONNECTION TESTING
Can source A reach destination B through the expected path?

PACKET EVIDENCE
What actually travelled on the wire/path when deeper inspection is necessary?
```

---

## Chapter 02 — Azure Monitor: Build the operational telemetry layer

BlueHarbor Operations wants a central way to collect, query and act on telemetry from the environment already built.

Conceptually:

```text
BlueHarbor resources
VNets / gateways / Load Balancer / App Gateway / Firewall / applications
        |
        v
telemetry
        |
        v
Azure Monitor
   /          \
metrics       logs
                 |
           Log Analytics
   \             /
    alerts / workbooks / investigation
```

### Business outcome

Move from:

```text
user reports outage
-> engineer starts investigating
```

to:

```text
telemetry detects condition
-> alert fires
-> operations investigates with evidence
```

### Terraform delta

Extend the existing stack with monitoring resources/configuration such as the capabilities required by the final design:

```text
Log Analytics workspace
monitoring/diagnostic settings
metric alerts
alert action groups
flow-log configuration
Connection Monitor configuration where appropriate
supporting storage/workspaces where required
```

The architecture audit before implementation will determine exact placement and dependencies.

### Core alert mental model

```text
metric / log signal
        |
condition
        |
alert rule
        |
action group / response path
```

---

## Chapter 03 — Exercise: Monitor the Load Balancer we already built

Microsoft's Load Balancer monitoring exercise maps directly onto the existing BlueHarbor telemetry service from Module 4.

Do **not** create a toy replacement Load Balancer.

```text
Manufacturing / service clients
        |
existing Azure Load Balancer
        |
   +----+----+
   |         |
backend01 backend02
```

Module 4 asked:

> How do we keep the regional service available when a backend fails?

Module 8 asks:

> How does Operations detect and investigate that failure without manually testing every backend?

### Failure experiment

Start healthy:

```text
backend01 healthy
backend02 healthy
```

Introduce a controlled failure:

```text
backend01 unhealthy
backend02 healthy
```

Then trace:

```text
failure
  -> monitoring signal
  -> alert / evidence
  -> investigation
  -> root cause
  -> restoration
```

The value of the exercise is the observable signal and investigation path, not merely the fact that the Load Balancer still exists.

---

## Chapter 04 — Network Watcher: Find where the network is wrong

Azure Monitor can tell Operations that something is degraded. Network Watcher tools help isolate where the network path is failing.

This chapter deliberately reuses knowledge from every earlier module.

### Scenario A — IP Flow Verify / security decision

Ticket:

> Manufacturing cannot reach Shared Services over an approved port.

Instead of reading NSG rules manually and guessing:

```text
source + destination + protocol + port
        |
IP Flow Verify / relevant diagnostic
        |
ALLOW / DENY
        |
matching rule / evidence
```

This operationalizes Module 6 security knowledge.

### Scenario B — Next Hop / routing decision

Ticket:

> Manufacturing cannot reach an approved external service.

Expected path:

```text
Manufacturing
      |
UDR
      |
Azure Firewall
      |
destination
```

Use routing/effective-state tooling to determine whether the actual next hop matches the intended design.

This operationalizes Module 1 routing and Module 6 firewall architecture.

### Scenario C — Connection Monitor / critical path

Monitor an important path such as:

```text
Partner Hub application
        |
private network path
        |
Private Endpoint / critical service
```

Where supported by the chosen endpoint model, use Connection Monitor to gather ongoing reachability/latency evidence rather than relying on a one-time manual test.

### Scenario D — VNet flow logs

BlueHarbor wants evidence of network communication patterns:

```text
source
  -> destination
  -> port/protocol
  -> observed flow information
```

Use **VNet flow logs** for the new BlueHarbor design. Do not base the 2026 project on creating new NSG flow logs.

### Scenario E — Traffic Analytics

Flow records answer individual flow questions. Traffic Analytics helps Operations reason about larger traffic patterns such as:

```text
top talkers
traffic distribution
unexpected communication patterns
ports/protocol usage
network trends
```

### Scenario F — packet capture / deeper inspection

Use packet capture only when higher-level evidence is insufficient.

A sensible escalation ladder is:

```text
1. resource/service health
2. metrics and alerts
3. DNS result
4. connection test
5. NSG/firewall decision
6. route / next hop
7. flow evidence
8. packet capture when necessary
```

Do not start with packet capture when simpler evidence can isolate the problem.

---

## Chapter 05 — Summary: Final BlueHarbor production incident

The final module summary becomes the programme-wide operational incident.

### Incident

> Brisbane engineers report intermittent failures accessing the Partner Hub engineering service and its private data service. At the same time, Manufacturing telemetry reports elevated latency.

The learner is **not** given the root cause.

The environment includes the architecture created across all previous modules:

```text
Brisbane / Perth / remote users
        |
VPN / ExpressRoute / Virtual WAN
        |
secured routing / Azure Firewall
        |
+----------------------+-------------------+
|                                          |
Partner Hub                            Manufacturing
|                                          |
Front Door / App Gateway               Load Balancer
|                                          |
Private Endpoint                      telemetry backends
|
PaaS data service
```

### Investigation method

Form hypotheses and eliminate them with evidence:

```text
DNS?
hybrid connectivity?
route / BGP path?
Azure Firewall?
NSG?
Front Door / App Gateway origin health?
Load Balancer backend health?
Private Endpoint / private DNS?
PaaS service?
application?
```

### Example multi-fault pattern

One fault may be a hybrid DNS inconsistency:

```text
Azure workload -> service name -> private IP
Brisbane client -> same name -> wrong/public result
```

That points toward the hybrid DNS path rather than immediate Private Endpoint recreation.

A second fault may be degraded telemetry backend health:

```text
backend01 healthy
backend02 unhealthy
```

Monitoring and network/application evidence should identify which layer is responsible.

The purpose is not to memorize tool names. The purpose is to answer:

> The business says the service is broken. Prove which networking layer is responsible.

---

## Module 8 Terraform progression

The cumulative Terraform root already represents the environment built through Module 7.

Module 8 adds the operations layer to those exact resources:

```text
existing Load Balancer
        + metrics / diagnostics / alerts

existing Azure Firewall
        + diagnostic settings / logs

existing VNets
        + VNet flow logs

existing critical application paths
        + connection monitoring

complete existing environment
        + Log Analytics / monitoring platform
```

Expected plan principle:

```text
Modules 1–7 resources: preserved
Module 8 monitoring resources/config: added
unexpected replacement/destruction: STOP AND INVESTIGATE
```

---

## Final architecture-board explain-back

The learner should be able to explain:

- metrics versus logs versus flow data;
- what configuration tells us versus what telemetry proves;
- why an NSG ALLOW does not prove application reachability;
- how to prove traffic is taking the intended next hop;
- how failed Load Balancer backends should become operational signals;
- how to separate Private Endpoint DNS failures from routing/service-policy failures;
- when Connection Monitor is useful;
- when flow logs/Traffic Analytics are useful;
- when packet capture is justified;
- how to walk a Brisbane user request through DNS, hybrid connectivity, security, application delivery and private PaaS access while identifying observability at every stage.

## Programme end state

```text
ONE BLUEHARBOR BUSINESS STORY
ONE AZURE ENVIRONMENT
ONE TERRAFORM ROOT
ONE TERRAFORM STATE LINEAGE

M1 network foundation
 -> M2 hybrid connectivity
 -> M3 enterprise connectivity
 -> M4 service availability
 -> M5 HTTP(S) delivery
 -> M6 security
 -> M7 private PaaS access
 -> M8 observability and operations
```

The next programme activity is the **Modules 1–8 Architecture & Terraform Dependency Audit**. Do not begin the actual Module 1 build until that audit has validated continuity, addressing, naming, dependencies and expected Terraform resource evolution across the full chain.
