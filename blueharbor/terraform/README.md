# BlueHarbor Cumulative Terraform Stack

This directory is the **single authoritative Terraform root** for the entire BlueHarbor AZ-700 engineering project.

## Core rule

Every applicable Microsoft Learn unit extends the Terraform code and state produced by the previous unit.

```text
first persistent practical
    Terraform baseline
          |
          + next requirement
          v
next practical
    same code + same state + new resources/config
          |
          v
Module 8
    complete BlueHarbor environment
```

There are no independent per-lab Terraform roots.

## When Terraform actually starts

Module 1 Units 01–03 are teaching/design chapters and do not require a persistent BlueHarbor deployment.

The first persistent infrastructure checkpoint is:

```text
Module 1
Unit 04 — Exercise: Design and implement a virtual network in Azure
```

Immediately before/within that first practical, establish the one project state backend and then build the canonical network foundation.

## One-state remote-backend contract

Canonical state resources:

```text
rg-bhi-tfstate-aue
stbhitfstate<global_suffix>
container: tfstate
key: blueharbor.tfstate
```

Use the AzureRM backend with Microsoft Entra ID/Azure CLI-compatible authentication. Do not commit Storage keys, SAS tokens or client secrets.

Bootstrap sequence:

```text
1. begin this same root with temporary local state
2. Terraform creates the backend resource group/storage/container
3. configure the azurerm backend
4. terraform init -migrate-state
5. verify state exists in Azure Blob
6. continue from that exact remote state through M1-M8
```

This is a **state migration**, not a new state lineage.

Protect state infrastructure from accidental destruction and enable appropriate Storage recovery/versioning controls when implemented.

## Global uniqueness contract

Choose once before the first deployment:

```text
global_suffix = six lowercase alphanumeric characters
```

Do not change it casually. It becomes part of globally unique Azure names that would otherwise collide.

Examples:

```text
stbhitfstate<suffix>
stbhimfgarchive<suffix>
stbhiflowaue<suffix>
stbhiflowsea<suffix>
```

Use the suffix only where global uniqueness requires it. Keep normal resource names readable.

## Local configuration and Git

Real local values are ignored:

```text
*.tfvars
*.tfvars.json
backend.hcl
*.backend.hcl
```

Safe examples may be committed. `.terraform.lock.hcl` remains tracked.

State files and plans are never committed.

## What we do NOT do

Do not:

- create independent `lab01/terraform`, `lab02/terraform`, etc.;
- copy the complete previous Terraform root into the next unit;
- start a fresh state file because a module changes;
- routinely destroy the environment after a unit;
- create persistent Azure resources manually and leave Terraform unaware;
- use state deletion to hide drift;
- accept unexpected destruction/replacement in a plan.

## Standard practical workflow

```text
1. inspect current code/state/environment
2. identify the new BlueHarbor requirement
3. modify this Terraform root only
4. terraform fmt -recursive
5. terraform init
6. terraform validate
7. terraform plan
8. read plan as architecture delta
9. STOP on unexpected destroy/replace
10. terraform apply
11. independently validate Azure behaviour
12. run the failure/troubleshooting exercise
13. encode permanent infrastructure fixes here
14. re-plan / re-apply / re-validate
15. Git checkpoint
16. carry this exact state into the next unit
```

## Special-purpose subnet guardrail

Do not build generic loops that attach NSGs, UDRs or NAT Gateways to every subnet.

Later subnets have special service requirements, including:

```text
GatewaySubnet
DNS Private Resolver endpoint subnets
Application Gateway subnets
Private Endpoint subnets
App Service VNet Integration subnet
Private Link Service NAT subnet
Application Gateway Private Link subnets
```

Each is configured only when its story requirement is reached.

## Terraform ownership boundaries

Terraform owns persistent BlueHarbor infrastructure/configuration.

CLI/Portal/protocol tools inspect, validate and troubleshoot.

Later exceptions include:

```text
Azure-auto-created Network Watcher
 -> discover/reconcile/import/reference instead of duplicate

Traffic Analytics NWTA* internals
 -> Azure service-managed

provider-side ExpressRoute dependencies
 -> model/document honestly when external
```

## Expected file growth

Files appear only when their story requirement is introduced. A likely final shape is:

```text
versions.tf
providers.tf
variables.tf
locals.tf
network.tf
dns.tf
peering.tf
routing.tf
nat.tf
hybrid.tf
expressroute.tf
load-balancing.tf
application-delivery.tf
security.tf
private-access.tf
monitoring.tf
outputs.tf
```

Do not pre-create empty files merely to match this list.

## Final planning authority

Read [`../../docs/WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md`](../../docs/WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md) before making a change whose naming, addressing, subnet policy or lifecycle is unclear.
