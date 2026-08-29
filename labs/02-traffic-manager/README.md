# Lab 02 — Azure Traffic Manager

## Purpose

Lab 02 continues the Azure Networking Engineering programme using the same learning method established and proven in Lab 01.

The source curriculum demonstrates **Azure Traffic Manager geographic routing** across multiple Azure App Service endpoints in different regions. The source scenario uses:

- East US
- West Europe
- Southeast Asia
- one App Service endpoint per region
- Azure Traffic Manager with the **Geographic** routing method

The source repository is a reference for the learning objective, not a script to copy blindly. Its `deploy.ps1` uses Azure PowerShell and then configures Traffic Manager manually. Our version will deliberately rebuild the scenario using our engineering workflow: **mental model → visuals → Azure CLI manual build → independent validation → Terraform rebuild → failure testing → Portal inspection → Git/GitHub → teardown → explain-back → PDF rebuild manual**.

Source curriculum:

```text
https://github.com/rithinskaria/kodekloud-az700/tree/main/labs/02-traffic-manager
```

---

## Non-negotiable learning preferences carried forward from Lab 01

These rules apply to Lab 02 and should be read at the start of every new session.

### 1. Azure-only programme

Do not introduce AWS or another cloud into this lab. The programme is intentionally Azure-first until the Azure track is mastered.

### 2. Learn the Azure concept before automating it

Do not start with Terraform.

The required order is:

```text
problem/use case
    ↓
mental model
    ↓
visual architecture
    ↓
manual Azure deployment
    ↓
Azure CLI inspection/validation
    ↓
Terraform implementation
```

Terraform must reinforce the Azure mental model rather than hide it.

### 3. Use normal engineering tools throughout the lab

Use these tools as part of the learning process rather than studying them separately:

- **VS Code** — editor, repository navigation, integrated terminal, file comparison
- **Azure CLI** — manual deployment, inspection, validation, troubleshooting, evidence gathering
- **Terraform** — Infrastructure as Code rebuild after the manual phase
- **Git** — local version control and checkpoints
- **GitHub** — remote source of truth and continuation record
- **Azure Portal** — visual inspection and troubleshooting, not the only deployment method
- **PowerShell** — shell/orchestration around CLI commands where useful

### 4. Teach commands and syntax, not just paste commands

For important commands, explain:

```text
what command group is being used
what the operation does
what each important parameter means
what output should be expected
what the result proves
```

Keep Azure CLI syntax, PowerShell syntax, DNS concepts, and Terraform/HCL syntax clearly separated.

### 5. Work one meaningful action at a time

During interactive execution, give one command/action, wait for the observed output, interpret it, then continue.

Do not dump the entire lab as one large execution block while teaching.

### 6. Handoff updates happen at meaningful checkpoints

Do **not** update the handoff after every command. Update it when:

- stopping for the day/session
- switching major phases
- completing a significant checkpoint
- recovering from an important failure
- before teardown
- completing the lab

### 7. Visual learning is mandatory

Lab 02 must include reusable **PNG/JPEG visual aids** saved under:

```text
labs/02-traffic-manager/visual-learning/
```

At minimum create these visuals during the lab:

```text
Lab02-01-Traffic-Manager-DNS-Mental-Model.png
Lab02-02-Geographic-Routing-Flow.png
Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
Lab02-04-Final-Lab-Architecture.png
```

The diagrams should be clear enough to review later without the chat.

For Traffic Manager, visuals must make one distinction especially obvious:

```text
Azure Load Balancer
= data-plane proxy/distributor for network flows

Azure Traffic Manager
= DNS-based traffic steering
= Traffic Manager does NOT sit in the application data path
```

Screenshots from Azure Portal, DNS lookups, endpoint health, or validation output may also be saved when they materially help learning.

### 8. Build manually before Terraform

The source lab uses PowerShell automation. We will not use that as the primary learning path.

The manual phase should use Azure CLI wherever practical so the learner understands the resources being created.

Only after the manual architecture is understood, tested, and normally torn down should the same logical design be rebuilt with Terraform.

### 9. Terraform must be taught deeply

When Terraform begins, teach:

- provider requirements and lock file
- provider configuration
- variables and local values
- resource blocks and resource addresses
- references and dependency graph
- `for_each`/maps when useful for regional repetition
- output values
- state
- `fmt`, `validate`, `plan`, saved plans, `apply`
- partial apply/recovery if encountered
- drift and reconciliation if encountered
- destroy planning and teardown

Do not treat Terraform as a black box.

### 10. Independently validate Terraform with Azure CLI

A successful `terraform apply` is not sufficient evidence.

After Terraform deployment, inspect the real Azure resources independently using Azure CLI, DNS tools, HTTP requests, and Azure Portal where useful.

### 11. Failure testing is required

Lab success is not just "resources deployed".

For Traffic Manager, failure testing should deliberately change endpoint health/availability and observe what Traffic Manager and DNS return.

Because this lab uses **Geographic routing**, do not assume the behavior is the same as Priority routing. Observe and explain the actual DNS/health behavior, including any effect of DNS TTL/cache.

### 12. DNS behavior must be taught explicitly

The Lab 02 mental model must explain:

```text
client
  ↓
DNS resolver
  ↓
Traffic Manager profile DNS name
  ↓
Traffic Manager routing/health decision
  ↓
DNS answer / endpoint hostname
  ↓
client connects DIRECTLY to selected endpoint
```

Important concepts to understand and test:

- Traffic Manager is DNS-based, not an inline proxy
- DNS resolver location can affect geographic routing decisions
- TTL and DNS caching affect how quickly clients observe changes
- endpoint health monitoring affects DNS answers
- direct endpoint access bypasses Traffic Manager routing logic
- Traffic Manager routing method and endpoint health are separate concepts

### 13. Do not confuse Traffic Manager with Lab 01 Load Balancer

Carry forward the comparison throughout Lab 02:

```text
Azure Load Balancer
- Layer 4
- regional
- sits in the traffic path
- distributes TCP/UDP flows
- frontend IP + backend pool + health probe + LB rules

Azure Traffic Manager
- DNS-based global traffic steering
- does not proxy the application connection
- returns/steers toward endpoint DNS targets
- routing methods include Geographic, Performance, Priority, Weighted, Multivalue, Subnet
```

The learner should be able to explain when each service is appropriate.

### 14. Cost and availability awareness

Use lab-appropriate low-cost/free resources when they still teach the intended concept.

Before deploying, validate current Azure availability and SKU restrictions rather than assuming the source repository's older selections are still valid.

If the source's Free App Service tier or a selected region is unavailable, choose the smallest practical supported alternative and document the reason.

### 15. Security and repository hygiene

Never commit:

- credentials
- access tokens
- private SSH keys
- Terraform state
- sensitive local `.tfvars`
- secrets/certificates

Commit reusable configuration, documentation, examples, visual learning assets, and provider lock files where appropriate.

### 16. Git/GitHub is part of the lab

At useful milestones:

```text
git status
git diff
git add
git commit
git push
```

Teach what the commands are doing and keep the repository clean.

### 17. Every lab ends with a complete rebuild/practice PDF

Before Lab 02 is marked complete, produce a detailed PDF manual similar to Lab 01 that includes:

- problem and learning objectives
- mental model
- diagrams/images
- manual Azure CLI build
- important commands and syntax explanations
- representative observed output
- troubleshooting/failures and recovery
- DNS and HTTP validation
- Portal inspection
- Terraform files and important HCL explanations
- Terraform deployment/recovery
- final validation
- Git/GitHub workflow
- teardown
- condensed repeat runbook
- explain-back questions

The goal is that the lab can later be rebuilt from the PDF without relying on chat history.

---

## Lab 02 planned engineering workflow

Follow this sequence unless a real Azure constraint requires an explicit documented deviation:

```text
1. Reconfirm source objective and current Azure context
2. Explain Traffic Manager use case and DNS-based mental model
3. Compare Traffic Manager with Azure Load Balancer
4. Create the required PNG/JPEG visual-learning diagrams
5. Design naming, regions, endpoints, routing method, monitoring and TTL
6. Build regional web endpoints manually using Azure CLI
7. Validate each endpoint directly before introducing Traffic Manager
8. Create/configure Traffic Manager Geographic routing manually
9. Inspect profile, endpoints, monitor status and DNS records with Azure CLI
10. Test Traffic Manager FQDN and DNS resolution
11. Test geographic behavior as far as the available test locations/resolvers allow
12. Perform endpoint-health/failure exercise and observe DNS behavior
13. Inspect the environment in Azure Portal
14. Capture evidence and lessons learned
15. Tear down the manual environment if needed before IaC rebuild
16. Implement the same logical architecture in Terraform
17. terraform fmt / validate / plan / apply
18. Validate Terraform-created resources independently with Azure CLI/DNS/HTTP
19. Repeat useful failure/recovery tests
20. Confirm Terraform convergence with a no-change plan
21. Commit/push Terraform and documentation
22. Generate the complete Lab 02 rebuild/practice PDF
23. Review a Terraform destroy plan and safely destroy the lab
24. Verify Azure resources are gone and Terraform state is empty
25. Learner explain-back
26. Mark Lab 02 COMPLETE
```

---

## Initial source-lab target architecture

The source curriculum's starting idea is:

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

Our implementation may adapt exact SKUs/names after current Azure capability and cost checks, but the learning objective remains **multi-region DNS-based geographic traffic steering**.

---

## New-session startup instruction

When Lab 02 starts in a new ChatGPT session:

1. Read `docs/HANDOFF.md`.
2. Read `labs/02-traffic-manager/handoff/HANDOFF.md`.
3. Read this `README.md`.
4. Read the source curriculum Lab 02 README for objective/context.
5. Do **not** start by running the source `deploy.ps1`.
6. Begin with the Traffic Manager mental model and visual-learning phase.
7. Proceed one meaningful command/action at a time.

The first teaching question should be:

> What problem does Azure Traffic Manager solve that the regional Layer-4 Azure Load Balancer from Lab 01 does not solve?
