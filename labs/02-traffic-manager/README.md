# Lab 02 — Azure Traffic Manager

> **Status: COMPLETE**  
> Completed: 2026-08-30  
> Next: Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture

## Purpose

Lab 02 builds a practical mental model of Azure Traffic Manager and proves that it is a **global DNS traffic-steering service**, not an inline HTTP proxy.

The source curriculum used regional App Service endpoints. The subscription encountered a real App Service compute-quota constraint, so the networking objective was preserved by using three public Azure Container Instances (ACI) registered as Traffic Manager External endpoints.

## Final validated architecture

```text
                        Azure Traffic Manager
                         tm-az700-global
                 Geographic DNS routing / TTL 30s
                               |
          +--------------------+--------------------+
          |                    |                    |
       GEO-NA               GEO-EU          GEO-AS + GEO-AP
          |                    |                    |
       ep-eus               ep-weu               ep-sea
          |                    |                    |
      East US ACI        West Europe ACI     Southeast Asia ACI
```

Profile:

```text
FQDN: az700-tm-md-87004.trafficmanager.net
Routing: Geographic
Monitor: HTTP / port 80 / path /
Probe interval: 30s
Tolerated failures: 3
Timeout: 10s
```

## Core mental model

```text
Client
  -> recursive DNS resolver
  -> Traffic Manager profile
  -> routing method + endpoint-health decision
  -> DNS answer
  -> client connects DIRECTLY to the selected regional endpoint
```

Traffic Manager is not crossed by the final HTTP connection. This differs from Lab 01 Azure Load Balancer, which is a regional Layer-4 service in the traffic path.

## Major lessons proven

### Geographic does not mean nearest

The first design mapped Southeast Asia only to `GEO-AS`. An Australian lookup did not receive an eligible endpoint because Australia/Pacific belongs to `GEO-AP`. Adding `GEO-AP` fixed the design.

```text
Geographic = explicit geography mapping
Performance = latency-oriented endpoint selection
```

### Resolver geography matters

The recursive DNS layer is part of the Geographic-routing mental model; the resolver/query geography can influence which mapping Traffic Manager evaluates.

### Administrative status and monitor status differ

```text
EndpointStatus        = administrative participation
EndpointMonitorStatus = Traffic Manager health observation
```

When the Southeast Asia ACI was stopped, `ep-sea` remained Enabled but eventually became Degraded. Health detection lagged application failure because probes run on an interval and tolerate configured failures.

### Observed Geographic failure behavior

During the lab, a fresh Google DNS query still returned Southeast Asia for the Australia/Pacific mapping while `ep-sea` was Degraded, and HTTP timed out because the application was stopped.

This is an **observed result in this lab**, not a universal rule for every Traffic Manager design.

### FQDN is the correct endpoint identity

The manual stop/start changed the Southeast Asia ACI public IP; the Terraform-built stop/start retained it. Stop/start therefore guarantees neither persistence nor change. Traffic Manager targets the ACI FQDN rather than a previously observed IP.

### DNS TTL has multiple layers

Observed:

```text
Traffic Manager configured TTL       30s
Traffic Manager authoritative CNAME  30s
AdGuard-presented CNAME              60s
ACI A-record TTL                     300s
```

Traffic Manager was configured with a 30-second DNS TTL and its authoritative DNS returned 30 seconds. The AdGuard recursive resolver used by the workstation returned the record with a 60-second TTL, demonstrating that recursive DNS behaviour can affect the effective caching period seen by clients.

## Terraform rebuild

Provider baseline deliberately matches Lab 01:

```text
Terraform >= 1.6.0
AzureRM ~> 4.0
Locked AzureRM 4.81.0
```

Terraform managed exactly eight resources:

```text
1 resource group
3 Azure Container Groups
1 Traffic Manager profile
3 Traffic Manager External endpoints
```

Verified lifecycle:

```text
terraform validate -> success
terraform plan     -> 8 to add, 0 change, 0 destroy
terraform apply    -> 8 added
state list         -> 8 resources
Azure CLI          -> regional ACI inventory matched
Australian DNS     -> Southeast Asia selected via GEO-AP
HTTP through TM    -> success
failure injection  -> SEA stopped, HTTP failed, ep-sea later Degraded
recovery           -> HTTP restored
final plan         -> No changes
code commit        -> 7891fe65064620480e2e1125f062f6138b08d3f5
terraform destroy  -> 8 destroyed
```

## Documentation and visual learning

Manual CLI walkthrough:

```text
manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

Terraform implementation:

```text
terraform/
```

Visual set:

```text
visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
visual-learning/Lab02-02-Geographic-Routing-Flow.png
visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
visual-learning/Lab02-04-Final-Lab-Architecture.png
visual-learning/Lab02-05-Engineering-Validation-and-Closeout.png
```

Complete rebuild/practice manual:

```text
documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.md
documentation/Lab02-Traffic-Manager-Rebuild-Practice-Manual.pdf
```

Continuation record:

```text
handoff/HANDOFF.md
```

## Final teardown

The final Terraform-managed environment returned:

```text
Destroy complete! Resources: 8 destroyed.
```

For every future rebuild, independently verify cleanup after destroy:

```powershell
az group exists --name rg-az700-tm-global
terraform state list
```

The final chat did not separately capture those two outputs after the Terraform destroy, so they are not claimed as observed final evidence here.

## Completion outcome

Lab 02 is complete at conceptual, architectural, implementation and operational levels: real quota troubleshooting, DNS/geography debugging, endpoint-health behavior, Terraform convergence, Git/GitHub and teardown were all exercised. Normal programme progression now moves to Lab 03.