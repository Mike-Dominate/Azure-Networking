# Module 7 — Design and implement private access to Azure Services

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-private-access-to-azure-services/

**BlueHarbor project:** Replace unnecessary public service paths with deliberate private-access patterns  
**Status:** NOT STARTED

Module 7 starts from the exact secured estate produced by Modules 1–6. It does not create a separate PaaS lab.

## Manufacturing — Storage service endpoint

```text
snet-mfg-data 10.20.2.0/24
  |
Microsoft.Storage service endpoint
  |
Storage network/VNet restriction
  |
Manufacturing archive Storage
```

A Storage service endpoint is used because the requirement is approved subnet identity + service-side restriction, not a private IP for Storage.

Use a Storage service endpoint policy where the current Azure service/API supports the intended resource restriction.

### Secured-hub exception

The service-endpoint route to Azure Storage is intentionally **not described as traversing the central Azure Firewall**. It is a deliberate exception to the general secured-hub Internet-egress model.

Enforcement for this path is:

```text
service endpoint
+ service endpoint policy
+ Storage network/VNet rules
```

If BlueHarbor later requires packet inspection for this Storage path, revisit the design rather than pretending the service endpoint is inspected by Firewall.

## Partner Hub — Private Endpoints + VNet Integration

AUE additions:

```text
snet-private-endpoints    10.40.3.0/24
snet-appsvc-integration   10.40.4.0/26
snet-appgw-pl             10.40.5.0/27
```

Canonical path:

```text
Application Gateway WAF_v2
 -> App Service Private Endpoint
 -> App Service /orders
 -> VNet Integration
 -> SQL Private Endpoint
 -> Azure SQL
```

## BlueHarbor-owned Private Link Service

Reuse:

```text
lb-telemetry-aue Standard
 -> pls-telemetry-aue
 -> Core consumer PE 10.10.20.0/24
```

Manufacturing provider subnet:

```text
snet-pls-nat 10.20.3.0/27
```

BlueHarbor-owned private name:

```text
telemetry.services.blueharbor.internal
```

which remains beneath the Module 1 `blueharbor.internal` zone.

## Front Door origin privacy

```text
Front Door Premium
 -> Private Link
 -> AUE / SEA Application Gateway WAF_v2
```

Provider-side subnets:

```text
AUE 10.40.5.0/27
SEA 10.50.3.0/27
```

Migrate through a new Private-Link-enabled origin group, validate and switch the route before retiring the old public origin data path.

### TLS truth

For a Private-Link-enabled Application Gateway origin, Front Door certificate subject-name validation is mandatory when the origin protocol is HTTPS.

`portal.blueharbor.example` is narrative-only and cannot be treated as a real publicly trusted certificate identity.

Therefore:

```text
baseline lab
client -> HTTPS -> Front Door
Front Door -> App Gateway private origin using a supported lab origin protocol
```

True Front Door -> Application Gateway HTTPS/end-to-end TLS is a conditional practical: enable it only when a real learner-controlled domain and matching trusted certificate chain are available. Do not claim a successful end-to-end TLS design using `.example`.

## DNS/hybrid rule

Private Endpoint DNS extends the existing Core DNS Private Resolver architecture. Microsoft service-owned Private Link zones remain separate from `blueharbor.internal`.

## Secured-Virtual-WAN rule

Private Endpoint subnet network policies/NSGs/routes are configured deliberately. Do not claim Azure Firewall automatically sees same-VNet Private Endpoint traffic.

## Microsoft Learn units

1. Introduction
2. Explain virtual network service endpoints
3. Define Private Link Service and private endpoint
4. Integrate private endpoint with Domain Name Service
5. Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal
6. Exercise: Create an Azure private endpoint using Azure PowerShell
7. Summary

Persistent changes extend the same Terraform root/state.
