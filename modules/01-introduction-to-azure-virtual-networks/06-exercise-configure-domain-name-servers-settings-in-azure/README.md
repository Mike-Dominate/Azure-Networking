# Unit 06 — Exercise: Configure domain name servers settings in Azure

**BlueHarbor chapter:** Build the internal directory  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This unit turns the Unit 05 DNS design into persistent Azure configuration.

## Business trigger

BlueHarbor's application teams now require stable internal names for services hosted in the Azure estate created in Unit 04.

The architecture decision is already made: BlueHarbor-owned private names use the parent namespace:

```text
blueharbor.internal
```

Your task is to implement that design without inventing a parallel DNS architecture or prematurely deploying the Module 2 hybrid resolver layer.

## Job reality check

### First 30 days

You may be asked to confirm whether a private DNS zone is linked to the correct VNet or why one client gets a DNS answer while another does not.

### 6-12 months

You may need to add records, links and custom DNS settings while preserving existing application resolution.

### Senior level

You must separate zone ownership, VNet visibility, resolver configuration and hybrid forwarding, and prevent local fixes from creating namespace sprawl.

## Recall before reference

Before opening Terraform, answer:

1. What is BlueHarbor's canonical private namespace?
2. What must be true before a VNet can resolve records in an Azure Private DNS zone through the intended Azure path?
3. Why does a DNS answer not prove the destination is reachable?
4. Why are future Microsoft Private Link zones not children of `blueharbor.internal`?
5. Why are DNS Private Resolver endpoints not being deployed in this unit?

## Architecture delta

State the delta before implementation:

```text
Previous state:
- three canonical VNets/subnets
- no BlueHarbor-owned private DNS zone deployed

This unit adds:
- private DNS zone: blueharbor.internal
- required VNet links
- representative BlueHarbor-owned records/autoregistration behaviour where appropriate
- validation evidence

This unit does NOT add:
- hybrid DNS Private Resolver endpoints
- on-premises forwarding rules
- Microsoft Private Link service zones
```

## Persistent implementation rule

Extend the same:

```text
blueharbor/terraform/
```

Do not create a second Terraform root for DNS.

Before apply:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Explain every DNS resource and relationship in the plan before applying.

## Validation standard

After apply, independently prove:

- the zone exists with the correct name;
- the intended VNets are linked;
- the expected record exists or expected registration behaviour is present;
- a client in an intended VNet receives the expected DNS answer;
- a name that should not exist fails as expected;
- connectivity is tested separately from name resolution.

For every test record:

```text
prediction
command/query\actual
PASS / FAIL
interpretation
```

## Deliberate fault drill

Recommended fault:

> Remove or misconfigure one required VNet link through Terraform, apply the controlled change, then investigate the resulting name-resolution failure from the affected VNet.

Do not reveal the diagnosis to yourself from the Terraform diff after the fault is introduced. Start from the client symptom.

Troubleshoot in this order:

```text
1. define exactly which name fails and from which VNet
2. confirm the client's resolver path
3. query the name directly
4. verify whether the zone/record exists
5. inspect VNet links
6. compare with a VNet where resolution still works
7. form one hypothesis
8. restore the intended link through Terraform
9. re-query
10. confirm Terraform and Azure agree
```

## Pressure scenario

**Situation:** Manufacturing can reach a shared service by IP, but its internal hostname stopped resolving after a network change. Core workloads still resolve the same name.

**Time boundary:** 20 minutes to identify the failure domain and restore service.

**You MUST:**

- prove that Layer-3 reachability still exists before blaming routing;
- compare DNS behaviour from at least two VNets;
- inspect the zone and VNet-link relationships;
- make one corrective change at a time;
- restore the permanent configuration through Terraform.

**You CANNOT:**

- hard-code the service IP as the fix;
- create a second private DNS zone for Manufacturing;
- deploy DNS Private Resolver as a workaround;
- report resolved until the hostname query succeeds again.

**Stakeholder update:** maximum 90 words explaining symptom, cause, fix and whether application configuration had to change.

## Evidence standard

Recommended evidence:

```text
blueharbor/evidence/m01/u06/
  architecture/
  terraform/
  validation/
  troubleshooting/
  communication/
```

Minimum useful artefacts:

- private DNS architecture diagram;
- Terraform DNS delta;
- successful query evidence from linked VNets;
- failed-query and root-cause record from the deliberate fault;
- stakeholder update.

## Communication challenge

**Audience:** Application Team  
**Format:** maximum 120 words

Explain why the service failed by name while remaining reachable by IP, and why hard-coding the IP would hide rather than solve the problem.

## Interview / scenario questions

Answer without notes:

1. What does a Private DNS VNet link control?
2. How would you distinguish a DNS failure from a routing failure?
3. Why might one VNet resolve a record while another cannot?
4. Why should a zone-link problem be fixed in Terraform rather than by creating duplicate records elsewhere?
5. When will DNS Private Resolver enter the BlueHarbor architecture, and why then?
6. How would you prove that the fix restored DNS without accidentally claiming application health?

## Low-guidance repeat

Without this README:

1. draw the Unit 06 DNS architecture;
2. reproduce the validation sequence;
3. explain the deliberate-fault diagnostic path;
4. identify the Terraform resources/relationships required conceptually;
5. explain why Module 2 extends rather than replaces this DNS design.

Do not tear down the cumulative estate.

## Unit mastery gate

Unit 06 becomes `MASTERED` when:

```text
[ ] I can explain the private DNS architecture from memory.
[ ] I understand what VNet links change and what they do not change.
[ ] I independently proved the intended DNS queries work.
[ ] I diagnosed a VNet-specific DNS failure from evidence.
[ ] I restored the intended configuration through Terraform.
[ ] I tested connectivity separately from name resolution.
[ ] I completed the timed pressure scenario and stakeholder update.
[ ] I produced useful evidence without secrets.
[ ] I answered the scenario/interview questions without notes.
[ ] I completed the low-guidance repeat.
[ ] Terraform and Azure agree at the end.
```

## Carry-forward

Hybrid DNS in Module 2 extends this design with DNS Private Resolver/forwarding when Brisbane/Perth create the requirement. It does not replace `blueharbor.internal`.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
