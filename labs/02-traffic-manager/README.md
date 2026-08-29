# Lab 02 — Azure Traffic Manager

## Purpose

Lab 02 continues the Azure Networking Engineering programme using the learning method established in Lab 01.

The source curriculum demonstrates **Azure Traffic Manager Geographic routing** across multiple Azure App Service endpoints in different regions:

- East US
- West Europe
- Southeast Asia
- one application endpoint per region
- Azure Traffic Manager using the **Geographic** routing method

The source repository is a reference for the learning objective. Do **not** simply run its PowerShell script. Rebuild the scenario through the programme workflow: **teach the Azure concept → visual mental model → manual Azure CLI build → independent validation → failure/recovery testing → Portal inspection → Terraform rebuild → Git/GitHub → PDF rebuild manual → teardown → explain-back**.

Source curriculum:

```text
https://github.com/rithinskaria/kodekloud-az700/tree/main/labs/02-traffic-manager
```

---

# Non-negotiable teaching method

This section has priority over any wording elsewhere in the lab.

## 1. TEACH FIRST — DO NOT START WITH A QUIZ

The learner must **not** be asked to discover a new Azure concept before it has been taught.

For every major concept, follow this sequence:

```text
TEACH
  ↓
Explain the concept in plain language
  ↓
Relate it to something already understood
  ↓
Show a concrete example / packet or DNS flow
  ↓
Use a visual diagram where it improves understanding
  ↓
CHECK UNDERSTANDING
  ↓
Ask one short comprehension/explain-back question
  ↓
If the answer shows a gap, reteach that specific point
  ↓
Only continue when the mental model is sound
  ↓
HANDS-ON
  ↓
Explain the next command before running it
```

Do **not** use a cold Socratic/pre-test question as the first teaching action unless the learner explicitly asks to be quizzed.

Questions are for **checking understanding after teaching**, not for replacing the teaching.

This is the same pattern used successfully in Lab 01: explain the Azure behaviour, reason through it together, then ask the learner to explain it back.

## 2. Teach in small connected chunks

Do not deliver a huge lecture and do not dump the whole lab at once.

For each concept:

1. explain what problem it solves;
2. explain how it works;
3. compare it with the closest concept already learned;
4. show the traffic/DNS flow;
5. identify common misconceptions;
6. ask a short understanding check;
7. correct/reteach if needed;
8. only then move to the next concept.

For Lab 02, the first teaching block must explain **what Traffic Manager is and what problem it solves** before asking the learner to compare it with Azure Load Balancer.

## 3. The first Lab 02 teaching block

A new session must begin by **teaching**, in this order:

```text
A. Why a regional Load Balancer is not enough for a global application
B. What Azure Traffic Manager actually is
C. Why Traffic Manager is DNS-based rather than an inline proxy
D. The role of the client and recursive DNS resolver
E. What Traffic Manager returns in DNS
F. Why the client then connects directly to the chosen endpoint
G. Geographic routing at a conceptual level
H. Endpoint health monitoring
I. DNS TTL and caching
J. Traffic Manager vs Azure Load Balancer
```

Use plain-language examples and a diagram while teaching this block.

**Only after the explanation** should the learner be asked something like:

> In your own words, what problem does Traffic Manager solve that the regional Load Balancer from Lab 01 does not solve?

If the answer shows a misconception, correct it and reteach before moving on.

---

# Learning preferences carried forward from Lab 01

## 4. Azure-only programme

Do not introduce AWS or another cloud into this lab. The programme remains Azure-first.

## 5. Learn Azure before Terraform

Do not start with Terraform.

Required order:

```text
problem/use case
    ↓
teach mental model
    ↓
visual architecture
    ↓
learner understanding check
    ↓
manual Azure deployment
    ↓
Azure CLI/DNS/HTTP validation
    ↓
Terraform implementation
```

Terraform must reinforce the Azure mental model rather than hide it.

## 6. Use normal engineering tools throughout

Use these tools as part of the lab:

- **VS Code** — primary editor, repository navigation and integrated terminal
- **Azure CLI** — manual deployment, inspection, validation and troubleshooting
- **Terraform** — Infrastructure as Code rebuild after the manual phase
- **Git** — local source control and checkpoints
- **GitHub** — remote source of truth and continuation record
- **Azure Portal** — visual inspection/troubleshooting, not the only deployment method
- **PowerShell** — supporting shell/orchestration where useful
- **DNS tools / curl** — protocol-level validation

## 7. Teach commands and syntax before execution

For important commands, explain before asking the learner to run them:

```text
what command group is being used
what operation is being performed
what each important parameter means
what output to expect
what the result will prove
```

Keep Azure CLI, PowerShell, DNS and Terraform/HCL syntax clearly separated.

## 8. One meaningful action at a time

During hands-on execution:

```text
explain command
  ↓
learner runs command
  ↓
inspect actual output
  ↓
explain what happened
  ↓
continue
```

Do not provide a large command dump during interactive learning.

## 9. Handoff updates only at meaningful checkpoints

Do **not** update the handoff after every command. Update it when:

- stopping for the day/session
- switching a major phase
- completing a significant checkpoint
- recovering from an important failure
- before teardown
- completing the lab

---

# Visual learning requirement

## 10. PNG/JPEG visuals are mandatory

Create reusable visual aids and save them under:

```text
labs/02-traffic-manager/visual-learning/
```

At minimum create:

```text
Lab02-01-Traffic-Manager-DNS-Mental-Model.png
Lab02-02-Geographic-Routing-Flow.png
Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
Lab02-04-Final-Lab-Architecture.png
```

The images must be useful later without the chat. They should show arrows, component names and the direction of DNS/application flows clearly.

ASCII or SVG may be used as supporting material during explanation, but they do **not** replace the required PNG/JPEG learning assets.

The first visual must make this distinction obvious:

```text
Azure Load Balancer
= regional Layer-4 flow distributor
= sits in the application/network data path

Azure Traffic Manager
= global DNS-based traffic steering
= does NOT proxy the application connection
= after DNS resolution the client connects directly to the selected endpoint
```

Portal screenshots, DNS lookups and validation evidence may also be saved when useful.

---

# Concepts that must be understood before Terraform

The learner should be able to explain, in their own words:

- what problem Traffic Manager solves
- why it is global/DNS-based rather than a regional Layer-4 Load Balancer
- the role of the recursive DNS resolver
- the Traffic Manager profile FQDN
- how a DNS query reaches Traffic Manager
- what Traffic Manager returns/steers toward
- why Traffic Manager is not in the HTTP/HTTPS data path
- endpoint monitoring and endpoint health
- Geographic routing decisions
- the importance of DNS resolver location for Geographic routing
- DNS TTL and caching
- direct endpoint URL versus Traffic Manager FQDN
- what happens when an endpoint becomes unhealthy under the chosen routing method
- how Traffic Manager differs from Azure Load Balancer

Do not assume Geographic routing behaves like Priority routing. Test the actual behaviour and explain the evidence.

## Core DNS mental model

```text
Client
  ↓
Recursive DNS resolver
  ↓
Traffic Manager profile DNS name
  ↓
Traffic Manager routing + endpoint health decision
  ↓
DNS answer pointing toward selected endpoint
  ↓
Client connects DIRECTLY to selected application endpoint
```

Traffic Manager is not inline on the final application connection.

---

# Manual phase

## 11. Build manually before Terraform

The source lab uses PowerShell automation. Do not use that as the primary learning path.

Use Azure CLI wherever practical so the learner sees each Azure resource being created and understands why it exists.

Validate each regional endpoint directly **before** introducing Traffic Manager.

Then create/configure the Traffic Manager profile and endpoints manually and validate:

- profile configuration
- Geographic routing method
- endpoint mappings
- health monitoring
- DNS resolution
- direct endpoint access
- Traffic Manager FQDN access

---

# Failure testing and DNS behaviour

## 12. Failure testing is required

Lab success is not simply "resources deployed".

Deliberately change endpoint health or availability and observe what Traffic Manager reports/returns.

Teach and test the effect of:

- endpoint monitoring interval
- endpoint health state
- DNS TTL
- recursive resolver caching
- client-side DNS caching where relevant

Always distinguish:

```text
control-plane configuration
DNS response behaviour
endpoint health
actual HTTP/HTTPS connectivity
```

---

# Terraform phase

## 13. Terraform must be taught deeply

After the manual design is understood and validated, rebuild the same logical architecture with Terraform.

Teach:

- `terraform` and provider requirements
- `.terraform.lock.hcl`
- provider configuration
- variables
- locals
- resource blocks and resource addresses
- references and dependency graph
- `for_each`/maps where useful for regional repetition
- outputs
- state
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- saved plans
- `terraform apply`
- convergence/no-change plan
- partial apply/recovery if encountered
- drift/reconciliation if encountered
- destroy planning and teardown

Do not treat Terraform as a black box.

## 14. Independently validate Terraform

A successful `terraform apply` is not sufficient evidence.

Validate the real Azure environment using Azure CLI, DNS tools, HTTP requests and the Azure Portal.

---

# Cost, security and Git

## 15. Cost and availability awareness

Use low-cost/free resources where they still teach the intended concept.

Before deploying, validate current Azure availability, region support and SKU restrictions rather than assuming the source repository remains current.

If a source Free App Service tier or selected region is unavailable, choose the smallest practical supported alternative and document the reason.

## 16. Repository hygiene

Never commit:

- credentials
- tokens
- private keys
- Terraform state
- sensitive local `.tfvars`
- secrets/certificates

Commit reusable configuration, documentation, provider lock files and visual learning assets.

## 17. Git/GitHub is part of the lab

At useful milestones teach and use:

```text
git status
git diff
git add
git commit
git push
git pull --rebase
```

Explain what each command changes.

---

# Required end-of-lab PDF

## 18. Complete rebuild/practice manual

Before Lab 02 is marked COMPLETE, produce a detailed PDF comparable to Lab 01 containing:

- problem and objectives
- mental model
- PNG/JPEG diagrams
- manual Azure CLI build
- commands and syntax explanations
- representative observed outputs
- DNS and HTTP validation
- failure/recovery exercises
- troubleshooting and lessons learned
- Portal inspection
- Terraform source and important HCL explanations
- Terraform deployment/recovery
- independent final validation
- Git/GitHub workflow
- teardown
- condensed repeat runbook
- explain-back questions

The PDF must be sufficient to rebuild the lab later without relying on chat history.

---

# Lab 02 engineering workflow

Follow this sequence unless a real Azure constraint requires a documented deviation:

```text
1. Read handoff and source objective
2. TEACH Traffic Manager problem/use case
3. TEACH DNS-based mental model with examples
4. Compare with Lab 01 Azure Load Balancer
5. Create first PNG/JPEG visual as part of the teaching
6. Ask learner comprehension/explain-back question
7. Reteach any weak point before continuing
8. Design naming, regions, endpoints, monitor settings and TTL
9. Build regional endpoints manually with Azure CLI
10. Validate each endpoint directly
11. Create Traffic Manager profile and Geographic endpoints manually
12. Inspect profile/endpoints/health with Azure CLI
13. Test DNS and HTTP behaviour
14. Test geographic behaviour where practical
15. Perform endpoint-health failure/recovery exercise
16. Explain TTL/cache behaviour observed
17. Inspect environment in Azure Portal
18. Capture evidence and lessons learned
19. Tear down manual environment if needed before IaC rebuild
20. Implement the same architecture in Terraform
21. terraform fmt / validate / plan / apply
22. Validate Terraform-created resources independently
23. Repeat useful failure/recovery tests
24. Confirm Terraform convergence with a no-change plan
25. Commit/push Terraform, docs and images
26. Generate complete Lab 02 rebuild/practice PDF
27. Review Terraform destroy plan and destroy safely
28. Verify Azure resources are gone and Terraform state is empty
29. Final learner explain-back
30. Mark Lab 02 COMPLETE
```

---

# Initial source-lab architecture

```text
                    User / DNS Resolver
                            |
                            | DNS query
                            v
                 Azure Traffic Manager
                  Geographic routing
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
      East US          West Europe      Southeast Asia
    App Service        App Service        App Service
  North America         Europe              Asia
```

The final HTTP/HTTPS connection does **not** pass through Traffic Manager:

```text
Client ---------------------------> Selected App Service
       direct application connection
```

---

# New-session startup instruction

At the beginning of a new Lab 02 session:

1. Read `docs/HANDOFF.md`.
2. Read `labs/02-traffic-manager/handoff/HANDOFF.md`.
3. Read this `README.md`.
4. Read the source curriculum Lab 02 README for objective/context.
5. Do **not** run the source `deploy.ps1` as the starting action.
6. Do **not** start by quizzing the learner.
7. Start by **teaching the Traffic Manager problem and DNS-based mental model in plain language**.
8. Use a concrete global-application example and compare it with Lab 01.
9. Create/use the first PNG/JPEG visual during the explanation.
10. Only after teaching, ask a short question to verify understanding.
11. If the learner is not yet clear, reteach before moving to Azure commands.
12. Proceed one meaningful action at a time.

The first interaction should therefore be an explanation, **not** this question by itself:

> What problem does Azure Traffic Manager solve that the regional Layer-4 Azure Load Balancer from Lab 01 does not solve?

That question belongs **after the concept has been taught** as a comprehension check.