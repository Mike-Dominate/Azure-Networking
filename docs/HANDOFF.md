# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Core rules

```text
Microsoft Learn order is authoritative.
Current AZ-700 study guide is the completeness authority.
One BlueHarbor story.
One blueharbor/terraform/ root.
One Terraform state lineage.
Each unit = previous deployed estate + next requirement.
```

Persistent infrastructure is Terraform-managed. CLI/Portal/PowerShell/protocol/diagnostic tools validate and troubleshoot. No routine destroy occurs between units/modules.

## Planning/audit status

```text
Story design                         COMPLETE
Gate 1  M1 -> M2                     PASS
Gate 2  M2 -> M3                     PASS
Gate 3  M3 -> M4                     PASS
Gate 4  M4 -> M5                     PASS
Gate 5  M5 -> M6                     PASS
Gate 6  M6 -> M7                     PASS
Gate 7  M7 -> M8                     PASS
Whole-programme architecture closeout PASS
July-2026 study-guide coverage       COMPLETE
Final curriculum / architecture QA   PASS
Implementation ready                 YES
```

See:

- [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md)
- [`WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md`](WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md)
- [`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)
- [`FINAL-CURRICULUM-QA.md`](FINAL-CURRICULUM-QA.md)

## Final canonical address additions

```text
Core AUE          10.10.0.0/16
Manufacturing AUE 10.20.0.0/16
Research SEA      10.30.0.0/16
Partner AUE       10.40.0.0/16
Partner SEA       10.50.0.0/16
Classic edge AUE  10.100.0.0/16
vHub AUE          10.200.0.0/22
vHub SEA          10.200.4.0/22

Brisbane          172.16.0.0/16
Perth             172.17.0.0/16
Classic P2S       172.31.240.0/24
vWAN User VPN     172.31.241.0/24
```

## Final DNS contract

BlueHarbor-owned private namespace:

```text
blueharbor.internal
```

Microsoft Private Link zones remain service-owned, for example:

```text
privatelink.database.windows.net
privatelink.azurewebsites.net
```

Hybrid resolution uses the Core DNS Private Resolver architecture.

## Terraform state contract

Before the first persistent BlueHarbor infrastructure is built, establish and migrate the one project state to:

```text
rg-bhi-tfstate-aue
stbhitfstate<global_suffix>
container: tfstate
key: blueharbor.tfstate
```

Use Microsoft Entra ID/Azure CLI-compatible backend authentication. Do not commit Storage keys, SAS tokens, client secrets, real tfvars or backend configuration.

`global_suffix` is one six-character lowercase alphanumeric value chosen once and carried through the project for Azure resources that require global uniqueness.

## Important routing/security evolutions

```text
classic workload gateway transit -> Virtual WAN
Research AUE-hub connection -> SEA hub
Core<->Mfg and Core<->Research direct peerings -> retire after secured transit proof
Brisbane<->Perth Global Reach -> retire in M6 after secured ER-to-ER path proof
Partner NAT egress -> retire after firewall egress proof
Front Door public origin group -> Private-Link-enabled origin group
```

If current Azure requires Microsoft support enablement for ExpressRoute-to-ExpressRoute transit through a secured vWAN security appliance, treat it as a real prerequisite rather than assuming it is a self-service toggle.

## Final study-guide/service guardrails

- `docs/AZ700-STUDY-GUIDE-COVERAGE.md` must be checked at every unit so current skills outside the visible Learn exercise are not skipped.
- Azure Route Server is covered as a mandatory M1 routing extension but is not deployed into a VNet connected to Virtual WAN simply for exam coverage.
- vWAN FastPath means ExpressRoute Direct plus a Virtual WAN ExpressRoute Gateway of at least five scale units under the current support model.
- Front Door -> private Application Gateway HTTPS requires a real trusted certificate subject/name; `.example` is never used to fake end-to-end TLS.

## Current programme position

```text
Module 1 — Introduction to Azure Virtual Networks
Unit 01 — Introduction
Status — CURRENT
Azure deployment — NONE required
Terraform deployment — NONE required
```

## Immediate resume instruction

Begin **Module 1 — Unit 01 — Introduction** using the BlueHarbor migration brief and mental model. Before each unit, check its corresponding rows in `AZ700-STUDY-GUIDE-COVERAGE.md`. Do not skip to Terraform. The first persistent infrastructure checkpoint is Module 1 Unit 04.
