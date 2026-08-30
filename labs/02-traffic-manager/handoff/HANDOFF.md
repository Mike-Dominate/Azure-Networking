# Lab 02 Handoff — Azure Traffic Manager

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** COMPLETE
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Next lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Completion record

Lab 02 has completed the programme learning and engineering workflow. The manual and Terraform implementations were completed and independently validated, failure/recovery behavior was tested, documentation and visual-learning assets were committed, and the environment was safely torn down and verified clean.

Completed:

```text
Traffic Manager mental model
DNS-based traffic steering
manual Azure CLI deployment
regional endpoint validation
Geographic routing configuration
Australia/Pacific mapping failure and correction
DNS validation
HTTP validation
endpoint health failure/recovery exercise
Geographic-routing degraded-endpoint behavior test
DNS TTL authoritative-versus-recursive investigation
Azure Portal inspection
manual teardown
Terraform implementation
Terraform fmt / validate / plan / apply
independent Azure + DNS + HTTP validation
Terraform failure/recovery validation
final no-change/convergence validation
Git/GitHub checkpoint
rebuild/practice documentation
Terraform destroy
Azure clean-state verification
final learner explain-back
```

## Actual architecture

The source scenario intended App Service F1 endpoints in East US, West Europe and Southeast Asia. The subscription's zero App Service VM quota prevented the East US App Service plan from being created, so the validated lab implementation used:

```text
Azure Container Instances
+ public regional ACI FQDNs
+ Azure Traffic Manager External endpoints
+ Geographic routing
```

Validated mapping:

```text
North America      -> ep-eus -> East US ACI
Europe             -> ep-weu -> West Europe ACI
Asia               -> ep-sea -> Southeast Asia ACI
Australia/Pacific  -> ep-sea -> Southeast Asia ACI
```

Traffic Manager profile:

```text
Resource: tm-az700-global
Routing: Geographic
DNS TTL: 30 seconds
Health monitor: HTTP / port 80 / path /
```

## Key lessons proven

```text
Traffic Manager = global DNS steering, not an inline proxy
Load Balancer   = regional Layer-4 data-path distribution

Geographic routing = explicit geography-to-endpoint mapping
Performance routing = latency-oriented endpoint selection

Traffic Manager health monitoring and Load Balancer backend health probes
operate at different levels.

DNS TTL and recursive resolver caching can affect observed client behavior.
```

The failure exercise also demonstrated that Geographic routing must not be assumed to behave like Priority routing: a degraded mapped endpoint did not automatically produce the invented cross-geography failover path.

## Repository artifacts

```text
labs/02-traffic-manager/README.md
labs/02-traffic-manager/manual-deployment/
labs/02-traffic-manager/terraform/
labs/02-traffic-manager/visual-learning/
labs/02-traffic-manager/handoff/
```

## Resume point

**Lab 02 is finished. Do not repeat its deployment unless performing an explicit review or maintenance exercise.**

The programme now resumes at **Lab 03**.

Follow the standard sequence:

```text
Problem/use case
-> Teach mental model
-> Visual architecture / traffic flow
-> Understanding check
-> Manual Azure CLI implementation
-> Independent validation
-> Failure/troubleshooting
-> Terraform rebuild
-> Independent IaC validation
-> Git/GitHub checkpoint
-> Rebuild documentation
-> Safe teardown
-> Explain-back
```
