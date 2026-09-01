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

## Story-first rule

Legacy labs created before the BlueHarbor narrative are not completion credit for the progressive project. Rebuild any concept at its proper story point if reuse would alter naming, topology, assumptions or learning order.

## Cumulative Terraform rule

All practical units contribute to one living implementation:

```text
blueharbor/terraform/
```

The next unit inherits:

```text
all previous Terraform code
+ the same Terraform state lineage
+ the deployed Azure resources
+ all architecture decisions
```

It then adds the smallest coherent change needed for the new BlueHarbor requirement.

Do not create separate disposable Terraform roots per lab. Do not routinely destroy infrastructure at unit/module boundaries. Git commits are the checkpoint/snapshot mechanism.

Before every apply, `terraform plan` must be reviewed specifically for unexpected destroy/replace actions. Previous resources should remain unless the story intentionally changes or replaces them.

## Official module sequence

| Module | Microsoft Learn module | Status |
|---:|---|---|
| 1 | Introduction to Azure Virtual Networks | **IN PROGRESS — Unit 01 current** |
| 2 | Design and implement hybrid networking | NOT STARTED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED |
| 6 | Design and implement network security | NOT STARTED |
| 7 | Design and implement private access to Azure Services | NOT STARTED |
| 8 | Design and implement network monitoring | NOT STARTED |

## Current position

```text
Module 1 — Introduction to Azure Virtual Networks
Unit 01 — Introduction
BlueHarbor project starts here
```

No pre-story practical is considered complete in the new project.

The canonical Terraform folder exists as a project blueprint, but no Azure resource is required for Unit 01. The first applicable practical will establish the persistent state lineage that subsequent units inherit.

## Required engineering loop

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

## Progression rule

Do not skip ahead merely because a similar resource was built previously. Prior knowledge can make a chapter faster, but BlueHarbor's architecture must still evolve in sequence.

More importantly, do not start a new deployment just because a new unit begins. The default assumption is:

```text
previous infrastructure remains
previous Terraform remains
previous state remains
new unit adds the next requirement
```

See [`MSLEARN-UNIT-MAP.md`](MSLEARN-UNIT-MAP.md) for exact unit numbering, [`PROJECT-NARRATIVE.md`](PROJECT-NARRATIVE.md) for the programme story and [`../blueharbor/terraform/README.md`](../blueharbor/terraform/README.md) for the cumulative IaC rules.
