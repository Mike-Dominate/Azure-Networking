# Programme Handoff — Azure Networking Engineering Labs

This is the authoritative continuation record for the programme.

## Curriculum authority

Primary programme sequence:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Coverage completeness check:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

Rule:

```text
Microsoft Learn path = sequence and teaching scope
AZ-700 study guide = completeness additions inside the matching module
Azure product docs = exact implementation behaviour
```

## Current status

- **Current Microsoft Learn module:** Module 1 — Introduction to Azure Virtual Networks
- **Completed Module 1 practical:** Lab 03 — VNet/IP addressing/public IP foundation
- **Current practical:** Lab 04 — Azure DNS / name resolution
- **Lab 04 state:** IN PROGRESS
- **Current phase:** Tutorial / mental model
- **Deployment phase:** NOT STARTED
- **Azure resources:** NONE
- **Module 4:** Load balance non-HTTP(S) traffic — COMPLETE from Labs 01 and 02

## Immediate resume instruction

Do not return to the old independent 22-lab sequence as the curriculum source.

Resume Microsoft Learn Module 1 at:

```text
Design name resolution for your virtual network
```

Finish Microsoft's name-resolution teaching first. Then add only the current AZ-700 study-guide name-resolution requirements that belong to the same section:

```text
- design name resolution inside a VNet
- configure DNS settings for a VNet
- design public DNS zones
- design private DNS zones
- configure public and private DNS zones
- link a private DNS zone to a VNet
- design and implement Azure DNS Private Resolver
```

Supporting DNS fundamentals are allowed where needed to understand those objectives, but they must not become an independent expanded curriculum.

## Module 1 progression

```text
Lab 03 — VNet/IP/public IP foundation                  COMPLETE
Lab 04 — name resolution / Azure DNS                   IN PROGRESS
Lab 05 — peering / cross-VNet connectivity             NOT STARTED
Lab 06 — routing / NAT                                 NOT STARTED
Lab 07 — Route Server study-guide routing extension    NOT STARTED
```

Historical lab numbers are retained only to preserve completed work and repository links. Microsoft Learn module order is authoritative.

## Lab 04 workflow

```text
Microsoft Learn name-resolution lesson
-> everyday mental model
-> visual DNS/query flow
-> understanding check
-> study-guide additions for name resolution
-> design practical scenario
-> manual Azure CLI implementation
-> independent DNS validation
-> deliberate failure / troubleshooting
-> Portal inspection where useful
-> Terraform rebuild
-> evidence / rebuild documentation
-> safe teardown
-> explain-back
```

Do not create Azure resources until the tutorial and understanding check are complete.

## Completed work retained

```text
Lab 01 — Azure Load Balancer      COMPLETE
Lab 02 — Azure Traffic Manager    COMPLETE
```

These map directly to Microsoft Learn Module 4 — Load balance non-HTTP(S) traffic in Azure, so Module 4 is already complete.

Lab 03 remains complete and maps to the VNet/IP/public-IP portion of Microsoft Learn Module 1.

## Drift prevention rule

Before teaching any new topic:

1. identify the Microsoft Learn module and unit it belongs to;
2. teach that unit's objective;
3. check the current AZ-700 study guide for additions in the same objective area;
4. do not introduce unrelated standalone topics;
5. only then design our deeper practical implementation.
