# Unit 03 — Configure public IP services

**BlueHarbor chapter:** Understand exposure before creating a public endpoint  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This is a concept/design unit. BlueHarbor does **not** create a throwaway persistent public endpoint here.

## Business trigger

Operations asks whether a future Azure workload can simply receive a public IP so users can reach it from the Internet.

Security immediately pushes back: public reachability, outbound Internet access, frontend exposure and security policy are not the same thing.

Before any public-facing BlueHarbor service is deployed, Network Engineering must establish the public-addressing mental model and the rules for when public IP resources are justified.

## Job reality check

### First 30 days

You may be asked to identify which Azure resource owns a public IP, whether the address is static, and whether that public IP is actually the source of application exposure.

### 6-12 months

You may need to design public frontends for gateways, load balancers or application-delivery services while keeping backend workloads private.

### Senior level

You must decide when to use individual public IPs, Public IP Prefix, or a provider/BYOIP model, and explain lifecycle, availability, allow-listing and ownership implications.

## Recall before reference

Answer first:

1. Does a private VM need its own public IP to reach the Internet?
2. Does assigning a public IP automatically make an application securely reachable?
3. What other Azure component usually controls whether a service is actually listening/allowed?
4. Why might a stable public address matter to a third party?
5. Why should public IP lifecycle be considered before application teams hard-code addresses?

## Mental model

Keep these ideas separate:

```text
public IP address
    = routable address resource

inbound exposure
    = address + frontend/listener/rule + path + security policy

outbound Internet
    = egress path; may use NAT or another managed egress design
```

Therefore:

```text
public IP != firewall policy
public IP != application listener
public IP != automatic inbound reachability
public IP != the only way to get outbound access
```

## Concepts to master

Cover and explain in BlueHarbor terms:

- public versus private addressing;
- static versus dynamic allocation where applicable;
- current SKU/availability implications;
- association and lifecycle of the address resource;
- inbound exposure versus outbound connectivity;
- why backends can stay private behind public frontends;
- when a stable contiguous range could justify Public IP Prefix;
- why Custom IP Prefix/BYOIP depends on real external ownership and validation.

## Study-guide extension — Public IP Prefix and Custom IP Prefix

The current AZ-700 study-guide coverage requires these concepts even though the visible Learn unit may be lighter.

### Public IP Prefix

Be able to explain when a contiguous Azure-allocated public range is useful, for example:

- stable allow-listing;
- predictable address inventory;
- scale where multiple public IP resources are expected.

Do not create a persistent prefix merely to tick a box. A controlled experiment is optional only if it adds genuine learning value and does not distort the cumulative architecture.

### Custom IP Prefix / BYOIP

Treat this honestly.

A real implementation requires an organisation-owned public prefix and validation/Internet-routing prerequisites. BlueHarbor does not pretend to own a public range.

Master the lifecycle, responsibilities and decision factors without fabricating provider ownership.

## Failure-thinking exercise

An application owner says:

> "We attached a public IP, so the service is now available and secured on the Internet."

Identify at least five assumptions hidden inside that sentence.

Your answer should separate:

```text
address ownership
frontend/listener association
routing
security rules
application health
TLS/application configuration
```

## Pressure scenario

**Situation:** A supplier needs a stable source or frontend address for allow-listing before tomorrow's integration test.

**Time boundary:** 15 minutes to recommend an addressing approach.

**You MUST:**

- establish whether the requirement is inbound frontend identity or outbound source identity;
- determine whether one address or a scalable contiguous set is expected;
- explain the lifecycle/ownership implication;
- avoid assigning public IPs directly to every backend just because it is easy.

**You CANNOT:**

- recommend BYOIP without verified ownership prerequisites;
- treat a public IP as the security control;
- deploy a throwaway persistent production dependency in this concept unit.

## Communication challenge

**Audience:** Application Owner  
**Format:** maximum 120 words

Explain why "give the VM a public IP" is not a complete Internet-publishing design. Include one safer architectural pattern without diving into Terraform syntax.

## Evidence for this unit

No persistent Azure implementation evidence is required.

Useful evidence:

- a one-page public/private/inbound/outbound decision diagram;
- a short comparison of individual public IP vs Public IP Prefix vs Custom IP Prefix;
- the pressure-scenario recommendation.

## Interview / scenario questions

Answer without notes:

1. What problem does a public IP resource solve, and what problems does it not solve?
2. How can a backend remain private while a service is publicly reachable?
3. Why are outbound Internet access and inbound Internet exposure separate design decisions?
4. When would Public IP Prefix be more appropriate than unrelated individual addresses?
5. What makes Custom IP Prefix an ownership/provider problem as well as an Azure configuration problem?
6. Why is a stable public address sometimes a business contract rather than a purely technical setting?

## Low-guidance repeat

Close this README and draw four boxes from memory:

```text
private workload
public frontend
security control
outbound egress
```

Explain how they can be combined without assuming that every workload needs a public IP.

Then explain the three public-prefix choices from memory.

## Unit mastery gate

Unit 03 becomes `MASTERED` when:

```text
[ ] I can distinguish public addressing, inbound exposure, security and outbound egress.
[ ] I understand why a public IP is not a firewall or application listener.
[ ] I can explain when stable/contiguous public addressing matters.
[ ] I can compare individual public IP, Public IP Prefix and Custom IP Prefix honestly.
[ ] I completed the pressure scenario without inventing a fake external prerequisite.
[ ] I can explain the concept to an application owner in plain English.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
```

The first persistent Terraform checkpoint remains Unit 04. Public IP resources appear later when the BlueHarbor story genuinely requires them.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
