# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

## Cumulative rule

```text
previous code + state + Azure resources
        + next BlueHarbor requirement
        = next project state
```

Canonical Terraform root:

```text
blueharbor/terraform/
```

No disposable Terraform root per lab and no routine destroy at module boundaries.

## Story-design status

Modules 1–8: **DESIGNED**.

## Architecture audit status

| Gate | Transition | Status |
|---:|---|---|
| 1 | M1 -> M2 | **PASS** |
| 2 | M2 -> M3 | **PASS** |
| 3 | M3 -> M4 | **NEXT** |
| 4 | M4 -> M5 | PENDING |
| 5 | M5 -> M6 | PENDING |
| 6 | M6 -> M7 | PENDING |
| 7 | M7 -> M8 | PENDING |

Do not start the BlueHarbor Terraform deployment until all gates pass.

## Approved architecture through Module 3

```text
M1
workload VNets / DNS / peering / routing / NAT
  |
M2 classic stage
bhi-vnet-connectivity-aue + VPN Gateway
  |
M2 production stage
bhi-vwan + bhi-vhub-aue 10.200.0.0/22
Brisbane + Perth + remote users + workload VNet connections
  |
M3
ExpressRoute added to the same Virtual WAN hub
VPN retained as alternate path
```

Reserved future regional hub:

```text
bhi-vhub-sea   10.200.4.0/22
```

Hybrid DNS is extended from the existing Core/Shared Services VNet.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / GATE 1-2 AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / GATE 2 AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / GATE 3 NEXT |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED |
| 6 | Design and implement network security | NOT STARTED | DESIGNED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED |

## Current phase

```text
STORY DESIGN        COMPLETE
AUDIT GATES 1–2     PASS
AUDIT GATE 3        NEXT
TERRAFORM BUILD     NOT STARTED
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the decision record.
