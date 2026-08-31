# Lab 04 — Azure DNS, Private DNS & DNS Private Resolver

> **Status: IN PROGRESS**  
> Started: 2026-08-31 (Australia/Brisbane)  
> Current phase: DNS mental model and topology design  
> Azure resources: NONE CREATED YET

## Purpose

Build a practical DNS mental model for Azure networking before deploying DNS resources.

This lab will move from ordinary DNS resolution through Azure public DNS zones, Azure Private DNS zones, VNet links and auto-registration, then into hybrid name resolution with Azure DNS Private Resolver.

## Core learning questions

By the end of the lab, the learner should be able to explain:

- what DNS actually does and what it does not do
- authoritative DNS vs recursive DNS resolution
- public DNS zones vs private DNS zones
- why Azure VMs can resolve names without running their own DNS server
- how Azure-provided DNS fits into a VNet
- how a Private DNS zone becomes visible to a VNet through a virtual network link
- the difference between resolution links and auto-registration
- why private DNS can produce split-horizon behaviour
- why on-premises DNS cannot automatically query Azure Private DNS zones
- what Azure DNS Private Resolver solves
- inbound endpoints vs outbound endpoints
- DNS forwarding rulesets and forwarding rules
- how hybrid DNS traffic flows between Azure and on-premises networks
- where DNS failures occur and how to isolate them

## Lab 04 learning sequence

```text
1. DNS fundamentals and packet-level mental model
2. Authoritative vs recursive DNS
3. Public Azure DNS zones and record types
4. Azure-provided DNS behaviour
5. Azure Private DNS zones
6. Virtual network links
7. Auto-registration behaviour
8. Split-horizon/private-name-resolution patterns
9. Azure DNS Private Resolver architecture
10. Inbound endpoint
11. Outbound endpoint
12. DNS forwarding ruleset and rules
13. Design the lab topology
14. Manual Azure CLI deployment
15. Independent DNS validation
16. Failure/troubleshooting exercises
17. Portal inspection
18. Terraform rebuild
19. Independent IaC validation
20. Evidence/rebuild documentation
21. Safe teardown
22. Learner explain-back
```

## Planned implementation principles

- DNS design first; resources second.
- Use Azure CLI for the manual implementation.
- Validate resolution with DNS tools rather than trusting resource provisioning alone.
- Introduce deliberate DNS failures and prove the root cause.
- Rebuild the validated architecture with Terraform.
- Capture evidence before teardown.
- Independently verify both Azure cleanup and Terraform state cleanup before marking COMPLETE.

## Current checkpoint

No Azure resources have been created for Lab 04 yet.

Immediate next step:

```text
Teach the DNS mental model:
name -> resolver -> recursive lookup -> authoritative answer -> IP address
```
