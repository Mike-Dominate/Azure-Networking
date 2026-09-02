# Module 1 — Introduction to Azure Virtual Networks

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/  
**BlueHarbor project:** Build and master the Azure network foundation  
**Status:** IN PROGRESS — Unit 01 current

Module 1 starts the BlueHarbor story from an empty Azure network and establishes the first persistent Terraform-managed architecture that every later module inherits.

It is also the calibration module for the programme's learner-mastery system.

See:

- [`PROJECT-STORY.md`](PROJECT-STORY.md)
- [`../../docs/LEARNER-MASTERY-FRAMEWORK.md`](../../docs/LEARNER-MASTERY-FRAMEWORK.md)

## Module 1 learner progression

Module 1 deliberately varies the amount of scaffolding instead of making every unit equally heavy.

```text
U01  Orientation / learning contract
U02  Addressing and segmentation design gate
U03  Public-addressing decision model
U04  FIRST PERSISTENT BUILD + Terraform/state mastery
U05  DNS mental model and design
U06  FULL DNS practical + fault recovery
U07  Peering / non-transitivity model
U08  FULL global-peering practical + cross-region incident
U09  Routing / effective-state troubleshooting practical
U10  FULL NAT egress practical + incident recovery
U11  MODULE CAPSTONE / architecture board / cross-unit incident
```

Concept units emphasize explanation, prediction and design judgement. Practical units emphasize Terraform delta reasoning, independent validation, deliberate faults, evidence and recovery. Unit 11 tests the combined Module 1 system.

## Microsoft Learn units and BlueHarbor chapters

| Unit | Microsoft Learn unit | BlueHarbor chapter | Learning mode | Status |
|---:|---|---|---|---|
| 01 | Introduction | Receive the Azure migration brief | Orientation / explain-back | **CURRENT** |
| 02 | Explore Azure Virtual Networks | Freeze the canonical VNet/subnet/address contract | Design mastery | NOT STARTED |
| 03 | Configure public IP services | Understand exposure before creating a public endpoint | Decision mastery | NOT STARTED |
| 04 | Exercise: Design and implement a virtual network in Azure | Build the Terraform-managed network foundation | **Full practical mastery** | NOT STARTED |
| 05 | Design name resolution for your virtual network | Teams can no longer depend on memorised IP addresses | Design / fault reasoning | NOT STARTED |
| 06 | Exercise: Configure domain name servers settings in Azure | Implement and validate internal name resolution | **Full practical mastery** | NOT STARTED |
| 07 | Enable cross-virtual network connectivity with peering | Manufacturing needs a service in Core | Connectivity mental model | NOT STARTED |
| 08 | Exercise: Connect two Azure virtual networks using global VNet peering | Connect Core to Research across regions | **Full practical mastery** | NOT STARTED |
| 09 | Implement virtual network traffic routing | Security requires deliberate traffic-path control | Effective-state troubleshooting | NOT STARTED |
| 10 | Configure internet access with Azure Virtual NAT | Selected private workloads need controlled outbound Internet | **Full practical mastery** | NOT STARTED |
| 11 | Summary | Architecture review and mastery board | **Module capstone** | NOT STARTED |

## Canonical network contract

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24

bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

These names/address spaces persist into later modules.

## Mastery progression

A learner does not move from "not started" directly to "done".

```text
NOT STARTED
    |
    v
LEARNED      mental model/design understood
    |
    v
BUILT        persistent implementation completed where applicable
    |
    v
VALIDATED    Azure/network behaviour independently proven
    |
    v
MASTERED     troubleshooting + evidence + communication + low-guidance repeat passed
```

Concept-only units can move from `LEARNED` to `MASTERED` without Azure deployment when the unit intentionally has no persistent build.

## Standard practical pattern

```text
BlueHarbor business trigger
-> job reality / recall
-> tutorial + traffic/control-plane mental model
-> predict expected behaviour
-> define delta from current estate
-> modify SAME blueharbor/terraform root
-> terraform plan / explain architecture delta
-> apply
-> independently validate with Azure/network tools
-> deliberately introduce a relevant fault
-> diagnose from symptom/effective state
-> reconcile permanent fix into Terraform
-> regression-test previous functionality
-> pressure scenario + stakeholder communication
-> capture evidence
-> low-guidance repeat
-> mastery gate
-> carry exact code + state + Azure environment forward
```

## Assistance level in Module 1

This is Foundation Mode, so guidance is intentionally strongest here.

The learner should receive:

- clear mental models and everyday analogies where useful;
- explicit explanation of unfamiliar Azure behaviours;
- suggested validation commands for new diagnostic tools;
- strong guardrails around Terraform/state and cumulative architecture;
- prompts that force prediction before commands are run.

But even in Module 1, the learner must not be reduced to copy/paste execution. Every practical contains decisions, explain-back, deliberate failure and a low-guidance repeat.

Later modules deliberately remove more scaffolding.

## Module 1 exit standard

Before Module 2 begins, the learner must be able to reason about the complete foundation across:

```text
addressing and subnet purpose
public/private addressing decisions
private DNS and VNet links
regional and global VNet peering
non-transitivity
system routes / UDRs / effective routes
NAT-managed outbound Internet
Terraform configuration vs state vs Azure state
failure isolation and regression validation
```

Unit 11 contains the formal Module 1 mastery board and cross-unit incident challenge.

Module 2 does not begin from a blank environment. It inherits the exact mastered Module 1 estate and asks the next business question: how do sites and remote users outside Azure reach it?
