# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and at meaningful checkpoints.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Current lab:** Lab 01 — Azure Load Balancer
- **Current phase:** CLOSEOUT — manual deployment and Terraform rebuild are complete and validated; Terraform-managed Azure resources are still running and are ready for planned teardown.
- **Overall progress:** 0 / 15 labs formally completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-26 (Australia/Brisbane)

## Last completed action

Lab 01 Terraform implementation was completed, validated, committed, and pushed to GitHub.

Final Terraform convergence check:

```powershell
terraform plan
```

returned:

```text
No changes. Your infrastructure matches the configuration.
```

Completed Terraform commit:

```text
bf02196 Complete Lab 01 Terraform load balancer deployment
```

Lab-specific continuation record:

```text
labs/01-load-balancer/handoff/HANDOFF.md
```

Detailed manual deployment walkthrough:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

## Immediate next action

Do not rebuild or modify the running Lab 01 environment.

From:

```text
C:\Users\W_Admin\Azure-Networking\labs\01-load-balancer\terraform
```

continue with:

```text
1. Generate and review a Terraform destroy plan.
2. Apply the reviewed destroy plan.
3. Verify resource group rg-az700-lb-aue no longer exists.
4. Confirm Terraform state contains no managed resources.
5. Update Lab 01 handoff to COMPLETE.
6. Commit/push final closeout documentation.
7. Complete learner explain-back / reflection.
8. Only then begin Lab 02.
```

## Lab 01 final architecture before teardown

Terraform created the following architecture in `australiaeast`:

```text
Internet client
      |
      | HTTP TCP/80
      v
Standard zone-redundant Public IP
pip-az700-lb-aue
40.82.216.41
      |
      v
Standard Azure Load Balancer
lb-az700-aue
      |
      +-- Frontend: fe-public
      +-- HTTP health probe: probe-http (port 80, path /)
      +-- Load-balancing rule: rule-http (TCP 80 -> 80)
      +-- Explicit outbound SNAT rule: outbound-web
      |
      v
Backend pool: be-web
      |
      +----------------------+----------------------+----------------------+
      |                      |                      |
      v                      v                      v
vm-web-az1               vm-web-az2               vm-web-az3
Zone 1                   Zone 2                   Zone 3
Standard_B2als_v2        Standard_B2als_v2        Standard_B2ls_v2
10.200.1.5               10.200.1.6               10.200.1.4
Apache :80               Apache :80               Apache :80
```

Network addressing:

```text
VNet:   10.200.0.0/16
Subnet: 10.200.1.0/24
```

All backend VMs have no individual public IP addresses.

## Lab 01 phases completed

- [x] Problem/use-case discussion
- [x] Mental model
- [x] Visual architecture
- [x] Manual Azure CLI deployment
- [x] Manual Azure CLI validation
- [x] Manual failure/recovery testing
- [x] Manual outbound SNAT testing
- [x] Manual environment teardown
- [x] Terraform syntax and file-structure teaching
- [x] Terraform `init`, `fmt`, `validate`, `plan`, and `apply`
- [x] Real Terraform partial-apply recovery
- [x] Azure zonal-capacity troubleshooting
- [x] Terraform convergence test
- [x] Azure CLI validation of Terraform-built resources
- [x] Application/cloud-init/Apache validation
- [x] Load distribution validation
- [x] Terraform health-probe failure/recovery test
- [x] Explicit outbound SNAT validation
- [x] Azure Portal inspection
- [x] Orphaned failed-deployment disk cleanup
- [x] Terraform outputs
- [x] Git commit and GitHub push
- [ ] Terraform teardown
- [ ] Final resource/state verification
- [ ] Learner explain-back / reflection
- [ ] Lab 01 formally marked COMPLETE

## Key Lab 01 lessons

### Azure Load Balancer mental model

- Clients connect to the Load Balancer frontend rather than directly to backend VMs.
- Backend pool members are NIC/IP configurations that are candidates for new flows.
- Health probes continuously determine whether a backend is eligible for new flows.
- The load-balancing rule ties frontend, backend pool, protocol/ports, and probe together.
- Azure Load Balancer is Layer 4; it does not perform path- or host-based HTTP routing.
- Distribution is flow-hash based, not guaranteed request-by-request round-robin.

### Application health versus VM state

A VM can remain powered on while its application is unhealthy. Stopping Apache on VM2 caused the HTTP health probe to remove it from new flows. Restarting Apache allowed it to rejoin automatically after probe recovery.

### Explicit outbound connectivity

The subnet was configured with default outbound access disabled. A dedicated Standard Load Balancer outbound rule supplied SNAT for the private backend VMs. An external-IP test from VM1 returned the same IP as the LB frontend, proving the explicit outbound path.

### Availability and capacity

`Standard_B2als_v2` worked in Zones 1 and 2 but failed in Zone 3 during the Terraform deployment with `ZonalAllocationFailed` due to live capacity.

The final design preserved three-zone placement by using:

```text
Zone 1 -> Standard_B2als_v2
Zone 2 -> Standard_B2als_v2
Zone 3 -> Standard_B2ls_v2
```

The key lesson remains:

```text
SKU supports a zone
      !=
SKU has live capacity right now
      !=
SKU is permitted for the current subscription
```

### Terraform behavior

- Terraform apply is not transactional; successful resources remain if a later resource fails.
- Terraform state recorded the 20 successful resources after the first partial apply.
- A failed Azure VM object could exist even when the resource was absent from Terraform state.
- Azure may leave provider/API artifacts such as unattached disks after a failed deployment.
- Suspected orphan resources must be inspected before manual deletion.
- `for_each` allowed one NIC/VM definition to create three keyed instances.
- An explicit `depends_on` was used because cloud-init required outbound connectivity before VM bootstrap, even though no VM property directly references the outbound rule.
- Terraform outputs provide a clean operator/automation interface to runtime-assigned values.
- A final no-change plan demonstrated convergence between desired configuration, state, and Azure.

## Terraform tooling checkpoint

```text
Terraform CLI:        1.15.8
AzureRM provider:     4.81.0
Provider constraint:  ~> 4.0
```

`.terraform.lock.hcl` is committed. Local `terraform.tfvars`, `.terraform/`, Terraform state, plan files, credentials, and private keys are ignored and must not be committed.

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

Lab 01 has completed steps 1 through 14. Step 15 is the immediate next action; step 16 follows before the lab is marked complete.

## Tooling agreement

Use the normal engineering tools throughout the programme rather than studying them separately:

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

Use it for lab objectives and concepts. Do not simply copy its workflow. Rebuild the exercises as our own visual + direct deployment + Terraform + validation learning programme.

## Guardrails / anti-drift rules

1. One lab per day maximum.
2. Never mark a lab complete only because deployment succeeded.
3. Teach Azure networking before teaching Terraform syntax for it.
4. Use the Portal for visual understanding, not as the only deployment method.
5. Use Azure CLI to independently validate what Terraform created.
6. Rebuild applicable labs with Terraform.
7. Never commit secrets, credentials, private keys, certificates, `.tfstate`, local `.tfvars`, Azure tokens, or other sensitive execution artifacts.
8. Update handoffs at the end of a working session or meaningful checkpoint rather than after every command.
9. Do not begin the next lab until the current lab has been safely torn down and formally closed out.
