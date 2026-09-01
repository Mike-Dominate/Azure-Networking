# Source and Coverage Reference

## Primary curriculum authority

The programme structure and teaching sequence must follow Microsoft's official AZ-700 Microsoft Learn learning path:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

The learning path currently contains eight modules:

1. Introduction to Azure Virtual Networks
2. Design and implement hybrid networking
3. Design and implement Azure ExpressRoute
4. Load balance non-HTTP(S) traffic in Azure
5. Load balance HTTP(S) traffic in Azure
6. Design and implement network security
7. Design and implement private access to Azure Services
8. Design and implement network monitoring

The module order above is the authoritative programme sequence.

## Coverage completeness authority

The current Microsoft AZ-700 study guide / skills measured outline is used as a coverage check so that exam objectives that are broader than an individual Learn module are not missed.

Current baseline:

- Exam: AZ-700 — Designing and Implementing Microsoft Azure Networking Solutions
- Skills outline baseline: effective July 27, 2026

Rule:

```text
Microsoft Learn path = curriculum structure and sequence
Microsoft AZ-700 study guide = completeness check inside that structure
Azure product documentation = technical implementation authority
```

If the study guide contains an objective that the Learn module treats only briefly, add it as an extension inside the matching module/lab rather than inventing a disconnected standalone programme sequence.

Example:

```text
Microsoft Learn Module 1: Introduction to Azure Virtual Networks
  -> name resolution lesson covers public/private DNS
  -> AZ-700 study guide also requires Azure DNS Private Resolver
  -> therefore Private Resolver belongs as a Module 1 name-resolution extension
     rather than as a separate unrelated programme track
```

## Supplemental references

External repositories such as `rithinskaria/kodekloud-az700` may be used for extra scenarios or implementation ideas, but they do not define the programme order or required scope.

Other Microsoft Learn modules and Azure product documentation may be used when the AZ-700 study guide requires a capability that the main learning-path lesson does not explain deeply enough.

## Engineering implementation rule

Microsoft Learn provides the learning objective and scenario boundary. Our engineering implementation deepens the practical work through Azure CLI, Terraform, troubleshooting, validation, Git/GitHub and rebuild documentation without changing the objective.

Normal practical-lab order:

```text
Microsoft Learn lesson/tutorial
  -> explain mental model with everyday analogy
  -> visual architecture / packet or query flow
  -> understanding check
  -> design our practical implementation
  -> manual Azure CLI implementation
  -> protocol / Azure CLI validation
  -> deliberate failure and troubleshooting
  -> Portal inspection where useful
  -> Terraform rebuild
  -> independent validation
  -> evidence and rebuild documentation
  -> safe teardown
  -> learner explain-back
```

## Cost/practicality rule

Where a Microsoft Learn objective is expensive or unrealistic to provision in a personal Azure subscription, such as a full production ExpressRoute circuit, use serious architecture simulation and configuration analysis instead of pretending an unnecessary deployment is required.

Such work can include:

- architecture diagrams
- configuration-object analysis
- BGP and route reasoning
- redundancy and failure scenarios
- validation plans
- troubleshooting workflows
- service-selection trade-offs

## Drift prevention

Before teaching or redesigning any module:

1. Read the corresponding Microsoft Learn module.
2. Use its learning objectives and unit titles as the core scope.
3. Check the current AZ-700 study guide for additional objectives that belong inside the same module.
4. Do not create standalone topics merely because they are interesting Azure networking features.
5. Update the programme roadmap and handoff whenever Microsoft's learning path changes.
