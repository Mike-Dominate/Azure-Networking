# Unit 09 — Implement virtual network traffic routing

**BlueHarbor chapter:** Connectivity exists, but the path must be controlled  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This unit moves the learner from "is there connectivity?" to "why did Azure choose this path?"

## Business trigger

BlueHarbor now has multiple connected VNets. Security and architecture teams no longer accept uncontrolled assumptions about how traffic leaves workload subnets.

Network Engineering must understand Azure system routes, user-defined routes, next-hop selection and effective-route evidence before later modules introduce gateways, Virtual WAN and centralized firewall transit.

## Job reality check

### First 30 days

You may be asked why a VM can reach one network but not another and expected to inspect the effective route rather than guess.

### 6-12 months

You may need to introduce route tables, next-hop controls and forced-path designs without black-holing existing traffic.

### Senior level

You must reason about route precedence, propagation, service chaining, gateway transit, NVA/firewall paths and the interaction between direct peering and centralized transit.

## Recall before reference

Answer before changing anything:

1. Which VNets are currently connected in Module 1?
2. Why does a peering relationship not tell you every route that a NIC will actually use?
3. What is the purpose of an effective route table?
4. Why can a valid UDR still cause an outage?
5. Why should route tables not be blanket-associated with every future special-purpose subnet?

## Mental model

Treat routing as a decision process:

```text
packet destination
      |
      v
candidate routes
      |
      v
Azure chooses the effective route / next hop
      |
      v
packet follows that path or is dropped/unreachable
```

The configuration you intended is less important than the route Azure actually made effective.

Master these ideas:

- system routes;
- user-defined routes;
- route-table association;
- next-hop types;
- effective routes;
- longest-prefix reasoning;
- route propagation concepts;
- forced tunneling as a design pattern;
- service chaining and gateway-transit concepts;
- why routing can evolve when Virtual WAN or Azure Firewall later enters the architecture.

## Study-guide extension — Azure Virtual Network Manager and Route Server

### Azure Virtual Network Manager

Understand how network groups/connectivity configurations can manage connectivity at scale. A controlled experiment may be performed against the existing VNets if it adds learning value, but do not leave behind connectivity that conflicts with the planned Virtual WAN/secured-transit architecture.

### Azure Route Server

Master the BGP/NVA use case, control-plane role and troubleshooting model.

Do **not** deploy Route Server into a BlueHarbor VNet that is or will be connected to Virtual WAN merely to tick a coverage box. The programme treats current platform compatibility constraints honestly rather than building a contradictory architecture.

## Architecture delta

Before implementation, state:

```text
what the current system/peering path is
what traffic needs deliberate path control
which workload subnet should receive the route table
what next hop is intended
which special-purpose/future subnets must remain untouched
```

The route-table implementation must be the smallest change that teaches the current objective without pre-building Module 6 secured transit.

## Validation standard

For the chosen workload path, capture:

```text
source
intended destination
expected effective route
expected next hop
actual effective route
actual next hop
connectivity result
interpretation
```

Do not infer success from the existence of a route-table resource.

## Deliberate fault drill

Introduce a safe but wrong route through Terraform that causes a predictable path failure on the selected normal workload subnet.

Examples may include:

- a more-specific UDR with an incorrect next hop;
- a route that intentionally black-holes a test destination;
- an association to the wrong normal workload subnet.

The exact exercise should match the resources available at execution time.

Start from the symptom and use effective-route evidence to diagnose it.

## Diagnostic framework

```text
1. define source, destination and failing protocol
2. confirm the source NIC/subnet
3. inspect the subnet's route-table association
4. inspect effective routes on the source NIC
5. identify the winning prefix and next hop
6. compare expected vs actual path
7. check the next-hop dependency only after the route is understood
8. form one hypothesis
9. change the smallest Terraform source of truth
10. re-plan / apply
11. re-test the original flow
12. regression-test unaffected Module 1 paths
```

## Pressure scenario

**Situation:** Manufacturing loses access to a required Core service immediately after a routing change. DNS still resolves correctly and Core itself is healthy.

**Time boundary:** 25 minutes to restore the path and explain the cause.

**You MUST:**

- inspect effective routes;
- identify the winning route and next hop;
- explain why DNS is not the primary failure domain;
- make one routing change at a time;
- restore the permanent configuration through Terraform;
- re-test Core/Manufacturing and Research/Core paths.

**You CANNOT:**

- delete all route tables;
- add a public IP as a workaround;
- change DNS records to route around the issue;
- deploy Azure Firewall early to hide the route mistake.

**Stakeholder update:** maximum 100 words for the Infrastructure Manager.

## Communication challenge

**Audience:** Infrastructure Manager  
**Format:** maximum 120 words

Explain why a route table that deployed successfully can still cause an outage. Describe how effective-route evidence was used to prove the actual path.

## Evidence standard

Minimum useful artefacts:

- before/after effective-route evidence;
- Terraform routing delta;
- deliberate-fault root-cause record;
- regression results for earlier peering paths;
- pressure-scenario stakeholder update.

## Interview / scenario questions

Answer without notes:

1. What is the difference between a route table resource and an effective route?
2. Why can the most specific route change the path you expected?
3. How would you prove which next hop Azure selected?
4. Why should UDRs not be associated blindly with special-purpose subnets?
5. What is forced tunneling, and why is Module 1 not yet the final production implementation of it?
6. What problem does Route Server solve, and why is it treated carefully in the BlueHarbor Virtual WAN architecture?
7. How can Azure Virtual Network Manager affect connectivity at scale?
8. Why is routing troubleshooting stronger when it starts from source/destination/effective state rather than from the route-table definition?

## Low-guidance repeat

Close this README and reproduce from memory:

1. the routing decision mental model;
2. the effective-route troubleshooting sequence;
3. three ways a UDR can break a workload path;
4. why Route Server is learned but not forced into the cumulative topology;
5. how later secured transit will change the assumptions made in Module 1.

## Unit mastery gate

Unit 09 becomes `MASTERED` when:

```text
[ ] I can explain system routes, UDRs and effective routes.
[ ] I can identify the winning route/next hop from evidence.
[ ] I understand why a syntactically valid route can be architecturally wrong.
[ ] I diagnosed a deliberate routing failure from effective state.
[ ] I restored the intended configuration through Terraform.
[ ] I regression-tested earlier Module 1 connectivity.
[ ] I understand the AVNM and Route Server study-guide extensions without distorting BlueHarbor.
[ ] I completed the timed pressure scenario and stakeholder update.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
[ ] Terraform and Azure agree at the end.
```

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
