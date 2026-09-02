# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Core rules

```text
Microsoft Learn order is authoritative.
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
Implementation ready                 YES
```

See:

- [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md)
- [`WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md`](WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md)

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

Full subnet contract is in the closeout document.

## Final DNS contract

BlueHarbor-owned private namespace:

```text
blueharbor.internal
```

Later BlueHarbor-owned records such as:

```text
telemetry.services.blueharbor.internal
```

remain under that parent private zone.

Microsoft Private Link zones remain service-owned, for example:

```text
privatelink.database.windows.net
privatelink.azurewebsites.net
```

Hybrid resolution uses the existing Core DNS Private Resolver architecture.

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

## Important routing/security exceptions

Public Application Gateway and telemetry Load Balancer service paths retain deliberate symmetric return-path exceptions where the Azure service requires them.

Manufacturing Storage service-endpoint traffic from `snet-mfg-data` is also an intentional exception to central Azure Firewall egress inspection; its enforcement is service endpoint + endpoint policy + Storage network rules.

## Intentional later retirements

These are approved architecture evolutions, not cleanup:

```text
classic workload gateway transit -> Virtual WAN
Research AUE-hub connection -> SEA hub
Core<->Mfg and Core<->Research direct peerings -> retire after secured transit proof
Partner NAT egress -> retire after firewall egress proof
Front Door public origin group -> Private-Link-enabled origin group
```

Classic VPN resources remain deployed after the Virtual WAN cutover, but the classic branch path is non-production/inactive unless a later explicit failback design says otherwise.

## Current programme position

```text
Module 1 — Introduction to Azure Virtual Networks
Unit 01 — Introduction
Status — CURRENT
Azure deployment — NONE required
Terraform deployment — NONE required
```

## Immediate resume instruction

Begin **Module 1 — Unit 01 — Introduction** using the BlueHarbor migration brief and mental model. Do not skip to Terraform. The first persistent infrastructure checkpoint is Module 1 Unit 04.
