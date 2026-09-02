# Unit 10 — Configure internet access with Azure Virtual NAT

**BlueHarbor chapter:** Private Manufacturing workloads need a controlled Internet exit  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

This unit adds the first explicit managed outbound Internet path to the cumulative BlueHarbor estate.

## Business trigger

Manufacturing application workloads need outbound access for approved software updates and external services.

Security does not want individual public IP addresses attached to every workload VM, and the network team needs predictable subnet-level egress that can later be compared with load-balancer and firewall egress designs.

The approved Module 1 solution is Azure NAT Gateway for the Manufacturing application subnet.

## Job reality check

### First 30 days

You may be asked why a private VM can reach the Internet without owning a public IP, or which resource provides its source NAT.

### 6-12 months

You may need to move workloads between egress models, diagnose SNAT/outbound failures and prove which subnet is associated with which NAT Gateway.

### Senior level

You must choose between NAT Gateway, load-balancer outbound rules, firewall egress or other architecture patterns based on security, scale, observability and control requirements.

## Recall before reference

Answer first:

1. Why is outbound Internet access different from unsolicited inbound Internet access?
2. Why should each Manufacturing VM not receive its own public IP merely to download updates?
3. At what scope is the approved NAT association applied in BlueHarbor?
4. Why must NAT not be attached blindly to every subnet?
5. Which later module will introduce centralized firewall egress that may change some earlier assumptions?

## Mental model

```text
private workload
  10.20.1.x
      |
      v
snet-mfg-app
      |
      v
NAT Gateway association
      |
      v
NAT public IP identity
      |
      v
Internet
```

For an outbound flow, NAT changes the source identity seen externally. It does not create an unsolicited inbound listener to the workload.

```text
managed outbound SNAT
!=
public inbound publishing
```

## Canonical BlueHarbor implementation contract

The Module 1 estate finishes this unit with:

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
         |
         +-- nat-mfg-aue
                |
                +-- explicit NAT public IP resource
```

The exact AzureRM resource/provider syntax is validated when the unit is executed. The architecture contract is fixed: `snet-mfg-app` has explicit NAT-managed outbound connectivity.

This association remains useful to later Manufacturing workloads, including the Module 4 Australia East telemetry backends, until a later explicit architecture decision changes the egress model.

## Architecture delta

```text
Previous state:
- Manufacturing subnet exists
- no approved subnet-level NAT Gateway association

This unit adds:
- NAT Gateway
- public IP identity required by the NAT design
- association to snet-mfg-app only

This unit does NOT:
- publish Manufacturing workloads inbound
- assign public IPs to every backend
- attach NAT automatically to every subnet
- deploy Azure Firewall early
```

## Persistent implementation

Extend the same:

```text
blueharbor/terraform/
```

Before apply:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Explain:

- the NAT Gateway resource;
- its public IP dependency;
- the subnet association;
- why no unrelated subnet should change.

Unexpected subnet associations or replacements are a hard stop.

## Validation standard

Independently prove:

- `nat-mfg-aue` exists;
- the intended public IP resource is associated correctly;
- `snet-mfg-app` is associated with the NAT Gateway;
- an appropriate Manufacturing test workload has outbound connectivity when available;
- the observed outbound source identity matches the intended NAT design when a safe external echo/check is available;
- unsolicited inbound access was not created by the NAT association;
- unrelated subnets were not unintentionally associated.

Predict the outcome before every check.

## Deliberate fault drill

Recommended fault:

> Remove the NAT Gateway association from `snet-mfg-app` through Terraform, or associate the NAT Gateway to the wrong normal workload subnet in a controlled exercise.

Use the resulting symptom to determine whether the problem is:

```text
workload network configuration
subnet association
NAT Gateway/public IP dependency
route/security path
external destination
```

Restore the approved association through Terraform and re-test.

## Diagnostic framework

```text
1. define source workload and destination
2. prove private subnet/IP configuration is intact
3. inspect subnet NAT association
4. inspect NAT Gateway/public IP state
5. inspect relevant effective routing/security state
6. compare with a known-good outbound path if one exists
7. form one hypothesis
8. change the smallest Terraform source of truth
9. re-plan/apply
10. verify outbound connectivity/source identity
11. verify no inbound exposure was introduced
12. regression-test Module 1 internal connectivity
```

## Pressure scenario

**Situation:** Manufacturing servers can reach internal BlueHarbor services but suddenly cannot reach an approved external update endpoint. No application configuration changed.

**Time boundary:** 25 minutes to restore approved egress.

**You MUST:**

- prove internal connectivity still works;
- inspect the subnet/NAT relationship;
- verify the NAT public identity/dependency;
- avoid changing inbound security as a guess;
- restore the permanent fix through Terraform;
- verify internal Module 1 paths after recovery.

**You CANNOT:**

- assign public IPs directly to the affected workloads as a workaround;
- open inbound ports;
- attach NAT to every subnet;
- deploy Azure Firewall early just to restore Internet access.

**Stakeholder update:** maximum 100 words for the Manufacturing Platform Lead.

## Communication challenge

**Audience:** Manufacturing Platform Lead  
**Format:** maximum 120 words

Explain how private servers can reach approved Internet services through NAT Gateway without becoming directly reachable from the Internet.

## Evidence standard

Minimum useful artefacts:

- Terraform NAT delta;
- subnet-association evidence;
- outbound validation/source-identity evidence where practical;
- deliberate-fault/root-cause record;
- proof that unrelated subnets were unchanged;
- stakeholder update.

## Interview / scenario questions

Answer without notes:

1. What problem does NAT Gateway solve for BlueHarbor?
2. At what scope is NAT Gateway associated?
3. Why does NAT-managed outbound not create unsolicited inbound access?
4. How would you prove that a workload is actually using the intended NAT path?
5. Why can attaching NAT to every subnet be a bad architecture pattern?
6. When might Azure Firewall egress be preferred later?
7. How does NAT Gateway differ conceptually from a public Load Balancer frontend?
8. Why is the NAT public IP a shared egress identity rather than a public identity of each backend?

## Low-guidance repeat

Close this README and:

1. draw the complete outbound flow from `snet-mfg-app` to the Internet;
2. explain what NAT changes in the packet identity;
3. reproduce the validation sequence;
4. explain three possible causes of an outbound failure;
5. state why the Module 1 NAT design may later evolve rather than remain universally correct forever.

Do not destroy the cumulative estate.

## Unit mastery gate

Unit 10 becomes `MASTERED` when:

```text
[ ] I can explain outbound NAT separately from inbound publishing.
[ ] I understood the Terraform NAT/public-IP/subnet delta before apply.
[ ] I independently verified the intended subnet association.
[ ] I proved approved outbound behaviour where a test workload is available.
[ ] I verified NAT did not create direct inbound exposure.
[ ] I diagnosed and recovered a NAT-related failure from evidence.
[ ] I restored the intended architecture through Terraform.
[ ] I regression-tested internal Module 1 connectivity.
[ ] I completed the pressure scenario and stakeholder update.
[ ] I answered the interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
[ ] Terraform and Azure agree at the end.
```

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
