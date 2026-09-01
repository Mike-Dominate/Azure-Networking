# Unit 06 — Exercise: Create an Azure private endpoint using Azure PowerShell

**BlueHarbor chapter:** Make the Partner Hub data tier privately reachable  
**Status:** NOT STARTED

## Microsoft objective, Terraform implementation

Study Microsoft's PowerShell exercise and preserve its learning objective, but implement BlueHarbor's persistent infrastructure through the cumulative Terraform root.

Expected delta:

```text
existing Partner Hub / application network
        +
managed PaaS service
        +
Private Endpoint
        +
private DNS integration
        +
appropriate service-specific public network restriction
```

Do not assume a Private Endpoint automatically disables every public access path. Configure the target PaaS service according to its network-access controls and the BlueHarbor requirement.

## App Service VNet Integration

Where required by the Microsoft module/study guide, extend the existing Partner Hub application design:

```text
App Service / managed app
        |
VNet Integration
        |
existing BlueHarbor VNet
        |
Private Endpoint
        |
PaaS data service
```

Mental distinction:

```text
VNet Integration
-> supported application outbound path into the VNet

Private Endpoint
-> supported service privately reachable through a private IP
```

## Deliberate failures

Test and isolate scenarios such as:

- endpoint healthy but DNS resolves the public path;
- Azure workload resolves privately but an approved hybrid client does not;
- private path works but unintended public access remains enabled;
- incorrect DNS/VNet linkage prevents the application from reaching the expected service.

End with Terraform and Azure reconciled.
