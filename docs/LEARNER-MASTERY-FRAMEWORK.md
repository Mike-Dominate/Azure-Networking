# BlueHarbor Learner Mastery Framework

## Purpose

BlueHarbor is not complete when Azure resources exist or when a Terraform apply succeeds.

The programme is complete only when the learner can **understand, build, validate, diagnose, recover, explain and evidence** the networking capability being taught.

This framework adds a professional mastery layer around the existing cumulative AZ-700 architecture without changing Microsoft Learn order, the BlueHarbor storyline, the canonical Terraform root, or the one-state progression.

```text
learn the problem
   -> explain the packet/control-plane model
   -> design the smallest architecture delta
   -> implement through the living Terraform stack
   -> validate independently
   -> break something deliberately
   -> diagnose from evidence, not guesses
   -> recover and reconcile Terraform/Azure
   -> communicate the result
   -> repeat with less guidance
   -> pass the mastery gate
   -> carry the exact estate forward
```

## Non-negotiable programme contract

The mastery layer must never turn BlueHarbor into a collection of disposable challenge labs.

The following remain authoritative:

```text
Microsoft Learn order              unchanged
AZ-700 study-guide coverage         unchanged
BlueHarbor business story           continuous
blueharbor/terraform/               one canonical Terraform root
Terraform state                     one continuous lineage
Azure estate                        cumulative
Git history                         progression record
routine terraform destroy           prohibited
```

A mastery exercise may introduce a controlled fault, but the learner must finish with the intended architecture restored and Terraform agreeing with Azure.

---

# 1. The BlueHarbor mastery loop

Every meaningful unit uses the following learning loop. Pure introduction/summary units may use a reduced version, but any unit that adds, changes, operates or troubleshoots infrastructure must use the full loop.

## Stage 1 — Business trigger

Before touching Azure, answer:

- What changed in BlueHarbor?
- Who needs the change?
- What business or technical risk exists if nothing changes?
- What capability from the current AZ-700 unit addresses the requirement?

The learner should receive a short realistic trigger such as:

- service desk escalation;
- security finding;
- architecture review action;
- application launch requirement;
- branch/site connectivity request;
- reliability incident;
- audit/compliance requirement;
- operations alert.

The trigger must describe the problem, not reveal the implementation answer.

## Stage 2 — Job reality check

Each practical states where this capability appears in real work:

```text
First 30 days  -> what a junior engineer is likely to observe or operate
6-12 months    -> what the engineer is expected to diagnose or change
Senior level   -> what trade-off, risk or design decision must be defended
```

This section exists to answer the learner's question: **why is this worth my time?**

## Stage 3 — Recall before reference

Before new instructions are shown, the learner answers 3-5 short recall questions from the existing estate.

Examples:

- Which VNet currently owns this subnet?
- What is the current egress path?
- Which DNS component is authoritative for this name?
- Which route should win and why?
- Which earlier resource will this unit modify rather than replace?

The learner attempts the answer first, then checks the repository.

This prevents the programme becoming copy/paste memory.

## Stage 4 — Mental model and traffic flow

Before implementation, the learner must be able to draw or explain:

- data-plane path;
- control-plane dependency;
- DNS path where relevant;
- security boundary;
- failure points;
- expected Azure-managed behaviour;
- what changes from the previous unit.

The learner should predict the expected outcome of validation commands before running them.

## Stage 5 — Architecture delta

The learner identifies:

```text
what already exists
+
what the new requirement adds
+
what existing configuration must change
-
what is intentionally retired
=
new BlueHarbor state
```

The Terraform plan is then read as an architecture change report, not as output to approve mechanically.

Unexpected destroy/replace actions are a hard stop.

## Stage 6 — Guided implementation

Infrastructure is implemented through `blueharbor/terraform/`.

Guidance is deliberately reduced as the programme progresses:

```text
Module 1  HIGH guidance
Module 2  MODERATE guidance
Module 3  MODERATE-LOW guidance
Modules 4-5  LOW guidance for previously learned patterns
Modules 6-7  ENGINEER mode: requirement + constraints + validation target
Module 8  OPERATIONS mode: symptoms and objectives, minimal build guidance
```

The learner should never be protected from thinking by receiving every final command before forming a plan.

## Stage 7 — Independent validation

A successful `terraform apply` is not proof that the network works.

The learner validates with tools appropriate to the unit, for example:

- Azure CLI;
- Azure Portal effective state;
- Network Watcher;
- DNS queries;
- HTTP/TLS tests;
- effective routes/security rules;
- flow logs;
- connection monitoring;
- backend health;
- packet-path reasoning.

Each test has:

```text
command/action
expected result predicted first
actual result
PASS / FAIL
interpretation
```

## Stage 8 — Deliberate fault

Every practical unit contains at least one fault relevant to its learning objective.

Faults must be realistic, reversible and diagnostically valuable.

Examples:

- wrong UDR next hop;
- missing peering option;
- incorrect DNS link;
- NSG rule priority error;
- health-probe mismatch;
- Private Endpoint DNS failure;
- route propagation issue;
- backend pool membership error;
- WAF/routing interaction;
- diagnostic setting omission.

Do not tell the learner the root cause before investigation.

## Stage 9 — Diagnostic framework

Troubleshooting follows a repeatable evidence-first sequence:

```text
1. Define the symptom precisely.
2. State what still works.
3. Draw the expected path.
4. Identify the first point that could disprove the path.
5. Inspect effective state.
6. Form one hypothesis.
7. Run one test that can prove/disprove it.
8. Interpret before changing anything.
9. Make the smallest corrective change.
10. Re-run the original test.
11. Re-run regression checks for earlier functionality.
12. Reconcile the permanent fix into Terraform.
```

The learner records:

```text
symptom
hypothesis
observation
root cause
fix
verification
prevention / lesson
```

## Stage 10 — Pressure scenario

Each substantial practical has a timed incident or constrained engineering task.

The pressure scenario should contain:

- a believable business impact;
- a time boundary;
- incomplete initial information;
- explicit restrictions;
- a required technical outcome;
- a required stakeholder update.

Example restrictions:

```text
do not rebuild the resource
no terraform destroy
one change at a time
explain the hypothesis before changing configuration
do not use the Portal for a task intended to test CLI diagnosis
do not report resolved until the original symptom and regression tests pass
```

The clock is a learning device, not a grading gimmick. Accuracy and method outrank speed.

## Stage 11 — Evidence and communication

A practical is not complete because the learner says it worked.

Required evidence should include the smallest useful set of artefacts such as:

- Terraform plan delta;
- successful validation output;
- Azure effective-state evidence;
- architecture or packet-flow diagram;
- diagnostic record;
- failure/recovery evidence;
- measured failover/latency/health result where relevant;
- decision record for important trade-offs.

The learner also produces one short communication artefact for a realistic audience:

- service desk update;
- change record;
- incident summary;
- architecture recommendation;
- security explanation;
- manager/CTO briefing;
- application-team handoff.

Technical accuracy must survive translation into plain English.

## Stage 12 — Low-guidance repeat and mastery gate

Before advancing, the learner repeats the core outcome with materially less guidance.

The repeat is not necessarily a full rebuild. Because BlueHarbor is cumulative, repetition should preserve the live estate and use safe methods such as:

- recreate the Terraform delta from memory in a temporary Git branch and compare it;
- explain and redraw the path without notes;
- diagnose a second fault without a runbook;
- reproduce validation commands from memory;
- restore a deliberately altered setting through Terraform;
- answer scenario questions without opening Microsoft Learn or the unit README.

The exact production-like estate remains cumulative.

---

# 2. Hard mastery gate

A practical unit is **not complete** until all applicable gates pass.

```text
[ ] I can explain why the component exists.
[ ] I can draw the expected traffic/control-plane path.
[ ] I can identify what changed from the previous BlueHarbor state.
[ ] I understand the Terraform plan before apply.
[ ] I independently proved the implementation works.
[ ] I diagnosed at least one relevant failure from evidence.
[ ] I restored the intended architecture without resetting the programme.
[ ] Terraform and Azure agree at the end.
[ ] I produced the required evidence artefacts.
[ ] I can explain the outcome to a non-technical stakeholder.
[ ] I can answer the unit's interview/scenario questions without notes.
[ ] I completed the low-guidance repeat.
```

A learner may continue reading future material, but the programme tracker must not mark the practical `MASTERED` until the gate passes.

---

# 3. Progress states

Use four states rather than a simple done/not-done flag:

```text
NOT STARTED
LEARNED      -> mental model / design understood
BUILT        -> intended infrastructure/configuration implemented
VALIDATED    -> behaviour independently proven
MASTERED     -> failure, evidence, communication and low-guidance gate passed
```

This distinction prevents "I deployed it once" from being mistaken for competence.

---

# 4. Assistance taper

The programme deliberately removes scaffolding.

## Module 1 — Foundation mode

Learner receives:

- explicit mental models;
- worked examples;
- stronger Terraform guidance;
- suggested validation commands;
- diagnostic prompts.

Expectation: build correct foundational habits.

## Module 2 — Engineering mode begins

Learner receives:

- business requirement;
- architecture constraints;
- partial implementation guidance;
- required validation outcomes.

Expectation: choose more of the implementation sequence independently.

## Module 3 — Design and dependency mode

Learner receives external-boundary constraints and Azure-side requirements, but must reason explicitly about provider ownership, BGP, failure domains and what can/cannot honestly be built in the lab.

Expectation: distinguish architecture knowledge from button-click simulation.

## Modules 4-5 — Service delivery mode

Previously learned networking concepts are no longer re-taught line by line.

Expectation: combine routing, DNS, health, TLS and application-delivery behaviour into one diagnosis.

## Modules 6-7 — Senior change mode

Learner receives security/private-access requirements and acceptance criteria.

Expectation: design the Terraform delta, predict side effects, protect earlier functionality and defend trade-offs.

## Module 8 — Operations / on-call mode

Learner receives symptoms, alerts and service objectives.

Expectation: investigate the complete M1-M7 estate using observability and effective-state evidence with minimal hints.

---

# 5. Module mastery outcomes

## Module 1 — Network foundation

By mastery exit the learner can:

- explain Azure VNet/subnet/addressing behaviour;
- reason about DNS, peering, routes and NAT packet-by-packet;
- extend the first persistent Terraform estate safely;
- diagnose basic connectivity without random changes;
- explain the network foundation to another engineer.

## Module 2 — Hybrid networking

By mastery exit the learner can:

- reason about S2S, P2S and Virtual WAN path selection;
- distinguish tunnel, route and authentication failures;
- troubleshoot hybrid DNS and connectivity;
- explain why the design evolves from classic connectivity toward vWAN.

## Module 3 — ExpressRoute

By mastery exit the learner can:

- explain provider versus Azure responsibility;
- reason about circuit/peering/BGP/resiliency/Global Reach/FastPath;
- identify which claims can be validated in the lab and which require a provider or support dependency;
- defend an enterprise private-connectivity design.

## Module 4 — Non-HTTP load balancing

By mastery exit the learner can:

- explain probe, frontend, backend and rule behaviour;
- diagnose why a healthy VM may still be unreachable;
- reason about regional versus DNS-based global distribution;
- run a controlled backend/failover incident.

## Module 5 — HTTP application delivery

By mastery exit the learner can:

- reason across DNS, TLS, listener, rule, probe and origin layers;
- distinguish Application Gateway from Front Door decisions;
- diagnose HTTP(S) failures from the client edge to the backend;
- explain application-delivery trade-offs to an application team.

## Module 6 — Network security

By mastery exit the learner can:

- reason about NSG/ASG, DDoS, Firewall, Firewall Manager and WAF boundaries;
- prove which component sees a traffic flow;
- detect bypass paths;
- make security changes without unintentionally breaking established connectivity;
- produce a defensible security change record.

## Module 7 — Private access

By mastery exit the learner can:

- distinguish Service Endpoint, Private Endpoint and Private Link behaviours;
- diagnose private DNS failures systematically;
- explain PaaS network paths and public/private exposure;
- validate the end-to-end private access path rather than only resource configuration.

## Module 8 — Monitoring and operations

By mastery exit the learner can:

- use Network Watcher, flow logs, Log Analytics, Connection Monitor and Azure Monitor as evidence sources;
- investigate multi-layer incidents across the full BlueHarbor estate;
- measure and communicate operational impact;
- produce a concise incident timeline/root-cause record.

---

# 6. Portfolio evidence standard

Evidence should prove ability without requiring the learner to verbally rescue unclear artefacts.

Recommended structure when evidence begins to be produced:

```text
blueharbor/evidence/
  m01/
    u04/
      architecture/
      terraform/
      validation/
      troubleshooting/
      communication/
```

Do not pre-create empty directories. Add evidence folders only when the corresponding unit is executed.

Do not commit:

- secrets;
- credentials;
- SAS tokens;
- private keys;
- real tfvars;
- sensitive tenant/user data;
- unnecessary raw logs containing sensitive information.

A strong evidence pack answers:

```text
What was required?
What changed?
How was it proven?
What failed?
How was it diagnosed?
What was the permanent fix?
What did the learner conclude?
```

---

# 7. Interview and scenario layer

Each practical should end with 3-6 questions of increasing depth:

```text
Level 1 — explain the component
Level 2 — explain the packet/control-plane path
Level 3 — diagnose a failure
Level 4 — compare two valid designs
Level 5 — defend the BlueHarbor decision under a changed constraint
```

The learner answers before reading any model answer.

The goal is not interview trivia. The questions expose whether the mental model survives outside the exact lab procedure.

---

# 8. Communication layer

Every module includes at least one non-technical communication challenge.

Examples:

```text
M1 -> explain why controlled egress/DNS/routing matter to an IT manager
M2 -> explain hybrid connectivity risk to a site manager
M3 -> explain ExpressRoute/provider ownership to procurement/leadership
M4 -> explain availability versus performance to a service owner
M5 -> explain Front Door/App Gateway responsibilities to an application owner
M6 -> explain a security-path change to a CISO/change board
M7 -> explain Private Link/public exposure to an application team
M8 -> write an incident summary with impact, cause, fix and prevention
```

Use plain language. Technical jargon is allowed only where the audience genuinely needs it.

---

# 9. Cost and lab-efficiency guardrail

Learner ROI includes time and Azure spend.

The mastery layer must not create expensive duplicate estates merely to repeat a skill.

Prefer:

- the existing cumulative estate;
- short controlled failure windows;
- temporary Git branches for code-memory exercises;
- conditional/short-lived expensive resources when technically appropriate;
- evidence from effective state instead of redundant deployments;
- architecture/design treatment where external/provider dependencies make a fake lab misleading.

Never reduce technical honesty merely to make every objective deployable.

---

# 10. Module exit review

At the end of every module, run a module-level review covering the complete accumulated estate.

The learner must be able to answer:

1. What business capabilities now exist that did not exist at module start?
2. What Azure resources/configuration were added or retired?
3. Which traffic paths changed?
4. Which new failure modes now exist?
5. Which earlier assumptions are no longer true?
6. What would I inspect first if the module's main service failed tomorrow?
7. What portfolio evidence proves I did the work?
8. Which AZ-700 objectives did this module satisfy?

Module status becomes `MASTERED` only after this review passes.

---

# 11. Final BlueHarbor capstone

Module 8 ends with a whole-estate operational capstone rather than a simple final deployment.

The learner receives multiple symptoms across the accumulated BlueHarbor environment and must:

```text
triage impact
map symptoms to likely layers
inspect observability evidence
form hypotheses
identify one or more root causes
make controlled fixes
reconcile Terraform
run regression validation
produce an incident summary
produce a final architecture diagram
explain which design decisions made diagnosis easier or harder
```

The capstone must exercise infrastructure created across multiple earlier modules.

The learner should not be told in advance which modules contain the faults.

---

# 12. Definition of programme success

The target is not:

> I completed AZ-700 labs.

The target is:

> I progressively built and operated one Azure enterprise network through Terraform. I can explain its packet and control-plane behaviour, safely change the architecture, diagnose failures using Azure evidence, restore service without resetting the estate, and show version-controlled evidence of the work.

That is the BlueHarbor mastery standard.
