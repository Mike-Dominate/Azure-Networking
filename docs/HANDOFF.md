# Programme Handoff — Azure Networking Engineering Labs

This is the **authoritative continuation record** for the programme. Read this file before doing any lab work. Update it at the end of every working session and at meaningful checkpoints.

## Current status

- **Programme:** Azure Networking Engineering Labs
- **Repository:** `Mike-Dominate/Azure-Networking`
- **Coverage baseline:** Microsoft AZ-700 skills measured effective July 27, 2026
- **Last completed lab:** Lab 01 — Azure Load Balancer
- **Next lab:** Lab 02 — Azure Traffic Manager
- **Current phase:** Lab 01 formally complete; Lab 02 prepared and ready to begin.
- **Overall progress:** 1 / 22 labs completed
- **Cadence:** Maximum of one lab per day
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Important programme rebaseline — 2026-08-30

The original 15-lab roadmap was reviewed against the current Microsoft AZ-700 skills outline and was found to have good engineering depth but incomplete syllabus coverage.

The programme has therefore been expanded to 22 labs.

**Do not restart Lab 01 or Lab 02.**

Lab 01 remains complete. Lab 02 remains the immediate next lab. The additional coverage begins after Lab 02.

The current roadmap is authoritative in:

```text
docs/PROGRAMME-ROADMAP.md
```

The Microsoft skills outline is now the coverage authority. The KodeKloud repository remains a learning/scenario reference rather than the definition of programme completeness.

## Rebaselined roadmap

```text
01  Azure Load Balancer                                      COMPLETE
02  Azure Traffic Manager                                   NEXT
03  IP Addressing, VNets, Subnets & Public IP Architecture  NOT STARTED
04  Azure DNS, Private DNS & DNS Private Resolver            NOT STARTED
05  VNet Peering, Gateway Transit & Virtual Network Manager  NOT STARTED
06  UDRs, Forced Tunnelling, NAT Gateway & NVA               NOT STARTED
07  Azure Route Server & Dynamic Routing                     NOT STARTED
08  Network Watcher, Azure Monitor, Flow Logs, DDoS & Defender NOT STARTED
09  Site-to-Site VPN                                         NOT STARTED
10  Point-to-Site VPN                                        NOT STARTED
11  ExpressRoute Architecture & BGP                          NOT STARTED
12  Azure Virtual WAN                                        NOT STARTED
13  Application Gateway                                      NOT STARTED
14  Azure Front Door                                         NOT STARTED
15  Gateway Load Balancer & NVA Service Insertion            NOT STARTED
16  Private Endpoint, Private Link & Private DNS             NOT STARTED
17  Service Endpoints & Service Endpoint Policies            NOT STARTED
18  NSG, ASG & Azure Bastion                                 NOT STARTED
19  Azure Firewall & Firewall Manager                        NOT STARTED
20  Web Application Firewall                                 NOT STARTED
21  Network Troubleshooting Incident Lab                     NOT STARTED
22  AZ-700 Enterprise Capstone                               NOT STARTED
```

## Coverage gaps fixed by the rebaseline

The expanded roadmap deliberately adds or deepens:

- IP addressing and subnet architecture
- subnet delegation and public IP planning
- Azure DNS public/private zones
- Azure DNS Private Resolver
- Virtual Network Manager
- gateway transit and forced tunnelling
- Azure Route Server and BGP/dynamic routing
- Network Watcher
- IP flow verify, next hop and connection troubleshoot
- virtual network flow logs and Azure Monitor for Networks
- DDoS and Defender for Cloud networking signals
- Site-to-Site VPN
- ExpressRoute architecture, peering, redundancy and BGP
- Gateway Load Balancer
- Private Endpoint and Private Link
- Service Endpoint Policies
- Application Security Groups
- Azure Firewall Manager
- a dedicated troubleshooting incident lab
- an enterprise capstone spanning all AZ-700 domains

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

Do not rebuild Lab 01 during normal programme progression.

The next lab is:

```text
Lab 02 — Azure Traffic Manager
```

Resume using:

```text
1. docs/HANDOFF.md
2. labs/02-traffic-manager/handoff/HANDOFF.md
3. labs/02-traffic-manager/README.md
```

Then begin with teaching, not commands or Terraform:

```text
A. Why a regional Load Balancer is not enough for a global application
B. What Azure Traffic Manager is
C. Why it is DNS-based rather than inline
D. Client and recursive resolver roles
E. Traffic Manager DNS response/steering
F. Direct client connection to selected endpoint
G. Geographic routing
H. Endpoint health monitoring
I. DNS TTL/caching
J. Traffic Manager vs Azure Load Balancer
```

## Programme method for every practical lab

```text
1. Problem/use case
2. Teach mental model
3. Visual architecture and traffic/control-plane flow
4. Learner understanding check
5. Manual Azure deployment
6. Azure CLI/protocol inspection and validation
7. Failure testing and troubleshooting
8. Portal inspection where useful
9. Teardown if appropriate before IaC rebuild
10. Terraform implementation
11. terraform fmt / validate / plan / apply
12. Independent Azure CLI/protocol validation
13. Git/GitHub checkpoint
14. Rebuild/practice documentation
15. Safe teardown and verification
16. Learner explain-back
```

For design-heavy or impractical services, especially ExpressRoute, replace forced deployment with rigorous architecture, BGP/route reasoning, redundancy, validation planning and troubleshooting simulations.

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

Azure Load Balancer uses flow-based selection rather than guaranteed request-by-request round-robin. The default behaviour should be thought of as flow affinity, not application sticky sessions: one established TCP flow stays with its selected backend, while a new flow may select another healthy backend.

### Application health versus VM state

A VM can remain powered on while its application is unhealthy. Stopping Apache on VM2 caused the HTTP health probe to remove it from new flows. Restarting Apache allowed it to rejoin automatically after probe recovery.

### NSG, routing and SNAT are separate concepts

```text
NSG   = may this traffic pass?
Route = where should this traffic go?
SNAT  = what source identity should outbound traffic use?
```

`defaultOutboundAccess = false` was a subnet setting. The NSG could permit outbound traffic but did not itself create Internet egress or perform NAT.

The dedicated Standard Load Balancer outbound rule supplied SNAT. The backend VMs had different private IPs but shared the Load Balancer frontend public IP as their Internet-visible egress identity.

## Lab 01 key Terraform lessons

- Terraform configuration files in one directory form one configuration regardless of filename.
- Variables provide external input; locals provide internal reusable values.
- `for_each` created keyed NIC and VM instances.
- Terraform resource addresses differ from Azure resource names.
- References create implicit graph dependencies.
- `depends_on` can represent an operational dependency not expressed by a property reference.
- Terraform apply is not transactional. Successful resources remain and are recorded even if another operation later fails.
- Cloud state and Terraform state can diverge after failed provider/API operations.
- Terraform does not silently overwrite an unmanaged Azure object at the desired resource ID.
- Failed operations can leave unmanaged artifacts such as unattached disks.
- A final no-change plan demonstrated convergence among configuration, Terraform state and observed Azure infrastructure.
- A saved destroy plan was reviewed before teardown and then applied exactly.

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

## Non-negotiable working preferences

- Azure only.
- Maximum one lab per day.
- VS Code used throughout the programme.
- Azure CLI preferred for manual deployment, inspection and validation.
- Terraform follows understanding; it does not replace learning Azure.
- Teach concepts before testing comprehension.
- Explain important command syntax before execution.
- Work one meaningful action at a time during interactive labs.
- Interpret actual output before continuing.
- Use Azure Portal for inspection/troubleshooting, not as the sole deployment method.
- Create reusable PNG/JPEG visuals where they materially improve understanding.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behaviour rather than hiding it.
- Never commit secrets, Terraform state, credentials, tokens, private keys or sensitive local tfvars.
- End practical labs with detailed rebuild/practice documentation sufficient to repeat the lab without chat history.

## Status consistency rule

The following must agree whenever a lab status changes:

```text
README.md
docs/PROGRAMME-ROADMAP.md
docs/HANDOFF.md
labs/<lab>/README.md
labs/<lab>/handoff/HANDOFF.md
```

Do not leave stale `NEXT`, `NOT STARTED`, `IN PROGRESS` or `COMPLETE` markers in conflicting files.
