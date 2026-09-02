# Unit 08 — Exercise: Connect two Azure virtual networks using global virtual network peering

**BlueHarbor chapter:** Research must reach Core across regions  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This is the Module 1 peering practical. It preserves Microsoft's global-peering objective while extending the same BlueHarbor estate.

## Business trigger

The Research division in Southeast Asia needs private access to a shared service hosted in Core in Australia East.

The two VNets already exist, use non-overlapping address spaces and have the private-DNS foundation from Unit 06. The business now needs cross-region connectivity without creating a second Research network or rebuilding Core.

## Job reality check

### First 30 days

You may be asked to confirm whether cross-region peering exists and distinguish a DNS, peering or workload-level failure.

### 6-12 months

You may need to add cross-region connectivity while validating route behaviour and avoiding assumptions about transitivity.

### Senior level

You must defend direct global peering versus hub/transit alternatives and recognize when a later security architecture should retire a direct bypass path.

## Recall before reference

Before opening Terraform, answer:

1. Which two canonical VNets are being connected?
2. Why must you prove the pre-change isolation first?
3. Why is a successful DNS lookup insufficient proof that Research can reach Core?
4. What does non-transitive peering mean for Research, Core and Manufacturing?
5. Why should this unit modify the same Terraform state rather than create a new regional lab?

## Architecture delta

```text
Previous state:
- Core AUE exists
- Manufacturing AUE exists
- Research SEA exists
- Core <-> Manufacturing regional peering exists
- private DNS architecture exists

This unit adds:
- Core AUE <-> Research SEA global VNet peering

This unit does NOT add:
- generic Research <-> Manufacturing transit
- VPN/vWAN
- centralized firewall transit
```

## Pre-change proof

Before changing Terraform, prove the relevant Research-to-Core network path is absent or unavailable as expected.

Record:

```text
expected result
actual result
why the failure is expected
```

The purpose is to create a clean before/after experiment rather than assume the new configuration caused success.

## Persistent implementation

Extend:

```text
blueharbor/terraform/
```

Run and interpret:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

The plan should show the intended peering delta without unrelated replacements.

After apply, independently inspect the peering state and then test actual connectivity between suitable endpoints/workloads when present.

## Validation sequence

Use a layered validation model:

```text
1. confirm peering objects/settings exist
2. confirm expected route/connectivity state
3. test the intended Research -> Core path
4. verify DNS separately if hostname is used
5. prove no claim of automatic Research -> Manufacturing transit
6. regression-test Core <-> Manufacturing
```

Predict each result before running the test.

## Deliberate fault drill

Introduce one reversible peering-related configuration fault through Terraform.

The exact fault should be chosen at execution time from currently supported peering settings, but it must create a meaningful connectivity or control-plane symptom without corrupting the wider estate.

Investigation must begin from the symptom, not from rereading the changed line.

Record:

```text
symptom
what still works
expected path
hypothesis
evidence
root cause
fix
verification
regression result
```

## Diagnostic framework

When cross-VNet connectivity fails:

```text
1. define source and destination precisely
2. confirm name resolution separately if a hostname is involved
3. inspect peering state in both directions
4. inspect effective routes / expected next-hop behaviour where available
5. inspect workload security/host state only after the network path is understood
6. compare with a known-good peered path
7. form one hypothesis
8. correct the smallest source of truth in Terraform
9. re-test the original failure
10. regression-test earlier connectivity
```

## Pressure scenario

**Situation:** Research reports that the shared Core service became unreachable after a network change. Manufacturing access to the same Core service is still healthy.

**Time boundary:** 25 minutes to isolate and recover the fault.

**You MUST:**

- use the healthy Manufacturing path as comparative evidence;
- separate DNS and connectivity tests;
- inspect the global-peering relationship before rebuilding anything;
- restore the permanent configuration in Terraform;
- verify both Research->Core and Manufacturing->Core after the fix.

**You CANNOT:**

- create a new Research VNet;
- add a VPN as a workaround;
- assume a global Azure outage without evidence;
- report success after only the peering object looks healthy.

**Stakeholder update:** maximum 100 words for the Research Engineering Lead.

## Evidence standard

Minimum useful artefacts:

- before/after connectivity results;
- Terraform peering delta;
- independent peering-state evidence;
- deliberate-fault diagnostic record;
- regression results;
- stakeholder update.

## Communication challenge

**Audience:** Research Engineering Lead  
**Format:** maximum 120 words

Explain what global VNet peering provides, why Research remains a separate network, and why this does not mean every BlueHarbor VNet can automatically route through Core to every other VNet.

## Interview / scenario questions

Answer without notes:

1. Why is a before-failure test useful before adding peering?
2. What is the difference between regional and global peering from an architecture perspective?
3. How would you separate a DNS issue from a peering issue?
4. Why must both the intended path and earlier paths be regression-tested after a peering change?
5. Why is non-transitivity relevant to hub-and-spoke designs?
6. Why may this direct global peering later be retired when secured transit is introduced?

## Low-guidance repeat

Without this README:

1. draw the full three-VNet Module 1 topology;
2. identify the two peerings that now exist;
3. state what connectivity still must not be assumed;
4. reproduce the troubleshooting sequence for a Research->Core failure;
5. explain the before/after validation experiment.

Do not destroy the cumulative estate.

## Unit mastery gate

Unit 08 becomes `MASTERED` when:

```text
[ ] I proved the pre-change connectivity expectation.
[ ] I understood the Terraform peering delta before apply.
[ ] I independently verified the global peering.
[ ] I proved the intended Research-to-Core behaviour.
[ ] I did not incorrectly claim transitive connectivity.
[ ] I diagnosed and recovered a peering-related fault from evidence.
[ ] I regression-tested the earlier Core-to-Manufacturing path.
[ ] I completed the timed incident and stakeholder update.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
[ ] Terraform and Azure agree at the end.
```

This peering is carried into Module 2 until a later explicit architecture evolution changes it.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
