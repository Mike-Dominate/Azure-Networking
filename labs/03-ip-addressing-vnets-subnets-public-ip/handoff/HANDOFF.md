# Lab 03 Handoff — IP Addressing, VNets, Subnets & Public IP Architecture

## Status

- **Lab:** 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **State:** IN PROGRESS
- **Previous lab:** Lab 02 — Azure Traffic Manager — COMPLETE
- **Current phase:** Terraform rebuild and independent validation COMPLETE; documentation/visual/PDF closeout NEXT
- **Azure resources:** Terraform environment is currently LIVE in `rg-az700-ip-aue`; do not destroy before final evidence/documentation capture
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do not repeat the manual build or Terraform deployment. Both have been completed and validated.

Next sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. review validation/TERRAFORM-VALIDATION.md if context is needed
4. create visual-learning assets
5. create rebuild/practice documentation and PDF while Terraform resources still exist
6. capture any final live Azure evidence needed by the manual
7. final terraform destroy
8. independently verify az group exists --name rg-az700-ip-aue returns false
9. independently verify terraform state list is empty
10. update README/roadmap/handoffs to Lab 03 COMPLETE and Lab 04 next
11. learner explain-back / wrap
```

## Terraform checkpoint

Configuration and provider initialization are complete.

```text
AzureRM provider selected: 4.81.0
Provider constraint: ~> 4.0
.terraform.lock.hcl: committed and pushed
```

Plan:

```text
Plan: 16 to add, 0 to change, 0 to destroy.
```

Apply:

```text
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
```

Terraform state contained exactly 16 resources:

```text
1 Resource Group
1 Virtual Network
8 Subnets
2 Network Interfaces
3 Public IP Addresses
1 Public IP Prefix
```

Independent Azure CLI validation confirmed:

```text
7 top-level resources
8 VNet child subnets
snet-postgres delegated to Microsoft.DBforPostgreSQL/flexibleServers
nic-lab03-app-static = 10.30.20.10 / Static
nic-lab03-web-dynamic = 10.30.10.4 / Dynamic
web NIC PublicIP = null
```

Current Public IP values:

```text
pip-lab03-from-prefix-aue  20.11.118.4
pip-lab03-web-aue          4.196.170.206
pip-lab03-zr-aue           4.237.190.4
pipprefix-lab03-aue        20.11.118.4/30
```

Zone architecture independently validated:

```text
pip-lab03-web-aue          zones null
pip-lab03-zr-aue           zones 1,2,3
pip-lab03-from-prefix-aue  zones 1,2,3 + references pipprefix-lab03-aue
pipprefix-lab03-aue        zones 1,2,3 / Standard / Regional / Succeeded
```

Azure returned zone arrays in the order `2,3,1`; this represents the same zone set and is not drift.

Final Terraform convergence check:

```text
No changes. Your infrastructure matches the configuration.
```

Detailed evidence:

```text
validation/TERRAFORM-VALIDATION.md
```

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

The manual phase was completed before Terraform and intentionally included failure testing:

```text
NetcfgSubnetRangesOverlap
PrivateIPAddressInReservedRange
PrivateIPAddressIsAllocated
PrivateIPAddressNotInSubnet
```

Manual resources were destroyed only after evidence capture and independently verified absent:

```text
az group exists --name rg-az700-ip-aue
-> false
```

Terraform then recreated the architecture from code.

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

## Critical warning

The Terraform environment is live intentionally. Do not run `terraform destroy` until the rebuild/practice documentation, visuals and useful evidence have been captured and synchronized.
