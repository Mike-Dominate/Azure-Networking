# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Current lab:** Lab 04 — Azure DNS, Private DNS & DNS Private Resolver
- **Lab 04 state:** IN PROGRESS
- **Current phase:** Tutorial / mental model
- **Deployment phase:** NOT STARTED
- **Overall progress:** 3 / 22 labs complete; Lab 04 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-09-01 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03. It is complete and fully torn down.

Lab 04 has formally started, but the deployment phase must not begin until the complete Lab 04 tutorial is finished.

Use the original Lab 04 scope only:

```text
1. Azure public DNS zones
2. private DNS zones
3. VNet links and auto-registration concepts
4. custom DNS settings on VNets
5. Azure DNS Private Resolver
6. inbound and outbound endpoints
7. forwarding rulesets
8. hybrid/on-premises name resolution
9. DNS troubleshooting and packet/query flow
```

Supporting DNS fundamentals may be taught only where they directly support these nine topics; they are not additional Lab 04 scope items.

## Lab 04 tutorial progress

Already covered interactively with DNS queries:

- recursive resolver versus authoritative DNS
- public DNS hierarchy and delegation concepts
- NS, CNAME, MX and SOA records
- common DNS record types: A, AAAA, CNAME, MX, TXT, NS, SOA and PTR
- Microsoft public DNS authority on Azure DNS
- Microsoft-to-Akamai CNAME/authority handoff

Resume the tutorial at the first official topic: **Azure public DNS zones**.

## Programme method

```text
complete tutorial / mental model
-> visual architecture / traffic or query flow
-> understanding check
-> design the lab
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

## Lab 04 engineering rule

Provisioning state `Succeeded` does not prove DNS is functioning. Actual DNS queries must validate resolution behaviour, returned records and the intended query path.

## Lab 03 completion checkpoint

Lab 03 is COMPLETE.

```text
Manual Azure build and validation         COMPLETE
Failure testing                           COMPLETE
Terraform rebuild                         COMPLETE
Final Terraform convergence               NO CHANGES
terraform destroy                         16 destroyed
post-destroy az group exists              false
post-destroy terraform state list         empty
```

## Roadmap status

```text
01  Azure Load Balancer                                      COMPLETE
02  Azure Traffic Manager                                   COMPLETE
03  IP Addressing, VNets, Subnets & Public IP Architecture  COMPLETE
04  Azure DNS, Private DNS & DNS Private Resolver            IN PROGRESS
05–22                                                       NOT STARTED
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
