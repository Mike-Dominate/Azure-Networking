# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** NOT STARTED — READY
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Pre-lab preparation complete. Learning method and visual requirements have been carried forward from Lab 01.
- **Next action:** Start with Traffic Manager problem/use case, mental model, comparison with Azure Load Balancer, then create the first visual-learning diagram before deploying resources.
- **Last updated:** 2026-08-29 (Australia/Brisbane)

## Source curriculum objective

Reference:

```text
https://github.com/rithinskaria/kodekloud-az700/tree/main/labs/02-traffic-manager
```

The source lab demonstrates Azure Traffic Manager using **Geographic routing** across three App Service endpoints:

```text
East US        -> North America
West Europe    -> Europe
Southeast Asia -> Asia
```

The source uses a PowerShell deployment script followed by manual Traffic Manager configuration.

For this programme, **do not simply run the source `deploy.ps1`**. Use the source for the objective and rebuild it through the agreed learning workflow.

## Mandatory learning method inherited from Lab 01

The authoritative detailed rules are in:

```text
labs/02-traffic-manager/README.md
```

The essential sequence is:

```text
Problem/use case
  ↓
Mental model
  ↓
Visual PNG/JPEG architecture
  ↓
Manual Azure CLI build
  ↓
Azure CLI + DNS + HTTP validation
  ↓
Failure/health testing
  ↓
Portal inspection
  ↓
Manual teardown if needed
  ↓
Terraform rebuild
  ↓
fmt / validate / plan / apply
  ↓
Independent validation
  ↓
Failure/recovery testing
  ↓
Git/GitHub
  ↓
Complete rebuild/practice PDF
  ↓
Terraform destroy + verification
  ↓
Learner explain-back
  ↓
COMPLETE
```

## Working preferences that must not drift

- Azure only.
- One lab per day maximum.
- Use VS Code throughout the work.
- Prefer Azure CLI for manual deployment and validation.
- Use Terraform only after the Azure concept is understood manually.
- Teach command syntax and HCL syntax, not just provide commands.
- Work one meaningful action/command at a time and wait for observed output.
- Use Azure Portal for visual inspection/troubleshooting, not as the only deployment path.
- Create reusable PNG/JPEG visuals and save them in the repository.
- Update handoff only at meaningful checkpoints/end of session, not after every command.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behavior rather than hiding it.
- Never commit secrets, Terraform state, credentials, tokens, or sensitive local tfvars.
- End the lab with a detailed PDF rebuild/practice manual containing commands, representative outputs, diagrams, troubleshooting, Terraform, validation and teardown.

## Mandatory Lab 02 visual assets

Create and save these during the visual-learning/validation phases:

```text
labs/02-traffic-manager/visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
labs/02-traffic-manager/visual-learning/Lab02-02-Geographic-Routing-Flow.png
labs/02-traffic-manager/visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
labs/02-traffic-manager/visual-learning/Lab02-04-Final-Lab-Architecture.png
```

Additional screenshots/diagrams may be saved when they materially improve understanding.

The first diagram must make this distinction visually obvious:

```text
Traffic Manager answers DNS.
Traffic Manager does NOT proxy the user's HTTP connection.
After DNS resolution, the client connects directly to the chosen application endpoint.
```

## Concepts that must be understood before Terraform

The learner should be able to explain:

- what problem Traffic Manager solves
- why it is global/DNS-based rather than a regional Layer-4 data-plane load balancer
- the role of the client DNS resolver
- Traffic Manager profile FQDN
- endpoint monitoring and endpoint health
- geographic routing decisions
- DNS TTL and caching
- direct endpoint URL versus Traffic Manager FQDN
- why the DNS resolver's perceived location can matter for geographic routing
- how Traffic Manager differs from Azure Load Balancer
- what happens when an endpoint becomes unhealthy under the selected routing method

Do not assume cross-region failover behavior for Geographic routing. Test the actual behavior and explain the result.

## Source architecture to begin from

```text
                    Client
                      |
                 DNS lookup
                      |
                      v
             Recursive DNS Resolver
                      |
                      v
            Azure Traffic Manager
             Geographic routing
                      |
        +-------------+-------------+
        |             |             |
        v             v             v
     East US      West Europe   Southeast Asia
   App Service    App Service     App Service
```

The HTTP/HTTPS data path after DNS selection is:

```text
Client ---------------------------> Selected App Service
       direct application connection
```

Traffic Manager is not inline on that application connection.

## Planned validation/failure evidence

During the lab, capture evidence for:

- each regional endpoint directly reachable
- Traffic Manager profile exists and has expected routing method
- all endpoints configured with expected geographic mapping
- endpoint monitor state
- DNS lookup of Traffic Manager FQDN
- HTTP request to Traffic Manager FQDN
- comparison of direct endpoint access versus Traffic Manager access
- geographic behavior from available resolvers/test locations where practical
- endpoint-unhealthy exercise
- DNS TTL/cache effects during change/recovery
- final no-change Terraform plan
- final teardown: Azure resources absent and Terraform state empty

## Lab 01 lessons to deliberately reuse

1. **Do not trust deployment success alone.** Validate at infrastructure, protocol and application levels.
2. **Cloud state and Terraform state can differ after failures.** Inspect both before corrective action.
3. **Availability/support does not guarantee live capacity or subscription permission.** Validate current Azure conditions.
4. **Security, routing, NAT and load balancing are separate concepts.** Do not merge them mentally.
5. **Observed behavior is not automatically a service guarantee.** Verify the documented mental model and actual test result.
6. **Use source control as part of the engineering workflow.** Commit useful learning artifacts, not transient execution files.

## Required end-of-lab deliverable

Before Lab 02 is marked COMPLETE, create a PDF comparable to the Lab 01 practice manual. It must be sufficient to rebuild the lab later without this conversation.

## New-session resume instruction

At the beginning of the new session, read these files in order:

```text
1. docs/HANDOFF.md
2. labs/02-traffic-manager/handoff/HANDOFF.md
3. labs/02-traffic-manager/README.md
```

Then begin with this question before any Azure deployment:

> What problem does Azure Traffic Manager solve that the regional Layer-4 Azure Load Balancer from Lab 01 does not solve?

Do not jump directly to Terraform or the source PowerShell script.
