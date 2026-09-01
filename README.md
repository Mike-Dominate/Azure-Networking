# Azure Networking Engineering Programme

A hands-on Azure networking programme that follows Microsoft's official AZ-700 Microsoft Learn learning path in the published module and unit order, using one continuous fictional company project: **BlueHarbor Industries**.

> **Primary curriculum:** https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/
>
> **Coverage check:** https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700
>
> **Technical authority:** Microsoft Azure product documentation for the service being implemented.

## Programme principle

This is one cumulative project, not a collection of disposable labs.

Every Microsoft Learn unit introduces the next BlueHarbor requirement. The **story, Azure environment, Terraform code and Terraform state all continue from the previous unit**.

```text
Microsoft Learn unit
-> BlueHarbor business problem
-> mental model
-> design decision
-> MODIFY THE EXISTING TERRAFORM STACK
-> terraform plan: inspect the incremental change
-> terraform apply
-> independent validation
-> deliberate failure / troubleshooting
-> repair through Terraform where infrastructure configuration changed
-> evidence / Git checkpoint
-> NEXT UNIT STARTS FROM THIS EXACT STATE
```

### Cumulative Terraform rule

There is one canonical living Terraform implementation for BlueHarbor:

```text
blueharbor/terraform/
```

We do **not** create an isolated Terraform root for each lab and we do **not** copy the previous lab into a new folder.

Instead:

```text
Lab/Unit 1 Terraform
        |
        + new requirement
        v
Lab/Unit 2 Terraform
        |
        + new requirement
        v
Lab/Unit 3 Terraform
        |
        + new requirement
        v
...
        v
Module 8 = complete BlueHarbor environment
```

Git commits provide historical lab checkpoints. The working Terraform code represents the **current complete architecture**.

No routine `terraform destroy` occurs between units or modules. A destroy/replacement is performed only when the BlueHarbor design itself requires removal/replacement, or when the user explicitly chooses to reset the complete project.

Azure CLI, Portal and protocol tools may be used for inspection, validation and troubleshooting. Persistent Azure infrastructure configuration is managed through Terraform.

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
Phase — start the cumulative project from the beginning
Azure deployment — NONE required for Unit 01
Terraform stack — blueprint created; first resources added when the story requires them
```

## Repository layout

```text
Azure-Networking/
├── README.md
├── blueharbor/
│   └── terraform/
│       └── README.md      # rules for the one cumulative Terraform stack
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

Each module contains Microsoft Learn unit numbering and a BlueHarbor `PROJECT-STORY.md` where designed. The module folders contain the teaching story; `blueharbor/terraform/` contains the actual cumulative infrastructure.

## Learning rule

Complete the tutorial and mental model before changing infrastructure. For exercises, preserve Microsoft's learning objective but implement the BlueHarbor version through the existing Terraform stack.

A new unit should normally result in a **small understandable Terraform delta**, not an unrelated deployment.

## Definition of done for a practical unit

A practical unit is complete only when applicable items are satisfied:

- Microsoft Learn objective understood;
- BlueHarbor business reason understood;
- architecture / packet / query flow explainable;
- the existing Terraform stack was extended rather than replaced;
- `terraform plan` showed only the intended project delta;
- Terraform apply completed successfully;
- previous BlueHarbor infrastructure still exists unless deliberate design change removed it;
- independent Azure/protocol validation completed;
- deliberate failure/troubleshooting completed;
- permanent fixes are represented in Terraform;
- evidence and Git checkpoint captured;
- resulting infrastructure and state become the starting point for the next unit;
- learner can explain the design and trade-offs without the guide.

## Resume

Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before continuing.
