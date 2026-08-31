# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Current lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Lab 03 state:** IN PROGRESS
- **Current phase:** Manual phase COMPLETE; Terraform rebuild and independent validation COMPLETE; documentation/visual/PDF closeout NEXT
- **Azure state:** Terraform environment currently LIVE in `rg-az700-ip-aue` pending final evidence capture and destroy
- **Overall progress:** 2 / 22 labs complete; Lab 03 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03 design, manual deployment, Terraform deployment, or validation. Those phases are complete.

Resume sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. create Lab 03 visual-learning assets
4. create rebuild/practice documentation and PDF while Terraform resources are still live
5. capture any final evidence needed by the guide
6. terraform destroy
7. verify az group exists --name rg-az700-ip-aue returns false
8. verify terraform state list is empty
9. update README.md, docs/PROGRAMME-ROADMAP.md, docs/HANDOFF.md, Lab 03 README and Lab 03 handoff to COMPLETE
10. set Lab 04 as next
11. learner explain-back
```

## Lab 03 Terraform checkpoint

Terraform desired state:

```text
1 Resource Group
1 Virtual Network
8 Subnets
2 Network Interfaces
3 Public IP Addresses
1 Public IP Prefix
--------------------
16 managed resources
```

Toolchain:

```text
Terraform requirement: >= 1.6.0
AzureRM constraint:    ~> 4.0
AzureRM selected:      4.81.0
.terraform.lock.hcl:   committed and pushed
```

Deployment evidence:

```text
terraform validate
-> Success! The configuration is valid.

terraform plan -out lab03.tfplan
-> Plan: 16 to add, 0 to change, 0 to destroy.

terraform apply "lab03.tfplan"
-> Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

terraform state list
-> 16 resources

terraform plan
-> No changes. Your infrastructure matches the configuration.
```

Independent Azure validation confirmed:

```text
7 top-level resources
8 VNet child subnets
snet-postgres delegation correct
web NIC 10.30.10.4 / Dynamic
app NIC 10.30.20.10 / Static
web NIC PublicIP association = null
3 Public IP resources = Standard / Regional / Static
zone-redundant PIP = zones 1,2,3
Public IP Prefix = 20.11.118.4/30 / zones 1,2,3 / Succeeded
PIP 20.11.118.4 allocated from that prefix
```

Detailed evidence is recorded in:

```text
labs/03-ip-addressing-vnets-subnets-public-ip/validation/TERRAFORM-VALIDATION.md
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

Manual teardown was independently verified before Terraform recreated the environment:

```text
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

Do not destroy a live lab before capturing useful documentation and evidence. After each destroy, independently verify Azure clean and Terraform state empty before claiming teardown is complete.
