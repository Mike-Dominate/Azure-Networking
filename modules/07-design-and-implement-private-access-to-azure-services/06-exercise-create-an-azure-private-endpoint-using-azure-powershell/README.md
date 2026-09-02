# Unit 06 — Exercise: Create an Azure private endpoint using Azure PowerShell

**BlueHarbor chapter:** Privatize Partner Hub data, modernize `/orders`, and move Front Door origins to Private Link  
**Status:** NOT STARTED

Study Microsoft's PowerShell exercise and preserve its learning objective. Persistent BlueHarbor changes remain Terraform-managed.

## AUE subnet delta

```text
bhi-vnet-partner-aue 10.40.0.0/16
  snet-private-endpoints   10.40.3.0/24
  snet-appsvc-integration  10.40.4.0/26
  snet-appgw-pl            10.40.5.0/27
```

SEA adds:

```text
bhi-vnet-partner-sea
  snet-appgw-pl            10.50.3.0/27
```

## Azure SQL Private Endpoint

Create a dedicated BlueHarbor Partner SQL logical server/database and add the SQL Private Endpoint to `snet-private-endpoints`.

DNS:

```text
privatelink.database.windows.net
```

Required sequence:

```text
create service
 -> add private endpoint
 -> validate Partner private DNS/connectivity
 -> validate approved hybrid DNS/route where required
 -> disable SQL public network access
 -> prove unintended public access is gone
```

Do not assume the Private Endpoint automatically disables public service access.

## App Service VNet Integration becomes real

Modernize the Partner Hub `/orders` backend to App Service.

```text
Application Gateway WAF_v2
 -> App Service Private Endpoint
 -> App Service `/orders`
 -> VNet Integration through snet-appsvc-integration
 -> SQL Private Endpoint
 -> Azure SQL
```

`snet-appsvc-integration` is a dedicated delegated integration subnet and is not shared with Private Endpoints.

Add the current App Service private DNS integration, including `privatelink.azurewebsites.net` where applicable.

Mental distinction:

```text
VNet Integration = App Service outbound path into the VNet
Private Endpoint  = private inbound/service identity through a VNet IP
```

After the private Application Gateway -> App Service path is proven, disable unnecessary App Service public network access according to current service behaviour.

## Private Endpoint network-policy rule

Because the estate now uses secured Virtual WAN private routing, Private Endpoint subnets use the current network-policy setting required for NSG/UDR enforcement and symmetric hybrid routing. Do not keep an obsolete blanket assumption that PE network policies must always be disabled.

Also do not claim same-VNet Partner -> SQL PE traffic automatically traverses Azure Firewall. Prove the actual route.

## Front Door Premium -> Application Gateway Private Link

Module 6 has already upgraded:

```text
Front Door Premium
App Gateway WAF_v2 AUE/SEA
```

Create provider-side Application Gateway Private Link configuration using:

```text
AUE snet-appgw-pl 10.40.5.0/27
SEA snet-appgw-pl 10.50.3.0/27
```

Then migrate safely:

```text
create new private-link origin group
 -> create/approve AUE + SEA private origin connections
 -> validate origin health
 -> switch Front Door route
 -> validate end-to-end application delivery
 -> retire public origin data path after rollback window
```

Do not mix public and Private-Link-enabled origins inside one origin group where the current Front Door service does not support that design.

### Origin TLS guardrail

When the Front Door origin protocol is HTTPS for a Private-Link-enabled Application Gateway, certificate subject-name validation is mandatory.

The narrative hostname `portal.blueharbor.example` does not represent a real trusted public certificate. Therefore the baseline private-origin lab must use a supported origin protocol/configuration that can be honestly validated.

Only claim:

```text
Front Door -> HTTPS -> Application Gateway
```

when a real learner-controlled domain and matching trusted certificate chain are available and configured. That conditional practical is where end-to-end TLS is proved.

## Failure tests

- SQL PE healthy but DNS resolves public path;
- Partner resolves privately but Brisbane does not;
- private SQL works but public access was accidentally left enabled;
- App Service VNet Integration subnet/delegation wrong;
- App Gateway cannot resolve/reach App Service PE;
- Front Door private origin connection not approved;
- Front Door route still points to old public origin group;
- HTTPS origin certificate name/chain does not validate when end-to-end TLS is enabled.

End with Terraform, Azure state, DNS and application paths reconciled.
