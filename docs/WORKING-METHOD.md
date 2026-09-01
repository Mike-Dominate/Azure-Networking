# Working Method

This programme teaches Azure networking as one progressive BlueHarbor Industries engineering project and one progressive Terraform-managed Azure environment.

## Governance

- Microsoft Learn AZ-700 path defines module and unit order.
- The current AZ-700 study guide is the completeness check.
- Azure product documentation is the technical behaviour authority.
- The BlueHarbor story provides the progressive business context.
- Legacy labs are reference history only and do not override story continuity.
- `blueharbor/terraform/` is the single canonical Terraform root for the project.

## Story and infrastructure continuity

Do not skip or reshape a chapter merely because a similar service was built previously. Prior knowledge may shorten teaching time, but the BlueHarbor architecture must evolve in Microsoft Learn order.

A unit begins with the business problem that makes the next networking capability necessary.

The infrastructure follows the same rule:

```text
Unit N starts with Unit N-1's
  Terraform code
  Terraform state
  deployed Azure resources
  architecture decisions

Unit N adds only the new requirement.
```

Do not create isolated Terraform roots for individual units. Do not copy all previous Terraform files into a new lab folder. Git provides version history; the working Terraform root is the current complete environment.

## Terraform-only infrastructure management

Persistent Azure infrastructure is provisioned and changed through Terraform for this programme.

Azure CLI, Azure Portal and network/protocol tools remain important, but their normal role is:

- inspect deployed Azure state;
- independently validate Terraform results;
- inspect effective routes, IPs, health and diagnostics;
- generate/read test traffic and protocol behaviour;
- troubleshoot.

Do not create a second unmanaged version of the architecture through ad-hoc Portal/CLI writes.

If a troubleshooting exercise deliberately creates infrastructure drift, either perform the fault through Terraform or explicitly reconcile the drift back into Terraform before the unit is complete.

## Standard lifecycle

### Phase A — Understand

1. Identify the exact Microsoft Learn unit.
2. State the BlueHarbor business problem.
3. Complete the tutorial/mental model before deployment.
4. Draw the architecture and traffic/control-plane flow.
5. Identify dependencies, failure points, security boundaries and trade-offs.
6. Use an explain-back to confirm understanding.

### Phase B — Define the incremental change

1. Inspect the current BlueHarbor architecture and Terraform code.
2. State what already exists from previous units.
3. Define only the new resources/configuration required by this unit.
4. Identify expected Terraform additions, changes and any intentional replacements.
5. If an existing resource must change, explain why the new business requirement requires that change.

### Phase C — Extend the living Terraform stack

1. Work in `blueharbor/terraform/`.
2. Add or modify readable Terraform files without hiding the Azure relationships prematurely.
3. Run:

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

4. Read the plan as an architecture change report.
5. Stop if the plan proposes unexpected destruction/replacement of previous BlueHarbor resources.
6. Apply only after the delta is understood.
7. Keep the same state lineage for the next unit.

### Phase D — Validate, operate and troubleshoot

1. Inspect deployed resources independently using Azure CLI/Portal where useful.
2. Test real traffic/control-plane behaviour.
3. Test one or more relevant failure scenarios.
4. Inspect effective Azure state rather than guessing.
5. Use DNS queries, effective routes, Network Watcher, flow logs, HTTP tests and Azure Monitor where applicable.
6. Record symptom, hypothesis, investigation, root cause, fix and verification.
7. Ensure permanent infrastructure fixes are represented in Terraform.
8. Re-run plan/apply and end with Terraform and Azure agreeing.

### Phase E — Checkpoint and carry forward

1. Update unit/module README when status changes.
2. Capture useful commands and evidence.
3. Record trade-offs and lessons.
4. Update `docs/HANDOFF.md`, `docs/PROGRAMME-ROADMAP.md` and root `README.md` when programme status changes.
5. Commit meaningful progression to Git/GitHub.
6. Record the Terraform plan/apply delta for the unit.
7. **Do not routinely destroy the environment.**
8. Confirm the current Terraform state contains all expected BlueHarbor resources.
9. Confirm Azure still contains the expected previous infrastructure plus the new unit's additions.
10. Use this exact code/state/environment as the starting point for the next unit.

## Destroy / replacement policy

`terraform destroy` is not part of the normal unit lifecycle.

Removal is appropriate only when:

- the BlueHarbor design intentionally retires a component;
- the new architecture replaces an earlier temporary design;
- a deliberate troubleshooting exercise requires a controlled change and it is subsequently restored/reconciled;
- the user explicitly chooses to reset the complete programme environment.

Any planned destroy/replace action must be explained before apply.

## State continuity

The first applicable Terraform deployment establishes the project state lineage. The backend/storage choice must be documented and then carried consistently through the programme.

Do not silently start a new state file for a later unit. Do not use state deletion as a way to make a plan look clean.

Useful checks at unit boundaries include:

```text
terraform validate
terraform plan
terraform state list
```

plus independent Azure resource inspection.

## Status consistency

These must agree whenever progress changes:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
modules/<module>/README.md
modules/<module>/<unit>/README.md
blueharbor/terraform/README.md
```

## Git progression

Git commits are the lab checkpoints for the cumulative Terraform codebase.

Examples:

```text
M1 U04: build BlueHarbor VNet foundation
M1 U06: add internal DNS to existing network
M1 U08: add global VNet peering
M1 U10: add NAT to manufacturing subnet
M2 U03: extend existing core with VPN gateway
```

There is no need to duplicate a complete Terraform tree just to preserve the earlier version; Git already preserves it.

## Terraform file organisation

The exact files should appear only when the corresponding story requirement is introduced. A likely evolution might look like:

```text
blueharbor/terraform/
  versions.tf
  providers.tf
  variables.tf
  locals.tf
  network.tf
  dns.tf
  peering.tf
  routing.tf
  nat.tf
  hybrid.tf
  expressroute.tf
  load-balancing.tf
  application-delivery.tf
  security.tf
  private-access.tf
  monitoring.tf
  outputs.tf
```

Do not pre-create empty files simply to match this example. Prefer explicit readable resources first; introduce modules, `for_each`, locals and other abstraction only when they improve the project rather than hide what Azure is doing.

## Design-heavy or externally dependent services

Terraform is the provisioning method, but some technologies such as ExpressRoute can require an external connectivity provider or other non-Azure dependencies. Provision all practical Azure-side components through the cumulative Terraform stack, then document/simulate the external boundary accurately where an external provider is genuinely required.

The objective is still one continuous architecture; external dependencies do not justify resetting the Terraform environment.
