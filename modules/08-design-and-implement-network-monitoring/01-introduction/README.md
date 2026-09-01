# Unit 01 — Introduction

**BlueHarbor chapter:** We built it; can we operate it?  
**Status:** NOT STARTED

## Starting state

The complete architecture from Modules 1–7 already exists conceptually in the same cumulative Terraform state: networking, hybrid connectivity, application delivery, security and private PaaS access.

## Business event

A user reports that the Partner Hub is slow. The symptom alone does not identify the fault domain.

Possible layers include:

```text
DNS
hybrid connectivity
routing
security controls
Front Door / Application Gateway
backend health
Private Endpoint
PaaS service
application
```

## Core lesson

Module 8 changes the question from:

```text
What should the network do?
```

to:

```text
What is the network actually doing, and what evidence proves it?
```

Build the mental model for metrics, logs, flow evidence, health, connection testing and deeper packet evidence before adding monitoring infrastructure.

## Terraform impact

No new toy environment. Later units add observability to the existing BlueHarbor resources through the same `blueharbor/terraform/` root.
