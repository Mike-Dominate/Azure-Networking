# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Core rules

```text
Microsoft Learn order is authoritative.
One BlueHarbor story.
One blueharbor/terraform/ root.
One Terraform state lineage.
Each unit = previous deployed estate + next requirement.
```

No routine destroy between units/modules. Persistent infrastructure is Terraform-managed; CLI/Portal/protocol tools validate and troubleshoot.

## Story-design milestone

Stories for Modules 1–8 are designed. Formal learning execution still begins at Module 1 Unit 01 after the architecture audit is complete.

## Architecture audit status

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   PASS
Gate 4  M4 -> M5   NEXT
Gate 5  M5 -> M6   PENDING
Gate 6  M6 -> M7   PENDING
Gate 7  M7 -> M8   PENDING
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the canonical decision record.

## Approved architecture through Module 3

```text
M1
Core / Manufacturing / Research VNets
DNS / peering / routing
NAT on snet-mfg-app

M2
classic VPN learning
-> Virtual WAN production transit
bhi-vhub-aue 10.200.0.0/22
Brisbane + Perth + remote users

M3
ExpressRoute added to bhi-vhub-aue
VPN retained as alternate path
```

Hybrid DNS resolver endpoint subnets belong in `bhi-vnet-core-aue`:

```text
snet-dns-inbound    10.10.10.0/28
snet-dns-outbound   10.10.10.16/28
```

Reserved:

```text
bhi-vhub-sea   10.200.4.0/22
```

## Approved Module 4 application-availability architecture

New workload:

```text
BlueHarbor Device Telemetry Ingest
TCP/9000
```

Australia East:

```text
existing bhi-vnet-mfg-aue / snet-mfg-app
 -> telemetry backends
 -> public Standard lb-telemetry-aue
 -> reuse existing Module 1 NAT for backend outbound
```

Southeast Asia DR:

```text
existing bhi-vnet-research-sea
 -> add snet-telemetry-dr 10.30.3.0/24
 -> telemetry DR backends
 -> public Standard lb-telemetry-sea
```

Global service selection:

```text
Traffic Manager
Priority 1 -> AUE
Priority 2 -> SEA
monitor TCP/9000
```

Two failure layers:

```text
backend failure  -> handled by regional Load Balancer
regional failure -> handled by Traffic Manager DNS selection
```

## Current programme phase

- **Curriculum execution position:** Module 1 Unit 01 remains the first teaching/build unit.
- **Story design:** COMPLETE.
- **Architecture audit:** Gates 1–3 PASS; Gate 4 NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.

## Immediate resume instruction

Do not start implementation yet.

Proceed with:

```text
Gate 4 — Module 4 -> Module 5
```

Audit only that transition, fix conflicts, obtain approval, then move to Gate 5.
