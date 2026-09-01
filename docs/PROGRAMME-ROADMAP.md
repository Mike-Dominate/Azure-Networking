# Programme Roadmap

## Purpose

Build real Azure networking engineering capability by following Microsoft's official AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture and Terraform stack evolve across the programme.

## Authority

```text
Microsoft Learn path = structure and order
Microsoft Learn unit = atomic teaching step
Microsoft Learn exercise = practical objective where present
BlueHarbor story = progressive business scenario
AZ-700 study guide = completeness additions inside matching units
Azure product docs = exact implementation behaviour
```

## Cumulative Terraform rule

All practical units contribute to one living implementation:

```text
blueharbor/terraform/
```

Each unit inherits all previous Terraform code, the same state lineage, the deployed Azure resources and architecture decisions, then adds the smallest coherent change required by the next BlueHarbor business event.

Do not create disposable Terraform roots per lab. Do not routinely destroy infrastructure at unit/module boundaries. Git commits are the historical checkpoints.

Before every apply, inspect `terraform plan` for unexpected destroy/replace actions.

## Story-design status

The complete BlueHarbor narrative across Microsoft Learn Modules 1–8 is now designed.

```text
M1 network foundation
 -> M2 hybrid connectivity
 -> M3 enterprise private connectivity
 -> M4 service availability
 -> M5 HTTP(S) delivery
 -> M6 security
 -> M7 private PaaS access
 -> M8 monitoring / operations
```

The next programme activity is a full architecture and Terraform dependency audit before implementation begins.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED |

## Current phase

```text
STORY DESIGN        COMPLETE
ARCHITECTURE AUDIT  NEXT
TERRAFORM BUILD     NOT STARTED
```

Do not start the new BlueHarbor Azure deployment until the audit validates the full module chain.

## Architecture & Terraform Dependency Audit

Walk:

```text
M1 -> M2 -> M3 -> M4 -> M5 -> M6 -> M7 -> M8
```

For each transition record:

```text
previous end state
-> reused resources
-> new business requirement
-> Terraform additions
-> Terraform in-place changes
-> intentional replacements if any
-> validation dependencies
-> resulting next state
```

Audit naming, regions, address spaces, special-purpose subnet requirements, DNS, route propagation, hybrid dependencies, load-balancing/application-delivery dependencies, security enforcement points, private-access dependencies and monitoring targets.

A later module must not depend on a resource that was never introduced earlier.

## Required engineering loop after the audit

For each Microsoft Learn unit:

```text
Microsoft Learn objective
-> BlueHarbor requirement
-> explanation / analogy
-> architecture or traffic/query flow
-> understanding check
-> identify the delta from the CURRENT BlueHarbor environment
-> update the SAME Terraform root
-> terraform fmt / init / validate
-> terraform plan and inspect intended delta
-> terraform apply
-> independent validation using Azure CLI / Portal / protocol tools
-> deliberate failure / troubleshooting
-> encode permanent infrastructure fix in Terraform
-> re-plan / re-apply / re-validate
-> evidence / rebuild notes
-> Git checkpoint
-> carry code + state + Azure resources into next unit
-> explain-back
```

See [`MSLEARN-UNIT-MAP.md`](MSLEARN-UNIT-MAP.md), [`PROJECT-NARRATIVE.md`](PROJECT-NARRATIVE.md), [`HANDOFF.md`](HANDOFF.md) and [`../blueharbor/terraform/README.md`](../blueharbor/terraform/README.md).
