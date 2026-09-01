# Lab 01 — Validation

## Purpose

Prove the deployment works from both the Azure control-plane view and the client/data-plane view.

## Azure CLI checks

Commands will be added as we perform them. Expected areas to inspect:

- resource group contents
- Load Balancer configuration
- frontend IP
- backend pool
- health probe
- load-balancing rule
- NIC/IP configuration
- VM power state
- NSG rules

## Data-plane tests

Record repeated HTTP requests to the Load Balancer frontend and confirm responses come from multiple healthy backends.

_To be completed during Lab 01._

## Failure validation

Test a backend failure safely and record:

- what was changed
- how long it took to affect traffic
- what Azure showed
- what the client observed
- how service recovered

_To be completed during Lab 01._

## Success criteria

- [ ] Azure configuration matches the intended architecture
- [ ] Health probes work as expected
- [ ] HTTP traffic reaches healthy backends
- [ ] Failed backend is excluded from serving traffic
- [ ] Recovery behaviour is observed and understood
