# Unit 02 — Explore Azure Virtual Networks

**BlueHarbor chapter:** Freeze the network contract before building  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This unit is a design gate. No Azure resources are deployed yet.

Your job is to approve an address and subnet contract that later VPN, ExpressRoute, application-delivery, security and Private Link work can inherit without expensive redesign.

## Business trigger

BlueHarbor's application, manufacturing and research teams are preparing to move workloads into Azure. Each team has proposed address ranges independently.

The Architecture Review Board has stopped deployment until Network Engineering proves that the cloud address plan is non-overlapping, expandable and divided into subnets with clear purposes.

You must turn three independent workload requests into one enterprise network contract.

## Job reality check

### First 30 days

You may be asked to identify VNet/subnet ownership, interpret CIDR ranges and spot obvious address overlap before a change is approved.

### 6-12 months

You may have to extend an existing address plan while preserving peering, VPN, private endpoints, routing and workload dependencies.

### Senior level

You must reserve enough design space for future services, challenge poor subnet boundaries and explain why an address decision made today may constrain hybrid connectivity years later.

## Recall before reference

Answer before reading the canonical contract below:

1. Why should BlueHarbor not allow each application team to choose any private range that looks unused?
2. What problem does address overlap create once two networks need to communicate?
3. Why are VNets and subnets architectural boundaries rather than just naming containers?
4. Why might a special Azure service require a dedicated subnet later?
5. Why is it useful to reserve address capacity rather than consume the entire VNet immediately?

## Canonical BlueHarbor network contract

### Australia East

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24
```

### Southeast Asia

```text
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

These names and address spaces become architecture contracts. Later modules may extend the estate, but they must not casually rename or recreate these objects.

## Mental model

Think of the VNet address space as land owned by one BlueHarbor site and subnets as deliberately zoned areas inside it.

```text
VNet address space
     |
     +-- workload subnet
     +-- data subnet
     +-- management/shared-services subnet
     +-- future reserved space
```

The important point is not the analogy. It is the engineering rule:

> Connectivity becomes easier to add than address space is to change once dependencies exist.

Later BlueHarbor modules introduce services that can have dedicated-subnet requirements or strong subnet-placement implications. Examples include gateways, Application Gateway, DNS Private Resolver endpoints, App Service integration and other service-specific network components.

Do **not** pre-create all of those future subnets now. Understand why they need space and introduce them only when their business requirement arrives.

## Design exercise — prove the contract

For every VNet/subnet above, be able to state:

```text
owner / workload purpose
region
address space or prefix
why it does not overlap another BlueHarbor network
what growth space remains
which later dependency could make changing it difficult
```

Then draw the three VNets without looking at this README.

## Failure-thinking exercise

A project team proposes a new application VNet using:

```text
10.20.50.0/24
```

They argue that the subnet is currently unused.

Do not answer only with "it overlaps."

Explain:

1. which existing BlueHarbor address contract owns the containing range;
2. why the design may work while isolated;
3. what happens when peering/VPN/transit connectivity is required;
4. why NAT should not be treated as the default cure for poor internal address planning;
5. where the correct long-term fix belongs: application config, Terraform syntax or architecture design.

## Architecture review pressure scenario

**Situation:** A migration team is asking for approval today because their deployment window is tomorrow. Their proposed VNet overlaps a network reserved for a future site.

**Time boundary:** 15 minutes to produce a recommendation.

**You MUST:**

- identify the overlap precisely;
- show the affected range;
- recommend a non-overlapping alternative consistent with the approved plan;
- explain the future connectivity risk.

**You CANNOT:**

- approve it because the networks are not connected yet;
- solve the problem by saying "we can NAT it later" without a justified architecture reason;
- change an existing canonical BlueHarbor range merely to accommodate the late request.

## Communication challenge

**Audience:** Application Project Manager  
**Format:** maximum 120 words

Explain why an apparently unused private IP range can still be unavailable to their project. Avoid subnetting jargon where possible. The project manager should understand the future business risk.

## Evidence for this unit

No Azure evidence is required.

Useful evidence is design evidence:

- VNet/subnet architecture diagram;
- a simple address-plan table;
- one overlap analysis example;
- one short architecture decision explaining why the canonical ranges were frozen.

Do not create evidence folders merely to hold empty placeholders.

## Interview / scenario questions

Answer without notes:

1. What is the difference between a VNet address space and a subnet prefix?
2. Why does non-overlap matter for peering and hybrid connectivity?
3. Why might shared and dedicated subnets both be valid choices depending on the Azure service?
4. What would make you reject an otherwise syntactically valid subnet design?
5. Why should future service-subnet needs influence planning without causing you to build every future subnet now?
6. If a later team asks to change `10.20.0.0/16`, what dependencies would you inspect before agreeing?

## Low-guidance repeat

Close this README and reproduce from memory:

1. all three canonical VNet names and address spaces;
2. the six initial subnet names and prefixes;
3. the reason each VNet exists;
4. three reasons overlapping addressing becomes expensive later;
5. the principle for shared versus dedicated service subnets.

Reopen the README only after attempting the exercise.

## Unit mastery gate

Unit 02 becomes `MASTERED` when:

```text
[ ] I can reproduce the canonical VNet/subnet contract without copying it.
[ ] I can explain CIDR/non-overlap in the context of BlueHarbor rather than as isolated subnet maths.
[ ] I can identify an overlapping proposal and explain the future failure it creates.
[ ] I understand why some later Azure services need deliberate subnet placement.
[ ] I can distinguish future planning from prematurely creating future infrastructure.
[ ] I completed the architecture-review pressure scenario.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
```

No Azure/Terraform deployment gate applies. Unit 04 remains the first persistent infrastructure checkpoint.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
