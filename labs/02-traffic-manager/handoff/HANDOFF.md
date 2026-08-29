# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** NOT STARTED — READY
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Pre-lab preparation complete. Lab 01 teaching style, command-by-command execution method, visual requirements and closeout standards have been carried forward.
- **Next action:** TEACH the Traffic Manager problem/use case and DNS-based mental model first. Do not begin with a quiz or Azure commands.
- **Last updated:** 2026-08-29 (Australia/Brisbane)

## Critical teaching rule — do not drift

**Teach first. Check understanding second. Hands-on third.**

Do not ask the learner to infer or discover an unfamiliar Azure concept before explaining it.

For every major concept use:

```text
TEACH
  ↓
plain-language explanation
  ↓
relate to prior knowledge
  ↓
concrete example / traffic or DNS flow
  ↓
visual diagram where useful
  ↓
CHECK UNDERSTANDING
  ↓
one short explain-back question
  ↓
reteach/correct any gap
  ↓
only then continue
  ↓
HANDS-ON
  ↓
explain one command before the learner runs it
```

Do **not** use a cold Socratic/pre-test question as the first action unless the learner explicitly asks to be quizzed.

This is the teaching pattern that worked in Lab 01 and must continue in Lab 02.

## First Lab 02 teaching block

Before asking the learner a comprehension question, teach all of the following in a connected, understandable way:

```text
1. Why the regional Load Balancer from Lab 01 does not solve global user steering
2. What Azure Traffic Manager is
3. Why Traffic Manager is DNS-based
4. Why Traffic Manager is not an inline HTTP/HTTPS proxy
5. Client versus recursive DNS resolver
6. Traffic Manager profile FQDN
7. Geographic routing at a conceptual level
8. Endpoint health monitoring
9. DNS TTL and caching
10. Traffic Manager versus Azure Load Balancer
```

Use a realistic example such as users in North America, Europe and Asia accessing one global application name.

Create/use the first PNG/JPEG mental-model image as part of the teaching.

Only after that explanation ask:

> In your own words, what problem does Traffic Manager solve that the regional Azure Load Balancer from Lab 01 does not solve?

If the answer shows a gap, correct it and reteach before moving to the next concept or Azure command.

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

## Essential programme sequence

The detailed rules are in:

```text
labs/02-traffic-manager/README.md
```

The Lab 02 sequence is:

```text
Teach problem/use case
  ↓
Teach mental model
  ↓
PNG/JPEG visual learning
  ↓
Learner understanding check
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
Final learner explain-back
  ↓
COMPLETE
```

## Working preferences that must not drift

- Azure only.
- Maximum one lab per day.
- Use VS Code throughout the work.
- Prefer Azure CLI for manual deployment, inspection and validation.
- Use Terraform only after the Azure concept is understood manually.
- Teach concepts before asking comprehension questions.
- Teach command syntax and HCL syntax rather than only providing commands.
- Work one meaningful action/command at a time and wait for actual output.
- Interpret output before proceeding.
- Use Azure Portal for visual inspection/troubleshooting, not as the only deployment path.
- Create reusable PNG/JPEG visuals and save them in the repository.
- ASCII/SVG can support the lesson but do not replace required PNG/JPEG assets.
- Update handoff only at meaningful checkpoints/end of session, not after every command.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behaviour rather than hiding it.
- Never commit secrets, Terraform state, credentials, tokens, private keys or sensitive local tfvars.
- End the lab with a detailed PDF rebuild/practice manual containing commands, outputs, diagrams, troubleshooting, Terraform, validation and teardown.

## Mandatory Lab 02 visual assets

Create and save:

```text
labs/02-traffic-manager/visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
labs/02-traffic-manager/visual-learning/Lab02-02-Geographic-Routing-Flow.png
labs/02-traffic-manager/visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
labs/02-traffic-manager/visual-learning/Lab02-04-Final-Lab-Architecture.png
```

Additional screenshots/diagrams may be saved when useful.

The first image must make this distinction obvious:

```text
Azure Load Balancer
= regional Layer-4 flow distribution
= sits in the network/application data path

Azure Traffic Manager
= global DNS-based traffic steering
= does NOT proxy the final application connection
= after DNS resolution the client connects directly to the selected endpoint
```

## Core Traffic Manager mental model to teach

```text
Client
  ↓
Recursive DNS Resolver
  ↓
Traffic Manager profile DNS name
  ↓
Traffic Manager evaluates routing method + endpoint health
  ↓
DNS answer toward selected endpoint
  ↓
Client connects DIRECTLY to selected App Service
```

Important: the Traffic Manager service is not inline in the HTTP/HTTPS connection after DNS resolution.

## Concepts that must be understood before Terraform

The learner should be able to explain:

- what problem Traffic Manager solves
- global DNS steering versus regional Layer-4 load balancing
- client DNS behaviour and recursive resolver role
- Traffic Manager FQDN
- Geographic routing
- endpoint monitoring and endpoint health
- DNS TTL/cache
- direct endpoint access versus Traffic Manager access
- why resolver location can matter for Geographic routing
- what happens when an endpoint becomes unhealthy
- how Traffic Manager differs from Azure Load Balancer

Do not assume cross-region failover behaviour for Geographic routing. Test and explain actual behaviour.

## Planned validation/failure evidence

Capture evidence for:

- each regional endpoint directly reachable
- Traffic Manager profile and Geographic routing method
- expected endpoint geographic mappings
- endpoint monitor health
- DNS lookup of Traffic Manager FQDN
- HTTP request to Traffic Manager FQDN
- direct endpoint versus Traffic Manager access
- geographic behaviour from available resolvers/test locations where practical
- endpoint-unhealthy exercise
- DNS TTL/cache effects during failure/recovery
- final no-change Terraform plan
- final teardown with Azure resources absent and Terraform state empty

## Lab 01 lessons to deliberately reuse

1. **Do not trust deployment success alone.** Validate infrastructure, protocol and application behaviour.
2. **Cloud state and Terraform state can differ after failures.** Inspect both before corrective action.
3. **Availability/support does not guarantee live capacity or subscription permission.** Validate current Azure conditions.
4. **Security, routing, NAT and load balancing are separate concepts.** Keep them mentally separate.
5. **Observed behaviour is not automatically a service guarantee.** Distinguish test observations from documented design behaviour.
6. **Use source control as part of the engineering workflow.** Commit useful learning artifacts, not transient execution files.
7. **Teach before testing understanding.** Explain, demonstrate, then use explain-back to confirm the mental model.

## Required end-of-lab deliverable

Before Lab 02 is marked COMPLETE, create a PDF comparable to the Lab 01 practice manual. It must be sufficient to rebuild the lab later without this conversation.

## New-session resume instruction

Read these files in order:

```text
1. docs/HANDOFF.md
2. labs/02-traffic-manager/handoff/HANDOFF.md
3. labs/02-traffic-manager/README.md
```

Then:

```text
DO NOT start with a question.
DO NOT start with Terraform.
DO NOT start by running deploy.ps1.
DO NOT dump Azure commands.

START by teaching:
- the problem Traffic Manager solves
- the DNS flow
- the difference from Lab 01 Load Balancer
- Geographic routing and endpoint health at a conceptual level

Use/create the first PNG/JPEG visual during that teaching.
Then ask one comprehension question.
Only proceed when the learner demonstrates the concept is understood.
```
