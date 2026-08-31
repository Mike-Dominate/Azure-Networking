# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Current lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Lab 03 state:** IN PROGRESS
- **Current phase:** Manual phase COMPLETE and verified clean; full Terraform configuration AUTHORED; local init/validate/plan/apply NEXT
- **Overall progress:** 2 / 22 labs complete; Lab 03 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03 design or manual deployment. Do not rewrite the Terraform configuration by hand; it is already committed.

Resume sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. enter labs/03-ip-addressing-vnets-subnets-public-ip/terraform
4. terraform fmt -recursive
5. terraform init
6. terraform validate
7. terraform plan -out=lab03.tfplan
8. inspect plan
9. terraform apply lab03.tfplan
10. independently validate Terraform state/live Azure
11. produce final no-change plan
12. complete documentation/visual/PDF closeout before final Terraform destroy
13. destroy and verify Azure false + Terraform state empty
```

## Lab 03 Terraform checkpoint

Committed Terraform files:

```text
terraform/versions.tf
terraform/providers.tf
terraform/variables.tf
terraform/main.tf
terraform/outputs.tf
terraform/terraform.tfvars.example
terraform/README.md
```

The desired state contains:

```text
1 Resource Group
1 Virtual Network
8 Subnets
2 Network Interfaces
3 Public IP Addresses
1 Public IP Prefix
--------------------
16 Terraform resources
```

## Lab 03 validated address plan

```text
VNet: vnet-az700-ip-aue
Address space: 10.30.0.0/16

10.30.10.0/26    snet-web
10.30.20.0/27    snet-app
10.30.30.0/27    snet-db
10.30.40.0/28    snet-management
10.30.50.0/27    snet-postgres (delegated to Microsoft.DBforPostgreSQL/flexibleServers)
10.30.100.0/27   GatewaySubnet
10.30.101.0/26   AzureFirewallSubnet
10.30.102.0/26   AzureBastionSubnet
```

Manual teardown was independently verified before Terraform work:

```text
az group show --name rg-az700-ip-aue
-> ResourceGroupNotFound

az group exists --name rg-az700-ip-aue
-> false
```

## Lab 02 completion checkpoint

Lab 02 — Azure Traffic Manager is COMPLETE. Do not repeat it during normal programme progression.

Key retained mental model:

```text
Traffic Manager = global DNS steering
Load Balancer   = regional Layer-4 data-path distribution
```

## Roadmap status

```text
01  Azure Load Balancer                                      COMPLETE
02  Azure Traffic Manager                                   COMPLETE
03  IP Addressing, VNets, Subnets & Public IP Architecture  IN PROGRESS
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

## Teardown evidence rule

Do not destroy a live lab before capturing useful documentation and evidence. After each destroy, independently verify Azure clean before claiming teardown is complete.
