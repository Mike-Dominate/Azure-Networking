# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact order while one BlueHarbor Industries architecture, Terraform codebase and Azure state evolve continuously.

## Authority

```text
Microsoft Learn path = structure/order
Microsoft Learn unit = teaching step
Microsoft exercise = practical objective
BlueHarbor story = business progression
AZ-700 study guide = completeness inside matching unit
Azure product docs = exact technical behaviour
```

## Cumulative Terraform rule

All persistent practical infrastructure lives in one evolving root:

```text
blueharbor/terraform/
```

Every unit inherits all previous code/state/resources and adds the smallest coherent delta. Git commits provide historical checkpoints.

## Story-design status

```text
M1 network foundation
 -> M2 hybrid connectivity
 -> M3 enterprise private connectivity
 -> M4 service availability
 -> M5 HTTP(S) delivery
 -> M6 security
 -> M7 private PaaS access
 -> M8 monitoring / operations
```

All eight stories are designed.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED |

## Architecture & Terraform Dependency Audit

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   NEXT
Gate 3  M3 -> M4   PENDING
Gate 4  M4 -> M5   PENDING
Gate 5  M5 -> M6   PENDING
Gate 6  M6 -> M7   PENDING
Gate 7  M7 -> M8   PENDING
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for findings and decisions.

### Gate 1 authoritative contract

```text
M1 deployed:
  bhi-vnet-core-aue       10.10.0.0/16
  bhi-vnet-mfg-aue        10.20.0.0/16
  bhi-vnet-research-sea   10.30.0.0/16
  DNS / peerings / routing / selected NAT

M2 adds:
  bhi-vnet-connectivity-aue 10.100.0.0/16
  GatewaySubnet              10.100.255.0/26
  DNS resolver subnets       10.100.10.0/28 and 10.100.10.16/28
  VPN Gateway
  gateway transit
  Brisbane S2S
  P2S 172.31.240.0/24
  hybrid DNS extension
  later Virtual WAN
```

The next audit must settle how the classic VPN/gateway-transit design evolves into Virtual WAN and ExpressRoute without contradictory remote-gateway ownership.

## Current phase

```text
STORY DESIGN        COMPLETE
ARCHITECTURE AUDIT  IN PROGRESS — Gate 2 next
TERRAFORM BUILD     NOT STARTED
```

Do not start Azure deployment until all dependency gates pass.

## Engineering loop after audit

```text
Microsoft Learn objective
-> BlueHarbor requirement
-> explanation / architecture
-> understanding check
-> identify delta from CURRENT environment
-> update SAME Terraform root
-> fmt / init / validate
-> plan and inspect intended delta
-> apply
-> independent validation
-> failure / troubleshooting
-> permanent fix in Terraform
-> Git checkpoint
-> carry state/resources forward
```
