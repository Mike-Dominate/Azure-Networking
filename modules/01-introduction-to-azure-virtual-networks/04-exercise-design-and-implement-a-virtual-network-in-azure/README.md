# Unit 04 — Exercise: Design and implement a virtual network in Azure

**BlueHarbor chapter:** Build the approved network foundation  
**Status:** NOT STARTED  
**Mastery stage:** NOT STARTED

Complete Microsoft's VNet exercise objective using the BlueHarbor architecture approved in Units 01–03.

This is the **first persistent Azure infrastructure checkpoint** in the programme.

## Business trigger

BlueHarbor has completed the initial Azure network design. The architecture team has approved the first cloud network foundation for shared corporate services, manufacturing workloads and research expansion.

The design now has to become a controlled, repeatable Azure deployment without turning into a one-off portal build.

Your responsibility is to implement the approved VNet/subnet foundation so that every later module can safely extend it.

## Job reality check

### First 30 days

You may be asked to inspect existing VNets/subnets, confirm address spaces, identify overlap risk and verify whether deployed Azure state matches documentation.

### 6-12 months

You may need to add subnets or connected VNets without breaking peering, routing, private endpoints, gateways or application dependencies.

### Senior level

You must defend address-space and regional decisions before later hybrid connectivity makes them expensive to change.

## Recall before reference

Before opening Terraform files, answer:

1. Why are Australia East and Southeast Asia both part of the target architecture?
2. Which address spaces were approved in Units 01–03?
3. Why must address overlap be treated as an architecture problem rather than a Terraform syntax problem?
4. Which later capabilities could be affected by poor subnet planning?
5. Why does this unit establish the state lineage for the rest of the programme?

## Mental model

A VNet is not just a container for subnets. In BlueHarbor it becomes the Layer-3 boundary that later receives:

```text
DNS
peering
routes
NAT
VPN / vWAN connectivity
load-balancing components
security controls
private endpoints
monitoring
```

A poor foundation becomes technical debt in almost every later module.

## Architecture delta

Before implementation, state explicitly:

```text
Previous BlueHarbor state:
- approved design
- no persistent Azure network deployment
- no established Terraform remote-state lineage yet

This unit adds:
- first canonical BlueHarbor VNets/subnets
- required Terraform provider/version/variable structure
- backend bootstrap/migration when applicable
- first Azure resources managed by the living Terraform root

This unit must NOT add:
- future VPN/vWAN resources
- future ExpressRoute resources
- future load balancers
- future security/private-link/monitoring resources
```

## Persistent implementation rule

Create the canonical BlueHarbor VNets/subnets through:

```text
blueharbor/terraform/
```

This is not a disposable Terraform rebuild after a manual lab.

Before apply:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Read the plan as an architecture change report.

You should be able to explain every planned resource and why it belongs in Unit 04.

Unexpected destruction or unrelated future resources are a hard stop.

## Independent validation

After apply, do not rely on Terraform output alone.

Use Azure CLI and/or the Portal to independently verify:

- VNet names;
- regions;
- address spaces;
- subnet names;
- subnet prefixes;
- resource-group placement;
- absence of unintended future infrastructure.

For each validation test record:

```text
expected
actual
PASS / FAIL
interpretation
```

The learner should predict the expected answer before running each inspection command.

## Deliberate fault drill

Introduce one safe fault through Terraform after the clean baseline has been proven.

Recommended fault for first execution:

> Change one non-critical subnet prefix to an incorrect but syntactically valid value that does not overlap another subnet.

Then:

1. run `terraform plan`;
2. identify the unexpected architecture delta before applying it;
3. explain what future dependencies could be affected;
4. correct the Terraform configuration;
5. prove the plan returns to the intended state.

The first lesson is deliberate: **good troubleshooting includes preventing a bad change before it reaches Azure.**

A later execution may use a controlled Azure/Terraform drift scenario, but the unit must finish with Terraform and Azure reconciled.

## Diagnostic framework

If deployed state does not match the approved design:

```text
1. Define exactly which name/prefix/region differs.
2. Check Terraform configuration.
3. Check the Terraform plan/state.
4. Inspect actual Azure state independently.
5. Decide whether the problem is code, state, deployment or documentation.
6. Form one hypothesis.
7. Correct the smallest source of truth.
8. Re-plan.
9. Re-validate Azure.
10. Confirm no regression elsewhere.
```

Do not delete and recreate the entire environment simply because one object is wrong.

## Pressure scenario

**Situation:** An application team is ready to deploy a shared service. During the pre-change review, they report that the subnet they were given does not match the approved architecture diagram.

**Time boundary:** 20 minutes for diagnosis and recommendation.

**You MUST:**

- identify whether documentation, Terraform configuration/state or Azure is wrong;
- show evidence;
- state the safest correction;
- verify that no address overlap is introduced.

**You CANNOT:**

- run `terraform destroy`;
- recreate all VNets;
- make more than one architecture change at a time;
- tell the application team to proceed until the source of truth is clear.

**Stakeholder update:** Write a maximum 80-word update explaining what was wrong, whether deployment can proceed and what is being corrected.

## Evidence standard

Useful evidence for this unit:

```text
blueharbor/evidence/m01/u04/
  architecture/
  terraform/
  validation/
  troubleshooting/
  communication/
```

Create these directories only when evidence is actually produced.

Minimum useful artefacts:

- approved VNet/subnet architecture diagram;
- Terraform plan delta for the initial foundation;
- independent Azure inventory proving names/regions/prefixes;
- deliberate-fault investigation note;
- stakeholder update from the pressure scenario.

Never commit secrets, credentials, real tfvars or backend secrets.

## Communication challenge

**Audience:** Application Team Lead  
**Format:** maximum 120 words

Explain why they cannot simply choose any unused-looking subnet range when requesting a new Azure subnet. Explain the consequences in business terms, not CIDR theory alone.

## Interview / scenario questions

Answer without notes:

1. Why is overlapping address space especially dangerous in a hybrid Azure environment?
2. What is the difference between Terraform configuration, Terraform state and actual Azure state?
3. If Azure and Terraform disagree, what evidence would you inspect before changing anything?
4. Why is an unexpected resource replacement in a Terraform plan a hard stop in this programme?
5. How could a subnet decision made in Module 1 affect Private Endpoints or VPN design much later?
6. Why is a successful `terraform apply` insufficient evidence that the architecture is correct?

## Low-guidance repeat

Without this README open:

1. describe the Unit 04 architecture delta;
2. reproduce the validation checklist from memory;
3. explain the relationship between configuration, state and actual Azure resources;
4. inspect the Terraform plan and explain every VNet/subnet change aloud;
5. draw the resulting network foundation from memory.

Do **not** destroy the live cumulative estate for repetition.

## Unit mastery gate

Unit 04 becomes `MASTERED` only when:

```text
[ ] I can explain why each VNet/subnet exists.
[ ] I can draw the deployed foundation from memory.
[ ] I understand the Terraform plan before apply.
[ ] I independently verified Azure names, regions and prefixes.
[ ] I completed a deliberate fault/prevention drill.
[ ] I can distinguish code, state and Azure-state failures.
[ ] I completed the pressure scenario and stakeholder update.
[ ] I produced the required evidence without exposing secrets.
[ ] I answered the scenario/interview questions without notes.
[ ] I completed the low-guidance repeat.
[ ] Terraform and Azure agree at the end.
```

Later units modify this same code/state rather than copy it into new lab folders.

Full programme standard: [`docs/LEARNER-MASTERY-FRAMEWORK.md`](../../../docs/LEARNER-MASTERY-FRAMEWORK.md).
