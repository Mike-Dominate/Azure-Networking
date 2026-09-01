# Working Method

This programme teaches Azure networking as one progressive BlueHarbor Industries engineering project.

## Governance

- Microsoft Learn AZ-700 path defines module and unit order.
- The current AZ-700 study guide is the completeness check.
- Azure product documentation is the technical behaviour authority.
- The BlueHarbor story provides the progressive business context.
- Legacy labs are reference history only and do not override story continuity.

## Story continuity

Do not skip or reshape a chapter merely because a similar service was built previously. Prior knowledge may shorten teaching time, but the BlueHarbor architecture must evolve in Microsoft Learn order.

A unit begins with the business problem that makes the next networking capability necessary.

## Standard lifecycle

### Phase A — Understand

1. Identify the exact Microsoft Learn unit.
2. State the BlueHarbor business problem.
3. Complete the tutorial/mental model before deployment.
4. Draw the architecture and traffic/control-plane flow.
5. Identify dependencies, failure points, security boundaries and trade-offs.
6. Use an explain-back to confirm understanding.

### Phase B — Direct Azure learning

1. Follow the Microsoft exercise objective where one exists.
2. Deploy/configure directly with Azure CLI and/or Portal where educationally useful.
3. Work one meaningful action at a time during interactive tutoring.
4. Inspect major resources after creation.
5. Generate real traffic/protocol activity where possible.
6. Validate with Azure CLI and client/network tools.
7. Deliberately test at least one safe failure or misconfiguration.

### Phase C — Infrastructure as Code

1. Start Terraform from a known state.
2. Rebuild the same architecture where useful.
3. Keep resources explicit and understandable before introducing abstractions.
4. Run `terraform fmt`, `init`, `validate`, `plan` and `apply`.
5. Validate the deployed service independently; a successful apply is not proof of end-to-end function.

### Phase D — Operate and troubleshoot

1. Test normal behaviour.
2. Test one or more failure scenarios.
3. Inspect effective Azure state rather than guessing.
4. Use appropriate tools such as DNS queries, effective routes, Network Watcher, flow logs and application tests.
5. Record symptom, hypothesis, investigation, root cause, fix and verification.

### Phase E — Document, hand off and clean up

1. Update the unit/module README when status changes.
2. Capture useful commands and evidence.
3. Record trade-offs and lessons.
4. Update `docs/HANDOFF.md`, `docs/PROGRAMME-ROADMAP.md` and root `README.md`.
5. Commit meaningful progression.
6. Create rebuild notes/manuals for substantial practical work.
7. Destroy resources that do not need to persist.
8. Independently verify Azure cleanup and Terraform state cleanup.
9. Carry the resulting architecture and decisions into the next unit.

## Status consistency

These must agree whenever progress changes:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
modules/<module>/README.md
modules/<module>/<unit>/README.md
```

## Git progression

Prefer small commits tied to the Microsoft unit and BlueHarbor story, for example:

```text
Module 1 Unit 02: document BlueHarbor VNet design
Module 1 Unit 04: add CLI VNet implementation
Module 1 Unit 06: add DNS validation and failure test
```

## Tooling

Primary workspace/tools:

- VS Code
- Azure CLI
- Terraform
- Git/GitHub
- Azure Portal where visual inspection adds value
- protocol/network diagnostic tools

## Design-heavy or expensive services

Full provisioning is not required merely to claim a topic was covered. For services such as ExpressRoute or commercial NVA integrations, use rigorous architecture, route/BGP analysis, configuration objects, redundancy scenarios and troubleshooting where provider involvement or cost makes a full build unreasonable.

The goal is accurate engineering understanding, not artificial spending.
