# Azure Networking Engineering Labs

A hands-on Azure networking learning and reference repository structured around Microsoft's official AZ-700 Microsoft Learn learning path and deepened with Azure CLI, Terraform, troubleshooting, validation, Git/GitHub and rebuild documentation.

> **Primary curriculum:** https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/
>
> **Coverage completeness check:** https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700
>
> **Technical authority:** Microsoft Azure product documentation for each service.

## Goal

Learn Azure networking in Microsoft's published AZ-700 module sequence while going beyond click-through exercises into engineering understanding, CLI deployment, failure analysis, Terraform and repeatable rebuilds.

## Engineering learning loop

```text
Microsoft Learn lesson
-> mental model + everyday analogy
-> visual architecture / traffic or query flow
-> understanding check
-> practical lab design
-> manual Azure CLI deployment
-> independent validation
-> deliberate failure / troubleshooting
-> Portal inspection where useful
-> Terraform rebuild
-> independent validation
-> evidence / documentation
-> teardown
-> explain-back
```

## Toolchain

- Azure
- VS Code
- Terraform
- Azure CLI
- Git
- GitHub
- Azure Portal where visual inspection is useful
- PowerShell/Bash where appropriate
- DNS, HTTP and network diagnostic tools

## Official Microsoft Learn curriculum

| Module | Microsoft Learn module | Status |
|---:|---|---|
| 1 | Introduction to Azure Virtual Networks | IN PROGRESS |
| 2 | Design and implement hybrid networking | NOT STARTED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED |
| 4 | Load balance non-HTTP(S) traffic in Azure | COMPLETE |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED |
| 6 | Design and implement network security | NOT STARTED |
| 7 | Design and implement private access to Azure Services | NOT STARTED |
| 8 | Design and implement network monitoring | NOT STARTED |

Module 4 is already complete because the Azure Load Balancer and Azure Traffic Manager practical labs were finished before the curriculum was realigned to Microsoft Learn.

## Current work

```text
Microsoft Learn Module 1 — Introduction to Azure Virtual Networks
Current practical — Lab 04: Azure DNS / name resolution
Phase — tutorial / mental model
Deployment — NOT STARTED
```

Lab 03 already completed the Module 1 VNet/IP-addressing foundation. Lab 04 now implements the name-resolution portion of Module 1, with Azure DNS Private Resolver included only because the current AZ-700 study guide explicitly requires it under name resolution.

## Existing practical lab folders

Historical lab numbers are retained so completed work and links are not destroyed. The numbers no longer define the curriculum order; Microsoft Learn modules do.

Examples:

```text
Module 1
  Lab 03 — VNet / IP / public IP foundation            COMPLETE
  Lab 04 — DNS / name resolution                       IN PROGRESS
  Lab 05 — VNet peering / connectivity                 NOT STARTED
  Lab 06 — routing / NAT                               NOT STARTED
  Lab 07 — Route Server study-guide extension          NOT STARTED

Module 4
  Lab 01 — Azure Load Balancer                         COMPLETE
  Lab 02 — Azure Traffic Manager                       COMPLETE
```

See [`docs/PROGRAMME-ROADMAP.md`](docs/PROGRAMME-ROADMAP.md) for the full Microsoft Learn-to-practical mapping.

## Repository layout

```text
Azure-Networking/
├── README.md
├── .gitignore
├── docs/
│   ├── HANDOFF.md
│   ├── PROGRAMME-ROADMAP.md
│   ├── WORKING-METHOD.md
│   └── SOURCE-REFERENCE.md
└── labs/
    ├── 01-load-balancer/
    ├── 02-traffic-manager/
    ├── 03-ip-addressing-vnets-subnets-public-ip/
    ├── 04-azure-dns-private-dns-resolver/
    └── ...
```

## Resume here

**Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before continuing.**

Current continuation point:

```text
Microsoft Learn Module 1
Introduction to Azure Virtual Networks
  -> Design name resolution for your virtual network
```

We finish the Microsoft Learn tutorial/name-resolution material first, then add only the current AZ-700 study-guide requirements that belong inside the same name-resolution section, then design and deploy the practical lab.

## Definition of done for a practical lab

A practical is complete only when all applicable items are satisfied:

- [ ] Microsoft Learn objective understood
- [ ] Study-guide additions for that objective covered
- [ ] Mental model explainable
- [ ] Visual architecture / packet/query flow understood
- [ ] Manual Azure deployment completed where practical
- [ ] CLI/protocol validation completed
- [ ] Failure/troubleshooting exercise completed
- [ ] Terraform implementation completed where appropriate
- [ ] Terraform deployment independently validated
- [ ] Evidence captured
- [ ] Git/GitHub updated
- [ ] Rebuild documentation created
- [ ] Infrastructure safely torn down when appropriate
- [ ] Learner can explain the design and trade-offs without the guide

## Safety

Do not commit passwords, client secrets, certificates, private keys, Terraform state, sensitive local variable files, tokens or environment-specific secrets.
