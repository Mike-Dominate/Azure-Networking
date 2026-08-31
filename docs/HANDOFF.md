# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 02 — Azure Traffic Manager
- **Current lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Lab 03 state:** IN PROGRESS
- **Current phase:** Address-space, subnet and IP architecture mental model/design — no Azure resources yet
- **Overall progress:** 2 / 22 labs complete; Lab 03 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Start Lab 03 with design, not deployment.

Required sequence:

```text
1. Teach IPv4/CIDR and Azure address-space mental model
2. Design a deliberate RFC1918 VNet address plan
3. Design workload and infrastructure subnets with room for growth
4. Account for Azure-reserved subnet addresses and service-specific subnet constraints
5. Understand subnet delegation
6. Understand private IP allocation and public IP architecture
7. Cover Public IP Prefix and Custom IP Prefix/BYOIP concepts
8. Produce the final address plan before creating Azure resources
9. Build manually with Azure CLI
10. Validate Azure state and addressing independently
11. Perform troubleshooting/failure exercises
12. Rebuild with Terraform
13. Document and safely tear down
```

## Lab 02 completion checkpoint

Lab 02 — Azure Traffic Manager is COMPLETE. Do not repeat it during normal programme progression.

Key retained mental model:

```text
Traffic Manager = global DNS steering
Load Balancer   = regional Layer-4 data-path distribution
```

## Lab 03 engineering objective

Build deliberate Azure IP architecture skill instead of treating VNets and subnets as incidental scaffolding.

Must cover:

```text
RFC1918 planning and overlap avoidance
CIDR and usable address reasoning
VNet address spaces and growth strategy
workload vs infrastructure subnets
Azure-reserved subnet addresses
service-specific subnet requirements
subnet delegation
private IP allocation
public IP addresses and Public IP Prefix
Custom IP Prefix / BYOIP concepts
regional/zonal/global endpoint considerations
validation and troubleshooting
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
