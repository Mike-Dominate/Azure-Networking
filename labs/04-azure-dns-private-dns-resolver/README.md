# Lab 04 — Azure DNS / Name Resolution

## Microsoft Learn alignment

**Module 1:** Introduction to Azure Virtual Networks  
**Current unit:** Design name resolution for your virtual network

Primary source:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Current AZ-700 study-guide additions for this same objective area:

- design name resolution inside a VNet
- configure DNS settings for a VNet
- design public DNS zones
- design private DNS zones
- configure public and private DNS zones
- link a private DNS zone to a VNet
- design and implement Azure DNS Private Resolver

## Status

`IN PROGRESS`

**Current phase:** Microsoft Learn tutorial / mental model  
**Deployment phase:** NOT STARTED  
**Azure resources:** NONE

## Purpose

Understand and implement Azure name resolution exactly within the Microsoft Learn Module 1 name-resolution scope, with Azure DNS Private Resolver added because the current AZ-700 study guide explicitly includes it under name resolution.

## Scope

### Microsoft Learn core

- name resolution inside an Azure VNet
- Azure-provided name resolution
- custom DNS server settings on a VNet
- Azure DNS public zones
- Azure Private DNS zones
- private DNS zone links to VNets

### AZ-700 study-guide extension in the same objective area

- Azure DNS Private Resolver

Private Endpoint / Private Link DNS integration is not expanded here; it belongs primarily to Microsoft Learn Module 7 — Design and implement private access to Azure Services.

## Engineering requirement

After the tutorial is complete, design a practical lab that proves DNS behaviour with actual queries rather than relying on provisioning state.

The practical must include, where reasonable:

```text
manual Azure CLI implementation
DNS query validation
at least one deliberate DNS failure and recovery
Terraform rebuild
independent validation
rebuild documentation
safe teardown
explain-back
```

## Current rule

Do not deploy Azure resources until the Microsoft Learn name-resolution tutorial and the corresponding study-guide additions are understood.
