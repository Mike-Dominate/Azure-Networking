# Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture

> **Status: IN PROGRESS**  
> Started: 2026-08-31  
> Current phase: Terraform rebuild and validation COMPLETE; documentation/visual/PDF closeout NEXT; Terraform environment remains live pending evidence capture

## Purpose

Build deliberate Azure address-space and subnet-design skill instead of treating VNets as incidental lab scaffolding.

This lab makes IP design decisions before deployment so later peering, VPN, ExpressRoute, Private Link, firewalls, application gateways and hybrid connectivity do not inherit avoidable address-space problems.

## Validated address plan

```text
VNet: vnet-az700-ip-aue
Address space: 10.30.0.0/16
Region: Australia East

Workload subnets
├── 10.30.10.0/26    snet-web
├── 10.30.20.0/27    snet-app
├── 10.30.30.0/27    snet-db
└── 10.30.40.0/28    snet-management

Delegated service subnet
└── 10.30.50.0/27    snet-postgres
    └── Microsoft.DBforPostgreSQL/flexibleServers

Azure infrastructure subnets
├── 10.30.100.0/27   GatewaySubnet
├── 10.30.101.0/26   AzureFirewallSubnet
└── 10.30.102.0/26   AzureBastionSubnet
```

Most of `10.30.0.0/16` remains deliberately unused for future expansion.

## Manual phase

Manual Azure CLI deployment, independent validation, deliberate failure testing and Portal inspection were completed first.

Intentional failures included:

```text
NetcfgSubnetRangesOverlap
PrivateIPAddressInReservedRange
PrivateIPAddressIsAllocated
PrivateIPAddressNotInSubnet
```

Each failed test was followed by a lookup proving the invalid resource had not been partially created.

The manual environment was then destroyed after evidence capture and independently verified clean:

```text
az group show --name rg-az700-ip-aue
-> ResourceGroupNotFound

az group exists --name rg-az700-ip-aue
-> false
```

## Terraform rebuild

Terraform configuration reproduces the validated manual end-state with 16 managed resources:

```text
1 Resource Group
1 Virtual Network
8 Subnets
2 Network Interfaces
3 Public IP Addresses
1 Public IP Prefix
```

Toolchain checkpoint:

```text
Terraform requirement: >= 1.6.0
AzureRM constraint:    ~> 4.0
AzureRM selected:      4.81.0
Lock file:             committed
```

Validation sequence completed:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out lab03.tfplan
terraform apply "lab03.tfplan"
terraform state list
independent Azure CLI validation
terraform plan
```

Saved plan result:

```text
Plan: 16 to add, 0 to change, 0 to destroy.
```

Apply result:

```text
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
```

Final convergence result:

```text
No changes. Your infrastructure matches the configuration.
```

## Current Terraform live values

These values are expected to differ from the earlier manual deployment because Public IP resources were destroyed and recreated.

```text
nic-lab03-web-dynamic
  private IP: 10.30.10.4
  allocation: Dynamic
  public IP association: null

nic-lab03-app-static
  private IP: 10.30.20.10
  allocation: Static

pip-lab03-web-aue
  IP: 4.196.170.206
  Standard / Regional / Static
  zones: null

pip-lab03-zr-aue
  IP: 4.237.190.4
  Standard / Regional / Static
  zones: 1,2,3

pipprefix-lab03-aue
  prefix: 20.11.118.4/30
  Standard / Regional
  zones: 1,2,3

pip-lab03-from-prefix-aue
  IP: 20.11.118.4
  allocated from pipprefix-lab03-aue
  zones: 1,2,3
```

Azure may return the zone array in a different order such as `2,3,1`; the order is not semantically important.

## Independent validation summary

```text
Terraform state:            16 resources
Azure top-level inventory:   7 resources
Azure VNet child subnets:    8 subnets
PostgreSQL delegation:       verified
Static NIC IP:               verified
Dynamic NIC IP:              verified
Public IP properties:        verified
Public IP Prefix:            verified
PIP-from-prefix relation:    verified
Web NIC public association:  null / detached
Final Terraform plan:        no changes
```

Detailed Terraform evidence lives in:

```text
validation/TERRAFORM-VALIDATION.md
```

## Core mental models retained

```text
VNet       = overall network/address boundary
Subnet     = functional IP + policy/routing boundary
Private IP = identity inside the private network
Public IP  = separate Internet-routable Azure resource

NSG   = permission
Route = path

Ordinary subnet != delegated subnet != special Azure service subnet
Needs Internet access != needs an individual Public IP
Unused VNet address space = future design flexibility
```

## Must cover / status

- [x] RFC1918 planning and overlap avoidance
- [x] IPv4 CIDR reasoning and usable address ranges
- [x] VNet address spaces and growth strategy
- [x] workload vs infrastructure subnets
- [x] Azure-reserved subnet addresses
- [x] Azure service-specific subnet requirements
- [x] subnet delegation
- [x] private IP allocation behaviour
- [x] Standard public IP addresses
- [x] Public IP Prefix
- [x] Custom IP Prefix/BYOIP concept explained
- [x] zonal and zone-redundant public IP considerations
- [x] manual Azure CLI deployment
- [x] independent CLI validation
- [x] deliberate failure/troubleshooting exercises
- [x] Portal inspection
- [x] manual environment teardown and independent clean verification
- [x] Terraform rebuild
- [x] independent Terraform/Azure validation
- [x] final no-change Terraform plan
- [ ] visual-learning assets
- [ ] rebuild/practice documentation and PDF
- [ ] final Terraform destroy
- [ ] post-destroy Azure + state verification
- [ ] learner explain-back

## Immediate next step

Do **not** destroy the Terraform environment yet.

```text
git pull --rebase
-> complete visual-learning and rebuild/practice documentation while Azure is live
-> capture final evidence
-> final Terraform destroy
-> verify az group exists = false
-> verify terraform state list is empty
-> update all status records to COMPLETE
-> learner explain-back
```
