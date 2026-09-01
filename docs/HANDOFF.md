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

No routine destroy between units/modules. Persistent infrastructure is Terraform-managed; CLI/Portal/PowerShell/protocol/diagnostic tools validate and troubleshoot.

## Architecture transition audit

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   PASS
Gate 4  M4 -> M5   PASS
Gate 5  M5 -> M6   PASS
Gate 6  M6 -> M7   PASS
Gate 7  M7 -> M8   PASS
```

**All module-transition gates are complete.**

## Approved Module 8 operations architecture

Central operations platform:

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
ag-bhi-netops
```

Regional VNet flow-log Storage:

```text
AUE  st-bhi-flow-aue-<unique>
SEA  st-bhi-flow-sea-<unique>
```

VNet flow logs cover all six project VNets and feed Traffic Analytics to the central workspace. New NSG flow logs are not used.

Regional Network Watchers are discovered/reconciled because Azure may already have auto-enabled them; do not blindly create duplicates.

Core management becomes the NetOps source location:

```text
snet-management 10.10.1.0/24
  vm-netops-aue
```

Connection Monitor tests real public, private and hybrid paths.

The Microsoft Load Balancer monitoring exercise uses:

```text
lb-telemetry-aue
```

and distinguishes backend Health Probe Status from Load Balancer Data Path Availability.

Tier-1 diagnostics/alerts cover real Azure Firewall, Application Gateway, Front Door, hybrid connectivity and related service-health conditions.

Final capstone faults are deterministic:

```text
hybrid SQL DNS forwarding fault
+
one AUE telemetry backend unhealthy
```

## Current programme phase

- **Story design:** COMPLETE.
- **Module-transition architecture audit:** COMPLETE — all seven gates PASS.
- **Whole-programme architecture closeout:** NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.
- **Formal curriculum execution position after closeout:** Module 1 Unit 01.

## Immediate resume instruction

Do **not** start Module 1 implementation yet.

Proceed with one short:

```text
WHOLE-PROGRAMME ARCHITECTURE CLOSEOUT
```

Check combined addressing, names, resource dependencies, intentional replacements/retirements, special subnet policies, Terraform ownership/import boundaries, DNS and routing/security exceptions.

If closeout passes, start **Module 1 — Unit 01 — Introduction**.
