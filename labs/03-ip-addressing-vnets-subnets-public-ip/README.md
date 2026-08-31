# Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture

> **Status: IN PROGRESS**  
> Started: 2026-08-31  
> Current phase: Manual Azure phase COMPLETE and independently torn down; Terraform rebuild is NEXT

## Purpose

Build deliberate Azure address-space and subnet-design skill instead of treating VNets as incidental lab scaffolding.

This lab makes IP design decisions before deployment so later peering, VPN, ExpressRoute, Private Link, firewalls, application gateways and hybrid connectivity do not inherit avoidable address-space problems.

## Final manual-phase address plan

```text
VNet: vnet-az700-ip-aue
Address space: 10.30.0.0/16
Region: Australia East

Workload subnets
├── 10.30.10.0/26    snet-web          59 usable before consumption
├── 10.30.20.0/27    snet-app          27 usable before consumption
├── 10.30.30.0/27    snet-db           27 usable
└── 10.30.40.0/28    snet-management   11 usable

Delegated service subnet
└── 10.30.50.0/27    snet-postgres
    └── Microsoft.DBforPostgreSQL/flexibleServers

Reserved Azure infrastructure subnets
├── 10.30.100.0/27   GatewaySubnet
├── 10.30.101.0/26   AzureFirewallSubnet
└── 10.30.102.0/26   AzureBastionSubnet
```

The design intentionally leaves most of `10.30.0.0/16` unused for future expansion. Unused address space is planned capacity, not waste.

## Manual Azure resource checkpoint

The manual build used resource group:

```text
rg-az700-ip-aue
```

Top-level resources validated before teardown:

```text
vnet-az700-ip-aue              Microsoft.Network/virtualNetworks
nic-lab03-web-dynamic          Microsoft.Network/networkInterfaces
nic-lab03-app-static           Microsoft.Network/networkInterfaces
pip-lab03-web-aue              Microsoft.Network/publicIPAddresses
pip-lab03-zr-aue               Microsoft.Network/publicIPAddresses
pipprefix-lab03-aue            Microsoft.Network/publicIPPrefixes
pip-lab03-from-prefix-aue      Microsoft.Network/publicIPAddresses
```

Total top-level resources: **7**. The eight subnets were child resources of the VNet.

## Private IP proofs

```text
nic-lab03-web-dynamic
├── subnet: snet-web
├── private IP: 10.30.10.4
└── allocation: Dynamic

nic-lab03-app-static
├── subnet: snet-app
├── private IP: 10.30.20.10
└── allocation: Static
```

The dynamic NIC received `10.30.10.4`, demonstrating that Azure reserves the first four addresses in the subnet before normal resource assignment.

## Public IP proofs

```text
pip-lab03-web-aue
├── IP: 4.196.200.103
├── SKU: Standard
├── tier: Regional
├── allocation: Static
└── zones: null

pip-lab03-zr-aue
├── IP: 20.227.26.52
├── SKU: Standard
├── tier: Regional
├── allocation: Static
└── zones: 1, 2, 3

pipprefix-lab03-aue
├── prefix: 4.237.111.112/30
├── SKU: Standard
├── tier: Regional
└── zones: 1, 2, 3

pip-lab03-from-prefix-aue
├── IP: 4.237.111.112
├── source prefix: pipprefix-lab03-aue
├── allocation: Static
└── zones: 1, 2, 3
```

`pip-lab03-web-aue` was temporarily associated with `nic-lab03-web-dynamic` and then detached. The NIC retained private IP `10.30.10.4`, while the standalone Public IP resource remained `4.196.200.103`. This proves that private NIC addressing and Public IP resource lifecycles are separate.

## Failure tests completed

```text
NetcfgSubnetRangesOverlap
Attempt: 10.30.10.32/27 overlapping existing snet-web 10.30.10.0/26
Result: rejected; snet-overlap-test absent afterward

PrivateIPAddressInReservedRange
Attempt: NIC private IP 10.30.30.1 in snet-db 10.30.30.0/27
Result: rejected; test NIC returned ResourceNotFound afterward

PrivateIPAddressIsAllocated
Attempt: second NIC using existing 10.30.20.10
Result: rejected; test NIC returned ResourceNotFound afterward

PrivateIPAddressNotInSubnet
Attempt: 10.30.21.10 on snet-app 10.30.20.0/27
Result: rejected; test NIC returned ResourceNotFound afterward
```

Troubleshooting checklist reinforced by these tests:

```text
1. Is the address inside the correct subnet?
2. Is the subnet CIDR valid and non-overlapping?
3. Is the requested address Azure-reserved?
4. Is the requested address already allocated?
```

## Portal validation

Portal inspection confirmed all eight subnets and seven top-level resources before teardown.

Observed available-address counts included:

```text
snet-web         58 available  (59 usable originally; one NIC consumed an IP)
snet-app         26 available  (27 usable originally; one NIC consumed an IP)
snet-db          27 available  (failed test NICs consumed nothing)
snet-management  11 available  (unused)
```

The Portal also visibly showed the PostgreSQL delegation on `snet-postgres`, while the special Azure service subnets remained non-delegated.

## Manual teardown verification

The manual resource group was deleted after documentation and evidence capture.

Independent post-delete checks observed:

```text
az group show --name rg-az700-ip-aue
-> ResourceGroupNotFound

az group exists --name rg-az700-ip-aue
-> false
```

Therefore the manual Azure environment is independently verified clean.

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
- [ ] Terraform rebuild
- [ ] independent Terraform validation/failure testing
- [ ] visual-learning assets
- [ ] rebuild/practice documentation and PDF
- [ ] final teardown and explain-back

## Immediate next step

```text
git pull --rebase
-> verify working tree clean
-> enter labs/03-ip-addressing-vnets-subnets-public-ip/terraform
-> build the validated architecture in Terraform
-> terraform fmt / init / validate / plan / apply
-> independently validate state and live Azure
```
