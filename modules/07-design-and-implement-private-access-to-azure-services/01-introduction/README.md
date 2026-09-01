# Unit 01 — Introduction

**BlueHarbor chapter:** Our network is private, our PaaS is not  
**Status:** NOT STARTED

## Starting state

BlueHarbor enters this unit with the cumulative environment from Modules 1–6: VNets, DNS, routing, hybrid connectivity, application delivery and security controls already exist in the same Terraform state.

## Business event

Application teams begin adopting Azure Storage, SQL/data services and App Service-style managed services.

Security asks:

> Why should services consumed only by BlueHarbor workloads depend on publicly reachable service endpoints?

## Core lesson

```text
resource hosted in Azure
!=
resource privately addressed inside BlueHarbor's VNet
```

This unit frames the private-access problem before choosing service endpoints, Private Link or VNet integration.

## Terraform impact

None yet unless the story explicitly requires a resource to support the tutorial. The unit defines the requirement; later practical units extend the existing `blueharbor/terraform/` stack.
