# Lab 03 Handoff — IP Addressing, VNets, Subnets & Public IP Architecture

## Status

- **Lab:** 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **State:** IN PROGRESS
- **Previous lab:** Lab 02 — Azure Traffic Manager — COMPLETE
- **Current phase:** Terraform configuration AUTHORED; local rebase, init, validate, plan and apply are NEXT
- **Azure resources:** Manual resource group `rg-az700-ip-aue` deleted and independently verified absent
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do not repeat the manual build and do not rewrite the Terraform files by hand. The complete commented Terraform configuration is already committed under `terraform/`.

Next sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. enter labs/03-ip-addressing-vnets-subnets-public-ip/terraform
4. read/review the commented HCL as needed
5. terraform fmt -recursive
6. terraform init
7. terraform validate
8. terraform plan -out=lab03.tfplan
9. inspect the plan carefully
10. terraform apply lab03.tfplan
11. independently validate Terraform state and live Azure
12. run useful failure/recovery validation if required
13. final no-change terraform plan
14. capture docs/visual/PDF before final destroy
15. final Terraform destroy and post-destroy verification
```

## Terraform files now present

```text
terraform/versions.tf
terraform/providers.tf
terraform/variables.tf
terraform/main.tf
terraform/outputs.tf
terraform/terraform.tfvars.example
terraform/README.md
```

The configuration models the validated manual end-state:

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

Temporary invalid resources used for manual troubleshooting are intentionally excluded from desired state.

## Manual address plan

```text
VNet: vnet-az700-ip-aue
Address space: 10.30.0.0/16

Workload
10.30.10.0/26    snet-web
10.30.20.0/27    snet-app
10.30.30.0/27    snet-db
10.30.40.0/28    snet-management

Delegated
10.30.50.0/27    snet-postgres
                  Microsoft.DBforPostgreSQL/flexibleServers

Azure infrastructure
10.30.100.0/27   GatewaySubnet
10.30.101.0/26   AzureFirewallSubnet
10.30.102.0/26   AzureBastionSubnet
```

## Manual-phase proof retained

```text
Dynamic private IP: 10.30.10.4
Static private IP: 10.30.20.10
Regional Standard Public IP: 4.196.200.103
Zone-redundant Standard Public IP: 20.227.26.52
Zone-redundant Public IP Prefix: 4.237.111.112/30
Public IP allocated from prefix: 4.237.111.112
```

Intentional failures completed and post-failure absence verified:

```text
NetcfgSubnetRangesOverlap
PrivateIPAddressInReservedRange
PrivateIPAddressIsAllocated
PrivateIPAddressNotInSubnet
```

## Manual teardown evidence

```text
az group show --name rg-az700-ip-aue
-> ResourceGroupNotFound

az group exists --name rg-az700-ip-aue
-> false
```

Manual Azure environment is verified clean before Terraform deployment.

## Mental model retained

```text
VNet = address/container boundary
Subnet = functional/policy/routing boundary
Private IP = private network identity
Public IP = separate Internet-routable resource
Public IP Prefix = reserved contiguous public range

NSG = permission
Route = path

ordinary subnet != delegated subnet != special service subnet
```
