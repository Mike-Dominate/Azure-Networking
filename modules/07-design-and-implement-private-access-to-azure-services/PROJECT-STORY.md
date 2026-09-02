# BlueHarbor Industries — Module 7 Project Story

## Project — Remove unnecessary public service paths

**Status:** NOT STARTED  
**Terraform:** same cumulative `blueharbor/terraform/` state

## Starting point

BlueHarbor enters Module 7 with secured Virtual WAN, Azure Firewall, hybrid routing/DNS, WAF, public telemetry services and the Partner Hub.

Three requirements intentionally use different technologies:

```text
Manufacturing archive
 -> Storage Service Endpoint

Partner Hub data/application modernization
 -> Private Endpoints + App Service VNet Integration

BlueHarbor telemetry service
 -> Private Link Service + consumer Private Endpoint
```

---

## Service Endpoint story

Use:

```text
bhi-vnet-mfg-aue
  snet-mfg-data 10.20.2.0/24
```

Add `Microsoft.Storage`, a restricted archive Storage account and a Storage service endpoint policy where supported.

### Important route truth

The Storage service-endpoint route is an intentional exception to the central firewall egress model:

```text
snet-mfg-data
 -> Azure Storage service endpoint route
 -> approved Storage
```

Do not claim:

```text
snet-mfg-data -> Azure Firewall -> Storage
```

for this access pattern.

Security is enforced by the endpoint identity/policy plus Storage network rules. A future requirement for packet inspection would justify a different access pattern.

---

## BlueHarbor-owned Private Link Service

Reuse the Module 4 AUE telemetry service:

```text
lb-telemetry-aue
Standard / TCP 9000
NIC-backed backend membership
```

Add:

```text
snet-pls-nat 10.20.3.0/27
pls-telemetry-aue
```

Consumer in Core:

```text
snet-private-endpoints 10.10.20.0/24
consumer PE -> pls-telemetry-aue
```

Use:

```text
telemetry.services.blueharbor.internal
```

as a record beneath the existing `blueharbor.internal` private zone.

Brisbane/Perth consume the private service through the existing hybrid network and Core DNS resolver path.

---

## DNS integration

Canonical Microsoft service zones include:

```text
privatelink.database.windows.net
privatelink.azurewebsites.net
```

BlueHarbor-owned names remain in:

```text
blueharbor.internal
```

Hybrid forwarding extends the Core DNS Private Resolver. Troubleshoot name resolution separately from reachability.

---

## Manufacturing Storage exercise

Apply the real delta to `snet-mfg-data`, create the archive Storage restriction/policy and prove approved versus unapproved access.

The service-endpoint firewall exception is expected and documented.

---

## Partner private application exercise

AUE adds:

```text
snet-private-endpoints   10.40.3.0/24
snet-appsvc-integration  10.40.4.0/26
snet-appgw-pl            10.40.5.0/27
```

SEA adds:

```text
snet-appgw-pl 10.50.3.0/27
```

Canonical Partner data path:

```text
Application Gateway WAF_v2
 -> App Service Private Endpoint
 -> App Service /orders
 -> VNet Integration
 -> SQL Private Endpoint
 -> Azure SQL
```

After private SQL connectivity/DNS is proven, disable unnecessary SQL public access. Do the same for App Service according to the current service model after the private ingress path is proven.

Front Door Premium then migrates from the hardened public App Gateway origins to a new Private-Link-enabled origin group. Validate both private connections and health before switching the route and later retiring the public origin data path.

Do not claim same-VNet App Service/SQL PE flows automatically traverse Azure Firewall; prove actual routing and use PE subnet policy/NSG/UDR controls deliberately.

---

## Module 7 end state

```text
Service Endpoint
 -> Manufacturing approved Storage path

Private Endpoint
 -> SQL / App Service private service IPs

VNet Integration
 -> App Service outbound into Partner VNet

Private Link Service
 -> BlueHarbor telemetry published privately

Front Door Private Link
 -> Front Door Premium to regional App Gateway WAF_v2 origins
```

No new VNet or transit hub is introduced.
