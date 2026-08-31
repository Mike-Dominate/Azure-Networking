# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Next lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Lab 03 state:** NOT STARTED
- **Overall progress:** 2 / 22 labs complete
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 02 during normal programme progression. At the next session:

```powershell
git pull --rebase
```

Then start Lab 03 by teaching and designing the address-space/subnet/IP mental model before creating Azure resources.

## Lab 02 completion checkpoint

Lab 02 completed the full engineering lifecycle:

```text
Traffic Manager mental model taught
manual Azure CLI build completed
App Service quota constraint diagnosed
architecture deliberately adapted to ACI
three regional HTTP endpoints validated
Geographic routing configured
GEO-AP omission discovered and corrected
DNS + HTTP behavior validated
endpoint health failure/recovery tested
TTL authoritative-versus-recursive behavior investigated
Azure Portal inspected
manual environment torn down and independently verified
Terraform rebuild completed
Terraform plan: 8 to add
Terraform apply: 8 added
Terraform state: 8 managed resources
Terraform environment independently validated with Azure CLI, DNS and HTTP
Terraform endpoint failure/recovery test completed
final Terraform plan: no changes
Terraform source committed and pushed
final Terraform destroy: 8 resources destroyed
rebuild/practice documentation completed
visual-learning closeout updated
```

Terraform implementation checkpoint:

```text
Commit: 7891fe65064620480e2e1125f062f6138b08d3f5
Message: Complete Lab 02 Terraform Traffic Manager rebuild
Terraform >= 1.6.0
AzureRM constraint ~> 4.0
Locked AzureRM 4.81.0
```

The final Terraform destroy explicitly reported:

```text
Destroy complete! Resources: 8 destroyed.
```

The final chat did not separately capture `az group exists` and an empty `terraform state list` after that Terraform destroy. Do not claim those two outputs were observed. The rebuild manual records them as required post-destroy checks for every repeat. The earlier manual-phase teardown was independently verified clean.

## Lab 02 mental model to retain

```text
Client
  -> recursive DNS resolver
  -> Traffic Manager routing + health decision
  -> DNS answer
  -> client connects DIRECTLY to selected regional endpoint
```

Traffic Manager performs global DNS steering; it is not an inline HTTP proxy.

```text
Geographic = explicit geography mapping
Performance = latency-oriented selection
```

Australia/Pacific required `GEO-AP`; `GEO-AS` alone did not cover the Australian test path.

In the lab's degraded-endpoint test, a fresh Google DNS query still returned the mapped Southeast Asia endpoint for Australia/Pacific and HTTP failed while that application was stopped. Treat this as **observed behavior in this lab**, not a universal cross-geography failover rule.

Manual ACI stop/start changed the Southeast Asia public IP; the Terraform-built stop/start retained it. This proves neither outcome should be assumed; use the ACI FQDN as the Traffic Manager target.

Observed DNS TTL layers:

```text
Configured Traffic Manager TTL       30s
Authoritative Traffic Manager CNAME  30s
AdGuard-presented CNAME              60s
ACI A record                         300s
```

## Lab 02 reusable artifacts

```text
labs/02-traffic-manager/README.md
labs/02-traffic-manager/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
labs/02-traffic-manager/terraform/
labs/02-traffic-manager/visual-learning/
labs/02-traffic-manager/documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.md
labs/02-traffic-manager/documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.pdf
labs/02-traffic-manager/handoff/HANDOFF.md
```

## Roadmap status

```text
01  Azure Load Balancer                                      COMPLETE
02  Azure Traffic Manager                                   COMPLETE
03  IP Addressing, VNets, Subnets & Public IP Architecture  NOT STARTED
04–22                                                       NOT STARTED
```

## Programme method

```text
Problem/use case
-> teach mental model
-> visual architecture / traffic flow
-> understanding check
-> manual Azure implementation
-> independent validation
-> failure/troubleshooting
-> Portal inspection where useful
-> Terraform rebuild
-> independent IaC validation
-> final no-change plan
-> Git/GitHub checkpoint
-> rebuild documentation
-> safe teardown
-> learner explain-back
```

## Status consistency rule

When a lab status changes, keep these aligned:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
labs/<lab>/README.md
labs/<lab>/handoff/HANDOFF.md
```