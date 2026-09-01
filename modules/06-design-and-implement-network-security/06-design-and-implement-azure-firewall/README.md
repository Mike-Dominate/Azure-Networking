# Unit 06 — Design and implement Azure Firewall

**BlueHarbor chapter:** Introduce central traffic inspection and policy  
**Status:** NOT STARTED

## Business event

BlueHarbor has outgrown purely distributed subnet rules. Security requires central inspection and controlled outbound access for selected network flows.

## Architecture

```text
workload subnet
 -> route table / UDR
 -> Azure Firewall
 -> policy decision
 -> approved destination
```

## Concepts to master

- Azure Firewall role
- deployment/subnet architecture
- SKU and design considerations
- network rules
- application rules
- NAT-rule concepts
- firewall policy/rule intent
- central egress inspection
- DNS/FQDN dependencies where relevant
- routing dependency

## Core lesson

A firewall cannot inspect packets that do not traverse it. Routing and firewall policy are distinct parts of the same enforcement design.
