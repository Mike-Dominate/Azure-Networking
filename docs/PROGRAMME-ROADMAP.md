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
| 3 | M3 -> M4 | **PASS** |
| 4 | M4 -> M5 | **NEXT** |
| 5 | M5 -> M6 | PENDING |
| 6 | M6 -> M7 | PENDING |
| 7 | M7 -> M8 | PENDING |

Do not start the BlueHarbor Terraform deployment until all gates pass.

## Approved cumulative architecture through Module 4

```text
M1
Core / Manufacturing / Research VNets
DNS / peerings / routing
NAT on snet-mfg-app
  |
M2
classic VPN learning
-> bhi-vwan / bhi-vhub-aue 10.200.0.0/22
Brisbane + Perth + remote users
  |
M3
ExpressRoute added to the same Virtual WAN hub
VPN retained as alternate path
  |
M4
Device Telemetry Ingest TCP/9000
AUE public Standard Load Balancer in existing Manufacturing VNet
SEA public Standard Load Balancer in existing Research VNet
Traffic Manager Priority failover AUE -> SEA
```

Module 4 is an application-availability addition; it does not replace the transport architecture.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | Unit 01 is first build point | DESIGNED |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / GATE 4 NEXT |
| 6 | Design and implement network security | NOT STARTED | DESIGNED |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED |

## Current phase

```text
STORY DESIGN        COMPLETE
AUDIT GATES 1–3     PASS
AUDIT GATE 4        NEXT
TERRAFORM BUILD     NOT STARTED
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the decision record.
