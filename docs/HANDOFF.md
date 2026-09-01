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

No routine `terraform destroy` between units/modules. Git commits are the historical checkpoints. The working tree always represents the latest complete BlueHarbor architecture.

Persistent Azure configuration changes should be made through Terraform. Azure CLI/Portal are used for inspection, validation and troubleshooting rather than creating a second unmanaged version of the environment.

## Current status

- **Current module:** Module 1 — Introduction to Azure Virtual Networks
- **Current unit:** Unit 01 — Introduction
- **Project:** BlueHarbor Industries cumulative Azure networking build
- **Current phase:** Begin story / requirements and mental model
- **Azure deployment:** NOT STARTED
- **BlueHarbor Azure resources:** NONE required for Unit 01
- **Terraform root:** `blueharbor/terraform/` blueprint exists; first actual resources are added at the first applicable practical
- **Modules 2–8:** NOT STARTED

## Immediate resume instruction

Start Microsoft Learn Module 1 from the beginning:

```text
Unit 01 — Introduction
```

Then proceed strictly in Microsoft Learn order:

```text
01 Introduction
02 Explore Azure Virtual Networks
03 Configure public IP services
04 Exercise: Design and implement a virtual network in Azure
05 Design name resolution for your virtual network
06 Exercise: Configure domain name servers settings in Azure
07 Enable cross-virtual network connectivity with peering
08 Exercise: Connect two Azure virtual networks using global VNet peering
09 Implement virtual network traffic routing
10 Configure internet access with Azure Virtual NAT
11 Summary
```

## Required teaching/build loop

```text
Microsoft Learn unit
-> BlueHarbor business event
-> teach full tutorial / mental model
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
-> revalidate
-> evidence / Git checkpoint
-> carry SAME Terraform state and Azure environment forward
```

Do not deploy Azure resources before the relevant tutorial and understanding check are complete.

## Drift prevention

Before any new topic:

1. identify the exact Microsoft Learn module and unit;
2. state the BlueHarbor business problem for that unit;
3. teach Microsoft's objective first;
4. add study-guide depth only inside the matching unit;
5. do not create a parallel topic/lab sequence;
6. do not allow legacy evidence to dictate the project design;
7. do not create a separate Terraform state/root for the new unit;
8. confirm the new Terraform plan preserves prior BlueHarbor infrastructure unless a replacement is intentional.
