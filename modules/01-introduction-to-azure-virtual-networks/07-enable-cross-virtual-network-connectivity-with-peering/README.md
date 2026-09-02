# Unit 07 — Enable cross-virtual network connectivity with peering

**BlueHarbor chapter:** Manufacturing needs Shared Services  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This unit introduces the connectivity model and peering design. Unit 08 becomes the heavier global-peering practical.

## Business trigger

Manufacturing workloads in `bhi-vnet-mfg-aue` need to consume an internal service hosted in Core/Shared Services.

DNS can identify the service, but the VNets remain separate Layer-3 domains. Network Engineering must decide how to connect them without collapsing the address or security model.

## Job reality check

### First 30 days

You may be asked whether two VNets are peered, whether the relationship exists in both directions, and why a DNS answer does not guarantee connectivity.

### 6-12 months

You may need to add or change peering options while protecting existing routes, gateways and workload paths.

### Senior level

You must understand non-transitivity, gateway-transit/service-chaining implications and when direct peering should later be retired because it bypasses a more mature transit/security architecture.

## Recall before reference

Answer first:

1. What does successful private DNS resolution prove?
2. What does it *not* prove?
3. Why is non-overlapping addressing important before peering?
4. Why should you draw the intended traffic path before enabling connectivity?
5. If Core peers with Manufacturing and Research separately, can Manufacturing automatically reach Research through Core just because both peerings exist?

## Mental model

Peering creates private IP connectivity between the peered VNets; it does not merge them into one VNet.

```text
bhi-vnet-mfg-aue
        |
        |  VNet peering
        v
bhi-vnet-core-aue
```

Keep this distinction explicit:

```text
DNS resolution success
!=
network connectivity success
```

Also master the non-transitive mental model. A direct peering between A<->B and B<->C does not by itself make B a generic router that provides A<->C connectivity.

## BlueHarbor design decision

The regional relationship introduced here is:

```text
bhi-vnet-mfg-aue <-> bhi-vnet-core-aue
```

The relationship becomes part of the cumulative architecture.

Later modules may evolve the transit design. A connection that is correct in Module 1 can become an intentional retirement candidate once centralized secured transit exists. That is architecture evolution, not an error in the earlier lesson.

## Design exercise

Before implementation, draw and explain:

1. Manufacturing -> Shared Services by hostname;
2. the DNS step;
3. the separate network path after the IP answer is returned;
4. what changes when peering exists;
5. what does **not** become automatically transitive.

Then identify which later technologies could alter this path:

- VPN/gateway transit;
- Virtual WAN;
- centralized firewall/security inspection.

## Failure-thinking exercise

Scenario A:

> `service.blueharbor.internal` resolves correctly from Manufacturing, but the client cannot connect.

List the first evidence you would inspect before changing DNS.

Scenario B:

> Manufacturing can reach Core, and Research can reach Core. A developer assumes Manufacturing can therefore reach Research through Core.

Explain why that assumption is unsafe and what evidence would prove the actual routing/connectivity model.

## Pressure scenario

**Situation:** A change request says, "Enable Manufacturing access to Shared Services; DNS already works, so this should be a quick DNS change."

**Time boundary:** 15 minutes to correct the change plan before the CAB review.

**You MUST:**

- separate name resolution from connectivity;
- identify the required VNet relationship;
- state what must be validated before and after the change;
- call out non-transitivity explicitly.

**You CANNOT:**

- change DNS records as a substitute for network connectivity;
- claim all BlueHarbor VNets become mutually reachable;
- pre-build Module 2 transit infrastructure.

## Communication challenge

**Audience:** Change Advisory Board  
**Format:** maximum 120 words

Explain why a working DNS query does not mean the Manufacturing-to-Core network change is unnecessary. State the actual change and its main risk.

## Interview / scenario questions

Answer without notes:

1. What does VNet peering change?
2. What does it not change?
3. Why must peered VNets use non-overlapping address spaces?
4. What does non-transitive peering mean operationally?
5. How can DNS success mislead a troubleshooting investigation?
6. Why might BlueHarbor intentionally retire a direct peering in a later security module?

## Low-guidance repeat

Close this README and explain from memory:

```text
name resolution path
vs
network path
vs
future transit path
```

Then draw Core, Manufacturing and Research and state exactly which connectivity exists after Unit 07 and which does not yet exist.

## Unit mastery gate

Unit 07 becomes `MASTERED` when:

```text
[ ] I can distinguish DNS success from network connectivity.
[ ] I can explain VNet peering without describing it as a VNet merge.
[ ] I understand the non-transitive connectivity model.
[ ] I can draw the Manufacturing-to-Core flow from memory.
[ ] I can explain how later gateway/vWAN/security designs may evolve this path.
[ ] I completed the failure-thinking and CAB scenarios.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
```

The peering becomes part of the cumulative Terraform state when implemented and remains until a later architecture decision intentionally changes it.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
