# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and at meaningful checkpoints.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Last completed lab:** Lab 01 — Azure Load Balancer
- **Next lab:** Lab 02 — Azure Traffic Manager
- **Current phase:** Lab 01 formally complete; ready to begin Lab 02 on the next lab day.
- **Overall progress:** 1 / 15 labs completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-29 (Australia/Brisbane)

## Last completed action

Lab 01 was formally closed after all of the following were completed:

```text
manual Azure CLI build
manual validation and failure/recovery testing
manual teardown
Terraform rebuild
real partial-apply/capacity recovery
Azure CLI and application validation
Portal inspection
outbound SNAT validation
orphan-resource cleanup
Git/GitHub checkpoint
Terraform destroy plan
Terraform teardown
Azure resource-group verification
Terraform-state verification
complete rebuild/practice PDF
learner explain-back
```

Final Terraform destroy plan:

```text
Plan: 0 to add, 0 to change, 21 to destroy.
```

Final Terraform apply result:

```text
Apply complete! Resources: 0 added, 0 changed, 21 destroyed.
```

Independent Azure verification:

```powershell
az group exists --name rg-az700-lb-aue
```

returned:

```text
false
```

Terraform state verification:

```powershell
terraform state list
```

returned no resources.

Lab-specific completion record:

```text
labs/01-load-balancer/handoff/HANDOFF.md
```

Completed Terraform implementation commit:

```text
bf02196 Complete Lab 01 Terraform load balancer deployment
```

## Immediate next action

Do not rebuild Lab 01 during normal programme progression. The completed Lab 01 material is retained for deliberate practice.

The next lab is:

```text
Lab 02 — Azure Traffic Manager
```

Before deploying Lab 02, follow the programme method from the beginning:

```text
1. Problem/use case
2. Mental model
3. Visual architecture and traffic/DNS flow
4. Manual Azure deployment
5. Azure CLI inspection and validation
6. Teardown if appropriate before IaC rebuild
7. Terraform implementation
8. terraform fmt / validate / plan / apply
9. Independent Azure CLI validation
10. Failure testing and troubleshooting
11. Portal inspection where useful
12. Evidence and lessons
13. Git/GitHub checkpoint
14. Handoff update
15. Safe teardown
16. Learner explain-back
```

## Lab 01 completion summary

Lab 01 implemented and validated a Standard Public Azure Load Balancer architecture in Australia East with:

```text
VNet:   10.200.0.0/16
Subnet: 10.200.1.0/24
```

The design used:

- Standard zone-redundant public IP
- Standard Azure Load Balancer
- frontend `fe-public`
- backend pool `be-web`
- HTTP health probe on port 80 path `/`
- TCP/80 inbound load-balancing rule
- explicit Load Balancer outbound SNAT rule
- subnet-level NSG allowing public TCP/80
- three private backend NICs/VMs across Availability Zones 1, 2, and 3
- Apache installed and configured through cloud-init
- no individual backend VM public IPs

Final Terraform-built VM placement before teardown was:

```text
Zone 1 -> vm-web-az1 -> Standard_B2als_v2 -> 10.200.1.5
Zone 2 -> vm-web-az2 -> Standard_B2als_v2 -> 10.200.1.6
Zone 3 -> vm-web-az3 -> Standard_B2ls_v2  -> 10.200.1.4
```

## Lab 01 key networking lessons

### Inbound Load Balancer flow

The validated mental model is:

```text
Client
  -> public IP / LB frontend
  -> matching load-balancing rule
  -> continuously maintained healthy backend set
  -> five-tuple-based flow selection
  -> backend NIC/private IP
  -> NSG security evaluation
  -> Apache TCP/80
  -> response through established flow
```

The health probe is continuous and is not triggered only when a user request arrives.

Azure Load Balancer uses flow-based selection rather than guaranteed request-by-request round-robin. The default behavior should be thought of as **flow affinity**, not application sticky sessions: one established TCP flow stays with its selected backend, while a new flow may select another healthy backend.

### Application health versus VM state

A VM can remain powered on while its application is unhealthy. Stopping Apache on VM2 caused the HTTP health probe to remove it from new flows. Restarting Apache allowed it to rejoin automatically after probe recovery.

### NSG, routing, and SNAT are separate concepts

```text
NSG   = may this traffic pass?
Route = where should this traffic go?
SNAT  = what source identity should outbound traffic use?
```

`defaultOutboundAccess = false` was a subnet setting. The NSG could permit outbound traffic but did not itself create Internet egress or perform NAT.

The dedicated Standard Load Balancer outbound rule supplied SNAT. The backend VMs had different private IPs but shared the Load Balancer frontend public IP as their Internet-visible egress identity.

The Standard Public Load Balancer can perform SNAT through an outbound rule, but it is not a general-purpose router or UDR next hop.

## Lab 01 key Terraform lessons

- Terraform configuration files in one directory form one configuration regardless of filename.
- Variables provide external input; locals provide internal reusable values.
- `for_each` created keyed NIC and VM instances.
- Terraform resource addresses differ from Azure resource names.
- References create implicit graph dependencies.
- `depends_on` can represent an operational dependency not expressed by a property reference.
- Terraform apply is **not transactional**. Successful resources remain and are recorded even if another operation later fails.
- After the first partial apply, state contained the 20 successful resources, so the next plan proposed only the missing VM3.
- Azure can retain a failed object even when Terraform did not record it as a successfully managed resource.
- Terraform does not silently overwrite an unmanaged Azure object at the desired resource ID. The failed VM had to be reconciled deliberately.
- Failed provider/API operations can leave unmanaged artifacts such as unattached disks.
- A final no-change plan demonstrated convergence among configuration, Terraform state, and observed Azure infrastructure.
- A saved destroy plan was reviewed before teardown, then applied exactly.

## Lab 01 real capacity lesson

Azure capacity and subscription availability are runtime constraints, not merely configuration questions.

Observed during the lab:

```text
Standard_B1ms
-> zone support existed
-> deployment failed because of live capacity

Standard_B2s
-> reported unavailable for the subscription

Standard_B2als_v2
-> worked in Zones 1 and 2
-> later lacked live capacity in Zone 3 during Terraform apply

Standard_B2ls_v2
-> used successfully for the Zone 3 backend
```

Remember:

```text
SKU exists in region
      !=
SKU permitted for subscription
      !=
SKU supports requested zone
      !=
live capacity is available right now
```

## Lab 01 documentation retained

Manual CLI walkthrough:

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

Lab completion handoff:

```text
labs/01-load-balancer/handoff/HANDOFF.md
```

A separate full PDF rebuild/practice manual was produced after teardown so Lab 01 can be rebuilt later without relying on the original chat.

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

Lab 01 completed all 16 stages.

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

> Terraform describes and manages desired infrastructure. Azure CLI independently inspects, validates, and troubleshoots what actually exists in Azure.

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

## Resume instruction

Programme resumes at:

```text
Lab 02 — Azure Traffic Manager
```

Lab 01 is complete and should only be revisited for deliberate rebuild practice using its documentation.
