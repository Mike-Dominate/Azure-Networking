# Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture

> **Status: IN PROGRESS**  
> Started: 2026-08-31  
> Current phase: Address-space, subnet and IP architecture design — no Azure resources yet

## Purpose

Build deliberate Azure address-space and subnet-design skill instead of treating VNets as incidental lab scaffolding.

This lab is about making IP design decisions before deployment so later peering, VPN, ExpressRoute, Private Link, firewalls, application gateways and hybrid connectivity do not inherit avoidable address-space problems.

## Must cover

- RFC1918 planning and overlap avoidance
- IPv4 CIDR reasoning and usable address ranges
- VNet address spaces and growth strategy
- workload vs infrastructure subnets
- Azure-reserved subnet addresses
- Azure service-specific subnet requirements
- subnet delegation
- private IP allocation behaviour
- public IP addresses and Public IP Prefix
- Custom IP Prefix/BYOIP concepts
- zonal/regional/global public endpoint considerations
- design trade-offs, validation and troubleshooting

## Engineering requirement

Produce an address plan **before deployment**, then build and validate it manually before Terraform.

Required learning sequence:

```text
problem/use case
-> IPv4/CIDR mental model
-> Azure VNet/subnet mental model
-> design address plan
-> review growth and overlap risks
-> manual Azure CLI deployment
-> independent validation
-> failure/troubleshooting
-> Terraform rebuild
-> independent IaC validation
-> rebuild documentation
-> teardown
-> explain-back
```

## First design rule

A VNet CIDR is not merely a large bag of addresses. It is an architectural boundary from which subnet ranges are carved.

The address plan must leave deliberate room for:

```text
current workloads
future workloads
Azure infrastructure subnets
service-specific subnet requirements
future connectivity to other VNets/on-premises networks
```

Do not create Azure resources until the initial address plan has been reasoned through.
