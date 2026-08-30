# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Current lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Current phase:** Lab 02 complete; ready to begin Lab 03
- **Overall progress:** 2 / 22 labs completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Completed labs

```text
01  Azure Load Balancer     COMPLETE
02  Azure Traffic Manager   COMPLETE
```

## Lab 02 completion checkpoint

Lab 02 has completed its required learning and engineering workflow, including:

```text
Traffic Manager mental model
manual Azure deployment
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
independent clean-state verification
Terraform rebuild and validation
failure/recovery validation against IaC
final convergence/no-change validation
Git/GitHub checkpoint
rebuild/practice documentation
safe teardown and clean-state verification
final learner explain-back
```

## Lab 02 actual architecture

The original source scenario intended App Service F1 endpoints in East US, West Europe and Southeast Asia. The subscription's zero App Service VM quota prevented the East US App Service plan from being created, so the lab deliberately used:

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

## Critical Lab 02 lessons

```text
Traffic Manager = global DNS steering, not an inline application proxy
Load Balancer   = regional Layer-4 data-path distribution

Geographic routing = explicit geography-to-endpoint mapping
Performance routing = latency-oriented endpoint selection

Traffic Manager health monitoring and Load Balancer backend health probes
operate at different levels.

DNS TTL and recursive resolver caching can affect observed failover timing.
```

The lab also deliberately recorded the observed Geographic-routing behavior: a degraded mapped endpoint was not silently treated as a Priority-routing failover to another geography. The documentation reflects the actual tested behavior rather than inventing a failover path.

## Lab 02 artifacts

Manual deployment documentation, Terraform implementation, validation/troubleshooting material, required visual-learning assets and the rebuild/practice documentation are committed under:

```text
labs/02-traffic-manager/
```

## Immediate resume point

Do **not** return to Lab 02 unless a future maintenance/review task is explicitly requested.

Begin **Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture** using the standard learning loop:

```text
1. Problem/use case
2. Teach mental model
3. Visual architecture and traffic/control flow
4. Learner understanding check
5. Manual Azure deployment
6. Azure CLI/protocol validation
7. Failure/troubleshooting exercise
8. Portal inspection where useful
9. Terraform implementation
10. Independent IaC validation
11. Git/GitHub checkpoint
12. Rebuild/practice documentation
13. Safe teardown
14. Learner explain-back
```

## Non-negotiable working preferences

- Azure only.
- Maximum one lab per day.
- VS Code is the primary engineering workspace.
- Azure CLI is preferred for manual deployment, inspection and validation.
- Terraform follows understanding; it does not replace learning Azure.
- Teach concepts before testing comprehension.
- Explain important command and HCL syntax before execution.
- Work one meaningful action at a time during interactive labs.
- Interpret actual output before continuing.
- Use Azure Portal for inspection/troubleshooting, not as the sole deployment mechanism.
- Create reusable PNG/JPEG visual learning assets where useful.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behavior rather than hiding it.
- Never commit credentials, Terraform state, tokens, private keys, certificates or sensitive local `.tfvars`.
- End practical labs with detailed rebuild/practice documentation sufficient to repeat the lab without chat history.

## Status consistency rule

Whenever a lab status changes, keep these records synchronized:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
labs/<lab>/README.md
labs/<lab>/handoff/HANDOFF.md
```
