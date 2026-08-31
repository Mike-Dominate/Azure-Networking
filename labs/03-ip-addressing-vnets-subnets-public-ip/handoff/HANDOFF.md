# Lab 03 Handoff — IP Addressing, VNets, Subnets & Public IP Architecture

## Status

- **Lab:** 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **State:** IN PROGRESS
- **Previous lab:** Lab 02 — Azure Traffic Manager — COMPLETE
- **Current phase:** Address-space, subnet and IP architecture mental model/design
- **Azure resources:** NONE created for Lab 03 yet
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do not start by creating a VNet.

Teach and reason through the address plan first.

Next sequence:

```text
1. IPv4/CIDR mental model
2. RFC1918 address-space selection and overlap avoidance
3. Azure VNet and subnet boundaries
4. Azure-reserved subnet addresses
5. subnet sizing and growth
6. workload vs infrastructure/service subnets
7. subnet delegation
8. private IP allocation
9. public IP architecture and Public IP Prefix
10. Custom IP Prefix/BYOIP concepts
11. final address plan
12. only then manual Azure CLI build
```

## Core engineering objective

The learner should stop treating a VNet as an arbitrary `/16` and subnets as arbitrary `/24`s.

The goal is to be able to explain:

```text
why this RFC1918 range was selected
why it will not overlap intended connected networks
why the VNet is this size
why each subnet is this size
what growth space is deliberately unused
which subnets are workload subnets
which subnets are reserved for Azure services/infrastructure
how Azure's reserved addresses affect usable capacity
how public and private IP identities differ
```

## Required lab coverage

- RFC1918 ranges and overlap avoidance
- CIDR prefix maths and subnet boundaries
- VNet address-space planning
- multi-address-space concepts where relevant
- subnet sizing
- Azure-reserved addresses in each subnet
- service-specific subnet naming/size constraints where relevant
- subnet delegation
- dynamic vs static private IP assignment concepts
- Standard public IP architecture
- Public IP Prefix
- Custom IP Prefix / BYOIP concepts
- zonal, zone-redundant/regional and global endpoint considerations
- Azure CLI validation
- troubleshooting deliberately bad address plans
- Terraform rebuild after manual understanding

## Working method

One meaningful action at a time during implementation:

```text
teach -> explain syntax -> run -> inspect output -> interpret -> continue
```

Full Terraform files may be written as complete files once the Azure design is understood.
