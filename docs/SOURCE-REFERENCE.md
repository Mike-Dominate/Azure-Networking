# Source and Coverage Reference

## Coverage authority

The **Microsoft AZ-700 study guide / skills measured outline** is the authoritative coverage source for this programme.

Current baseline:

- Exam: AZ-700 — Designing and Implementing Microsoft Azure Networking Solutions
- Skills outline baseline: effective July 27, 2026

The programme roadmap must be reviewed whenever Microsoft changes the published skills measured outline.

## Primary learning reference

`https://github.com/rithinskaria/kodekloud-az700`

The KodeKloud lab collection remains a useful hands-on curriculum/reference source, but it is **not** the authority for deciding whether the programme is complete.

## Secondary references

Other current AZ-700 repositories, Microsoft Learn modules and Azure product documentation may be reviewed to:

- identify coverage gaps
- compare lab scenarios
- validate current service terminology and capabilities
- improve architecture/troubleshooting exercises

They must not be copied blindly or treated as more authoritative than Microsoft's current skills outline and product documentation.

## How we use external lab sources

External repositories provide learning objectives, scenarios and ideas. We do **not** treat their scripts, passwords, regions, naming, portal steps, architecture decisions or deployment mechanisms as mandatory implementation choices.

Our implementation may change:

- deployment mechanism
- Azure region
- VM SKU
- authentication method
- resource naming
- security defaults
- network topology
- validation commands
- Terraform structure
- failure scenarios
- troubleshooting exercises
- cost-control approach

provided the required Azure networking concept remains intact and the final behaviour is independently validated.

## Engineering rule

The programme must teach the Azure service before hiding it behind Infrastructure as Code.

Normal practical-lab order:

```text
problem/use case
  -> mental model
  -> visual architecture
  -> manual Azure implementation
  -> CLI/protocol validation
  -> failure/troubleshooting
  -> Terraform rebuild
  -> independent validation
  -> documentation and teardown
```

## Cost/practicality exception

Some objectives, especially ExpressRoute, can be impractical or unnecessarily expensive to deploy in a personal learning subscription.

Those objectives still require serious engineering work through:

- architecture diagrams
- configuration-object analysis
- BGP/route reasoning
- redundancy and failure scenarios
- validation plans
- troubleshooting workflows
- service-selection trade-offs

A design/simulation lab is acceptable when it teaches the real control-plane and operational concepts without pretending that an unrealistic deployment is necessary.

## Attribution

The KodeKloud AZ-700 lab collection by `rithinskaria` is used as a learning reference. This repository contains an independent engineering implementation, original notes, validation, Terraform, troubleshooting exercises and documentation created during the programme.
