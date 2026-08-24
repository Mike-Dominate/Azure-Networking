# Programme Roadmap

## Purpose

Complete one Azure networking lab per day while building a reusable engineering reference and GitHub progression record.

## Lab sequence

1. Azure Load Balancer
2. Traffic Manager
3. Application Gateway
4. Azure Front Door
5. Network Security Groups
6. Azure Bastion
7. Azure Firewall
8. Web Application Firewall
9. Service Endpoints
10. NAT Gateway
11. VNet Peering
12. Private DNS
13. User-Defined Routes + Network Virtual Appliance
14. Point-to-Site VPN
15. Azure Virtual WAN

## Progress states

Use only these states:

- `NOT STARTED`
- `IN PROGRESS`
- `BLOCKED`
- `READY FOR HANDOFF`
- `COMPLETE`

## Per-lab deliverables

Each lab should contain, where applicable:

```text
README.md
visual-learning/
manual-deployment/
terraform/
validation/
troubleshooting/
evidence/
handoff/
```

## Learning depth

The programme is not certification-cramming. Each lab should develop four levels of understanding:

1. **Conceptual** — what problem does this service solve?
2. **Architectural** — where does it sit in the traffic path and what are the trade-offs?
3. **Implementation** — how do we configure it directly and via Terraform?
4. **Operational** — how do we prove, monitor, and troubleshoot it?

## Progression of independence

Early labs can be mentor-led and explicit. Over time, the learner should increasingly:

- predict the required Azure resources
- design address spaces and dependencies
- write Terraform before seeing complete examples
- select the relevant Azure CLI queries
- diagnose failures from symptoms
- explain service-selection trade-offs
- improve repository structure and documentation independently

## End-state

At the end of Lab 15, the repository should function as:

- an Azure networking learning journal
- a rebuild/reference library
- a Terraform implementation portfolio
- an operational troubleshooting reference
- evidence of Git/GitHub progression
- a foundation for more advanced Azure architecture work
