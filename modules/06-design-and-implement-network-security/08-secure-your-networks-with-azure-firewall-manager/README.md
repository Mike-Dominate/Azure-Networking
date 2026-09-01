# Unit 08 — Secure your networks with Azure Firewall Manager

**BlueHarbor chapter:** Centralise firewall governance  
**Status:** NOT STARTED

## Business event

BlueHarbor now has multiple regions, firewall policies and Virtual WAN connectivity. Security does not want independent snowflake firewall configurations.

## Mental model

```text
Azure Firewall
= enforcement / packet-processing service

Azure Firewall Manager
= central management and policy orchestration
```

## Concepts to master

- Firewall Policy
- central rule governance
- policy hierarchy/inheritance concepts where applicable
- hub and VNet management models
- management plane versus packet-processing plane

The learner should be able to explain what Firewall Manager manages and what component actually processes the traffic.
