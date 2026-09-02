# Unit 11 — Summary

**BlueHarbor chapter:** Module 1 architecture review and mastery board  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

Unit 11 is not a passive recap. It is the Module 1 exit review.

BlueHarbor's Architecture Review Board asks you to prove that you understand and can operate the network foundation built across Units 01–10 before the programme introduces hybrid connectivity in Module 2.

## Business trigger

The first Azure network foundation is ready to become the base for physical-site and remote-user connectivity.

Before the board approves hybrid expansion, Network Engineering must demonstrate that the existing Azure foundation is understood, documented, testable and recoverable.

The board is not asking whether Terraform applied successfully.

It is asking whether you can explain what exists, why it exists, how traffic behaves, where it can fail and how you would investigate it.

## Module 1 end state

You should be able to draw from memory:

```text
Australia East

bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

       <---- regional peering ---->

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24 -> nat-mfg-aue -> NAT public IP -> Internet
  snet-mfg-data         10.20.2.0/24

Southeast Asia

bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24

       <---- global peering ---->

bhi-vnet-core-aue

Private DNS:
blueharbor.internal
+ required VNet links

Routing:
Module 1 route/effective-route learning and approved workload-subnet route controls
```

One Azure Blob Terraform state lineage carries the estate forward.

## What you must explain without notes

### Addressing and segmentation

- why each VNet exists;
- why the address spaces do not overlap;
- why current subnets were created and future special-purpose subnets were not pre-created;
- how a bad address decision can hurt later hybrid/private-access work.

### Public addressing

- public versus private identity;
- inbound exposure versus outbound egress;
- individual public IP, Public IP Prefix and Custom IP Prefix/BYOIP decision boundaries.

### DNS

- the path from client query to private DNS answer;
- `blueharbor.internal` ownership;
- VNet-link behaviour;
- why DNS success and connectivity success are independent;
- how Module 2 will extend private DNS into hybrid resolution.

### Peering

- Core<->Manufacturing regional peering;
- Core<->Research global peering;
- why peering is not transitive;
- why later secured transit may intentionally retire direct paths.

### Routing

- system routes, UDRs and effective routes;
- how to prove the winning route/next hop;
- why route tables are not attached blindly to special-purpose subnets;
- the roles of forced tunneling, AVNM and Route Server at the appropriate conceptual depth.

### NAT

- why `snet-mfg-app` receives NAT-managed outbound connectivity;
- how SNAT changes external source identity;
- why NAT Gateway does not publish workloads inbound;
- why later firewall egress may change some path assumptions.

## Architecture-board challenge

Without opening earlier unit READMEs, answer these questions in one session:

1. A Manufacturing hostname resolves but the service cannot be reached. Where do you start and why?
2. Research can reach Core, and Manufacturing can reach Core. Can Research reach Manufacturing automatically? Explain.
3. A new route table was deployed successfully and Manufacturing lost connectivity. What evidence proves the actual path?
4. A private Manufacturing VM reaches the Internet. How can that happen without a public IP on the VM?
5. An application team proposes a new overlapping VNet because it is not connected yet. Why do you reject it?
6. A supplier asks for a stable public allow-list. What questions determine whether you need one public IP, a prefix or an external/BYOIP process?
7. Why might a direct peering that is correct today become a security problem later?
8. What is the relationship between Terraform configuration, Terraform state and actual Azure state?

## Module regression validation

Run an end-of-module validation pack against the deployed estate.

At minimum prove all applicable behaviours:

```text
[ ] canonical VNet names / regions / address spaces are correct
[ ] canonical subnet prefixes are correct
[ ] blueharbor.internal and intended VNet links are correct
[ ] representative private DNS query returns the expected result
[ ] Core <-> Manufacturing intended connectivity works
[ ] Core <-> Research intended connectivity works
[ ] no transitive connectivity is claimed without evidence
[ ] selected effective-route expectations are correct
[ ] snet-mfg-app is associated with nat-mfg-aue
[ ] approved Manufacturing outbound behaviour works where test workload exists
[ ] unrelated subnets did not acquire unintended NAT/route associations
[ ] terraform validate passes
[ ] terraform plan shows no unexplained drift/change
[ ] terraform state contains the expected Module 1 estate
```

For each operational test record expected result, actual result and interpretation.

## Cross-unit incident challenge

This is the first multi-symptom challenge.

**Situation:** Manufacturing reports that an internal shared service is unavailable by hostname and external update access also fails. Research can still resolve the shared-service hostname and reach Core.

You are **not** told whether there is one fault or multiple faults.

**Time boundary:** 35 minutes for triage, diagnosis and recovery plan.

**You MUST:**

- build a symptom matrix before changing anything;
- use Research as known-good comparative evidence;
- test DNS and network connectivity separately;
- inspect Manufacturing route/NAT relationships;
- state a hypothesis before each corrective change;
- make the smallest fixes through Terraform;
- run the complete regression pack afterward.

**You CANNOT:**

- destroy/rebuild the environment;
- hard-code IPs;
- add public IPs to private workloads as a shortcut;
- deploy Module 2/6 infrastructure as a workaround;
- assume every symptom has the same cause.

## Incident record

Produce a concise engineering record:

```text
business impact
symptoms
what still worked
hypotheses tested
evidence
root cause(s)
corrective action
regression result
prevention / lesson
```

## Communication challenge

**Audience:** Architecture Review Board  
**Format:** maximum 250 words

Explain the Module 1 architecture to a mixed technical/non-technical audience:

- what BlueHarbor can now do;
- how internal naming/connectivity/outbound access work;
- the main failure domains;
- why the estate is ready for hybrid expansion;
- what Module 1 deliberately did **not** build yet.

## Portfolio evidence review

Before Module 2, confirm the evidence accumulated across Module 1 can prove the work without a live verbal explanation.

A strong Module 1 portfolio should include examples of:

- architecture/addressing diagrams;
- Terraform plan deltas;
- independent Azure validation;
- DNS query evidence;
- peering before/after validation;
- effective-route troubleshooting;
- NAT egress validation;
- deliberate-fault/root-cause records;
- stakeholder communications.

Do not manufacture evidence for concept units that did not deploy resources. Evidence should match the work actually performed.

## Closed-book Module 1 review

Close all Module 1 READMEs.

From memory:

1. draw the full Module 1 architecture;
2. explain a packet/name flow from Manufacturing to a Core service by hostname;
3. explain a packet flow from Manufacturing to the Internet;
4. describe the effective-route troubleshooting sequence;
5. explain why Research does not automatically transit through Core to Manufacturing;
6. list the main persistent Terraform additions in the order they appeared;
7. explain how Module 2 will extend rather than replace this estate.

Then compare your answer with the repository.

## Module 1 mastery gate

Module 1 is `MASTERED` only when:

```text
[ ] I can draw the full Module 1 architecture from memory.
[ ] I can explain addressing/subnet decisions and future consequences.
[ ] I can separate DNS, routing, peering and NAT failure domains.
[ ] I can independently validate the deployed estate.
[ ] I can troubleshoot from effective Azure state rather than random changes.
[ ] I completed the cross-unit incident challenge.
[ ] I restored all deliberate faults and Terraform/Azure agree.
[ ] I passed the module regression validation pack.
[ ] I can explain the architecture to the review board in plain English.
[ ] My evidence demonstrates build, validation and troubleshooting ability.
[ ] I completed the closed-book Module 1 review.
[ ] I can explain exactly what Module 2 inherits.
```

## Carry-forward contract into Module 2

Module 2 starts from this exact estate:

```text
three canonical VNets/subnets
blueharbor.internal private DNS architecture / links
Core <-> Manufacturing peering
Core <-> Research global peering
approved Module 1 routing configuration
nat-mfg-aue association to snet-mfg-app
one Azure Blob Terraform state lineage
```

Do not reset the environment.

## Next business problem

BlueHarbor still operates physical sites and supports remote engineers.

That creates the next requirement naturally:

> How do networks and users outside Azure reach the estate we just built?

Proceed to Module 2 — Design and implement hybrid networking — only after the Module 1 mastery gate is satisfied.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
