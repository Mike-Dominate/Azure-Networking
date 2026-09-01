# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Curriculum authority

```text
Microsoft Learn path = module/unit order and primary teaching scope
BlueHarbor story = progressive business context
AZ-700 study guide = completeness additions inside the matching unit
Azure product docs = exact technical behaviour
```

Primary path:
`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

## Story continuity rule

Do not reuse old pre-story practicals just because they exist. If legacy work would interrupt the BlueHarbor progression, rebuild the concept in sequence. Git history is reference only.

## Terraform continuity rule — CRITICAL

This programme uses **one cumulative Terraform implementation**, not one Terraform project per lab.

Canonical root:

```text
blueharbor/terraform/
```

Every practical unit starts from the code, state and deployed resources produced by the previous practical unit.

```text
previous unit
  code + state + Azure resources
           |
           + new BlueHarbor requirement
           v
current unit
  same codebase + incremental Terraform change
```

No routine `terraform destroy` between units/modules. Git commits are the historical checkpoints. Persistent Azure configuration changes are made through Terraform; Azure CLI/Portal/diagnostic tools are used for inspection, validation and troubleshooting.

## Story-design milestone

The progressive BlueHarbor stories for **Modules 1–8 are now designed**.

The intended full arc is:

```text
M1 Build the Azure network foundation
 -> M2 connect BlueHarbor sites/users
 -> M3 mature enterprise private connectivity
 -> M4 make services highly available
 -> M5 deliver HTTP(S) applications intelligently
 -> M6 secure the environment
 -> M7 privatize managed-service access
 -> M8 observe, operate and troubleshoot the complete estate
```

All modules must reuse the architecture produced before them. Nothing may "magically appear" in a later module without being introduced earlier or deliberately added as that module's incremental requirement.

## Current programme phase

- **Curriculum execution position:** Module 1 — Unit 01 remains the first teaching/build unit.
- **Story design:** Modules 1–8 DESIGNED.
- **Current planning task:** **Architecture & Terraform Dependency Audit — NOT STARTED / NEXT**.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.
- **BlueHarbor Azure resources:** NONE required yet.
- **Terraform root:** `blueharbor/terraform/` blueprint exists; first real resources will establish the persistent state lineage after the audit.

## Immediate resume instruction

Do **not** start Module 1 implementation yet.

Perform the complete:

```text
Modules 1–8 Architecture & Terraform Dependency Audit
```

The audit must walk the chain in order:

```text
M1 -> M2 -> M3 -> M4 -> M5 -> M6 -> M7 -> M8
```

For every transition verify:

1. what exists at the end of the previous module;
2. which exact resources/configuration the next module reuses;
3. what new business requirement appears;
4. what Terraform resources/configuration are added;
5. what existing resources must change;
6. whether any change would force avoidable replacement/destruction;
7. whether naming and regions remain consistent;
8. whether subnet/address-space requirements were planned early enough;
9. whether DNS/routing/security dependencies remain coherent;
10. whether the resulting state naturally becomes the next module's starting point.

## Audit targets

Specifically look for:

- inconsistent VNet/subnet/resource names across module stories;
- overlapping or insufficient address spaces;
- special-purpose subnets that appear too late to plan safely;
- duplicate VNets/services recreated by later modules;
- application networks that appear without an earlier origin;
- Virtual WAN/hybrid components being rebuilt instead of extended;
- ExpressRoute dependencies that cannot be realistically represented in the cumulative lab;
- Load Balancer / Application Gateway / Front Door origin inconsistencies;
- Module 6 controls attached to hypothetical rather than existing resources;
- Module 7 private endpoints/DNS attached to invented networks;
- Module 8 monitoring pointed at resources that were never created;
- Terraform changes that would unnecessarily replace earlier resources.

## After the audit passes

Return to:

```text
Microsoft Learn Module 1
Unit 01 — Introduction
```

Then teach/build strictly in order using the cumulative Terraform workflow.

## Unit build loop after audit

```text
Microsoft Learn unit
-> BlueHarbor business event
-> tutorial / mental model
-> architecture / packet / query flow
-> understanding check
-> define delta from existing BlueHarbor estate
-> update SAME Terraform root
-> terraform fmt / init / validate / plan
-> inspect plan for unintended destruction/replacement
-> terraform apply
-> independent Azure/protocol validation
-> deliberate failure / troubleshooting
-> encode permanent fix in Terraform
-> evidence / Git checkpoint
-> carry SAME Terraform state and Azure environment forward
```
