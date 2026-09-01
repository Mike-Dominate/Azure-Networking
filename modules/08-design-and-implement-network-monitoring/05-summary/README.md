# Unit 05 — Summary

**BlueHarbor chapter:** Final production incident and programme architecture review  
**Status:** NOT STARTED

## Final incident

Brisbane engineers report intermittent failures accessing the Partner Hub engineering service and its private data service. Manufacturing telemetry simultaneously reports elevated latency.

The learner is not given the root cause.

Use the cumulative environment and evidence to investigate:

```text
DNS?
hybrid VPN / ExpressRoute / Virtual WAN?
routing / BGP path?
Azure Firewall / NSG?
Front Door / Application Gateway?
Load Balancer backend health?
Private Endpoint / private DNS?
PaaS service?
application?
```

The objective is:

> The business says the service is broken. Prove which networking layer is responsible.

## Final explain-back

Be able to explain:

- metrics vs logs vs network-flow evidence;
- configuration vs observed behavior;
- why NSG ALLOW does not prove application reachability;
- how to prove the intended next hop;
- how failed Load Balancer backends become operational signals;
- how to isolate Private Endpoint DNS vs routing/service-policy faults;
- when Connection Monitor, flow logs, Traffic Analytics and packet capture are appropriate;
- how to trace and monitor a Brisbane user request through DNS, hybrid connectivity, security, application delivery and private PaaS access.

## Programme end state

```text
M1 network foundation
 -> M2 hybrid connectivity
 -> M3 enterprise private connectivity
 -> M4 service availability
 -> M5 HTTP(S) delivery
 -> M6 security
 -> M7 private PaaS access
 -> M8 observability / operations
```

All practical infrastructure belongs to the same `blueharbor/terraform/` root and one state lineage.

## Next step

Do **not** begin the implementation yet.

Perform the full **Modules 1–8 Architecture & Terraform Dependency Audit** first. Validate naming, IP addressing, subnet requirements, resource dependencies, module-to-module handoffs and expected Terraform additions/changes so later units do not force avoidable destructive redesign.
