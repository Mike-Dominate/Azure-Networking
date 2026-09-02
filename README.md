# Azure Networking Engineering Programme

A hands-on Azure networking programme that follows Microsoft's official AZ-700 Microsoft Learn learning path in published module/unit order, using one continuous fictional company project: **BlueHarbor Industries**.

## Programme principle

This is one cumulative project, not a collection of disposable labs.

```text
Microsoft Learn unit
 -> BlueHarbor business problem
 -> mental model
 -> incremental design
 -> same Terraform root/state
 -> plan / apply when the unit requires infrastructure
 -> independent validation
 -> deliberate failure / troubleshooting
 -> evidence / Git checkpoint
 -> next unit starts from the exact resulting state
```

Canonical Terraform root:

```text
blueharbor/terraform/
```

No routine `terraform destroy` occurs between units/modules. Persistent Azure configuration is Terraform-managed; CLI/Portal/protocol tools inspect, validate and troubleshoot.

## Planning status

```text
Story design                         COMPLETE
Transition audit Gates 1-7           PASS
Whole-programme architecture closeout PASS
Implementation ready                 YES
```

Authoritative closeout:

[`docs/WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md`](docs/WHOLE-PROGRAMME-ARCHITECTURE-CLOSEOUT.md)

## Current position

```text
BlueHarbor Industries
Microsoft Learn Module 1 — Introduction to Azure Virtual Networks
Unit 01 — Introduction
Status — CURRENT
Azure deployment — NONE required
Terraform deployment — NONE required
```

The first persistent Terraform infrastructure checkpoint is Module 1 Unit 04. Before/within that practical, the one project state lineage is bootstrapped and migrated to the approved Azure Blob backend.

## Key final contracts

```text
Primary region               Australia East
Secondary region             Southeast Asia
Private DNS parent zone      blueharbor.internal
Classic P2S pool             172.31.240.0/24
Virtual WAN User VPN pool    172.31.241.0/24
Terraform root               blueharbor/terraform/
Terraform remote state       Azure Blob / one state lineage
Global unique naming         one persistent 6-char lowercase alphanumeric suffix
```

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

## Working rule

Complete the tutorial/mental model before changing infrastructure. Preserve Microsoft's learning objective, but implement practical changes as small understandable deltas in the one cumulative Terraform environment.

Always read [`docs/HANDOFF.md`](docs/HANDOFF.md) before resuming.
