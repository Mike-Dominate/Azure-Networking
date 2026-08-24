# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and whenever the programme changes direction.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Current lab:** Lab 01 — Azure Load Balancer
- **Current phase:** Manual Azure CLI deployment completed, validated, failure/recovery tested, outbound tested, and destroyed. Ready for Terraform rebuild after Git synchronization.
- **Overall progress:** 0 / 15 labs completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-25 (Australia/Brisbane)

## Last completed action

Completed the full direct/manual Azure CLI lifecycle for Lab 01 and verified teardown:

```powershell
az group exists --name rg-az700-lb-aue
```

returned:

```text
false
```

A detailed command/syntax walkthrough was added at:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

The lab-specific continuation record is:

```text
labs/01-load-balancer/handoff/HANDOFF.md
```

## Immediate next action

The remote repository was updated with the latest documentation after the user's last local Git status check. The user also has a new local untracked file:

```text
labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

Therefore, from the local repository, synchronize first:

```powershell
git pull --rebase origin main
```

Then inspect status, add/commit the local cloud-init file, and push it:

```powershell
git status --short
git add labs/01-load-balancer/manual-deployment/cloud-init.yaml
git commit -m "Add Lab 01 cloud-init configuration"
git push origin main
```

Verify:

```powershell
git status
git log --oneline -5
```

Only after the Git repository is synchronized should the Terraform phase begin.

## Lab 01 manual build summary

The following architecture was successfully created in `australiaeast`:

```text
Client
  |
  v
Standard Public IP
  |
  v
Standard Azure Load Balancer
  |
  +--> Frontend IP configuration
  +--> TCP/80 load-balancing rule
  +--> HTTP/80 health probe path /
  +--> explicit outbound rule
  |
  v
Backend pool
  |
  +--> vm-web-az1 / Zone 1 / 10.200.1.4
  +--> vm-web-az2 / Zone 2 / 10.200.1.5
  +--> vm-web-az3 / Zone 3 / 10.200.1.6
          |
          v
     Web subnet / subnet NSG
          |
          v
        Apache
```

Network addressing:

```text
VNet:   10.200.0.0/16
Subnet: 10.200.1.0/24
```

Backend VMs had no individual public IP addresses.

## Manual phase tests completed

- [x] Each VM cloud-init completed successfully.
- [x] Apache was active on all three backends.
- [x] Each web page displayed its own VM hostname.
- [x] Public Load Balancer frontend returned an end-to-end HTTP response.
- [x] Repeated new TCP connections reached all three healthy backends.
- [x] Apache on VM2 was stopped while VM2 remained running.
- [x] Health probe removed VM2 from new traffic.
- [x] Traffic continued through VM1 and VM3.
- [x] Apache on VM2 was restarted.
- [x] Health probe automatically returned VM2 to service.
- [x] Outbound test from VM1 showed the Load Balancer public IP as the external source IP.
- [x] Resource Group was deleted after testing.
- [x] Resource Group absence was verified.

## Important troubleshooting lessons captured

### VM SKU behavior

`Standard_B1ms` supported Availability Zones 1/2/3 but failed at actual deployment because Azure reported live capacity restrictions.

`Standard_B2s` existed but was reported `NotAvailableForSubscription`.

`Standard_B2als_v2` was selected after checking restrictions and zone support. It successfully deployed across Zones 1, 2, and 3.

The key lesson is:

```text
SKU supports a zone
      !=
SKU has live capacity right now
      !=
SKU is allowed for the current subscription
```

### Application health versus VM power state

A VM can be `running` while its application is unhealthy. The failure exercise stopped Apache without stopping VM2, and the HTTP health probe removed that backend from new flows.

### Load distribution

Azure Load Balancer behavior should be understood as **flow-hash based**, not guaranteed request-by-request round-robin. The test generated separate client connections to make distribution observable.

### Explicit outbound connectivity

The subnet reported `defaultOutboundAccess: false`, so the lab used the Standard Load Balancer outbound rule to provide explicit SNAT for the private backend VMs.

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

Lab 01 has now completed steps 1 through 6 and is ready for step 7 after repository synchronization.

## Tooling agreement

Use the normal engineering tools throughout the programme instead of studying them separately:

- **VS Code** — primary editor/workspace and integrated terminal
- **Terraform** — primary Infrastructure as Code implementation
- **Azure CLI** — inspection, verification, troubleshooting, queries, and selected operational tasks
- **Git** — local source control and progression history
- **GitHub** — remote source of truth and portfolio/reference repository
- **Azure Portal** — visual learning and troubleshooting/inspection where useful
- **PowerShell/Bash** — supporting scripting when appropriate

Terraform and Azure CLI have deliberately different roles:

> Terraform describes and manages the desired infrastructure. Azure CLI helps inspect and prove what actually exists in Azure.

## Source curriculum

Reference repository:

`https://github.com/rithinskaria/kodekloud-az700`

Use it for lab objectives and concepts. Do not simply copy its PowerShell workflow. Rebuild the exercises as our own visual + direct deployment + Terraform + validation learning programme.

## Guardrails / anti-drift rules

1. One lab per day maximum.
2. Never mark a lab complete only because deployment succeeded.
3. Teach Azure networking before teaching the Terraform resource syntax for it.
4. Use the portal for visual understanding, not as the only deployment method.
5. Use Azure CLI to independently validate what was created.
6. Rebuild applicable labs with Terraform.
7. Never commit secrets, credentials, private keys, certificates, `.tfstate`, `.tfvars` containing sensitive values, or Azure tokens.
8. Update the handoff at the end of a working session or explicit checkpoint rather than after every command.
9. If a future conversation lacks context, this file and the lab-specific handoff override conversational guesses.
10. Do not begin the next lab until the current lab definition of done is satisfied.
11. Teach command and Terraform syntax rather than only providing commands to copy.

## Current repository checkpoint

Remote GitHub now contains updated documentation, including:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
labs/01-load-balancer/handoff/HANDOFF.md
docs/HANDOFF.md
```

The user's last known local Git state before these remote documentation commits was:

```text
?? labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

Because both the local working tree and remote `main` now have new work, **pull/rebase before committing and pushing the local file**.

## Resume instruction

Do not recreate the manual Azure deployment.

Resume with:

```powershell
git pull --rebase origin main
```

Then commit/push the local cloud-init file. Once the repository is clean and synchronized, inspect:

```powershell
Get-ChildItem .\labs\01-load-balancer\terraform
```

Then begin Terraform teaching from syntax and resource relationships before running `terraform init`, `plan`, or `apply`.
