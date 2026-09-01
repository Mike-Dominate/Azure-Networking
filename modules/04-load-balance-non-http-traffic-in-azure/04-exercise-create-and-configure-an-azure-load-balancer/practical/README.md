# Lab 01 — Azure Load Balancer

## Status

`COMPLETE`

Completed and formally closed on 2026-08-29. The full completion record is in `handoff/HANDOFF.md` and the programme-level `../../docs/HANDOFF.md`.

## Objective

Understand and implement a Standard public Azure Load Balancer distributing HTTP traffic across multiple Linux web servers placed across availability zones.

## Source intent

The reference lab demonstrates:

- resource group
- VNet `10.200.0.0/16`
- subnet `10.200.1.0/24`
- NSG
- three Ubuntu web VMs across availability zones 1, 2, and 3
- Apache on each backend
- Standard public Load Balancer
- backend pool
- HTTP health probe
- load-balancing rule on TCP/80

## What this lab taught

By completion, the learner demonstrated understanding of:

- what problem Azure Load Balancer solves
- why it is a Layer 4 service
- frontend IP configuration
- backend pools
- continuously maintained health probes
- load-balancing rules
- five-tuple/flow-based selection rather than guaranteed request-by-request round robin
- availability zones and backend resilience
- NSG placement and evaluation in the traffic path
- how a packet travels from the client to a backend VM
- what happens when the application becomes unhealthy while the VM remains running
- explicit outbound SNAT through a Standard Load Balancer outbound rule
- the distinction between NSG, routing and SNAT
- when to choose Load Balancer vs Application Gateway, Front Door or Traffic Manager

## Completed learning path

### 1. Visual learning

Completed under `visual-learning/`.

### 2. Direct Azure deployment

Completed using Azure CLI with command-by-command explanation and validation. See `manual-deployment/DEPLOYMENT-WALKTHROUGH.md`.

### 3. Validation and failure testing

Traffic distribution, application failure/recovery and outbound SNAT were independently validated.

### 4. Terraform rebuild

The architecture was rebuilt with Terraform, including real recovery from Azure capacity/partial-apply conditions.

### 5. Troubleshooting and recovery

The lab captured real Azure capacity constraints, Terraform/cloud-state reconciliation and orphan-resource cleanup rather than hiding unexpected behaviour.

### 6. Closeout

Git/GitHub checkpointing, rebuild documentation, destroy planning, teardown, Azure resource-group absence verification and Terraform-state verification were completed.

## Definition of done

- [x] Mental model explained
- [x] Traffic-flow diagram completed
- [x] Direct deployment completed
- [x] Direct deployment validated with CLI and HTTP traffic
- [x] Direct deployment removed/isolation confirmed before Terraform build
- [x] Terraform code written incrementally
- [x] `terraform fmt` clean
- [x] `terraform validate` successful
- [x] `terraform plan` reviewed
- [x] Terraform deployment successful
- [x] Terraform deployment independently validated with Azure CLI
- [x] Backend failure scenario tested
- [x] Troubleshooting notes recorded
- [x] Evidence captured
- [x] Git commits tell the progression story
- [x] Handoff updated
- [x] Lab resources safely destroyed when finished
- [x] Learner can explain the design without reading the guide

## Next programme lab

`Lab 02 — Azure Traffic Manager`
