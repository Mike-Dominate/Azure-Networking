# BlueHarbor Industries — Module 7 Project Story

## Project — Remove unnecessary public service paths

**Microsoft Learn module:** Design and implement private access to Azure Services  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 6

BlueHarbor already has:

```text
secured Virtual WAN / routing intent
AUE + SEA Azure Firewall
VPN / ExpressRoute / hybrid routing
Core DNS Private Resolver
DDoS / NSG / ASG
Front Door Premium + edge WAF
AUE + SEA Application Gateway WAF_v2
public telemetry Load Balancers
```

The new question is not "how do we build another network?"

It is:

> Which managed/service paths should remain public, which should trust a subnet identity, and which should be represented by private IP addresses inside BlueHarbor?

---

## Chapter 01 — Introduction: Azure-hosted is not automatically private

Three requirements appear:

```text
Manufacturing archive
 -> approved subnet may use Azure Storage

Partner Hub data
 -> application and hybrid clients require private-addressed Azure SQL

BlueHarbor telemetry service
 -> selected consumers should reach BlueHarbor's own service through Private Link
```

These requirements intentionally use different technologies.

---

## Chapter 02 — Service endpoints: Manufacturing archive access

Use the existing Module 6 data subnet, not the public telemetry subnet:

```text
bhi-vnet-mfg-aue
  snet-mfg-data 10.20.2.0/24
```

Add:

```text
Microsoft.Storage service endpoint
Azure Storage archive account
Storage network/VNet restriction
Storage service endpoint policy where supported/appropriate
```

The service endpoint does not create a private NIC or private Storage IP in the VNet. It allows the supported service to recognise the approved subnet identity and enforce service-side restrictions.

This keeps the lesson distinct from Private Endpoint.

---

## Chapter 03 — Private Link Service and Private Endpoint: make both provider and consumer real

### BlueHarbor-owned provider service

Reuse the existing Module 4 service:

```text
lb-telemetry-aue
Standard public Load Balancer
TCP/9000
NIC-backed backend membership
```

Add to Manufacturing:

```text
snet-pls-nat 10.20.3.0/27
privateLinkServiceNetworkPolicies = Disabled

pls-telemetry-aue
 -> existing lb-telemetry-aue frontend
```

The telemetry backend NSG must allow the required PLS NAT-source path on TCP/9000 according to the current service behaviour.

### BlueHarbor consumer

Add to Core:

```text
bhi-vnet-core-aue
  snet-private-endpoints 10.10.20.0/24
```

Create a consumer Private Endpoint from Core to `pls-telemetry-aue`.

Use a BlueHarbor private DNS name, for example:

```text
telemetry.services.blueharbor.internal
```

mapped to the Core consumer Private Endpoint IP through the existing BlueHarbor private-DNS architecture.

### Hybrid proof

```text
Brisbane / Perth client
  -> existing VPN / ExpressRoute
  -> secured Virtual WAN
  -> Core consumer PE
  -> Private Link
  -> pls-telemetry-aue
  -> existing telemetry Load Balancer/backends
```

This fulfills the private consumption story without inventing a second telemetry application.

---

## Chapter 04 — DNS: make private names resolve through the existing architecture

Private Endpoint resources are useful only when clients resolve the intended private address.

Canonical private DNS requirements include:

```text
Azure SQL
privatelink.database.windows.net

App Service private endpoint
privatelink.azurewebsites.net

BlueHarbor-owned PLS consumer
services.blueharbor.internal
```

Link service-specific private DNS zones to the VNets that must resolve them, including Partner AUE and Core where required by the design.

### Hybrid forwarding

For on-premises clients, keep using the Core DNS Private Resolver introduced earlier.

For a service such as Azure SQL, conditional forwarding should target the appropriate public service namespace (for example `database.windows.net`) toward the Azure resolver path, allowing Azure DNS to follow the service CNAME into the private zone.

Do not create an unrelated DNS server merely for this module.

### Required failures

```text
PE healthy + wrong DNS answer     -> private design fails
Azure client resolves privately
but Brisbane does not             -> hybrid DNS path problem
```

---

## Chapter 05 — Exercise: Manufacturing Storage service endpoint

Preserve Microsoft's exercise objective but implement the real cumulative delta:

```text
existing snet-mfg-data
  + Microsoft.Storage service endpoint

new Storage archive account
  + default-deny / public network firewall posture required by the exercise
  + allow approved snet-mfg-data path
  + service endpoint policy to approved Storage resource where supported
```

Validation:

```text
approved data workload -> Storage   ALLOW
unapproved source       -> Storage   DENY
```

Do not treat a successful apply as proof.

---

## Chapter 06 — Exercise: Partner Hub private data and App Service modernization

### Canonical AUE subnet additions

```text
bhi-vnet-partner-aue 10.40.0.0/16

snet-private-endpoints   10.40.3.0/24
snet-appsvc-integration  10.40.4.0/26
snet-appgw-pl            10.40.5.0/27
```

`snet-appsvc-integration` is delegated to the current App Service integration service (`Microsoft.Web/serverFarms` in the expected model) and is not shared with Private Endpoints.

Private Endpoint network policies are enabled where required for the secured Virtual WAN/NSG/route-table design. App Gateway Private Link provider-side subnets use the current required Private Link service policy setting.

### Azure SQL becomes the canonical managed-data target

Create:

```text
Azure SQL logical server
Partner database
SQL Private Endpoint in snet-private-endpoints
private DNS: privatelink.database.windows.net
```

Migration sequence:

```text
create SQL
 -> add PE
 -> prove Partner private DNS + connectivity
 -> prove Brisbane/private hybrid resolution and route where required
 -> disable SQL public network access
 -> prove unintended public path is gone
```

A Private Endpoint alone is not assumed to disable the public service path.

### `/orders` moves to App Service

Modernize the Partner Hub `/orders` backend:

```text
Application Gateway WAF_v2
  -> App Service Private Endpoint
  -> App Service orders component
  -> VNet Integration through snet-appsvc-integration
  -> SQL Private Endpoint
  -> Azure SQL
```

Add App Service private DNS using the current service-specific private zone, including `privatelink.azurewebsites.net` where applicable.

After Application Gateway reaches the App Service through the private endpoint and application health is proven, disable unnecessary App Service public network access according to the current service model.

Mental distinction:

```text
VNet Integration
 -> App Service outbound access into the VNet

Private Endpoint
 -> private inbound/service reachability through a private IP
```

### Front Door origin path becomes private

Module 6 already upgraded Front Door to Premium and App Gateways to WAF_v2.

Add provider-side Application Gateway Private Link subnets:

```text
AUE: snet-appgw-pl 10.40.5.0/27
SEA: snet-appgw-pl 10.50.3.0/27
```

Then migrate Front Door safely:

```text
existing public origin group
  -> create new Private-Link-enabled AUE/SEA origin group
  -> approve private connections
  -> validate both origins healthy
  -> switch Front Door route to private origin group
  -> validate end-to-end traffic
  -> retire public origin data path when rollback window closes
```

Do not mix public and Private-Link-enabled origins in one origin group when current Azure Front Door behaviour does not support that design.

Module 6's public-origin FDID/source restrictions remain useful during migration and as protection for any retained public regional frontend.

### Secured Virtual WAN nuance

Do not say "the firewall sees all Private Endpoint traffic." Same-VNet Partner App -> SQL PE traffic may remain local unless explicitly routed through another path. Use Private Endpoint subnet network policies, NSGs and route-table design consciously.

For on-premises/branch -> PE flows, verify the secured Virtual WAN route and return path so `/32` endpoint routes do not create asymmetry.

---

## Chapter 07 — Private-access architecture review

Final patterns:

```text
Service Endpoint
 -> Manufacturing subnet identity -> restricted Storage

Private Endpoint
 -> Azure SQL / App Service represented by private IPs

App Service VNet Integration
 -> App Service outbound into Partner VNet

Private Link Service
 -> publish BlueHarbor-owned telemetry privately

Front Door Private Link
 -> global Front Door Premium reaches regional App Gateway origins privately
```

## Canonical Module 7 address delta

```text
CORE AUE
10.10.20.0/24   snet-private-endpoints

MFG AUE
10.20.3.0/27    snet-pls-nat

PARTNER AUE
10.40.3.0/24    snet-private-endpoints
10.40.4.0/26    snet-appsvc-integration
10.40.5.0/27    snet-appgw-pl

PARTNER SEA
10.50.3.0/27    snet-appgw-pl
```

No new VNet and no new transit hub are introduced.

## Handoff to Module 8

The estate now contains hybrid/private DNS, secured hub routing, public and private application paths, Private Endpoints, Private Link Service, service endpoints, WAF and multiple regions.

Operations asks:

> Configuration says what should happen. How do we prove what this complete network is actually doing?

That is Module 8.
