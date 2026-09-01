# Programme Roadmap

## Purpose

Build real Azure networking engineering capability by following Microsoft's official AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture evolves across the programme.

## Authority

```text
Microsoft Learn path = structure and order
Microsoft Learn unit = atomic teaching step
Microsoft Learn exercise = practical baseline where present
BlueHarbor story = progressive business scenario
AZ-700 study guide = completeness additions inside matching units
Azure product docs = exact implementation behaviour
```

## Story-first rule

Legacy labs created before the BlueHarbor narrative are not completion credit for the progressive project. Rebuild any concept at its proper story point if reuse would alter naming, topology, assumptions or learning order.

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

## Required engineering loop

For each Microsoft Learn unit:

```text
Microsoft Learn objective
-> BlueHarbor requirement
-> explanation / analogy
-> architecture or traffic/query flow
-> understanding check
-> Microsoft exercise where present
-> Azure CLI implementation where practical
-> independent validation
-> deliberate failure / troubleshooting
-> Portal inspection where useful
-> Terraform rebuild where appropriate
-> independent IaC validation
-> evidence / rebuild notes
-> safe teardown
-> explain-back
-> carry architecture forward
```

## Progression rule

Do not skip ahead merely because a similar resource was built previously. Prior knowledge can make a chapter faster, but BlueHarbor's architecture must still evolve in sequence so later modules inherit a coherent environment and mental model.

See [`MSLEARN-UNIT-MAP.md`](MSLEARN-UNIT-MAP.md) for exact unit numbering and [`PROJECT-NARRATIVE.md`](PROJECT-NARRATIVE.md) for the programme story.
