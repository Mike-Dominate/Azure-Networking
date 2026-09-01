# Azure Networking Engineering Programme

A hands-on Azure networking programme that follows Microsoft's official AZ-700 Microsoft Learn learning path in the published module and unit order, using one continuous fictional company project: **BlueHarbor Industries**.

> **Primary curriculum:** https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/
>
> **Coverage check:** https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700
>
> **Technical authority:** Microsoft Azure product documentation for the service being implemented.

## Programme principle

The project is progressive. Each Microsoft Learn unit introduces the next BlueHarbor business requirement, and the architecture evolves from the previous unit.

```text
Microsoft Learn unit
-> BlueHarbor business problem
-> mental model
-> design
-> implementation
-> validation
-> deliberate failure / troubleshooting
-> Terraform where appropriate
-> evidence / rebuild notes
-> carry architecture forward
```

### Story continuity outranks legacy work

Previous labs built before the BlueHarbor storyline do **not** count as completed project chapters and are not reused merely because they already exist.

If old work would force the story around earlier assumptions, naming, topology or sequencing, rebuild it at the correct point in the BlueHarbor project. Old commits remain available in Git history for reference only.

## Official Microsoft Learn curriculum

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
BlueHarbor Industries
Microsoft Learn Module 1 — Introduction to Azure Virtual Networks
Unit 01 — Introduction
Phase — start the progressive story from the beginning
Azure deployment — NONE
```

## Repository layout

```text
Azure-Networking/
├── README.md
├── docs/
│   ├── HANDOFF.md
│   ├── MSLEARN-UNIT-MAP.md
│   ├── PROGRAMME-ROADMAP.md
│   ├── PROJECT-NARRATIVE.md
│   ├── SOURCE-REFERENCE.md
│   └── WORKING-METHOD.md
└── modules/
    ├── 01-introduction-to-azure-virtual-networks/
    ├── 02-design-and-implement-hybrid-networking/
    ├── 03-design-and-implement-azure-expressroute/
    ├── 04-load-balance-non-http-traffic-in-azure/
    ├── 05-load-balance-http-traffic-in-azure/
    ├── 06-design-and-implement-network-security/
    ├── 07-design-and-implement-private-access-to-azure-services/
    └── 08-design-and-implement-network-monitoring/
```

Each module contains the Microsoft Learn unit numbering and a BlueHarbor `PROJECT-STORY.md` where designed.

## Learning rule

Complete the tutorial/mental model before building Azure resources. For exercises, follow the Microsoft objective first, then deepen it with Azure CLI, validation, failure analysis and Terraform where useful.

## Definition of done

A substantial practical is complete only when applicable items are satisfied:

- Microsoft Learn objective understood;
- BlueHarbor business reason understood;
- architecture / packet / query flow explainable;
- manual Azure implementation completed where practical;
- independent validation completed;
- deliberate failure/troubleshooting completed;
- Terraform rebuild completed where appropriate;
- evidence and rebuild notes captured;
- resources safely torn down when they do not need to remain deployed;
- learner can explain the design and trade-offs without the guide.

## Resume

Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before continuing.
