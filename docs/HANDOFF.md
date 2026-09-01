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

## Architecture audit status

```text
Gate 1  M1 -> M2   PASS
Gate 2  M2 -> M3   PASS
Gate 3  M3 -> M4   PASS
Gate 4  M4 -> M5   PASS
Gate 5  M5 -> M6   PASS
Gate 6  M6 -> M7   PASS
Gate 7  M7 -> M8   NEXT
```

See [`ARCHITECTURE-DEPENDENCY-AUDIT.md`](ARCHITECTURE-DEPENDENCY-AUDIT.md).

## Approved architecture through Module 6

The estate includes:

```text
Core / Manufacturing / Research / Partner VNets
AUE + SEA Virtual WAN hubs
VPN + ExpressRoute
secured-hub Azure Firewalls + central policy
DDoS / NSG / ASG
AUE + SEA telemetry Load Balancers + Traffic Manager
Front Door Premium + edge WAF
AUE + SEA Application Gateway WAF_v2
Core DNS Private Resolver / hybrid DNS
```

## Approved Module 7 private-access evolution

Manufacturing Storage:

```text
snet-mfg-data
 -> Microsoft.Storage service endpoint
 -> restricted Storage archive account
 -> Storage service endpoint policy where supported
```

Partner AUE:

```text
snet-private-endpoints   10.40.3.0/24
snet-appsvc-integration  10.40.4.0/26
snet-appgw-pl            10.40.5.0/27
```

Canonical path:

```text
Application Gateway WAF_v2
 -> App Service Private Endpoint
 -> `/orders` App Service
 -> VNet Integration
 -> SQL Private Endpoint
 -> Azure SQL
```

SQL/App Service private DNS extends the existing Core/Partner DNS design. SQL public network access is disabled after the private path is proven.

BlueHarbor-owned Private Link Service:

```text
lb-telemetry-aue
 -> pls-telemetry-aue
 -> Core consumer PE in 10.10.20.0/24
```

Provider NAT subnet:

```text
snet-pls-nat 10.20.3.0/27
```

Module 4 AUE Load Balancer uses NIC-backed backend membership for this dependency.

Front Door origin privacy:

```text
Front Door Premium
 -> Private Link
 -> AUE / SEA Application Gateway WAF_v2
```

Provider-side subnets:

```text
AUE 10.40.5.0/27
SEA 10.50.3.0/27
```

Migrate through a new private-link origin group, validate, then switch the Front Door route. Keep Module 6 public-origin restrictions during migration/rollback as required.

## Current programme phase

- **Curriculum execution position:** Module 1 Unit 01 remains the first teaching/build unit.
- **Story design:** COMPLETE.
- **Architecture audit:** Gates 1–6 PASS; Gate 7 NEXT.
- **Terraform build:** NOT STARTED.
- **Azure deployment:** NOT STARTED for the new BlueHarbor build.

## Immediate resume instruction

Do not start implementation yet.

Proceed with:

```text
Gate 7 — Module 7 -> Module 8
```

Audit the final transition, fix conflicts, obtain approval, then perform the whole-programme audit closeout before starting Module 1 Unit 01.
