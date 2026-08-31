# Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture

> **Status: COMPLETE**  
> Started: 2026-08-31  
> Completed: 2026-08-31  
> Final state: Azure resources destroyed and Terraform state empty

## Purpose

Build deliberate Azure address-space and subnet-design skill instead of treating VNets as incidental lab scaffolding.

This lab made IP design decisions before deployment so later peering, VPN, ExpressRoute, Private Link, firewalls, application gateways and hybrid connectivity do not inherit avoidable address-space problems.

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

Most of `10.30.0.0/16` remained deliberately unused for future expansion.

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
az group exists --name rg-az700-ip-aue
-> false
```

## Terraform rebuild

Terraform reproduced the validated manual end-state with 16 managed resources:

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

Validated Terraform-run values included:

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

Public IP values are deployment-specific and are not expected to be identical on future rebuilds.

## Final teardown verification

The Terraform environment was destroyed after evidence and rebuild documentation were captured.

```text
terraform destroy
-> Destroy complete! Resources: 16 destroyed.

az group exists --name rg-az700-ip-aue
-> false

terraform state list
-> blank / empty
```

This proves both live Azure and Terraform state are clean.

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
Terraform configuration + state + live Azure must agree
```

## Deliverables

```text
manual-deployment/DEPLOYMENT-WALKTHROUGH.md
troubleshooting/FAILURE-TESTS.md
validation/MANUAL-VALIDATION.md
validation/TERRAFORM-VALIDATION.md
validation/FINAL-CLOSEOUT.md
documentation/LAB03-REBUILD-GUIDE.md
terraform/  (complete commented Terraform configuration + provider lock)
```

## Completion checklist

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
- [x] rebuild/practice documentation
- [x] final Terraform destroy
- [x] post-destroy Azure + state verification

## Next lab

**Lab 04 — Azure DNS, Private DNS & DNS Private Resolver — NOT STARTED.**
