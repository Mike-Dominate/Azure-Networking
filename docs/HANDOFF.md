# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and at meaningful checkpoints.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 01 — Azure Load Balancer
- **Current lab:** Lab 02 — Azure Traffic Manager — IN PROGRESS
- **Current phase:** Lab 02 manual Azure phase is complete, fully documented, visually documented, and torn down. Terraform rebuild is NEXT.
- **Overall progress:** 1 / 22 labs completed; Lab 02 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Immediate resume instruction

Do **not** repeat the Lab 02 manual Azure build.

The manual phase is complete and Azure is clean.

Resume using:

```text
1. docs/HANDOFF.md
2. labs/02-traffic-manager/handoff/HANDOFF.md
3. labs/02-traffic-manager/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
4. labs/02-traffic-manager/README.md
```

On the learner workstation first run:

```powershell
git pull --rebase
```

Then begin the **Lab 02 Terraform rebuild**. Teach the Terraform resource model and dependency relationships before writing HCL. Continue one meaningful action at a time and interpret output before proceeding.

## Lab 02 manual-phase completion checkpoint

The following are complete:

```text
Traffic Manager mental model teaching
manual Azure CLI build
direct regional endpoint validation
Geographic routing configuration
Australia/Pacific mapping failure and correction
DNS validation
HTTP validation
endpoint health failure/recovery exercise
Geographic-routing degraded-endpoint behavior test
DNS TTL authoritative-versus-recursive investigation
Azure Portal inspection
manual Azure teardown
independent clean-state verification
manual command-by-command documentation
required PNG visual-learning assets
```

Independent Azure clean-state proof:

```powershell
az group exists --name rg-az700-tm-global
```

returned:

```text
false
```

## Lab 02 actual architecture used

The source scenario intended to use App Service F1 endpoints, but East US App Service plan creation was blocked by this subscription's zero App Service VM quota.

No partial App Service plan remained.

The manual lab therefore used the following deliberate substitution:

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
FQDN: az700-tm-md-87004.trafficmanager.net
Routing: Geographic
Configured DNS TTL: 30 seconds
Health monitor: HTTP / port 80 / path /
```

## Critical Lab 02 lessons already proven

### Traffic Manager is DNS steering, not an inline proxy

```text
Client
  -> recursive DNS resolver
  -> Traffic Manager DNS decision
  -> DNS answer identifying/leading to selected endpoint
  -> client connects DIRECTLY to selected application endpoint
```

### Geographic routing is not proximity routing

An Australian query initially received no eligible endpoint when only `GEO-AS` was configured on Southeast Asia.

The design was corrected by adding `GEO-AP`.

```text
Geographic routing = explicit geography mapping
Performance routing = latency-oriented endpoint selection
```

### Geographic endpoint degradation does not imply cross-geography failover

During the failure exercise:

```text
ep-sea -> Degraded
```

A fresh DNS query for Australia/Pacific still returned Southeast Asia, and the HTTP connection timed out while the ACI endpoint was stopped.

Do not teach or document an invented Europe/North-America failover path for this Geographic design.

### DNS TTL has multiple layers

Observed:

```text
Traffic Manager configured TTL       30s
Traffic Manager authoritative CNAME  30s
AdGuard-presented CNAME              60s
ACI endpoint A record               300s
```

The recursive DNS layer can affect the effective TTL a client sees, and different records in the resolution chain have independent TTLs.

## Lab 02 documentation now committed

Manual documentation:

```text
labs/02-traffic-manager/manual-deployment/README.md
labs/02-traffic-manager/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

Required visual-learning PNGs:

```text
labs/02-traffic-manager/visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
labs/02-traffic-manager/visual-learning/Lab02-02-Geographic-Routing-Flow.png
labs/02-traffic-manager/visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
labs/02-traffic-manager/visual-learning/Lab02-04-Final-Lab-Architecture.png
```

These visuals reflect the actual ACI implementation and tested behavior.

## Lab 02 remaining work

```text
Terraform implementation
terraform fmt / validate / plan / apply
independent Azure CLI + DNS + HTTP validation
meaningful Terraform-built failure/recovery test
final no-change Terraform plan
Git/GitHub checkpoint
complete Lab 02 rebuild/practice PDF
Terraform destroy
Azure clean-state verification
Terraform state-empty verification
final learner explain-back
mark Lab 02 COMPLETE
```

## Rebaselined roadmap

```text
01  Azure Load Balancer                                        COMPLETE
02  Azure Traffic Manager                                     IN PROGRESS
03  IP Addressing, VNets, Subnets & Public IP Architecture    NOT STARTED
04  Azure DNS, Private DNS & DNS Private Resolver              NOT STARTED
05  VNet Peering, Gateway Transit & Virtual Network Manager    NOT STARTED
06  UDRs, Forced Tunnelling, NAT Gateway & NVA                 NOT STARTED
07  Azure Route Server & Dynamic Routing                       NOT STARTED
08  Network Watcher, Azure Monitor, Flow Logs, DDoS & Defender NOT STARTED
09  Site-to-Site VPN                                           NOT STARTED
10  Point-to-Site VPN                                          NOT STARTED
11  ExpressRoute Architecture & BGP                            NOT STARTED
12  Azure Virtual WAN                                          NOT STARTED
13  Application Gateway                                        NOT STARTED
14  Azure Front Door                                           NOT STARTED
15  Gateway Load Balancer & NVA Service Insertion              NOT STARTED
16  Private Endpoint, Private Link & Private DNS               NOT STARTED
17  Service Endpoints & Service Endpoint Policies              NOT STARTED
18  NSG, ASG & Azure Bastion                                   NOT STARTED
19  Azure Firewall & Firewall Manager                          NOT STARTED
20  Web Application Firewall                                   NOT STARTED
21  Network Troubleshooting Incident Lab                       NOT STARTED
22  AZ-700 Enterprise Capstone                                 NOT STARTED
```

## Coverage authority

The Microsoft AZ-700 skills outline effective July 27, 2026 is the programme coverage authority.

The KodeKloud repository remains a learning/scenario reference rather than the definition of completeness.

## Programme method for every practical lab

```text
1. Problem/use case
2. Teach mental model
3. Visual architecture and control/data flow
4. Learner understanding check
5. Manual Azure deployment
6. Azure CLI/protocol inspection and validation
7. Failure testing and troubleshooting
8. Portal inspection where useful
9. Manual teardown where appropriate
10. Terraform implementation
11. terraform fmt / validate / plan / apply
12. Independent Azure CLI/protocol validation
13. Failure/recovery validation against IaC build
14. final no-change plan
15. Git/GitHub checkpoint
16. rebuild/practice documentation
17. safe teardown and verification
18. learner explain-back
```

For design-heavy or impractical services, especially ExpressRoute, replace forced deployment with rigorous architecture, BGP/route reasoning, redundancy, validation planning and troubleshooting simulations.

## Non-negotiable working preferences

- Azure only.
- Maximum one lab per day.
- VS Code used throughout the programme.
- Azure CLI preferred for manual deployment, inspection and validation.
- Terraform follows understanding; it does not replace learning Azure.
- Teach concepts before testing comprehension.
- Explain important command and HCL syntax before execution.
- Work one meaningful action at a time during interactive labs.
- Interpret actual output before continuing.
- Use Azure Portal for inspection/troubleshooting, not as the sole deployment method.
- Create reusable PNG/JPEG visuals where they materially improve understanding.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behavior rather than hiding it.
- Never commit secrets, Terraform state, credentials, tokens, private keys or sensitive local tfvars.
- End practical labs with detailed rebuild/practice documentation sufficient to repeat the lab without chat history.

## Status consistency rule

The following must agree whenever a lab status changes:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
labs/<lab>/README.md
labs/<lab>/handoff/HANDOFF.md
```

Do not leave stale `NEXT`, `NOT STARTED`, `IN PROGRESS` or `COMPLETE` markers in conflicting files.
