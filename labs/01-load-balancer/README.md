# Lab 01 — Azure Load Balancer

## Status

`NOT STARTED`

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

## What this lab must teach

By the end of the lab, the learner should be able to explain:

- what problem Azure Load Balancer solves
- why it is a Layer 4 service
- frontend IP configuration
- backend pool
- health probe
- load-balancing rule
- availability zones and backend resilience
- NSG placement and evaluation in the traffic path
- how a packet travels from the client to a backend VM
- what happens when a backend becomes unhealthy
- when to choose Load Balancer vs Application Gateway, Front Door, or Traffic Manager

## Learning path

### 1. Visual learning

Complete `visual-learning/architecture.md` before deployment.

### 2. Direct Azure deployment

Follow `manual-deployment/README.md` and build the architecture directly so the Azure objects are understood visually.

### 3. Validate

Use `validation/README.md` and prove traffic reaches multiple healthy backends.

### 4. Terraform rebuild

Build the same architecture under `terraform/` incrementally. Do not paste a complete solution before understanding each resource relationship.

### 5. Failure/troubleshooting exercise

Stop or break one backend safely and observe how the health probe affects traffic distribution. Record findings in `troubleshooting/README.md`.

### 6. Handoff

Update `handoff/HANDOFF.md` and the programme-level `../../docs/HANDOFF.md` before the session ends.

## Definition of done

- [ ] Mental model explained
- [ ] Traffic-flow diagram completed
- [ ] Direct deployment completed
- [ ] Direct deployment validated with CLI and HTTP traffic
- [ ] Direct deployment removed/isolation confirmed before Terraform build
- [ ] Terraform code written incrementally
- [ ] `terraform fmt` clean
- [ ] `terraform validate` successful
- [ ] `terraform plan` reviewed
- [ ] Terraform deployment successful
- [ ] Terraform deployment independently validated with Azure CLI
- [ ] Backend failure scenario tested
- [ ] Troubleshooting notes recorded
- [ ] Evidence captured
- [ ] Git commits tell the progression story
- [ ] Handoff updated
- [ ] Lab resources safely destroyed when finished
- [ ] Learner can explain the design without reading the guide
