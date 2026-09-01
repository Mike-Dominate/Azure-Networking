# Programme Handoff — BlueHarbor Azure Networking

This is the authoritative continuation record.

## Curriculum authority

```text
Microsoft Learn path = module/unit order and primary teaching scope
BlueHarbor story = progressive business context
AZ-700 study guide = completeness additions inside the matching unit
Azure product docs = exact technical behaviour
```

## Terraform continuity rule

One canonical root:

```text
blueharbor/terraform/
```

Every practical starts from the code, state and deployed resources produced previously. No routine destroy between units/modules. Persistent configuration changes are Terraform-managed; CLI/Portal/diagnostic tools validate and troubleshoot.

## Story-design milestone

Stories for Modules 1–8 are designed. Formal learning execution still begins at Module 1 Unit 01 after the architecture audit is complete.

## Architecture audit status

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   NEXT
Gate 4  M4 -> M5   PENDING
Gate 5  M5 -> M6   PENDING
Gate 6  M6 -> M7   PENDING
Gate 7  M7 -> M8   PENDING
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md) for the canonical decisions.

## Key approved connectivity architecture

```text
MODULE 1
workload VNets / DNS / peering / routing / NAT

EARLY MODULE 2
bhi-vnet-connectivity-aue
+ classic VPN Gateway
+ Brisbane S2S
+ classic P2S

END MODULE 2
bhi-vwan
+ bhi-vhub-aue 10.200.0.0/22
+ Brisbane
+ Perth
+ remote users
+ Core / Manufacturing / Research VNet connections

MODULE 3
add ExpressRoute to bhi-vhub-aue
+ Virtual WAN ExpressRoute Gateway
+ circuit/provider boundary
+ private peering/BGP
+ ExpressRoute-preferred / VPN-alternate routing intent
```

Hybrid DNS resolver endpoint subnets belong in `bhi-vnet-core-aue`:

```text
snet-dns-inbound    10.10.10.0/28
snet-dns-outbound   10.10.10.16/28
```

Reserve:

```text
bhi-vhub-sea   10.200.4.0/22
```

Do not invent a Singapore physical office; Brisbane and Perth are the current physical sites.

## Current programme phase

- **Curriculum execution position:** Module 1 — Unit 01 remains the first teaching/build unit.
- **Story design:** COMPLETE.
- **Architecture audit:** Gates 1–2 PASS; Gate 3 NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.

## Immediate resume instruction

Do **not** start Module 1 implementation yet.

Proceed with:

```text
Gate 3 — Module 3 -> Module 4
```

Audit one transition only. Fix and approve it before moving to Gate 4.
