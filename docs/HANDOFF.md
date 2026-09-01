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

No routine destroy between units/modules. Persistent infrastructure is Terraform-managed; CLI/Portal/protocol/diagnostic tools validate and troubleshoot.

## Architecture audit status

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   PASS
Gate 4  M4 -> M5   PASS
Gate 5  M5 -> M6   PASS
Gate 6  M6 -> M7   NEXT
Gate 7  M7 -> M8   PENDING
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md).

## Approved architecture through Module 5

```text
M1
Core / Manufacturing / Research VNets
DNS / routing / initial direct peerings
nat-mfg-aue

M2
classic VPN learning
-> Virtual WAN production transit
bhi-vhub-aue 10.200.0.0/22

M3
ExpressRoute added to AUE hub

M4
Telemetry TCP/9000
AUE lb + nat-mfg-aue
SEA lb + nat-telemetry-sea
Traffic Manager

M5
Partner Hub
AUE/SEA Partner VNets
AUE/SEA Application Gateway Standard_v2
activate bhi-vhub-sea 10.200.4.0/22
Front Door Standard
```

## Approved Module 6 security evolution

Distributed controls:

```text
DDoS Network Protection plan
NSG / ASG segmentation
Manufacturing test data target
Partner backend segmentation
```

Central transit security:

```text
fwpol-bhi-global
  |
  +-- azfw-bhi-aue -> bhi-vhub-aue
  +-- azfw-bhi-sea -> bhi-vhub-sea
```

Production routing intent secures approved Internet/private transit.

Public-return-path exceptions remain for:

```text
AUE/SEA Application Gateway subnets
AUE telemetry subnet + nat-mfg-aue
SEA telemetry subnet + nat-telemetry-sea
```

Partner backend egress evolves from:

```text
nat-partner-aue / nat-partner-sea
```

to:

```text
snet-partner-app -> secured Virtual WAN -> Azure Firewall -> approved Internet
```

The Partner NAT resources/associations are retired after the firewall path is proven.

Direct Module 1 peerings are retired after secured private transit is proven because they would bypass central inspection.

Partner Hub web security evolves to:

```text
Front Door Premium + edge WAF
        |
AUE / SEA Application Gateway WAF_v2
        |
Partner backends
```

Regional origins restrict direct arbitrary Internet bypass using the current supported Front Door backend-source restriction plus BlueHarbor `X-Azure-FDID` validation.

## Current programme phase

- **Curriculum execution position:** Module 1 Unit 01 remains the first teaching/build unit.
- **Story design:** COMPLETE.
- **Architecture audit:** Gates 1–5 PASS; Gate 6 NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.

## Immediate resume instruction

Do not start implementation yet.

Proceed with:

```text
Gate 6 — Module 6 -> Module 7
```

Audit only that transition, fix conflicts, obtain approval, then move to Gate 7.
