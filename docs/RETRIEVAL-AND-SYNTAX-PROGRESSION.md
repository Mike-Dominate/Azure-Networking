# BlueHarbor Teach -> Recall -> Reuse -> Extend Standard

## Purpose

BlueHarbor uses progression for one primary learning reason: **make previous knowledge harder to forget by forcing the learner to retrieve and reuse it before new complexity is added.**

The cumulative Azure estate is not an end in itself. It is the vehicle for spaced repetition of:

- networking mental models;
- packet/control-plane reasoning;
- Terraform/HCL syntax;
- Azure CLI syntax;
- validation habits;
- troubleshooting sequences.

The learner must never be asked to work independently on a capability that has not first been taught.

---

# 1. Non-negotiable teaching order

Every module follows this order:

```text
1. TEACH THE NEW MODULE
   concept -> purpose -> architecture -> traffic/control-plane model -> new syntax

2. RETRIEVE THE PREVIOUS MODULE
   explain previous mental model without notes
   recall important commands/HCL from memory

3. REUSE PREVIOUS SKILL
   write or apply previously learned syntax again
   preferably as a legitimate part of the new BlueHarbor change

4. ADD THE NEW CAPABILITY
   instructor teaches the new resource relationships/syntax
   learner integrates them into the existing estate

5. VALIDATE AND TROUBLESHOOT
   prove old + new behaviour together

6. INDEPENDENT REPEAT
   learner performs the combined task with substantially less guidance

7. MASTERY GATE
   learner demonstrates recall, syntax, diagnosis and explanation
```

This order is mandatory across Modules 1-8.

The assistance taper applies only to **previously taught skills**. A genuinely new Azure concept must still be taught clearly before the learner is expected to use it independently.

---

# 2. Two different kinds of progression

BlueHarbor progression has two purposes and they must not be confused.

## Architecture progression

The Azure estate grows continuously:

```text
M1 foundation
 -> M2 hybrid
 -> M3 ExpressRoute
 -> M4 L4 delivery
 -> M5 HTTP delivery
 -> M6 security
 -> M7 private access
 -> M8 operations
```

## Learning progression

The learner repeatedly retrieves earlier knowledge:

```text
learn once
 -> recall later
 -> write it again
 -> use it in a new context
 -> troubleshoot it when combined with newer services
 -> eventually use it without prompts
```

The second progression is the educational reason for the first.

---

# 3. Teach before independence

A module must never begin with a cold challenge such as:

> Build an Azure Virtual WAN architecture. Go.

if Virtual WAN has not yet been taught.

Instead:

```text
Teach:
- what Virtual WAN is;
- why BlueHarbor now needs it;
- hub/gateway/connection mental model;
- packet/control-plane path;
- important limitations/trade-offs;
- new Terraform resources and relationships;
- new validation commands.

Then require the learner to work increasingly independently.
```

Independence tests learning. It does not replace teaching.

---

# 4. Retrieval before reference

Once a skill has been taught, later modules should not immediately show the learner the old syntax again.

The learner first attempts it from memory.

Examples:

```text
Write the azurerm subnet resource pattern from memory.
Write terraform init / validate / plan / apply in the correct sequence.
Write the Azure CLI command pattern used to inspect a VNet.
Draw the DNS resolution path from the previous module.
Explain which route would win and why.
```

Only after the attempt should the learner compare against the repository/reference material.

The purpose is retrieval, not punishment. If the learner cannot recall it, review it, then attempt it again.

---

# 5. Syntax repetition rule

Important syntax is learned through repeated production, not repeated reading.

If a learner has already been taught a syntax pattern, future modules should prefer:

```text
PROMPT
"Write the resource/command yourself."
```

over:

```text
COPY
"Paste this exact block."
```

Examples of patterns that should become progressively automatic:

### Terraform workflow

```text
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

The programme still teaches when each command is appropriate and does not encourage routine destroy of the cumulative estate.

### Terraform resource anatomy

```hcl
resource "TYPE" "LABEL" {
  name                = ...
  location            = ...
  resource_group_name = ...
  ...
}
```

### Reference syntax

```hcl
azurerm_resource_group.example.name
azurerm_virtual_network.example.id
var.example
local.example
```

### Azure CLI inspection pattern

```text
az <resource> show/list ...
az network ...
--resource-group
--name
--query
--output table/json
```

Exact commands are taught when first introduced. Later use should increasingly require recall.

---

# 6. Reuse should preferably create legitimate new architecture

The strongest repetition occurs when old syntax is needed naturally by the next business requirement.

Example:

```text
Module 1 teaches:
- resource group/VNet/subnet Terraform anatomy
- references
- init/validate/plan/apply
- Azure CLI inspection

Module 2 needs GatewaySubnet before VPN Gateway.

Learner task BEFORE new VPN Gateway HCL is shown:
- explain the M1 VNet mental model;
- write the new GatewaySubnet block from memory using M1 subnet syntax;
- run the known Terraform workflow from memory;
- inspect the subnet using the known CLI pattern.

Instructor THEN teaches:
- Public IP requirements for the gateway;
- Virtual Network Gateway resource model;
- Local Network Gateway/connection concepts;
- new Terraform blocks and validation.
```

The previous skill is therefore repeated inside the real next architecture rather than as an artificial duplicate lab.

---

# 7. Do not duplicate live resources merely for repetition

Because BlueHarbor has one cumulative Terraform state, repetition must not create duplicate declarations for resources that already exist.

Do **not** ask the learner to recreate `bhi-vnet-core-aue` in the live root merely to practise VNet syntax.

Use one of these patterns instead, in preferred order:

1. **Legitimate reuse** — the next module genuinely needs another subnet/resource using a known pattern.
2. **Blank-to-code retrieval** — learner writes a known HCL block in a temporary scratch file or Git branch, then compares it and discards it without applying.
3. **Code completion from memory** — provide only the resource type/business requirement and let the learner author attributes/references.
4. **Fault repair** — remove or corrupt a known block in a controlled branch and require the learner to restore it from memory.
5. **CLI retrieval** — learner reconstructs the validation/troubleshooting command without opening notes.

This keeps repetition high without corrupting state or creating fake architecture.

---

# 8. Destroy syntax versus routine destroy

If Terraform destroy syntax is taught, the learner should know and be able to recall it:

```text
terraform destroy
```

But knowing syntax is different from using it as the normal BlueHarbor workflow.

BlueHarbor's live cumulative estate is not routinely destroyed between modules because doing so would erase the dependencies needed for later learning.

Destroy practice, where educationally useful, should use:

- explicitly disposable bootstrap/test resources;
- a safe isolated exercise;
- targeted retirement that the storyline genuinely requires;
- a temporary sandbox outside the canonical state when necessary.

The learner should understand both **how to destroy infrastructure** and **why an enterprise engineer often should not destroy the current estate**.

---

# 9. Module-to-module retrieval contract

Every module after Module 1 must explicitly define:

```text
PREVIOUS-MODULE MENTAL MODEL TO RECALL
PREVIOUS-MODULE TERRAFORM SYNTAX TO REPEAT
PREVIOUS-MODULE CLI/VALIDATION SYNTAX TO REPEAT
PREVIOUS CAPABILITY REUSED IN THE NEW ARCHITECTURE
NEW CAPABILITY THAT MUST BE TAUGHT
INDEPENDENT TASK AFTER TEACHING
```

Example module header:

```text
Module 2 retrieval contract

Recall from M1:
- VNet/subnet/addressing mental model
- DNS/peering/routing/NAT paths
- Terraform resource/reference syntax
- fmt/init/validate/plan/apply workflow
- az network VNet/subnet inspection patterns

Reuse in M2:
- add GatewaySubnet using known subnet syntax
- inspect VNet/subnet state without being given commands

Teach new in M2:
- VPN Gateway
- S2S/P2S
- Local Network Gateway
- IPsec/IKE
- Virtual WAN
- hybrid DNS additions
```

The same structure repeats from M2 -> M3, M3 -> M4, and onward.

---

# 10. Spaced syntax progression

A syntax pattern should move through four levels:

```text
LEVEL 1 — TAUGHT
Instructor explains and demonstrates it.

LEVEL 2 — PROMPTED RECALL
Learner is told what pattern is needed but not shown the syntax.

LEVEL 3 — CONTEXTUAL REUSE
Learner identifies independently that the old pattern is required inside a new task.

LEVEL 4 — AUTOMATIC USE
Learner writes/uses it during troubleshooting or implementation without a syntax prompt.
```

Do not move a learner to Level 4 for a syntax pattern that was never properly taught at Level 1.

---

# 11. Example of the intended progression

## Module 1

Instructor teaches VNet/subnet Terraform from first principles.

```text
teach resource blocks
teach references
teach variables
teach Terraform workflow
teach Azure CLI verification
learner builds foundation with guidance
learner repeats key syntax
```

## Module 2

Instructor first teaches the hybrid-networking mental model.

Before the new gateway-specific Terraform is provided, learner must retrieve Module 1 knowledge:

```text
"Add the required GatewaySubnet to the existing connectivity VNet.
You already know how to create a subnet. Write it yourself."
```

Then the instructor teaches the new VPN Gateway resources and integrates them with the learner.

## Module 3

Instructor teaches ExpressRoute concepts first.

Learner must still remember:

- VNet/subnet references;
- resource IDs;
- provider/resource anatomy;
- Terraform workflow;
- CLI inspection;
- hybrid path reasoning from M2.

Only ExpressRoute-specific syntax receives first-time teaching.

By later modules, basic Terraform syntax should be produced with little or no prompting while new Azure service syntax is still taught before independent use.

---

# 12. Success criterion

The programme succeeds when the learner does not merely recognise syntax on screen.

The learner should be able to say:

> I have written this pattern enough times in different real architecture changes that I can produce it, explain what it references, predict what Terraform will change, and verify the result without relying on copy/paste.

That is the intended BlueHarbor progression model.
