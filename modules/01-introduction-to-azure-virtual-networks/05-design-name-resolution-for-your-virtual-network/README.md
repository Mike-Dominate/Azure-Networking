# Unit 05 — Design name resolution for your virtual network

**BlueHarbor chapter:** Stop depending on raw IP addresses  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This is a design/mental-model unit. Unit 06 performs the first persistent DNS implementation.

## Business trigger

BlueHarbor's first Azure networks now exist. Application and operations teams have started sharing private IP addresses in tickets and deployment notes.

That is already becoming brittle.

Network Engineering must design a naming model before more workloads arrive, so teams can depend on stable names while the underlying addressing, scaling and service placement evolve.

## Job reality check

### First 30 days

You may be asked why a hostname resolves on one VM but not another, or which DNS server a VNet is actually using.

### 6-12 months

You will need to design private DNS zones, VNet links and custom DNS behaviour while preventing name-resolution changes from breaking applications.

### Senior level

You must distinguish authoritative zones, forwarding, Azure-provided resolution, private service zones and hybrid resolver responsibilities, then decide where each belongs.

## Recall before reference

Answer first:

1. Why does successful IP connectivity not prove DNS is working?
2. Why does successful DNS resolution not prove network connectivity is working?
3. What is the difference between a DNS name and the IP address returned for that name?
4. Why might the same organisation need both public and private DNS namespaces?
5. What future BlueHarbor requirement will make hybrid DNS more complex?

## Mental model

DNS is a name-to-answer system, not a packet-forwarding system.

```text
application asks for name
        |
        v
client chooses configured DNS resolver
        |
        v
resolver finds or forwards answer
        |
        v
client receives IP
        |
        v
network connectivity is attempted separately
```

Therefore:

```text
name resolves successfully
!=
network path is reachable
```

and:

```text
network path works by IP
!=
DNS is configured correctly
```

## BlueHarbor namespace decision

The canonical BlueHarbor-owned private namespace is:

```text
blueharbor.internal
```

Later BlueHarbor-owned records remain beneath that namespace where appropriate.

Microsoft-owned Private Link service zones introduced in Module 7 remain separate because BlueHarbor does not own those namespaces.

## Concepts to master

Explain the role of:

- Azure-provided name resolution;
- custom DNS server settings on VNets;
- Azure Private DNS zones;
- VNet links;
- autoregistration where applicable;
- public DNS zones;
- DNS Private Resolver;
- inbound/outbound resolver endpoints and forwarding rules at a conceptual level;
- public versus private namespace ownership.

Do not deploy DNS Private Resolver yet. Module 2 introduces it when Brisbane/Perth hybrid name resolution creates the real requirement.

## Design exercise

Draw three separate flows:

1. an Azure VM resolving an internal BlueHarbor private name;
2. an Azure workload resolving a public Internet name;
3. a future Brisbane on-premises client resolving an Azure private name after hybrid DNS is introduced.

For each flow identify:

```text
client
configured resolver
zone/forwarding authority
returned answer
separate network path after resolution
```

## Failure-thinking exercise

A user reports:

> "The server is down. I can ping 10.10.2.20 but `app.blueharbor.internal` does not work."

Before changing anything, classify the likely problem domain and list the evidence you would collect.

Then reverse the scenario:

> "The name resolves to 10.10.2.20 but the application still cannot connect."

Explain why this second symptom points you away from DNS as the first suspect.

## Pressure scenario

**Situation:** A new internal application is being launched today. The application team wants to hard-code a private IP because they believe DNS adds unnecessary complexity.

**Time boundary:** 15 minutes to approve/reject and recommend a design.

**You MUST:**

- explain the lifecycle risk of hard-coded addresses;
- identify the private namespace to use;
- state how Azure workloads will eventually resolve the name;
- preserve future hybrid DNS extensibility.

**You CANNOT:**

- deploy hybrid resolver infrastructure early merely to make the diagram look complete;
- invent a second arbitrary BlueHarbor private namespace;
- claim DNS itself provides connectivity or security.

## Communication challenge

**Audience:** Application Developer  
**Format:** maximum 120 words

Explain why their application should depend on a stable internal name rather than a private IP. Include what DNS does and what it does not guarantee.

## Evidence for this unit

Useful evidence is design evidence:

- internal DNS flow diagram;
- public DNS flow diagram;
- future hybrid-resolution diagram;
- short namespace decision record.

No Azure DNS resource is required until Unit 06.

## Interview / scenario questions

Answer without notes:

1. What is the difference between Azure-provided DNS and Azure Private DNS?
2. What does linking a private DNS zone to a VNet accomplish?
3. Why can DNS resolution succeed while the application still fails?
4. Why does BlueHarbor use one parent private namespace rather than inventing a new zone for every project?
5. When does DNS Private Resolver become useful?
6. Why are Microsoft Private Link zones treated differently from `blueharbor.internal`?

## Low-guidance repeat

Close this README and draw the complete internal-resolution path from an Azure workload to a private BlueHarbor record.

Then explain from memory how that design will later extend to on-premises clients without replacing the private namespace.

## Unit mastery gate

Unit 05 becomes `MASTERED` when:

```text
[ ] I can explain DNS resolution separately from network connectivity.
[ ] I understand the role of Azure-provided DNS, Private DNS and custom DNS settings.
[ ] I can explain why `blueharbor.internal` is the canonical private namespace.
[ ] I can describe how VNet links affect private DNS visibility.
[ ] I can explain the future DNS Private Resolver role without deploying it early.
[ ] I completed both failure-thinking scenarios.
[ ] I completed the communication challenge.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
```

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
