# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme. Read it before starting new lab work.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture
- **Current lab:** Lab 04 — Azure DNS, Private DNS & DNS Private Resolver
- **Lab 04 state:** IN PROGRESS
- **Current phase:** DNS mental model and topology design
- **Azure resources:** NONE CREATED YET
- **Overall progress:** 3 / 22 labs complete; Lab 04 in progress
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-31 (Australia/Brisbane)

## Immediate resume instruction

Do not repeat Lab 03. It is complete and fully torn down.

Lab 04 has formally started. Do not create Azure resources until the DNS mental model and lab topology are understood.

Resume sequence:

```text
1. git pull --rebase
2. verify git working tree clean
3. teach what DNS does and does not do
4. distinguish stub resolver, recursive resolver and authoritative DNS
5. walk a public DNS query end-to-end
6. explain Azure-provided DNS behaviour inside a VNet
7. cover Azure DNS public zones and record types
8. cover Azure Private DNS zones and VNet links
9. explain auto-registration behaviour
10. explain split-horizon/private-name-resolution patterns
11. teach Azure DNS Private Resolver architecture
12. distinguish inbound endpoint, outbound endpoint and DNS forwarding ruleset
13. design the Lab 04 topology before deployment
14. build manually with Azure CLI
15. independently validate DNS resolution
16. run failure/troubleshooting exercises
17. Terraform rebuild
18. documentation/evidence
19. safe teardown and independent clean verification
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
