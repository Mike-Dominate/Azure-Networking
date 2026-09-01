# Lab 03 Handoff — IP Addressing, VNets, Subnets & Public IP Architecture

## Status

- **Lab:** 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **State:** COMPLETE
- **Completed:** 2026-08-31 (Australia/Brisbane)
- **Previous lab:** Lab 02 — Azure Traffic Manager — COMPLETE
- **Next lab:** Lab 04 — Azure DNS, Private DNS & DNS Private Resolver — NOT STARTED
- **Azure resources:** NONE remaining
- **Terraform state:** EMPTY

## Final closeout proof

Terraform destroy:

```text
Destroy complete! Resources: 16 destroyed.
```

Independent Azure check:

```powershell
az group exists --name rg-az700-ip-aue
```

Observed:

```text
false
```

Terraform state check:

```powershell
terraform state list
```

Observed:

```text
<blank / no output>
```

Lab 03 is therefore fully torn down and safe to leave closed.

## Validated address plan

```text
VNet: vnet-az700-ip-aue
Address space: 10.30.0.0/16

10.30.10.0/26    snet-web
10.30.20.0/27    snet-app
10.30.30.0/27    snet-db
10.30.40.0/28    snet-management
10.30.50.0/27    snet-postgres
                  Microsoft.DBforPostgreSQL/flexibleServers
10.30.100.0/27   GatewaySubnet
10.30.101.0/26   AzureFirewallSubnet
10.30.102.0/26   AzureBastionSubnet
```

## Manual phase retained evidence

Completed before Terraform:

```text
Azure CLI build
independent subnet/resource validation
Portal validation
Public IP attach/detach proof
NetcfgSubnetRangesOverlap failure
PrivateIPAddressInReservedRange failure
PrivateIPAddressIsAllocated failure
PrivateIPAddressNotInSubnet failure
manual teardown and post-delete verification
```

## Terraform phase retained evidence

```text
AzureRM selected: 4.81.0
Plan: 16 to add, 0 to change, 0 to destroy
Apply: 16 added
State: 16 resources
Independent Azure validation: passed
Final plan: No changes
Destroy: 16 destroyed
Azure post-destroy: false
Terraform state post-destroy: empty
```

## Key retained mental model

```text
VNet = address/network boundary
Subnet = functional/policy/routing boundary
Private IP = private network identity
Public IP = separate Internet-routable resource
Public IP Prefix = contiguous public address range

NSG = permission
Route = path

ordinary subnet != delegated subnet != special Azure service subnet
needs Internet access != needs an individual Public IP
configuration + Terraform state + live Azure must agree
```

## Rebuild/reference files

```text
manual-deployment/DEPLOYMENT-WALKTHROUGH.md
troubleshooting/FAILURE-TESTS.md
validation/MANUAL-VALIDATION.md
validation/TERRAFORM-VALIDATION.md
validation/FINAL-CLOSEOUT.md
documentation/LAB03-REBUILD-GUIDE.md
terraform/
```

## Resume instruction

Do not reopen Lab 03 during normal programme progression.

When ready, start **Lab 04 — Azure DNS, Private DNS & DNS Private Resolver** with DNS mental models and topology design before resource creation.
