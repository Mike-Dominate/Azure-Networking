# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and whenever the programme changes direction.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Current lab:** Lab 01 — Azure Load Balancer
- **Current phase:** Repository/bootstrap complete; Lab 01 learning has not started yet
- **Overall progress:** 0 / 15 labs completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-24 (Australia/Brisbane)

## Last completed action

Initial repository structure and programme governance files created.

## Next action

Begin **Lab 01 — Azure Load Balancer** with the visual/mental-model lesson before any deployment or Terraform code.

The first lab action should be:

1. Explain the problem a Layer 4 Azure Load Balancer solves.
2. Draw and understand the traffic path: Client -> Public IP -> Load Balancer frontend -> rule -> health probe/backend pool -> VM NIC -> subnet/NSG -> Apache.
3. Confirm the learner can explain frontend IP configuration, backend pool, health probe, load-balancing rule, availability zones, and where the NSG applies.

Do **not** jump straight to Terraform.

## Agreed learning method

Every applicable lab follows this sequence:

```text
1. Problem and use case
2. Mental model
3. Visual architecture and packet/traffic flow
4. Direct/manual Azure deployment
5. Azure CLI inspection and validation
6. Teardown if needed before IaC rebuild
7. Terraform implementation
8. terraform fmt / validate / plan / apply
9. Azure CLI validation of Terraform-built environment
10. Failure testing and troubleshooting
11. Portal inspection where visually useful
12. Capture evidence and lessons learned
13. Git/GitHub commit history
14. Complete/update lab handoff
15. Safe teardown
16. Learner explains the design back in their own words
```

## Tooling agreement

Use the normal engineering tools throughout the programme instead of studying them separately:

- **VS Code** — primary editor/workspace and integrated terminal
- **Terraform** — primary Infrastructure as Code implementation
- **Azure CLI** — inspection, verification, troubleshooting, queries, and selected operational tasks
- **Git** — local source control and progression history
- **GitHub** — remote source of truth and portfolio/reference repository
- **Azure Portal** — visual learning, direct deployment where useful, and troubleshooting/inspection
- **PowerShell/Bash** — supporting scripting when appropriate

Terraform and Azure CLI have deliberately different roles:

> Terraform describes and manages the desired infrastructure. Azure CLI helps inspect and prove what actually exists in Azure.

## Source curriculum

Reference repository:

`https://github.com/rithinskaria/kodekloud-az700`

Use it for lab objectives and concepts. Do not simply copy its PowerShell workflow. Rebuild the exercises as our own visual + direct deployment + Terraform + validation learning programme.

## Lab 01 source intent

Original concept:

- Standard public Azure Load Balancer
- VNet: `10.200.0.0/16`
- Web subnet: `10.200.1.0/24`
- Three Ubuntu web VMs across availability zones 1, 2, and 3
- Apache web server on each backend
- Backend pool
- HTTP health probe on port 80
- Load-balancing rule frontend 80 -> backend 80

We may adjust region, names, VM size, authentication method, and implementation details where required for current Azure practices, cost, availability, or security, while preserving the networking learning objective.

## Guardrails / anti-drift rules

1. One lab per day maximum.
2. Never mark a lab complete only because deployment succeeded.
3. Teach Azure networking before teaching the Terraform resource syntax for it.
4. Use the portal for visual understanding, not as the only deployment method.
5. Use Azure CLI to independently validate what was created.
6. Rebuild applicable labs with Terraform.
7. Never commit secrets, credentials, private keys, certificates, `.tfstate`, `.tfvars` containing sensitive values, or Azure tokens.
8. Update this handoff before ending a working session.
9. If a future conversation lacks context, this file overrides conversational guesses.
10. Do not begin the next lab until the current lab definition of done is satisfied.

## Decisions made

| Decision | Rationale |
|---|---|
| Use one lab per day | Prioritise understanding and repetition over speed |
| Keep a living handoff file | Prevent context loss and programme drift |
| Use visual + direct + IaC deployment | Learn both Azure itself and repeatable engineering |
| Use Terraform as primary IaC | Build practical platform/cloud engineering skill |
| Use Azure CLI throughout | Develop operational inspection/troubleshooting skill |
| Maintain work in `Mike-Dominate/Azure-Networking` | Preserve progression as portfolio and future reference |
| Keep KodeKloud repo as reference only | Preserve objectives while producing an independent implementation |

## Open items

- Verify local workstation tooling from VS Code integrated terminal when Lab 01 starts: `az`, `terraform`, `git`, and GitHub authentication/workflow.
- Decide the Azure region for Lab 01 based on three-zone availability and VM SKU availability at execution time.
- Prefer SSH keys rather than the source lab's shared password for Linux VMs.

## Session log

### 2026-08-24 — Programme bootstrap

- User created `Mike-Dominate/Azure-Networking`.
- Repository confirmed empty and writable.
- Programme structure established.
- Handoff control file established.
- Next session/action is Lab 01 visual learning, not deployment.
