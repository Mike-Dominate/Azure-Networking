# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Current lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Lab 03 state:** IN PROGRESS
- **Current phase:** Manual Azure CLI build, validation, failure testing and Portal inspection COMPLETE; manual environment remains live pending teardown
- **Overall progress:** 2 / 22 labs complete; Lab 03 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03 design or manual deployment. The manual architecture is already built and validated.

Resume sequence:

```text
1. git pull --rebase
2. inspect Lab 03 README and handoff updates
3. verify git working tree clean
4. destroy manual resource group rg-az700-ip-aue
5. independently verify Azure clean
6. start Terraform rebuild of the validated architecture
7. independently validate Terraform state/live Azure
8. perform failure/recovery validation where useful
9. produce final no-change plan
10. complete documentation/visual/PDF closeout before final Terraform destroy
```

## Lab 03 manual checkpoint

Validated address plan:

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

Top-level manual Azure resources validated in `rg-az700-ip-aue`:

```text
vnet-az700-ip-aue
nic-lab03-web-dynamic
nic-lab03-app-static
pip-lab03-web-aue
pip-lab03-zr-aue
pipprefix-lab03-aue
pip-lab03-from-prefix-aue
```

Key manual proofs:

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

Portal inspection confirmed all 8 subnets, the PostgreSQL delegation, expected available-IP counts, and the 7 top-level resources.

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
