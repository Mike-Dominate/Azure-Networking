# Programme Roadmap

## Purpose

Follow Microsoft's AZ-700 Microsoft Learn path in exact module/unit order while one BlueHarbor Industries architecture, Terraform codebase and state lineage evolve continuously.

Canonical Terraform root:

```text
blueharbor/terraform/
```

Learner-performance standard:

```text
docs/LEARNER-MASTERY-FRAMEWORK.md
```

## Planning status

```text
STORY DESIGN                         COMPLETE
MODULE-TRANSITION AUDIT              COMPLETE — GATES 1–7 PASS
WHOLE-PROGRAMME CLOSEOUT             PASS
JULY-2026 STUDY-GUIDE COVERAGE       COMPLETE
FINAL CURRICULUM / ARCHITECTURE QA   PASS
LEARNER MASTERY FRAMEWORK             ACTIVE
IMPLEMENTATION READY                 YES
TERRAFORM BUILD                      NOT STARTED
AZURE DEPLOYMENT                     NOT STARTED
CURRENT CURRICULUM POSITION          M1 U01
CURRENT MASTERY POSITION              M1 U01 — NOT STARTED
```

## Learning progression

Every practical now moves through four distinct learner states:

```text
LEARNED
  -> mental model and design understood
BUILT
  -> intended infrastructure/configuration implemented
VALIDATED
  -> behaviour independently proven
MASTERED
  -> failure, evidence, communication and low-guidance gate passed
```

Deployment alone does not complete a practical.

## Final cumulative programme chain

```text
M1
VNets / blueharbor.internal / peerings / routing / NAT
+ current-study-guide core networking extensions
  |
M2
classic VPN/P2S -> Virtual WAN
Core DNS Private Resolver
+ current-study-guide hybrid extensions
  |
M3
ExpressRoute on existing AUE hub
Brisbane + Perth two-circuit Global Reach stage
exact vWAN FastPath eligibility
  |
M4
Telemetry TCP/9000
AUE/SEA Standard Load Balancers
Traffic Manager
+ Load Balancer study-guide extensions
  |
M5
Partner AUE/SEA VNets
regional Application Gateways
Front Door
+ rewrite/caching/rules/TLS study-guide extensions
  |
M6
secured Virtual WAN
AUE/SEA Azure Firewall
DDoS / NSG / ASG / WAF
retire private-transit bypasses including Global Reach
  |
M7
Storage Service Endpoint
App Service Private Endpoint + VNet Integration
Azure SQL Private Endpoint
telemetry Private Link Service
Front Door -> App Gateway Private Link
  |
M8
central Log Analytics
regional VNet flow-log Storage
VNet flow logs / Traffic Analytics
Connection Monitor / diagnostics / alerts
```

## Learner-experience chain

The same infrastructure progression is now wrapped in this repeatable mastery loop:

```text
business trigger
  -> job reality
  -> recall existing estate
  -> mental model / packet path
  -> architecture delta
  -> Terraform change
  -> independent validation
  -> deliberate fault
  -> diagnostic framework
  -> pressure incident
  -> evidence + stakeholder communication
  -> low-guidance repeat
  -> mastery gate
  -> exact estate carried forward
```

Guidance deliberately reduces from Module 1 to Module 8. Module 1 teaches the method explicitly; by Module 8 the learner is expected to operate the accumulated estate from symptoms and evidence with minimal hints.

## Final cross-programme contracts

```text
Classic P2S pool       172.31.240.0/24
vWAN User VPN pool     172.31.241.0/24
Private DNS zone       blueharbor.internal
Remote state           Azure Blob / one migrated state lineage
Global unique names    one persistent six-character suffix
```

## Coverage control

Microsoft Learn remains the execution sequence. Before each unit, use:

[`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)

to add the current July 27, 2026 study-guide objectives inside the matching unit without creating a parallel curriculum.

The learner-performance layer is defined separately in:

[`LEARNER-MASTERY-FRAMEWORK.md`](LEARNER-MASTERY-FRAMEWORK.md)

It changes **how deeply each applicable unit must be demonstrated**, not the Microsoft Learn sequence or technical scope.

## Official module sequence

| Module | Microsoft Learn module | Execution status | Story/audit status |
|---:|---|---|---|
| 1 | Introduction to Azure Virtual Networks | **IN PROGRESS — Unit 01 current** | DESIGNED / AUDITED / QA PASS |
| 2 | Design and implement hybrid networking | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 3 | Design and implement Azure ExpressRoute | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 4 | Load balance non-HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 5 | Load balance HTTP(S) traffic in Azure | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 6 | Design and implement network security | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 7 | Design and implement private access to Azure Services | NOT STARTED | DESIGNED / AUDITED / QA PASS |
| 8 | Design and implement network monitoring | NOT STARTED | DESIGNED / AUDITED / QA PASS |

## Mastery emphasis by module

```text
M1  Foundation mode        — explain and build correct habits
M2  Engineering mode       — choose more of the implementation path
M3  Design/dependency mode — reason honestly about external boundaries
M4  Service availability   — diagnose probes, backends and global selection
M5  Application delivery   — combine DNS, TLS, routing and backend health
M6  Senior security change — protect existing paths while hardening the estate
M7  Private access         — diagnose DNS/private-path behaviour end-to-end
M8  Operations/on-call     — investigate the full estate from symptoms/telemetry
```

## Execution rule

The planning/QA phase is finished. Begin at Module 1 Unit 01 and continue in Microsoft Learn order.

Do not pre-build future resources simply because their final address/name is already known. The closeout/coverage maps are dependency contracts, not permission to skip the progressive story.

Do not mark a practical complete merely because Terraform applied successfully. Use the mastery framework and record the correct `LEARNED`, `BUILT`, `VALIDATED` or `MASTERED` state.
