# Azure Networking Engineering Labs

A hands-on Azure networking learning and reference repository built around the current Microsoft AZ-700 skills measured outline and reinforced with visual learning, direct Azure deployment, Terraform, Azure CLI, VS Code, Git, GitHub, troubleshooting and rebuild documentation.

> **Primary coverage authority:** Microsoft AZ-700 study guide / skills measured, effective July 27, 2026.
>
> **Learning reference:** https://github.com/rithinskaria/kodekloud-az700
>
> This repository is an independent engineering learning implementation. External repositories are used as curriculum/reference material; the architecture, deployment, validation, troubleshooting, Terraform and documentation here are our own.

## Goal

Build a reusable Azure networking engineering reference while progressing through one lab per day. A lab is not complete merely because resources deploy. Each lab must demonstrate understanding, implementation, validation, troubleshooting, Infrastructure as Code where appropriate, documentation and safe teardown.

## Engineering learning loop

```text
Problem/use case -> Teach mental model -> Visual architecture -> Understanding check
                 -> Direct Azure deployment -> Azure CLI validation
                 -> Failure/troubleshooting -> Portal inspection where useful
                 -> Terraform rebuild -> Independent validation
                 -> Git/GitHub -> Rebuild documentation -> Teardown -> Explain-back
```

## Toolchain

- Azure
- VS Code
- Terraform
- Azure CLI
- Git
- GitHub
- Azure Portal for visual inspection and troubleshooting
- PowerShell/Bash when appropriate
- DNS, HTTP and network diagnostic tools where appropriate

## 22-lab roadmap

| Lab | Topic | Status |
|---:|---|---|
| 01 | Azure Load Balancer | COMPLETE |
| 02 | Azure Traffic Manager | COMPLETE |
| 03 | IP Addressing, VNets, Subnets & Public IP Architecture | IN PROGRESS |
| 04 | Azure DNS, Private DNS & DNS Private Resolver | NOT STARTED |
| 05 | VNet Peering, Gateway Transit & Virtual Network Manager | NOT STARTED |
| 06 | UDRs, Forced Tunnelling, NAT Gateway & NVA | NOT STARTED |
| 07 | Azure Route Server & Dynamic Routing | NOT STARTED |
| 08 | Network Watcher, Azure Monitor, Flow Logs, DDoS & Defender | NOT STARTED |
| 09 | Site-to-Site VPN | NOT STARTED |
| 10 | Point-to-Site VPN | NOT STARTED |
| 11 | ExpressRoute Architecture & BGP | NOT STARTED |
| 12 | Azure Virtual WAN | NOT STARTED |
| 13 | Application Gateway | NOT STARTED |
| 14 | Azure Front Door | NOT STARTED |
| 15 | Gateway Load Balancer & NVA Service Insertion | NOT STARTED |
| 16 | Private Endpoint, Private Link & Private DNS | NOT STARTED |
| 17 | Service Endpoints & Service Endpoint Policies | NOT STARTED |
| 18 | NSG, ASG & Azure Bastion | NOT STARTED |
| 19 | Azure Firewall & Firewall Manager | NOT STARTED |
| 20 | Web Application Firewall | NOT STARTED |
| 21 | Network Troubleshooting Incident Lab | NOT STARTED |
| 22 | AZ-700 Enterprise Capstone | NOT STARTED |

**Overall progress: 2 / 22 labs completed; Lab 03 in progress.**

The detailed coverage, sequencing and cost/practicality rules live in [`docs/PROGRAMME-ROADMAP.md`](docs/PROGRAMME-ROADMAP.md).

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
    └── ...
```

## Resume here

**Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before continuing the programme.** It is the authoritative continuation record and exists specifically to prevent drift between sessions.

**Current lab: Lab 03 — IP Addressing, VNets, Subnets & Public IP Architecture — IN PROGRESS.**

## Definition of done for every practical lab

A lab is complete only when all applicable items are satisfied:

- [ ] Networking problem and use case understood
- [ ] Mental model taught and explainable
- [ ] Visual architecture and traffic/control-plane flow understood
- [ ] Direct/manual Azure deployment completed where practical
- [ ] Azure CLI or protocol-level verification completed
- [ ] Terraform implementation completed where appropriate
- [ ] Terraform deployment independently validated
- [ ] Failure/troubleshooting exercise completed
- [ ] Evidence and useful outputs captured
- [ ] Git history updated with meaningful commits
- [ ] Lab handoff document completed
- [ ] Rebuild/practice documentation created
- [ ] Infrastructure safely torn down when appropriate
- [ ] Learner can explain the design and trade-offs without reading the guide

Design-heavy services that are impractical or expensive to provision, such as ExpressRoute, can use architecture simulation, route/BGP reasoning, validation planning and failure analysis instead of forcing an unrealistic deployment.

## Safety

Do not commit passwords, client secrets, certificates, private keys, Terraform state, sensitive local variable files, tokens or environment-specific secrets. Use example variable files and ignored local files for sensitive values.
