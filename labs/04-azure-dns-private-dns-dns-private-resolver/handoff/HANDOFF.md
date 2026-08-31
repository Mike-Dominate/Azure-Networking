# Lab 04 Handoff — Azure DNS, Private DNS & DNS Private Resolver

## Status

- **Lab:** 04 — Azure DNS, Private DNS & DNS Private Resolver
- **State:** IN PROGRESS
- **Previous lab:** Lab 03 — COMPLETE
- **Current phase:** DNS mental model and topology design
- **Azure resources:** NONE CREATED YET
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do not create Azure resources before the DNS mental model is understood.

Resume sequence:

```text
1. explain what DNS does: names -> IP addresses
2. distinguish stub resolver, recursive resolver and authoritative DNS
3. walk a public DNS lookup end-to-end
4. explain Azure-provided DNS inside a VNet
5. introduce Azure DNS public zones
6. introduce Azure Private DNS zones and VNet links
7. explain auto-registration
8. explain split-horizon DNS
9. introduce Azure DNS Private Resolver
10. distinguish inbound endpoint, outbound endpoint and ruleset
11. design Lab 04 topology before deployment
```

## Scope to prove practically

The lab should validate, where practical:

- Azure DNS public zone/record behaviour
- Private DNS zone visibility through VNet links
- manual private DNS records
- auto-registration behaviour
- cross-VNet private DNS resolution
- DNS Private Resolver inbound resolution path
- DNS Private Resolver outbound forwarding path
- forwarding ruleset behaviour
- deliberate DNS failure/recovery cases
- Terraform rebuild and convergence

## Learning method

```text
concept
-> packet/query path
-> architecture
-> manual CLI build
-> DNS query validation
-> failure injection
-> Terraform rebuild
-> independent validation
-> evidence
-> teardown
-> explain-back
```

## Critical rule

Provisioning state `Succeeded` does not prove DNS works. DNS must be tested with actual name-resolution queries and the returned server/answer/path must be understood.
