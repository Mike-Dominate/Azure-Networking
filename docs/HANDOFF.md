# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Curriculum authority

```text
Microsoft Learn path = module/unit order and primary teaching scope
BlueHarbor story = progressive business context
AZ-700 study guide = completeness additions inside the matching unit
Azure product docs = exact technical behaviour
```

## Terraform continuity rule — CRITICAL

```text
one BlueHarbor story
one blueharbor/terraform root
one Terraform state lineage
one cumulative Azure environment
```

Every practical unit begins with the code/state/resources produced previously and adds the next requirement. No routine destroy between units/modules.

## Story-design milestone

All eight module stories are designed.

## Architecture-audit status

The audit is performed one transition at a time.

```text
Gate 1  M1 -> M2   PASS — corrected and approved
Gate 2  M2 -> M3   NEXT
Gate 3  M3 -> M4   PENDING
Gate 4  M4 -> M5   PENDING
Gate 5  M5 -> M6   PENDING
Gate 6  M6 -> M7   PENDING
Gate 7  M7 -> M8   PENDING
```

Detailed record: [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md)

## Gate 1 decisions now authoritative

Module 1 end state uses these canonical VNets:

```text
bhi-vnet-core-aue       10.10.0.0/16
bhi-vnet-mfg-aue        10.20.0.0/16
bhi-vnet-research-sea   10.30.0.0/16
```

Module 2 starts from those deployed resources and adds:

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  snet-dns-inbound          10.100.10.0/28
  snet-dns-outbound         10.100.10.16/28
  GatewaySubnet             10.100.255.0/26

classic Azure VPN Gateway
explicit gateway-transit relationships
Brisbane S2S
P2S client pool 172.31.240.0/24
hybrid DNS extension
later Virtual WAN
```

Do not use old aliases such as `CoreServicesVnet`, `ManufacturingVnet` or `ResearchVnet`.

## Current programme phase

- **Formal curriculum execution position:** Module 1 — Unit 01.
- **Azure deployment:** NOT STARTED for the new cumulative build.
- **Terraform build:** NOT STARTED.
- **Architecture audit:** IN PROGRESS.
- **Immediate audit task:** Module 2 -> Module 3.

Do **not** start Module 1 implementation until all seven dependency gates pass.

## Gate 2 primary question

Resolve the exact progression among:

```text
classic connectivity VNet + VPN Gateway
workload VNet use_remote_gateways / gateway transit
Virtual WAN / Virtual Hub
Module 3 ExpressRoute gateway/circuit
```

Do not assume a VNet can simultaneously use multiple remote gateway models. Decide the supported evolution and encode it as intentional Terraform additions/in-place changes.

## Build loop after audit

```text
Microsoft Learn unit
-> business requirement
-> mental model
-> define delta from current estate
-> modify SAME Terraform root
-> plan / inspect
-> apply
-> independent validation
-> failure / troubleshooting
-> permanent fix in Terraform
-> Git checkpoint
-> carry code + state + Azure resources forward
```
