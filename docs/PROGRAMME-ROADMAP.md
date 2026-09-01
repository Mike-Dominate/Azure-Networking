# Programme Roadmap

## Purpose

Build real Azure networking engineering capability by following Microsoft's official AZ-700 Microsoft Learn learning path in the same published module and unit order, then deepen each Microsoft unit with Azure CLI, Terraform, troubleshooting, validation and rebuild documentation.

## Curriculum authority

Primary curriculum and sequence:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Exact unit map used by this repository:

[`docs/MSLEARN-UNIT-MAP.md`](MSLEARN-UNIT-MAP.md)

Coverage completeness check:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

Technical implementation authority:

Microsoft Azure product documentation for the service being implemented.

Rule:

```text
Microsoft Learn path = programme structure and order
Microsoft Learn module = major programme stage
Microsoft Learn unit = atomic teaching/lab step
Microsoft Learn exercise = practical baseline where one exists
AZ-700 study guide = completeness additions inside the matching unit
Azure product docs = exact implementation behaviour
```

## Programme structure

The repository no longer uses the historical numbered lab folders as the curriculum sequence.

The authoritative pattern is:

```text
Microsoft Learn learning path
  -> Module
     -> Unit
        -> Microsoft exercise where present
           -> our deeper CLI / validation / troubleshooting / Terraform work
```

Historical lab folders are retained only because they contain completed evidence, Terraform, notes and rebuild documentation.

## Official Microsoft Learn module sequence

| Module | Microsoft Learn module | Status |
|---:|---|---|
| 1 | Introduction to Azure Virtual Networks | IN PROGRESS |
| 2 | Design and implement hybrid networking | NOT STARTED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED |
| 4 | Load balance non-HTTP(S) traffic in Azure | PREVIOUS PRACTICAL EVIDENCE EXISTS |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED |
| 6 | Design and implement network security | NOT STARTED |
| 7 | Design and implement private access to Azure Services | NOT STARTED |
| 8 | Design and implement network monitoring | NOT STARTED |

## Current Microsoft Learn position

```text
Module 1 — Introduction to Azure Virtual Networks

Completed / evidenced:
- Explore Azure Virtual Networks
- Configure public IP services
- Exercise: Design and implement a virtual network in Azure

Current:
- Design name resolution for your virtual network

Next:
- Exercise: Configure domain name servers settings in Azure
```

Lab 03 contains the practical evidence for the earlier Module 1 VNet/IP/public-IP work.
Lab 04 is the implementation workspace for the current name-resolution units.

## Lab pattern from now on

Every lab/workspace must mirror Microsoft Learn rather than inventing a parallel topic list.

Example for the current work:

```text
Microsoft Learn Module 1 — Introduction to Azure Virtual Networks

Unit 5 — Design name resolution for your virtual network
  -> teach Microsoft unit
  -> everyday analogy
  -> visual query flow
  -> understanding check

Unit 6 — Exercise: Configure domain name servers settings in Azure
  -> complete / reproduce exercise objective
  -> Azure CLI equivalent
  -> independent validation
  -> deliberate failure / troubleshooting
  -> Terraform rebuild
  -> evidence / teardown
```

If the current AZ-700 study guide requires additional depth such as Azure DNS Private Resolver, that depth is inserted under the matching Microsoft Learn name-resolution unit after the core Microsoft unit is understood. It does not become an independent curriculum branch.

## Existing practical evidence mapping

```text
Lab 01 — Azure Load Balancer
Lab 02 — Azure Traffic Manager
    -> Microsoft Learn Module 4 evidence

Lab 03 — IP addressing / VNets / public IPs
    -> Microsoft Learn Module 1 Units 2-4 evidence

Lab 04 — DNS / name resolution
    -> Microsoft Learn Module 1 Units 5-6 workspace
```

When Module 4 is reached in Microsoft Learn order, review Units 1-7 in sequence and map Labs 01-02 against them. Reuse valid evidence and fill only genuine gaps rather than automatically repeating deployments.

## Required engineering learning loop

For every Microsoft Learn unit:

```text
Microsoft Learn unit
-> explain the Microsoft objective
-> everyday analogy where useful
-> architecture / packet / query flow
-> understanding check
-> Microsoft exercise where present
-> Azure CLI implementation where practical
-> independent validation
-> deliberate failure / troubleshooting
-> Portal inspection where useful
-> Terraform rebuild where appropriate
-> independent IaC validation
-> evidence / rebuild documentation
-> safe teardown
-> learner explain-back
```

## Drift prevention

Before teaching or implementing anything:

1. identify the exact Microsoft Learn module;
2. identify the exact Microsoft Learn unit;
3. follow the Microsoft unit before adding depth;
4. attach study-guide additions only to the matching unit;
5. do not create standalone topics merely because they are useful Azure features;
6. update `docs/MSLEARN-UNIT-MAP.md` if Microsoft changes the path.
