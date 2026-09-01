# Module 1 — Introduction to Azure Virtual Networks

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/

**Status:** IN PROGRESS

## BlueHarbor Industries project

Module 1 is taught as one continuous Azure migration project for **BlueHarbor Industries (BHI)** rather than as unrelated labs.

BlueHarbor is an industrial technology manufacturer with three cloud workload groups:

```text
Shared Services
Manufacturing
Research
```

The network evolves as new business requirements appear. We do not reset the scenario between Microsoft Learn units.

See [`PROJECT-STORY.md`](PROJECT-STORY.md) for the complete progressive story and [`../../docs/PROJECT-NARRATIVE.md`](../../docs/PROJECT-NARRATIVE.md) for the programme-wide narrative.

## Microsoft Learn units and project chapters

| Unit | Microsoft Learn unit | BlueHarbor chapter | Status |
|---:|---|---|---|
| 01 | Introduction | You become the Azure Network Engineer and receive the migration brief | COMPLETE |
| 02 | Explore Azure Virtual Networks | Design separate address spaces for shared services, manufacturing and research | COMPLETE |
| 03 | Configure public IP services | Operations needs a controlled public test endpoint | COMPLETE |
| 04 | Exercise: Design and implement a virtual network in Azure | Build the approved network foundation | COMPLETE |
| 05 | Design name resolution for your virtual network | Teams can no longer manage changing IP addresses by memory | **CURRENT** |
| 06 | Exercise: Configure domain name servers settings in Azure | Build and validate internal name resolution | NOT STARTED |
| 07 | Enable cross-virtual network connectivity with peering | Manufacturing needs a service hosted in Shared Services | NOT STARTED |
| 08 | Exercise: Connect two Azure virtual networks using global virtual network peering | Prove isolation, peer the networks and prove connectivity | NOT STARTED |
| 09 | Implement virtual network traffic routing | Security requires deliberate traffic-path control | NOT STARTED |
| 10 | Configure internet access with Azure Virtual NAT | Private workloads need outbound Internet without individual public IPs | NOT STARTED |
| 11 | Summary | Architecture review, final validation and learner explain-back | NOT STARTED |

## Learning pattern

For each unit:

```text
Microsoft Learn objective
-> BlueHarbor business problem
-> everyday analogy
-> architecture / packet / query flow
-> understanding check
-> Microsoft exercise where present
-> Azure CLI implementation where practical
-> independent validation
-> deliberate failure / troubleshooting
-> Terraform rebuild where appropriate
-> evidence / rebuild notes
-> carry architecture into next unit
```

Current position: **Unit 05 — Design name resolution for your virtual network**.
