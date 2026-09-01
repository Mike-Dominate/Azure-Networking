# Lab 04 Handoff — Azure DNS / Name Resolution

## Microsoft Learn alignment

**Module 1:** Introduction to Azure Virtual Networks  
**Unit:** Design name resolution for your virtual network

Primary curriculum source:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Coverage completeness source:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

## Status

- **State:** IN PROGRESS
- **Current phase:** Microsoft Learn tutorial / mental model
- **Deployment phase:** NOT STARTED
- **Azure resources:** NONE
- **Previous Module 1 practical:** Lab 03 — COMPLETE

## Authoritative scope

Teach the Microsoft Learn name-resolution unit first, then add only the current AZ-700 study-guide requirements that belong to the same objective area:

```text
1. design name resolution inside a VNet
2. configure DNS settings for a VNet
3. design public DNS zones
4. design private DNS zones
5. configure public and private DNS zones
6. link a private DNS zone to a VNet
7. design and implement Azure DNS Private Resolver
```

Supporting concepts such as recursive vs authoritative DNS, common record types and delegation may be used only to explain these objectives.

Do not expand Lab 04 into Private Endpoint / Private Link DNS integration. That belongs primarily to Microsoft Learn Module 7.

## Tutorial progress already completed

Supporting DNS fundamentals already demonstrated interactively:

- recursive resolver versus authoritative DNS
- public DNS hierarchy and delegation
- NS, CNAME, MX and SOA records
- common record types: A, AAAA, CNAME, MX, TXT, NS, SOA and PTR
- Microsoft public DNS authority on Azure DNS
- Microsoft-to-Akamai CNAME / authority handoff

These are foundation knowledge, not separate programme topics.

## Resume point

Restart the teaching structure from the Microsoft Learn unit rather than the previous improvised nine-topic list.

Resume with:

```text
Microsoft Learn Module 1
-> Design name resolution for your virtual network
```

Use the Microsoft Learn lesson's structure as the spine. Explain each concept with:

```text
technical concept
-> everyday analogy
-> Azure-specific behaviour
-> query-flow diagram
-> short understanding check
```

Only after the complete name-resolution tutorial plus the study-guide Private Resolver extension is understood should the implementation be designed.

## Practical workflow after tutorial

```text
understanding check
-> design practical scenario
-> manual Azure CLI deployment
-> DNS query validation
-> deliberate failure / troubleshooting
-> Portal inspection where useful
-> Terraform rebuild
-> independent validation
-> evidence / rebuild documentation
-> safe teardown
-> explain-back
```

## Critical rule

Provisioning state `Succeeded` never proves DNS is functioning. Actual DNS queries must prove the resolver path and returned answer.
