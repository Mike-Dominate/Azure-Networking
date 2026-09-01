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

## Current status

- **Current module:** Module 1 — Introduction to Azure Virtual Networks
- **Current unit:** Unit 01 — Introduction
- **Project:** BlueHarbor Industries progressive Azure networking build
- **Current phase:** Begin story / requirements and mental model
- **Azure deployment:** NOT STARTED
- **BlueHarbor Azure resources:** NONE required for Unit 01
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
-> Microsoft exercise where present
-> Azure CLI implementation where useful
-> independent validation
-> deliberate failure / troubleshooting
-> Terraform where appropriate
-> evidence / rebuild notes
-> safe teardown where appropriate
-> carry architecture into next unit
```

Do not deploy Azure resources before the relevant tutorial and understanding check are complete.

## Drift prevention

Before any new topic:

1. identify the exact Microsoft Learn module and unit;
2. state the BlueHarbor business problem for that unit;
3. teach Microsoft's objective first;
4. add study-guide depth only inside the matching unit;
5. do not create a parallel topic/lab sequence;
6. do not allow legacy evidence to dictate the project design.
