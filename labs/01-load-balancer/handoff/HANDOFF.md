# Lab 01 Handoff — Azure Load Balancer

Use this file to resume Lab 01 precisely.

## Status

- **Lab:** 01 — Azure Load Balancer
- **State:** IN PROGRESS — CLOSEOUT
- **Current phase:** Manual build and Terraform rebuild are complete and fully validated. The Terraform environment is still running and is ready for planned teardown.
- **Last completed action:** Pushed the completed Terraform implementation to GitHub in commit `bf02196` after a final `terraform plan` returned `No changes. Your infrastructure matches the configuration.`
- **Next action:** Review a Terraform destroy plan, destroy the Terraform-managed environment, verify the resource group is gone, then mark Lab 01 COMPLETE.
- **Last updated:** 2026-08-26 (Australia/Brisbane)

## Current Terraform-built architecture

The current environment was created by Terraform in `australiaeast`:

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
      +-- Health probe: probe-http (HTTP/80, path /)
      +-- Inbound rule: rule-http (TCP 80 -> 80)
      +-- Outbound rule: outbound-web (explicit SNAT)
      |
      v
Backend pool: be-web
      |
      +----------------------+----------------------+----------------------+
      |                      |                      |
      v                      v                      v
nic-web-az1              nic-web-az2              nic-web-az3
10.200.1.5               10.200.1.6               10.200.1.4
      |                      |                      |
      v                      v                      v
vm-web-az1               vm-web-az2               vm-web-az3
Zone 1                   Zone 2                   Zone 3
Standard_B2als_v2        Standard_B2als_v2        Standard_B2ls_v2
Apache :80               Apache :80               Apache :80
```

Network foundation:

```text
Resource Group: rg-az700-lb-aue
VNet:           vnet-az700-lb-aue 10.200.0.0/16
Subnet:         snet-web          10.200.1.0/24
NSG:            nsg-az700-web-aue
```

Backend VMs have no individual public IP addresses.

## Completion checklist

- [x] Lab workspace created
- [x] Mental model and visual learning completed
- [x] Direct/manual Azure CLI deployment completed
- [x] Manual deployment validated
- [x] Manual failure/recovery exercise completed
- [x] Manual explicit outbound SNAT validated
- [x] Manual environment destroyed and verified absent
- [x] Manual artifacts committed and pushed
- [x] Terraform initialized with AzureRM provider
- [x] Terraform implementation completed
- [x] `terraform fmt` and `terraform validate` completed successfully
- [x] Initial Terraform plan reviewed
- [x] Terraform deployment completed after real Azure capacity troubleshooting
- [x] Terraform state recovery understood and tested
- [x] Terraform deployment converged with `No changes`
- [x] Terraform outputs added and validated
- [x] VM/cloud-init/Apache validation completed on all three backends
- [x] End-to-end Load Balancer HTTP test completed
- [x] All three healthy backends observed receiving traffic
- [x] Terraform failure exercise completed by stopping Apache on VM2
- [x] Health probe removed VM2 from new flows
- [x] Recovery exercise returned VM2 to service automatically
- [x] Explicit outbound SNAT validated from VM1
- [x] Azure Portal inspection completed
- [x] Orphaned failed-deployment disk identified and removed safely
- [x] Terraform implementation committed and pushed to GitHub
- [ ] Terraform environment destroyed
- [ ] Resource Group absence verified
- [ ] Lab reflection / learner explanation completed
- [ ] Lab marked COMPLETE

## Terraform implementation

Terraform directory:

```text
labs/01-load-balancer/terraform
```

Key files:

```text
versions.tf
providers.tf
variables.tf
main.tf
outputs.tf
terraform.tfvars.example
.terraform.lock.hcl
```

Execution-specific `terraform.tfvars`, `.terraform/`, Terraform state, and `.tfplan` files are intentionally ignored by Git.

Terraform versions used:

```text
Terraform CLI:        1.15.8
AzureRM provider:     4.81.0
Provider constraint:  ~> 4.0
```

The provider lock file is committed so future `terraform init` runs can reproduce the selected provider version by default.

## Terraform concepts learned

- Terraform configuration files in one directory form a single configuration regardless of filename.
- `variable` blocks define external inputs; `locals` define values internal to the configuration.
- Resource references create implicit dependencies.
- `depends_on` is appropriate when an operational dependency exists but no direct property reference expresses it.
- `for_each` was used to create three keyed NIC and VM instances from one resource definition.
- Terraform resource addresses such as `azurerm_linux_virtual_machine.web["az1"]` are different from Azure resource names such as `vm-web-az1`.
- Terraform apply is not transactional: successful resources remain if another resource fails later in the graph.
- Terraform state records successful managed resources and allows subsequent plans to recover incrementally.
- `terraform plan` is the desired-state comparison; `terraform apply` changes infrastructure; `terraform output` exposes useful managed values.
- A final `terraform plan` returning no changes proves desired configuration, Terraform state, and observed Azure infrastructure have converged.

## Important Terraform deployment incident — Zone 3 capacity

The first Terraform deployment planned 21 resources and began successfully. Azure created 20 managed resources, but `vm-web-az3` failed with:

```text
ZonalAllocationFailed
```

`Standard_B2als_v2` did not have sufficient live capacity in Availability Zone 3 at deployment time.

Terraform state correctly contained the 20 successful resources and did not contain `azurerm_linux_virtual_machine.web["az3"]`.

The backend map was updated so VM size is a per-backend property:

```text
az1 -> Zone 1 -> Standard_B2als_v2
az2 -> Zone 2 -> Standard_B2als_v2
az3 -> Zone 3 -> Standard_B2ls_v2
```

This preserved the three-zone design rather than moving the third backend into a zone already in use.

### Failed Azure resource shell

Although the failed VM was not in Terraform state, Azure retained a failed VM object using the original size. A second Terraform apply therefore reported that `vm-web-az3` already existed.

Azure CLI inspection showed:

```text
name:              vm-web-az3
provisioningState: Failed
vmSize:            Standard_B2als_v2
zone:              3
```

The failed VM object was deleted manually. A fresh Terraform plan then showed only:

```text
1 to add, 0 to change, 0 to destroy
```

The replacement `vm-web-az3` successfully deployed in Zone 3 as `Standard_B2ls_v2`.

### Orphaned OS disk cleanup

The failed allocation also left an unattached managed OS disk. Azure CLI was used to compare the two Zone 3 disks and confirm which disk was attached to the successful VM.

The unattached failed-deployment disk was deleted. The active disk remained attached to `vm-web-az3`.

Key lesson:

```text
Terraform state can be correct while Azure still contains artifacts from a failed provider/API operation.
Always inspect ownership/attachment state before manually deleting a suspected orphan.
```

## Terraform validation evidence

### Convergence

Final command:

```powershell
terraform plan
```

Final result:

```text
No changes. Your infrastructure matches the configuration.
```

### Terraform outputs

```powershell
terraform output
```

Observed:

```text
backend_private_ips = {
  "az1" = "10.200.1.5"
  "az2" = "10.200.1.6"
  "az3" = "10.200.1.4"
}
load_balancer_public_ip = "40.82.216.41"
```

`terraform output -raw load_balancer_public_ip` returned `40.82.216.41`.

## Application validation

Azure Run Command was used on all three backend VMs:

```text
cloud-init status: done
Apache: active
Page hostname: correct for each VM
```

Final VM inventory:

```text
vm-web-az1  Zone 1  Standard_B2als_v2  10.200.1.5  no public IP  running
vm-web-az2  Zone 2  Standard_B2als_v2  10.200.1.6  no public IP  running
vm-web-az3  Zone 3  Standard_B2ls_v2   10.200.1.4  no public IP  running
```

## Load Balancer validation

Frontend public IP during the Terraform deployment:

```text
40.82.216.41
```

A direct HTTP request returned the Apache page from a backend VM.

Twelve separate client connections showed all three backends receiving traffic. The observed repeating sequence must not be interpreted as guaranteed round-robin behavior; Azure Load Balancer remains flow-hash based.

### Health-probe failure test

Apache was stopped on `vm-web-az2` while the VM remained running.

After the health probe detection window, repeated client requests showed only:

```text
vm-web-az1
vm-web-az3
```

`vm-web-az2` received no new test flows.

Apache was restarted, the probe recovered, and repeated requests again showed all three backends.

This proved application health and VM power state are separate concepts.

### Explicit outbound SNAT

The subnet is configured with:

```text
default_outbound_access_enabled = false
```

The inbound LB rule has implicit outbound SNAT disabled, and a dedicated outbound rule supplies egress.

From `vm-web-az1`, `curl https://api.ipify.org` returned:

```text
40.82.216.41
```

This matched the Load Balancer frontend public IP and proved the explicit outbound rule was providing SNAT.

## Azure Portal inspection completed

The Portal was used to visually confirm:

- Backend pool `be-web` contained all three NIC/IP configurations across Zones 1, 2 and 3.
- Health probe `probe-http` used HTTP port 80 and path `/`.
- Load-balancing rule `rule-http` mapped frontend TCP/80 to backend TCP/80 and showed all three backends healthy after recovery.
- Outbound rule `outbound-web` used frontend `fe-public`, backend pool `be-web`, protocol `All`, and 10,000 allocated outbound ports per backend.
- Frontend configuration `fe-public` used public IP resource `pip-az700-lb-aue`.

## Git / GitHub checkpoint

Completed Terraform commit:

```text
bf02196 Complete Lab 01 Terraform load balancer deployment
```

The commit was pushed successfully to `origin/main`.

It contains:

- completed `main.tf`
- completed `outputs.tf`
- updated `terraform.tfvars.example`
- `.terraform.lock.hcl` with AzureRM 4.81.0

Repository working tree was clean immediately before the push.

Manual/cloud-init/visual assets had already been committed and pushed in the earlier Lab 01 checkpoint.

## Documentation references

Detailed manual command/syntax walkthrough:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

Visual-learning assets:

```text
labs/01-load-balancer/visual-learning/
```

Terraform implementation:

```text
labs/01-load-balancer/terraform/
```

## Key mental-model checkpoints

- Clients connect to the Load Balancer frontend, not directly to backend VMs.
- The backend pool contains eligible endpoint IP configurations; the health probe determines whether each is currently eligible for new flows.
- Azure Load Balancer is Layer 4; it does not route by URL path or HTTP Host header.
- Distribution is flow-hash based rather than guaranteed round-robin.
- An NSG is a separate security decision point from the Load Balancer.
- A VM can be powered on while its application is unhealthy.
- Health probes remove unhealthy backends and automatically return recovered backends to service.
- Availability Zone support does not guarantee live compute capacity in every zone.
- Explicit Standard Load Balancer outbound rules can provide controlled SNAT for private backend VMs.
- IaC success must be validated independently with Azure CLI and application-level tests.

## Current blockers

None.

## Resume / closeout instruction

Do not rebuild or modify the running lab before teardown.

From:

```text
C:\Users\W_Admin\Azure-Networking\labs\01-load-balancer\terraform
```

continue with:

```text
1. Generate and review a Terraform destroy plan.
2. Apply the reviewed destroy plan.
3. Verify the resource group no longer exists with Azure CLI.
4. Confirm Terraform state is empty / no managed resources remain.
5. Update this handoff to COMPLETE.
6. Commit/push the final Lab 01 closeout documentation.
7. Perform learner reflection / explain-back before beginning Lab 02.
```
