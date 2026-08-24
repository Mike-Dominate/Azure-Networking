# Working Method

This programme is designed to teach Azure networking and the engineering practices used to build, verify, troubleshoot, document, and reproduce it.

## Standard lab lifecycle

### Phase A — Understand

1. Define the problem the Azure service solves.
2. Build the mental model before touching the portal or Terraform.
3. Draw the architecture and traffic flow.
4. Identify control plane vs data plane where relevant.
5. Identify dependencies, failure points, security boundaries, and trade-offs.

### Phase B — Direct Azure learning

1. Deploy/configure the service directly using the Azure Portal and/or Azure CLI where educationally useful.
2. Inspect each major resource after creation.
3. Generate real traffic.
4. Verify behaviour using Azure CLI and client-side tools.
5. Deliberately test at least one failure or misconfiguration where safe.

### Phase C — Infrastructure as Code

1. Remove or isolate the direct deployment so Terraform starts from a known state.
2. Build the same architecture in Terraform.
3. Use small, understandable increments rather than pasting a complete solution.
4. Run:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

5. Inspect the deployed resources independently with Azure CLI.
6. Compare the direct deployment mental model with the Terraform resource graph.

### Phase D — Operate and troubleshoot

1. Test normal traffic flow.
2. Test one or more failure scenarios.
3. Inspect Azure-side configuration and effective state.
4. Record the symptom, hypothesis, investigation, root cause, fix, and verification.

### Phase E — Document and hand off

1. Update the lab README.
2. Capture important commands and evidence.
3. Record lessons learned and trade-offs.
4. Update the lab handoff.
5. Update `docs/HANDOFF.md` with the exact programme continuation point.
6. Commit meaningful progression to Git/GitHub.
7. Destroy resources when the lab does not need to remain deployed.

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

## Evidence

Capture only evidence that teaches or proves something. Useful evidence includes:

- architecture diagrams
- `terraform plan` summaries
- Azure CLI resource queries
- DNS resolution output
- route/effective route inspection
- health probe status
- HTTP responses from multiple backends
- failure-test observations
- screenshots that clarify Azure relationships

Do not fill the repository with redundant screenshots.
