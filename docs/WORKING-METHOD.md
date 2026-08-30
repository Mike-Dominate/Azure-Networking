# Working Method

This programme is designed to teach Azure networking and the engineering practices used to build, verify, troubleshoot, document and reproduce it.

## Coverage governance

- The Microsoft AZ-700 skills measured outline is the programme's coverage authority.
- The current baseline is the skills outline effective July 27, 2026.
- External lab repositories are learning references, not the definition of completeness.
- When Microsoft materially changes the AZ-700 outline, review `docs/PROGRAMME-ROADMAP.md` before continuing blindly.

## Standard lab lifecycle

### Phase A — Understand

1. Define the problem the Azure service solves.
2. Teach the concept before testing the learner on unfamiliar material.
3. Build the mental model before touching the portal or Terraform.
4. Draw the architecture and traffic/control-plane flow.
5. Identify control plane vs data plane where relevant.
6. Identify dependencies, failure points, security boundaries and trade-offs.
7. Use a short explain-back to confirm understanding.

### Phase B — Direct Azure learning

1. Deploy/configure the service directly using Azure CLI and/or the Azure Portal where educationally useful.
2. Explain important commands and parameters before execution.
3. Work one meaningful action at a time during interactive learning.
4. Inspect each major resource after creation.
5. Generate real traffic or protocol activity where possible.
6. Verify behaviour using Azure CLI and client-side/network tools.
7. Deliberately test at least one failure or misconfiguration where safe.

### Phase C — Infrastructure as Code

1. Remove or isolate the direct deployment so Terraform starts from a known state.
2. Build the same architecture in Terraform where practical.
3. Use small, understandable increments rather than pasting a complete solution.
4. Run:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

5. Inspect the deployed resources independently with Azure CLI or protocol-level tests.
6. Compare the direct deployment mental model with the Terraform resource graph.
7. Do not treat a successful Terraform apply as proof that the service works end to end.

### Phase D — Operate and troubleshoot

1. Test normal traffic/control-plane behaviour.
2. Test one or more failure scenarios.
3. Inspect Azure-side configuration and effective state.
4. Use the appropriate tools rather than guessing: DNS tools, effective routes, Network Watcher, flow logs, application tests and Azure Monitor where applicable.
5. Record the symptom, hypothesis, investigation, root cause, fix and verification.

### Phase E — Document and hand off

1. Update the lab README.
2. Capture important commands and evidence.
3. Record lessons learned and trade-offs.
4. Update the lab handoff.
5. Update `docs/HANDOFF.md` with the exact programme continuation point.
6. Update `docs/PROGRAMME-ROADMAP.md` and root `README.md` when status changes.
7. Commit meaningful progression to Git/GitHub.
8. Create a rebuild/practice manual for substantial practical labs.
9. Destroy resources when the lab does not need to remain deployed.
10. Independently verify that intended resources and Terraform state are clean after teardown.

## Status consistency

Whenever a lab status changes, these sources must agree:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
labs/<lab>/README.md
labs/<lab>/handoff/HANDOFF.md
```

Do not leave stale `NEXT`, `NOT STARTED`, `IN PROGRESS` or `COMPLETE` markers in conflicting files.

## Git progression

Prefer small commits that communicate learning progression. Example:

```text
Lab 01: document load balancer mental model
Lab 01: add direct deployment notes
Lab 01: add Terraform network foundation
Lab 01: add backend compute and health probe
Lab 01: implement load balancing rule
Lab 01: add validation and failure test evidence
Lab 01: complete handoff
```

## VS Code usage

VS Code is the primary engineering workspace. Throughout the programme practise:

- Explorer and file navigation
- Integrated terminal
- Multi-file editing
- Search across the repository
- Source Control view
- Git diff inspection
- Terraform language support
- Markdown preview
- Command Palette
- Workspace settings where useful

## Terraform conventions

Start explicit and readable. Optimisation and abstraction come after understanding.

Typical lab layout:

```text
terraform/
├── versions.tf
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── terraform.tfvars.example
```

Later labs may introduce:

- `locals`
- `for_each`
- modules
- remote state
- CI validation
- policy/security scanning

Only introduce these when they improve learning rather than hide the underlying Azure resource relationships.

## Azure CLI conventions

CLI is used to answer questions such as:

- What resources exist?
- What IPs were assigned?
- What backend members are configured?
- What rules/probes/routes are effective?
- What Azure thinks the current configuration is?
- Is the service healthy?

Do not treat CLI output as proof by itself when an end-to-end traffic test is possible.

## Design-heavy / expensive services

Full provisioning is not required merely to say a topic was covered. For services such as ExpressRoute, where provider involvement or cost makes a real build impractical, use rigorous alternatives:

- architecture diagrams
- realistic configuration objects
- BGP and route tables
- redundancy/failure scenarios
- validation plans
- troubleshooting decision trees
- service-selection trade-offs

The goal is accurate engineering understanding, not artificial spending.

## Evidence

Capture only evidence that teaches or proves something. Useful evidence includes:

- architecture diagrams
- `terraform plan` summaries
- Azure CLI resource queries
- DNS resolution output
- route/effective route inspection
- health probe status
- HTTP responses from multiple backends
- Network Watcher results
- flow-log/monitor evidence
- failure-test observations
- screenshots that clarify Azure relationships

Do not fill the repository with redundant screenshots.
