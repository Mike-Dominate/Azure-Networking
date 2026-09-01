# Module 7 — Design and implement private access to Azure Services

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-private-access-to-azure-services/

**BlueHarbor project:** Remove unnecessary public exposure from Azure PaaS while preserving access from the existing BlueHarbor estate  
**Status:** NOT STARTED

Module 7 continues directly from the secured environment built through Modules 1–6. BlueHarbor now adopts managed Azure services such as Storage, SQL and App Service, creating a new question:

> Why should a service that is consumed only by BlueHarbor workloads remain reachable through a public endpoint?

The module evolves the existing network rather than creating a separate PaaS lab.

```text
existing VNets / DNS / hybrid connectivity / Partner Hub / security
        |
        + service endpoint requirement
        + private endpoint requirement
        + private DNS integration
        + App Service VNet integration
        + Private Link Service where appropriate
        v
same BlueHarbor Terraform stack and state lineage
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Explain virtual network service endpoints
3. Define Private Link Service and private endpoint
4. Integrate private endpoint with Domain Name Service
5. Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal
6. Exercise: Create an Azure private endpoint using Azure PowerShell
7. Summary

## Cumulative Terraform rule

Every practical change in this module modifies the existing canonical Terraform root:

```text
blueharbor/terraform/
```

The BlueHarbor VNets, routing, DNS, hybrid connectivity, application-delivery and security resources created earlier remain in the same state unless an intentional architecture change requires otherwise.

Microsoft Portal/PowerShell exercises remain the learning baseline, but persistent BlueHarbor infrastructure is implemented through Terraform and independently validated with Azure CLI, Portal and protocol tests.

## Study-guide depth attached to this module

Where required by the current AZ-700 study guide, deepen the matching Microsoft units with:

- service endpoint policies;
- Private Link Service design;
- private endpoint access from hybrid/on-premises clients;
- App Service VNet integration;
- DNS design for private endpoints.

Do not create extra curriculum units for those additions.
