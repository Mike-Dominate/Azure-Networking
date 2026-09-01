# Lab 01 Handoff — Azure Load Balancer

Use this file as the authoritative completion record for Lab 01.

## Status

- **Lab:** 01 — Azure Load Balancer
- **State:** COMPLETE
- **Current phase:** Closed out. Manual build, Terraform rebuild, validation, failure/recovery testing, documentation, teardown, and learner explain-back are complete.
- **Final Azure state:** Lab resource group deleted; no Lab 01 Azure infrastructure remains.
- **Final Terraform state:** Empty; `terraform state list` returned no resources.
- **Completed Terraform implementation commit:** `bf02196` — `Complete Lab 01 Terraform load balancer deployment`
- **Next lab:** Lab 02 — Azure Traffic Manager
- **Last updated:** 2026-08-29 (Australia/Brisbane)

## Final completion checklist

- [x] Lab workspace created
- [x] Mental model and visual learning completed
- [x] Direct/manual Azure CLI deployment completed
- [x] Manual deployment validated
- [x] Manual application failure/recovery exercise completed
- [x] Manual explicit outbound SNAT validated
- [x] Manual environment destroyed and verified absent
- [x] Manual artifacts committed and pushed
- [x] Terraform initialized with AzureRM provider
- [x] Terraform implementation completed
- [x] `terraform fmt` and `terraform validate` completed successfully
- [x] Terraform plan reviewed
- [x] Terraform deployment completed after live Azure capacity troubleshooting
- [x] Terraform partial-apply/state recovery understood and tested
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
- [x] Terraform destroy plan reviewed
- [x] Terraform environment destroyed
- [x] Resource Group absence independently verified with Azure CLI
- [x] Terraform state verified empty
- [x] Complete rebuild/practice PDF produced
- [x] Learner explain-back completed
- [x] Lab marked COMPLETE

## Architecture successfully built

The Terraform rebuild reproduced the manual architecture in `australiaeast`:

```text
Internet client
      |
      | HTTP TCP/80
      v
Standard zone-redundant Public IP
pip-az700-lb-aue
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

Backend VMs had no individual public IP addresses.

## Manual deployment outcome

The manual Azure CLI build successfully created the VNet, subnet, Standard Public IP, Standard Load Balancer, backend pool, HTTP health probe, TCP/80 rule, dedicated outbound rule, subnet NSG, three backend NICs, and three Apache VMs across Availability Zones 1, 2, and 3.

The manual deployment used `Standard_B2als_v2` after `Standard_B1ms` failed due to live capacity and `Standard_B2s` was reported as unavailable for the subscription.

The manual public IP during testing was `20.92.75.118`. It was released when the manual resource group was deleted.

Detailed command-by-command documentation is stored at:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

## Terraform implementation

Terraform directory:

```text
labs/01-load-balancer/terraform
```

Key committed files:

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

Versions used:

```text
Terraform CLI:        1.15.8
AzureRM provider:     4.81.0
Provider constraint:  ~> 4.0
```

The completed implementation used `for_each` over keyed backends, resource references for dependency construction, an explicit `depends_on` for the operational cloud-init/outbound-connectivity dependency, SSH-key authentication, dynamic private IP allocation, a zone-redundant Standard public IP, a dedicated LB outbound rule, and Terraform outputs for the LB public IP and backend private IPs.

## Important Terraform deployment incident — Zone 3 capacity

The first Terraform apply planned 21 resources. Twenty resources succeeded, but `vm-web-az3` failed with:

```text
ZonalAllocationFailed
```

`Standard_B2als_v2` lacked live capacity in Availability Zone 3 at that moment.

Terraform state retained the 20 resources that had successfully completed. Terraform apply is **not transactional**: it does not automatically roll back successful resources merely because a later resource fails. Dependency relationships influence creation/destruction ordering; they do not provide transaction-style rollback.

The backend map was changed to:

```text
az1 -> Zone 1 -> Standard_B2als_v2
az2 -> Zone 2 -> Standard_B2als_v2
az3 -> Zone 3 -> Standard_B2ls_v2
```

A subsequent plan correctly proposed only one missing resource because Terraform compared configuration with its existing state and recognized that the other 20 managed resources already existed.

### Failed Azure resource shell

Although the failed VM was not in Terraform state, Azure had retained a failed `vm-web-az3` object using the original SKU. Terraform therefore refused to create another resource at the same Azure resource ID/name.

Azure CLI inspection showed the object in `Failed` provisioning state. Because it was an unwanted failed object and the desired VM definition had changed to a different SKU, it was deleted manually rather than imported. Terraform was then able to create the desired Zone 3 VM.

### Orphaned OS disk

The failed allocation also left an unattached managed OS disk. The active Zone 3 disk was identified by attachment state, and only the unattached failed-deployment disk was deleted.

Key lesson:

```text
Terraform state can accurately represent successful managed resources
while Azure can still contain artifacts left by a failed provider/API operation.
Inspect before manually deleting suspected orphans.
```

## Validation evidence

Final Terraform-built VM inventory before teardown:

```text
vm-web-az1  Zone 1  Standard_B2als_v2  10.200.1.5  no public IP
vm-web-az2  Zone 2  Standard_B2als_v2  10.200.1.6  no public IP
vm-web-az3  Zone 3  Standard_B2ls_v2   10.200.1.4  no public IP
```

Terraform outputs before teardown:

```text
backend_private_ips = {
  "az1" = "10.200.1.5"
  "az2" = "10.200.1.6"
  "az3" = "10.200.1.4"
}
load_balancer_public_ip = "40.82.216.41"
```

All three backends showed:

```text
cloud-init status: done
Apache: active
Correct VM hostname in the generated page
```

Repeated new client TCP connections reached all three healthy backends. Distribution was understood as flow-hash based rather than guaranteed round-robin.

Stopping Apache on `vm-web-az2` while leaving the VM running caused the HTTP health probe to mark that backend unhealthy for new flows. Traffic continued through VM1 and VM3. Restarting Apache caused the probe to recover and VM2 automatically became eligible again.

The subnet had default outbound access disabled. The inbound LB rule had implicit outbound SNAT disabled, and the dedicated `outbound-web` rule provided egress SNAT. From VM1, an external-IP check returned `40.82.216.41`, matching the Load Balancer frontend public IP.

## Networking mental model confirmed during explain-back

The learner correctly explained the inbound path:

```text
Client
  -> Load Balancer public IP/frontend
  -> TCP/80 load-balancing rule
  -> healthy backend set
  -> five-tuple-based flow selection
  -> backend NIC/private IP
  -> NSG evaluation
  -> Apache TCP/80
  -> response through the established flow
```

Corrections consolidated during explain-back:

- Health probes run continuously; they are not triggered only when a client request arrives.
- Backend pool membership is represented by NIC/IP configurations.
- The default Load Balancer behavior is **flow affinity**, not application-level sticky sessions. A single established TCP flow stays with its selected backend, but a new TCP flow can hash to another backend.
- NSGs answer whether traffic is allowed; they do not provide routing or NAT.
- `defaultOutboundAccess = false` was a subnet setting, not a Load Balancer setting.
- The three VMs had different private IPs but shared one public egress identity through SNAT.
- Routing, NSG filtering, and SNAT are separate functions.
- The Standard Public Load Balancer can provide SNAT through an outbound rule, but it is not a general-purpose router or UDR next hop.

## Terraform mental model confirmed during explain-back

The learner correctly understood that:

- the next plan proposed only VM3 because the other successful resources were already represented in Terraform state;
- Azure had partially created a failed VM object even though Terraform did not record it as a successful managed VM;
- Terraform would not overwrite an existing Azure object with the same resource identity;
- deleting the failed unwanted VM allowed Terraform to create the desired replacement.

One correction was made: the 20 successful resources remained not because they were independent of VM3, but because Terraform apply is not transactional. Successful operations are recorded and retained; failed later operations do not trigger automatic rollback.

## Portal inspection completed

The Azure Portal was used to visually confirm:

- backend pool membership and per-zone private IPs;
- HTTP probe on port 80 path `/`;
- TCP/80 load-balancing rule;
- all three backends healthy after recovery;
- dedicated outbound rule using `fe-public` and `be-web`;
- 10,000 allocated outbound SNAT ports per backend;
- frontend public IP configuration.

## Final teardown evidence

A saved destroy plan was created and reviewed:

```powershell
terraform plan -destroy -out lab01-destroy.tfplan
```

Result:

```text
Plan: 0 to add, 0 to change, 21 to destroy.
```

The exact reviewed plan was then applied:

```powershell
terraform apply lab01-destroy.tfplan
```

Result:

```text
Apply complete! Resources: 0 added, 0 changed, 21 destroyed.
```

Azure was independently checked:

```powershell
az group exists --name rg-az700-lb-aue
```

Result:

```text
false
```

Terraform state was independently checked:

```powershell
terraform state list
```

Result: no output, confirming zero managed Lab 01 resources remained in state.

## Documentation and learning assets

Detailed manual walkthrough:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

Visual learning assets:

```text
labs/01-load-balancer/visual-learning/
```

Terraform implementation:

```text
labs/01-load-balancer/terraform/
```

A separate complete Lab 01 rebuild/practice PDF was also produced after teardown, containing the manual CLI build, outputs, Terraform rebuild, real failures/recovery, validation, teardown, and practice/reference material.

## Final Lab 01 lessons

```text
Frontend       = client entry point
LB rule        = maps matching frontend flows to a backend pool
Backend pool   = candidate NIC/IP endpoints
Health probe   = continuously determines eligibility for new flows
Flow hash      = chooses among eligible backends for a new flow
NSG            = security allow/deny decision
Route          = where traffic should go
SNAT           = source identity translation for outbound traffic
Outbound rule  = explicit SNAT mechanism used in this lab
Terraform      = desired-state infrastructure manager; not transactional rollback
Azure CLI      = independent inspection/validation/troubleshooting tool
```

## Resume instruction

Lab 01 is complete. **Do not rebuild Lab 01 as part of normal programme progression.** Use the rebuild manual later for deliberate practice.

The next programme activity is:

```text
Lab 02 — Azure Traffic Manager
```
