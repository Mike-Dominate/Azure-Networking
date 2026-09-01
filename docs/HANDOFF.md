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

## Architecture audit status

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   PASS
Gate 4  M4 -> M5   PASS
Gate 5  M5 -> M6   NEXT
Gate 6  M6 -> M7   PENDING
Gate 7  M7 -> M8   PENDING
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the canonical decisions.

## Approved cumulative architecture through Module 4

```text
M1
Core / Manufacturing / Research VNets
DNS / peerings / routing
NAT on snet-mfg-app

M2
classic VPN learning
-> Virtual WAN production transit
bhi-vhub-aue 10.200.0.0/22
Brisbane + Perth + remote users

M3
ExpressRoute added to bhi-vhub-aue
VPN retained as alternate path

M4
Device Telemetry Ingest TCP/9000
AUE + SEA public Standard Load Balancers
Traffic Manager Priority AUE -> SEA
```

## Approved Module 5 Partner Hub architecture

Australia East:

```text
bhi-vnet-partner-aue   10.40.0.0/16
  snet-appgw           10.40.1.0/24
  snet-partner-app     10.40.2.0/24

nat-partner-aue
appgw-partner-aue Standard_v2
Virtual WAN connection -> bhi-vhub-aue
```

Southeast Asia activation:

```text
bhi-vhub-sea           10.200.4.0/22

bhi-vnet-partner-sea   10.50.0.0/16
  snet-appgw           10.50.1.0/24
  snet-partner-app     10.50.2.0/24

nat-partner-sea
appgw-partner-sea Standard_v2
Virtual WAN connection -> bhi-vhub-sea
```

Research Virtual WAN connection changes from AUE hub to SEA hub; the Research VNet and Module 4 telemetry resources remain unchanged.

Global HTTP(S):

```text
Azure Front Door Standard
 -> appgw-partner-aue
 -> appgw-partner-sea
```

`portal.blueharbor.example` is a narrative hostname only. Live practicals use Azure-generated reachable endpoints unless a real learner-owned domain is later supplied.

The Module 4 telemetry stack remains deployed and separate.

## Current programme phase

- **Curriculum execution position:** Module 1 Unit 01 remains the first teaching/build unit.
- **Story design:** COMPLETE.
- **Architecture audit:** Gates 1–4 PASS; Gate 5 NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.

## Immediate resume instruction

Do not start implementation yet.

Proceed with:

```text
Gate 5 — Module 5 -> Module 6
```

Audit only that transition, fix conflicts, obtain approval, then move to Gate 6.
