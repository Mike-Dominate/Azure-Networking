# Lab 03 Handoff — IP Addressing, VNets, Subnets & Public IP Architecture

## Status

- **Lab:** 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **State:** IN PROGRESS
- **Previous lab:** Lab 02 — Azure Traffic Manager — COMPLETE
- **Current phase:** Manual Azure phase COMPLETE and independently torn down; Terraform rebuild NEXT
- **Azure resources:** Manual resource group `rg-az700-ip-aue` deleted and independently verified absent
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do not repeat the manual build.

Next sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. enter labs/03-ip-addressing-vnets-subnets-public-ip/terraform
4. create Terraform configuration for the validated design
5. terraform fmt
6. terraform init
7. terraform validate
8. terraform plan
9. terraform apply
10. independently validate Terraform state and live Azure
11. run useful failure/recovery validation
12. final no-change plan
13. capture docs/visual/PDF before final destroy
14. final Terraform destroy and post-destroy verification
```

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

## Manual resource inventory before teardown

```text
vnet-az700-ip-aue
nic-lab03-web-dynamic
nic-lab03-app-static
pip-lab03-web-aue
pip-lab03-zr-aue
pipprefix-lab03-aue
pip-lab03-from-prefix-aue
```

Total: 7 top-level resources plus 8 VNet child subnets.

## Key addressing evidence

```text
nic-lab03-web-dynamic
private IP: 10.30.10.4
allocation: Dynamic

nic-lab03-app-static
private IP: 10.30.20.10
allocation: Static

pip-lab03-web-aue
IP: 4.196.200.103
Standard / Regional / Static
zones: null

pip-lab03-zr-aue
IP: 20.227.26.52
Standard / Regional / Static
zones: 1,2,3

pipprefix-lab03-aue
4.237.111.112/30
zones: 1,2,3

pip-lab03-from-prefix-aue
4.237.111.112
allocated from pipprefix-lab03-aue
zones: 1,2,3
```

The Public IP `pip-lab03-web-aue` was associated with `nic-lab03-web-dynamic` and then detached. The NIC retained `10.30.10.4`; the Public IP resource remained `4.196.200.103`.

## Failure tests completed

```text
NetcfgSubnetRangesOverlap
10.30.10.32/27 overlapped snet-web 10.30.10.0/26
failed subnet absent afterward

PrivateIPAddressInReservedRange
10.30.30.1 rejected in snet-db
failed NIC absent afterward

PrivateIPAddressIsAllocated
second use of 10.30.20.10 rejected
failed NIC absent afterward

PrivateIPAddressNotInSubnet
10.30.21.10 rejected on snet-app 10.30.20.0/27
failed NIC absent afterward
```

## Portal checkpoint

Portal inspection confirmed all 8 subnets and the 7 top-level resources before teardown.

Useful observed counts:

```text
snet-web         58 available
snet-app         26 available
snet-db          27 available
snet-management  11 available
```

## Teardown evidence

Manual teardown was completed only after documentation/evidence was synchronized.

Observed independent checks:

```text
az group show --name rg-az700-ip-aue
-> ResourceGroupNotFound

az group exists --name rg-az700-ip-aue
-> false
```

Manual Azure environment is therefore verified clean.

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
