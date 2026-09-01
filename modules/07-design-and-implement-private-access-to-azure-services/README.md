# Module 7 — Design and implement private access to Azure Services

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-private-access-to-azure-services/

**BlueHarbor project:** Replace unnecessary public service paths with deliberate private-access patterns  
**Status:** NOT STARTED

Module 7 starts from the exact secured estate produced by Modules 1–6. It does not create a separate PaaS lab.

## Starting security/network state

```text
secured Virtual WAN
AUE + SEA Azure Firewall
central Firewall Policy / routing intent
hybrid VPN + ExpressRoute
Core DNS Private Resolver
DDoS / NSG / ASG
Front Door Premium + WAF
AUE + SEA Application Gateway WAF_v2
public telemetry Load Balancers
```

## Three deliberately different private-access scenarios

### Manufacturing — Storage service endpoint

```text
snet-mfg-data 10.20.2.0/24
  |
Microsoft.Storage service endpoint
  |
Storage firewall/VNet restriction
  |
Azure Storage archive account
```

A Storage service endpoint is used because the requirement is **approved subnet identity + service-side restriction**, not a private IP for Storage.

A Storage service endpoint policy is added where supported/appropriate to constrain the subnet to the approved Storage resource.

### Partner Hub — Private Endpoints + App Service VNet Integration

Australia East gains:

```text
bhi-vnet-partner-aue
  snet-private-endpoints    10.40.3.0/24
  snet-appsvc-integration   10.40.4.0/26
  snet-appgw-pl             10.40.5.0/27
```

Canonical managed data service:

```text
Azure SQL logical server + Partner database
  -> Private Endpoint in snet-private-endpoints
  -> privatelink.database.windows.net
```

Partner `/orders` is modernized to App Service:

```text
Application Gateway WAF_v2
  -> App Service Private Endpoint
  -> App Service
  -> VNet Integration via snet-appsvc-integration
  -> Azure SQL Private Endpoint
```

Private DNS for App Service uses the current service-specific zone, including `privatelink.azurewebsites.net` where applicable.

### BlueHarbor-owned service — Private Link Service

Reuse the real Module 4 AUE telemetry service:

```text
lb-telemetry-aue Standard
  -> Private Link Service
  -> consumer Private Endpoint in Core
```

Manufacturing adds:

```text
snet-pls-nat 10.20.3.0/27
```

Core adds:

```text
snet-private-endpoints 10.10.20.0/24
```

The Module 4 AUE Load Balancer uses NIC-backed backend membership so this later Private Link Service does not require rebuilding the service.

## Front Door origin privacy

Module 6 hardened public Application Gateway origins. Module 7 evolves the origin path further:

```text
Front Door Premium
  -> Private Link
  -> AUE / SEA Application Gateway WAF_v2 origins
```

SEA adds:

```text
bhi-vnet-partner-sea
  snet-appgw-pl 10.50.3.0/27
```

Use a new Private-Link-enabled origin group, validate both private origin connections, switch the route, then retire the public origin data path. Do not mix public and Private-Link-enabled origins in the same origin group when the current service model does not support that combination.

## DNS/hybrid rule

Private Endpoint DNS extends the existing Core DNS Private Resolver architecture.

For hybrid service resolution, forward the appropriate **public service zone** (for example `database.windows.net`) toward Azure DNS through the existing resolver path so Azure can follow the service's CNAME into the linked private DNS zone.

## Secured-Virtual-WAN rule

Private Endpoint subnets use the current network-policy configuration required for NSG/route-table enforcement in the secured Virtual WAN design. The approved contract is to enable Private Endpoint network policies where required so the `/32` private endpoint routes do not silently bypass the intended hybrid routing/security behaviour.

Do not claim Azure Firewall sees same-VNet Private Endpoint traffic automatically. Local same-VNet flows require their own subnet policy/NSG/UDR reasoning.

## Microsoft Learn units

1. Introduction
2. Explain virtual network service endpoints
3. Define Private Link Service and private endpoint
4. Integrate private endpoint with Domain Name Service
5. Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal
6. Exercise: Create an Azure private endpoint using Azure PowerShell
7. Summary

Persistent BlueHarbor infrastructure is implemented through the same `blueharbor/terraform/` root and independently validated with CLI/Portal/PowerShell/protocol tests.
