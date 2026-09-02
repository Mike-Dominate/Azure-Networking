# Unit 01 — Introduction

**BlueHarbor chapter:** Receive the Azure migration brief  
**Status:** CURRENT  
**Mastery stage:** NOT STARTED

BlueHarbor has no completed Azure network yet. Your role is to understand the business divisions, the intended progressive architecture and what an Azure Network Engineer must be able to explain before deployment begins.

No Azure resources or Terraform deployment are required for this orientation unit.

## Business trigger

You have joined BlueHarbor Industries as the Azure Network Engineer supporting a phased cloud migration.

The company has corporate services, manufacturing systems, research workloads, physical sites and remote engineers. Leadership does not want a collection of disconnected cloud experiments. The network must evolve as one controlled enterprise architecture that can later support hybrid connectivity, private connectivity, application delivery, security, PaaS private access and operations.

Your first task is not to deploy anything.

Your first task is to understand **what you are responsible for building and why the programme must be incremental**.

## Job reality check

### First 30 days

You are expected to read an existing architecture, understand naming/addressing/region decisions and avoid making changes before you understand dependencies.

### 6-12 months

You are expected to extend existing Azure networks without breaking applications, routes, DNS, hybrid paths or security controls.

### Senior level

You are expected to explain why the network evolved the way it did, identify technical debt and defend the next architecture change against business, security, reliability and cost constraints.

## Recall before reference

Answer these before looking elsewhere in the repository:

1. Why is BlueHarbor using one cumulative environment instead of independent AZ-700 labs?
2. What are the two Azure regions in the programme?
3. What four things must carry forward from one practical unit to the next?
4. Why is `terraform destroy` not the normal end of a unit?
5. What is the role of Azure CLI if Terraform manages persistent infrastructure?

Then verify your answers against the repository documentation.

## Mental model

Think of BlueHarbor as a real company whose Azure network is being built while the business continues to grow.

```text
business requirement
      |
      v
architecture decision
      |
      v
Terraform change to the living estate
      |
      v
independent Azure/network validation
      |
      v
failure + troubleshooting
      |
      v
evidence + Git checkpoint
      |
      v
same estate becomes the next unit's starting point
```

The programme therefore teaches two things at once:

1. the AZ-700 networking capability in Microsoft Learn order;
2. the engineering habit of changing an existing environment safely.

## Explain-back challenge

Without reading from the repository, explain this in your own words:

> Why would learning Azure networking through one evolving company environment produce a different skill set from completing twenty unrelated labs?

A strong answer should mention dependencies, change impact, troubleshooting, state continuity and architecture evolution.

## Architecture orientation

By the end of the programme, the same BlueHarbor estate will have evolved through:

```text
M1  Azure network foundation
 -> DNS / peering / routing / NAT
M2  VPN / P2S / Virtual WAN
M3  ExpressRoute
M4  Layer-4 load balancing / Traffic Manager
M5  Application Gateway / Front Door
M6  network security and inspection
M7  private PaaS access / Private Link
M8  monitoring and operations
```

Do not memorise product names as a list. The goal is to understand that each later capability solves a problem created by a more mature estate.

## Failure-thinking exercise

No infrastructure exists yet, so this unit uses an architecture failure rather than a technical fault.

### Scenario

A colleague proposes this study method:

> "For every Microsoft Learn exercise, create a new resource group, reproduce the lab, take screenshots, then delete everything and move to the next lab."

Identify at least four capabilities that this method would fail to teach well.

Consider:

- dependency awareness;
- Terraform state;
- architecture change impact;
- regression testing;
- operational troubleshooting;
- retirement/replacement decisions;
- Git history.

## Communication challenge

**Audience:** Infrastructure Manager  
**Format:** maximum 120 words

Explain why BlueHarbor will use a progressive Azure environment rather than resetting after every training exercise. Do not use certification language. Explain the engineering benefit to the business.

## Evidence for this unit

Create no Azure evidence yet.

The useful evidence is conceptual:

- one simple hand-drawn or digital diagram of the M1 -> M8 evolution;
- your explain-back answer;
- your short Infrastructure Manager explanation.

These do not need to be committed until execution begins unless they add lasting value to the repository.

## Interview / scenario questions

Answer without notes:

1. What is the difference between learning a service and learning how to introduce that service into an existing architecture?
2. Why can a technically correct Terraform plan still be a bad architecture change?
3. What should happen if Terraform proposes an unexpected replacement of an existing BlueHarbor resource?
4. Why should Azure CLI validation be independent of the Terraform configuration that created the resource?
5. What is the danger of treating Git history as a substitute for understanding the currently deployed state?

## Low-guidance repeat

Close this README.

From memory, describe the complete BlueHarbor learning loop from **business requirement** to **carry-forward estate**.

Then reopen this file and identify anything important you omitted.

## Unit mastery gate

Unit 01 becomes `MASTERED` when you can honestly tick all applicable items:

```text
[ ] I can explain the purpose of the BlueHarbor programme without notes.
[ ] I understand why the architecture must remain cumulative.
[ ] I can distinguish Terraform's role from Azure CLI/Portal validation.
[ ] I can explain why routine teardown would reduce the learning value.
[ ] I can describe the M1-M8 progression at a high level.
[ ] I completed the explain-back challenge.
[ ] I answered the scenario questions without relying on the README.
[ ] I completed the low-guidance repeat.
```

No Azure or Terraform gate applies because this is an orientation unit.

## Next unit

Proceed in Microsoft Learn order to Unit 02 only after the orientation mental model is clear.

The learner-mastery standard for the full programme is defined in [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
