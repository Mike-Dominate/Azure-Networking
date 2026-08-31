# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Current lab:** None active
- **Next lab:** Lab 04 — Azure DNS, Private DNS & DNS Private Resolver
- **Lab 04 state:** NOT STARTED
- **Overall progress:** 3 / 22 labs complete
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03. It is complete and fully torn down.

When the learner formally starts Lab 04, begin with the DNS mental model and design before creating resources.

Recommended Lab 04 opening sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. mark Lab 04 IN PROGRESS across authoritative status records
4. teach authoritative vs recursive DNS and Azure-provided DNS behaviour
5. cover public Azure DNS zones and record types
6. cover Private DNS zones and VNet links
7. cover auto-registration behaviour
8. cover split-horizon/private-name-resolution patterns
9. teach Azure DNS Private Resolver architecture
10. design the lab topology before deployment
11. build manually with Azure CLI
12. independently validate DNS resolution
13. failure/troubleshooting exercises
14. Terraform rebuild
15. documentation/evidence
16. safe teardown and independent clean verification
```

## Lab 03 completion checkpoint

Lab 03 is **COMPLETE**.

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

Manual phase completed:

```text
Azure CLI deployment                  COMPLETE
independent Azure validation          COMPLETE
failure testing                       COMPLETE
Portal inspection                     COMPLETE
manual teardown                       COMPLETE
manual post-delete az group exists    false
```

Terraform phase completed:

```text
AzureRM provider selected             4.81.0
terraform validate                    SUCCESS
saved plan                            16 add / 0 change / 0 destroy
terraform apply                       16 added
Terraform state validation            16 resources
independent Azure validation          PASSED
final terraform plan                  NO CHANGES
terraform destroy                     16 destroyed
post-destroy az group exists          false
post-destroy terraform state list     empty
```

Key retained mental models:

```text
VNet       = address/network boundary
Subnet     = functional IP/policy/routing boundary
Private IP = private network identity
Public IP  = separate Internet-routable resource
Public IP Prefix = contiguous public address block

NSG   = permission
Route = path

ordinary subnet != delegated subnet != Azure service-specific subnet
needs Internet access != needs an individual Public IP
configuration + Terraform state + live Azure must agree
```

Lab 03 evidence/reference files include:

```text
labs/03-ip-addressing-vnets-subnets-public-ip/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
labs/03-ip-addressing-vnets-subnets-public-ip/troubleshooting/FAILURE-TESTS.md
labs/03-ip-addressing-vnets-subnets-public-ip/validation/MANUAL-VALIDATION.md
labs/03-ip-addressing-vnets-subnets-public-ip/validation/TERRAFORM-VALIDATION.md
labs/03-ip-addressing-vnets-subnets-public-ip/validation/FINAL-CLOSEOUT.md
labs/03-ip-addressing-vnets-subnets-public-ip/documentation/LAB03-REBUILD-GUIDE.md
labs/03-ip-addressing-vnets-subnets-public-ip/terraform/
```

## Roadmap status

```text
01  Azure Load Balancer                                      COMPLETE
02  Azure Traffic Manager                                   COMPLETE
03  IP Addressing, VNets, Subnets & Public IP Architecture  COMPLETE
04  Azure DNS, Private DNS & DNS Private Resolver            NOT STARTED
05–22                                                       NOT STARTED
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
