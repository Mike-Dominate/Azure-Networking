# Lab 02 Handoff — Azure Traffic Manager

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** COMPLETE
- **Completed:** 2026-08-30 (Australia/Brisbane)
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Next lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture — NOT STARTED

## Final completion record

Lab 02 completed the manual Azure and Terraform paths, including independent DNS/HTTP validation, failure/recovery testing, documentation, Git/GitHub and teardown.

```text
Traffic Manager mental model                     COMPLETE
Manual Azure CLI deployment                      COMPLETE
Regional endpoint validation                     COMPLETE
Geographic routing + GEO-AP troubleshooting      COMPLETE
DNS + HTTP validation                            COMPLETE
Endpoint failure/recovery                        COMPLETE
TTL investigation                                COMPLETE
Azure Portal inspection                          COMPLETE
Manual teardown + clean-state verification       COMPLETE
Terraform implementation                         COMPLETE
terraform validate / plan / apply                COMPLETE
Independent IaC validation                       COMPLETE
Terraform failure/recovery                       COMPLETE
Final no-change plan                             COMPLETE
Terraform Git checkpoint                         COMPLETE
Rebuild/practice documentation                   COMPLETE
Final Terraform destroy                          COMPLETE — 8 destroyed
```

The final Terraform teardown explicitly returned:

```text
Destroy complete! Resources: 8 destroyed.
```

For future repeats, still run these independent post-destroy checks:

```powershell
az group exists --name rg-az700-tm-global
terraform state list
```

The final chat did not separately capture those two outputs after the Terraform destroy, so this handoff does not invent them. The earlier manual teardown was independently verified clean.

## Actual architecture

The source scenario intended App Service F1 endpoints. App Service plan creation was blocked by the subscription's zero App Service compute quota, so the lab deliberately used three public Azure Container Instances registered as Traffic Manager External endpoints.

```text
North America      GEO-NA -> ep-eus -> East US ACI
Europe             GEO-EU -> ep-weu -> West Europe ACI
Asia               GEO-AS -> ep-sea -> Southeast Asia ACI
Australia/Pacific  GEO-AP -> ep-sea -> Southeast Asia ACI
```

Traffic Manager:

```text
Name: tm-az700-global
FQDN: az700-tm-md-87004.trafficmanager.net
Routing: Geographic
Configured DNS TTL: 30 seconds
Monitor: HTTP :80 /
Probe interval: 30 seconds
Tolerated failures: 3
Timeout: 10 seconds
```

## Core lessons retained

```text
Traffic Manager = global DNS steering, not an inline HTTP proxy.
Client -> resolver -> Traffic Manager DNS decision -> DNS answer -> direct endpoint connection.

Geographic routing = explicit geography mapping.
Performance routing = latency-oriented selection.

EndpointStatus = administrative participation.
EndpointMonitorStatus = Traffic Manager health observation.
```

An Australian lookup initially had no eligible endpoint while Southeast Asia was mapped only to `GEO-AS`; adding `GEO-AP` corrected the design.

When Southeast Asia was stopped, `ep-sea` eventually became Degraded while remaining administratively Enabled. A fresh Google DNS lookup still returned Southeast Asia for the Australia/Pacific mapping and HTTP failed. Record this as **observed behavior in this lab**, not as a universal Traffic Manager rule.

Manual stop/start changed the Southeast Asia ACI public IP; the Terraform-built stop/start retained it. Therefore neither outcome should be assumed. The Traffic Manager endpoint correctly targets the ACI FQDN.

Observed TTL layers:

```text
Traffic Manager configured TTL       30s
Traffic Manager authoritative CNAME  30s
AdGuard-presented CNAME              60s
ACI A record                         300s
```

## Terraform completion

```text
Terraform >= 1.6.0
AzureRM constraint ~> 4.0
Locked AzureRM 4.81.0
Plan: 8 to add, 0 change, 0 destroy
Apply: 8 added
State: 8 resources
Final recovery plan: No changes
Final destroy: 8 destroyed
```

Terraform implementation commit:

```text
7891fe65064620480e2e1125f062f6138b08d3f5
Complete Lab 02 Terraform Traffic Manager rebuild
```

## Reusable artifacts

```text
labs/02-traffic-manager/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
labs/02-traffic-manager/terraform/
labs/02-traffic-manager/visual-learning/
labs/02-traffic-manager/documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.md
labs/02-traffic-manager/documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.pdf
```

## Resume point

**Lab 02 is finished. Normal programme progression now starts Lab 03.**

At the next session, sync the repository first:

```powershell
git pull --rebase
```

Then start Lab 03 with IP-address and subnet planning before deployment.