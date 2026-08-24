# Azure Networking Engineering Labs

A hands-on Azure networking learning and reference repository based on the concepts covered by the KodeKloud AZ-700 lab collection, rebuilt as an engineering programme using visual learning, direct Azure deployment, Terraform, Azure CLI, VS Code, Git, and GitHub.

> **Learning source:** https://github.com/rithinskaria/kodekloud-az700
>
> This repository is an independent learning implementation. The source repository is used as a curriculum/reference; the work here documents our own architecture, deployments, validation, troubleshooting, and Infrastructure as Code.

## Goal

Build a reusable Azure networking reference while learning one lab per day. A lab is not complete merely because resources deploy. Each lab must demonstrate understanding, deployment, validation, troubleshooting, IaC, documentation, and safe teardown.

## Engineering learning loop

```text
Problem -> Mental model -> Visual architecture -> Direct deployment
        -> Validate with Azure CLI -> Rebuild with Terraform
        -> Test/fail/troubleshoot -> Git/GitHub -> Handoff -> Teardown -> Reflect
```

## Toolchain

- Azure
- VS Code
- Terraform
- Azure CLI
- Git
- GitHub
- Azure Portal for visual learning, inspection, and troubleshooting
- PowerShell/Bash when appropriate

## 15-lab roadmap

| Day | Lab | Primary topic | Status |
|---:|---|---|---|
| 01 | Azure Load Balancer | L4 load balancing, backend pools, probes, availability zones | NEXT |
| 02 | Traffic Manager | DNS-based global traffic distribution | NOT STARTED |
| 03 | Application Gateway | Layer 7 routing, listeners, TLS, backend pools | NOT STARTED |
| 04 | Azure Front Door | Global edge routing and delivery | NOT STARTED |
| 05 | Network Security Groups | Network traffic filtering and rule evaluation | NOT STARTED |
| 06 | Azure Bastion | Secure administrative access | NOT STARTED |
| 07 | Azure Firewall | Centralised network/application filtering | NOT STARTED |
| 08 | Web Application Firewall | OWASP-oriented application protection | NOT STARTED |
| 09 | Service Endpoints | Azure PaaS network access | NOT STARTED |
| 10 | NAT Gateway | Controlled outbound connectivity | NOT STARTED |
| 11 | VNet Peering | VNet and cross-region connectivity | NOT STARTED |
| 12 | Private DNS | Internal Azure name resolution | NOT STARTED |
| 13 | UDR + NVA | Custom routing and traffic steering | NOT STARTED |
| 14 | Point-to-Site VPN | Remote client connectivity | NOT STARTED |
| 15 | Virtual WAN | Global/transitive Azure networking architecture | NOT STARTED |

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
    │   ├── README.md
    │   ├── visual-learning/
    │   ├── manual-deployment/
    │   ├── terraform/
    │   ├── validation/
    │   ├── troubleshooting/
    │   ├── evidence/
    │   └── handoff/
    ├── 02-traffic-manager/
    └── ...
```

## Resume here

**Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before continuing the programme.** It is the authoritative continuation record and exists specifically to prevent drift between sessions.

## Definition of done for every lab

A lab is complete only when all applicable items are satisfied:

- [ ] Networking problem and use case understood
- [ ] Visual architecture and traffic flow understood
- [ ] Direct/manual Azure deployment completed
- [ ] Azure CLI verification completed
- [ ] Terraform implementation completed
- [ ] Terraform deployment validated
- [ ] Failure/troubleshooting exercise completed
- [ ] Evidence and useful outputs captured
- [ ] Git history updated with meaningful commits
- [ ] Lab handoff document completed
- [ ] Infrastructure safely torn down when appropriate
- [ ] Learner can explain the design and trade-offs in their own words

## Safety

Do not commit passwords, client secrets, certificates, private keys, Terraform state, or sensitive environment-specific values. Use example variable files and local ignored files for secrets.
