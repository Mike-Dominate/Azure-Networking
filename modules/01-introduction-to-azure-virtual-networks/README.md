# Module 1 — Introduction to Azure Virtual Networks

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/  
**BlueHarbor project:** Build the Azure network foundation  
**Status:** IN PROGRESS — Unit 01 current

Module 1 starts the BlueHarbor story from an empty Azure network and establishes the first persistent Terraform-managed architecture that every later module inherits.

See [`PROJECT-STORY.md`](PROJECT-STORY.md).

## Microsoft Learn units and BlueHarbor chapters

| Unit | Microsoft Learn unit | BlueHarbor chapter | Status |
|---:|---|---|---|
| 01 | Introduction | Receive the Azure migration brief | **CURRENT** |
| 02 | Explore Azure Virtual Networks | Freeze the canonical VNet/subnet/address contract | NOT STARTED |
| 03 | Configure public IP services | Operations needs a controlled public test endpoint | NOT STARTED |
| 04 | Exercise: Design and implement a virtual network in Azure | Build the Terraform-managed network foundation | NOT STARTED |
| 05 | Design name resolution for your virtual network | Teams can no longer depend on memorised IP addresses | NOT STARTED |
| 06 | Exercise: Configure domain name servers settings in Azure | Implement and validate internal name resolution | NOT STARTED |
| 07 | Enable cross-virtual network connectivity with peering | Manufacturing needs a service in Core | NOT STARTED |
| 08 | Exercise: Connect two Azure virtual networks using global VNet peering | Connect Core to Research across regions | NOT STARTED |
| 09 | Implement virtual network traffic routing | Security requires deliberate traffic-path control | NOT STARTED |
| 10 | Configure internet access with Azure Virtual NAT | Selected private workloads need controlled outbound Internet | NOT STARTED |
| 11 | Summary | Architecture review and explain-back | NOT STARTED |

## Canonical network contract

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24

bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24

bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
```

These names/address spaces persist into later modules.

## Learning/build pattern

```text
Microsoft unit
-> BlueHarbor requirement
-> tutorial / mental model
-> understanding check
-> define delta from current estate
-> modify SAME blueharbor/terraform root
-> terraform plan / inspect / apply
-> independent validation
-> deliberate failure / troubleshooting
-> permanent fix represented in Terraform
-> Git checkpoint
-> carry code + state + Azure environment forward
```
