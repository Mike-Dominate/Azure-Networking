# Lab 02 — Manual Azure CLI Deployment Walkthrough

This document records the complete manual Azure CLI build, validation, failure testing, recovery testing, DNS TTL investigation, Portal inspection, and teardown performed for **Lab 02 — Azure Traffic Manager**.

It is intentionally written as a learning document rather than only a runbook. The goal is to make it possible to repeat the lab later and understand not only *what to type*, but *why each command and test exists*.

---

## 1. What this lab teaches

Lab 01 used Azure Load Balancer, which is a regional Layer-4 data-plane service. Lab 02 introduces Azure Traffic Manager, which is fundamentally different:

```text
Azure Load Balancer
= regional flow distribution
= sits in the application/network data path

Azure Traffic Manager
= global DNS-based traffic steering
= does NOT proxy the final HTTP/HTTPS connection
= after DNS resolution, the client connects directly to the selected endpoint
```

Core DNS flow:

```text
Client
  ↓
Recursive DNS Resolver
  ↓
Traffic Manager profile DNS name
  ↓
Traffic Manager evaluates routing method + endpoint configuration
  ↓
DNS answer points toward selected endpoint
  ↓
Client connects DIRECTLY to selected regional application endpoint
```

Traffic Manager is therefore a DNS decision service, not an inline reverse proxy.

---

## 2. Geographic routing mental model

The routing method used in this lab is **Geographic**.

Important distinction:

```text
Geographic routing != closest endpoint
Performance routing  = latency-oriented endpoint selection
Geographic routing   = explicit geography-to-endpoint mapping
```

The final mapping used in this lab was:

```text
North America      -> East US
Europe             -> West Europe
Asia               -> Southeast Asia
Australia/Pacific  -> Southeast Asia
```

The Australia/Pacific mapping was added during troubleshooting after we proved that Australia is not covered by the `GEO-AS` mapping.

---

## 3. Verify Azure account context

```powershell
az account show --query "{Subscription:name, SubscriptionId:id, TenantId:tenantId, IsDefault:isDefault}" -o table
```

Observed context:

```text
Subscription: Azure subscription 1
IsDefault:    True
```

Why this matters: networking labs can create chargeable resources, so confirm the active subscription before deployment.

---

## 4. Verify required Azure providers

```powershell
az provider list --query "[?namespace=='Microsoft.Web' || namespace=='Microsoft.Network'].{Provider:namespace,State:registrationState}" -o table
```

Observed:

```text
Microsoft.Network  Registered
Microsoft.Web      Registered
```

Later, after changing architecture to ACI, we also verified:

```powershell
az provider show --namespace Microsoft.ContainerInstance --query "{Provider:namespace,State:registrationState}" -o table
```

Observed:

```text
Microsoft.ContainerInstance  Registered
```

---

## 5. Check App Service F1 regional availability

The source exercise used App Service endpoints. We first checked whether Linux F1 was listed in the required regions:

```powershell
az appservice list-locations --sku F1 --linux-workers-enabled -o table
```

The output included:

```text
East US
West Europe
Southeast Asia
```

Important lesson:

```text
SKU listed in a region
        !=
subscription has usable quota/capacity there
```

---

## 6. Create the lab resource group

```powershell
az group create --name rg-az700-tm-global --location australiaeast -o table
```

Observed:

```text
Location       Name
-------------  ------------------
australiaeast  rg-az700-tm-global
```

The resource group's metadata location does not restrict the regions of resources placed inside it.

---

# Part A — Real subscription constraint and architecture change

## 7. Attempt the original App Service design

First App Service plan attempt:

```powershell
az appservice plan create `
  --name "asp-az700-tm-eus" `
  --resource-group rg-az700-tm-global `
  --location eastus `
  --sku F1 `
  --is-linux `
  -o table
```

Azure returned:

```text
Operation cannot be completed without additional quota.
Current Limit (Total VMs): 0
Current Usage: 0
Amount required: 1
Minimum New Limit: 1
```

This was not a command-syntax problem. The subscription's App Service compute quota in that region was zero.

We verified no partial App Service plan remained:

```powershell
az appservice plan list --resource-group rg-az700-tm-global -o table
```

Observed: no plan rows returned.

### Engineering decision

We deliberately substituted lightweight Azure Container Instances as the regional HTTP endpoints while preserving the actual Traffic Manager learning objectives:

```text
3 regional public HTTP applications
+
3 stable endpoint FQDNs
+
Traffic Manager External endpoints
+
Geographic routing
+
health monitoring
+
DNS TTL testing
```

This is preferable to abandoning the lab or pretending the quota issue did not happen.

---

# Part B — Build regional ACI application endpoints

## 8. Generate a unique DNS suffix

A PowerShell random suffix was generated to reduce DNS-label collision risk:

```powershell
$suffix = Get-Random -Minimum 10000 -Maximum 99999
```

For this run:

```text
suffix = 87004
```

---

## 9. East US container

The first ACI attempt omitted OS type and Azure returned:

```text
(InvalidOsType) The 'osType' for container group '<null>' is invalid.
The value must be one of 'Windows,Linux'.
```

Corrected command:

```powershell
az container create `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-eus `
  --location eastus `
  --image mcr.microsoft.com/azuredocs/aci-helloworld `
  --os-type Linux `
  --cpu 0.5 `
  --memory 0.5 `
  --ports 80 `
  --ip-address Public `
  --dns-name-label "az700-tm-eus-87004" `
  -o table
```

Observed:

```text
Name:      ci-az700-tm-eus
Status:    Running
Location:  eastus
IP:        20.242.191.210
```

Get the endpoint FQDN:

```powershell
az container show `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-eus `
  --query "ipAddress.fqdn" `
  -o tsv
```

Observed:

```text
az700-tm-eus-87004.eastus.azurecontainer.io
```

Direct HTTP validation:

```powershell
curl.exe http://az700-tm-eus-87004.eastus.azurecontainer.io
```

Returned the Azure Container Instances welcome page.

---

## 10. West Europe container

```powershell
az container create `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-weu `
  --location westeurope `
  --image mcr.microsoft.com/azuredocs/aci-helloworld `
  --os-type Linux `
  --cpu 0.5 `
  --memory 0.5 `
  --ports 80 `
  --ip-address Public `
  --dns-name-label "az700-tm-weu-87004" `
  -o table
```

Observed initial IP:

```text
20.8.44.51
```

Get FQDN:

```powershell
az container show `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-weu `
  --query "ipAddress.fqdn" `
  -o tsv
```

Observed:

```text
az700-tm-weu-87004.westeurope.azurecontainer.io
```

Direct HTTP validation:

```powershell
curl.exe http://az700-tm-weu-87004.westeurope.azurecontainer.io
```

Returned the ACI welcome page.

---

## 11. Southeast Asia container

```powershell
az container create `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea `
  --location southeastasia `
  --image mcr.microsoft.com/azuredocs/aci-helloworld `
  --os-type Linux `
  --cpu 0.5 `
  --memory 0.5 `
  --ports 80 `
  --ip-address Public `
  --dns-name-label "az700-tm-sea-87004" `
  -o table
```

Observed initial IP:

```text
40.119.253.24
```

Get FQDN:

```powershell
az container show `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea `
  --query "ipAddress.fqdn" `
  -o tsv
```

Observed:

```text
az700-tm-sea-87004.southeastasia.azurecontainer.io
```

Direct HTTP validation:

```powershell
curl.exe http://az700-tm-sea-87004.southeastasia.azurecontainer.io
```

Returned the ACI welcome page.

At this point all three regional applications worked independently before Traffic Manager was introduced.

---

# Part C — Build Traffic Manager

## 12. Create the Geographic Traffic Manager profile

```powershell
az network traffic-manager profile create `
  --resource-group rg-az700-tm-global `
  --name tm-az700-global `
  --routing-method Geographic `
  --unique-dns-name az700-tm-md-87004 `
  --ttl 30 `
  --protocol HTTP `
  --port 80 `
  --path "/" `
  -o table
```

The create command displayed no output in this terminal session, so instead of blindly rerunning it we verified state:

```powershell
az network traffic-manager profile show `
  --resource-group rg-az700-tm-global `
  --name tm-az700-global `
  --query "{Name:name,Status:profileStatus,Routing:trafficRoutingMethod,FQDN:dnsConfig.fqdn,TTL:dnsConfig.ttl,Protocol:monitorConfig.protocol,Port:monitorConfig.port,Path:monitorConfig.path}" `
  -o table
```

Observed:

```text
Name             Status   Routing      FQDN                                  TTL  Protocol  Port  Path
---------------  -------  -----------  ------------------------------------  ---  --------  ----  ----
tm-az700-global  Enabled  Geographic   az700-tm-md-87004.trafficmanager.net   30  HTTP        80  /
```

Lesson: verify Azure state before rerunning a create command just because output appears unusual.

---

## 13. Add East US as an External endpoint

```powershell
az network traffic-manager endpoint create `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --name ep-eus `
  --type externalEndpoints `
  --target az700-tm-eus-87004.eastus.azurecontainer.io `
  --geo-mapping GEO-NA `
  --endpoint-status Enabled `
  -o table
```

Observed initial health:

```text
CheckingEndpoint
```

---

## 14. Add West Europe endpoint

```powershell
az network traffic-manager endpoint create `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --name ep-weu `
  --type externalEndpoints `
  --target az700-tm-weu-87004.westeurope.azurecontainer.io `
  --geo-mapping GEO-EU `
  --endpoint-status Enabled `
  -o table
```

Observed initial health:

```text
CheckingEndpoint
```

---

## 15. Add Southeast Asia endpoint

Initial mapping:

```powershell
az network traffic-manager endpoint create `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --name ep-sea `
  --type externalEndpoints `
  --target az700-tm-sea-87004.southeastasia.azurecontainer.io `
  --geo-mapping GEO-AS `
  --endpoint-status Enabled `
  -o table
```

Observed initial health:

```text
CheckingEndpoint
```

---

## 16. Verify all endpoint health

```powershell
az network traffic-manager endpoint list `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --query "[].{Name:name,Health:endpointMonitorStatus,Status:endpointStatus,Target:target,Geo:geoMapping}" `
  -o table
```

Observed:

```text
ep-eus  Online  Enabled
ep-weu  Online  Enabled
ep-sea  Online  Enabled
```

The difference between these two fields matters:

```text
EndpointStatus        = administrative participation (Enabled/Disabled)
EndpointMonitorStatus = Traffic Manager health observation (Online/Degraded/etc.)
```

---

# Part D — Geographic routing failure discovered from Australia

## 17. Initial DNS lookup

The workstation used AdGuard DNS:

```text
dns.adguard-dns.com
94.140.14.14
```

Initial lookup:

```powershell
nslookup az700-tm-md-87004.trafficmanager.net
```

Observed:

```text
Server:  dns.adguard-dns.com
Address: 94.140.14.14

Name:    az700-tm-md-87004.trafficmanager.net
```

No endpoint address was returned.

### Why

Our mappings were only:

```text
GEO-NA -> East US
GEO-EU -> West Europe
GEO-AS -> Southeast Asia
```

Australia is under `GEO-AP` (Australia/Pacific), not `GEO-AS`.

This disproved the incorrect mental model that Geographic routing simply chooses a nearby region.

---

## 18. Fix the Southeast Asia geographic mapping

Update `ep-sea` to serve both Asia and Australia/Pacific:

```powershell
az network traffic-manager endpoint update `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --name ep-sea `
  --type externalEndpoints `
  --geo-mapping GEO-AS GEO-AP `
  -o table
```

Verify:

```powershell
az network traffic-manager endpoint show `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --name ep-sea `
  --type externalEndpoints `
  --query "{Health:endpointMonitorStatus,Status:endpointStatus,GeoMappings:geoMapping}" `
  -o json
```

Observed:

```json
{
  "GeoMappings": [
    "GEO-AS",
    "GEO-AP"
  ],
  "Health": "Online",
  "Status": "Enabled"
}
```

---

## 19. DNS routing now succeeds from Australia

```powershell
nslookup az700-tm-md-87004.trafficmanager.net
```

Observed:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

This proved the DNS steering path:

```text
Australian client/resolver geography
        ↓
GEO-AP
        ↓
ep-sea
        ↓
Southeast Asia ACI FQDN
```

---

## 20. Validate the application through Traffic Manager

```powershell
curl.exe http://az700-tm-md-87004.trafficmanager.net
```

Returned the ACI welcome page.

Important: the HTTP response alone did not identify the region because all three containers served the same content. The **DNS lookup + HTTP success together** proved the routing decision and successful application connection.

---

# Part E — Failure and recovery test

## 21. Stop the Southeast Asia application

```powershell
az container stop `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea
```

No output was returned, so Azure state was verified explicitly:

```powershell
az container show `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea `
  --query "{Name:name,State:instanceView.state,IP:ipAddress.ip}" `
  -o table
```

Observed:

```text
ci-az700-tm-sea  Stopped
```

---

## 22. Watch Traffic Manager health detection

```powershell
az network traffic-manager endpoint list `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --query "[].{Name:name,Health:endpointMonitorStatus,Status:endpointStatus,Target:target}" `
  -o table
```

Observed:

```text
ep-eus  Online    Enabled
ep-weu  Online    Enabled
ep-sea  Degraded  Enabled
```

This is the cleanest proof that endpoint administrative status and monitor health are different concepts.

---

## 23. Fresh DNS query while the mapped endpoint is degraded

To reduce the chance of reusing the previous recursive cache, Google DNS was queried directly:

```powershell
nslookup az700-tm-md-87004.trafficmanager.net 8.8.8.8
```

Observed:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

Critical lesson:

```text
GEO-AP is explicitly mapped to ep-sea
        ↓
ep-sea becomes degraded
        ↓
Traffic Manager does NOT silently move Australia to Europe or North America
        ↓
the geographic boundary is preserved
```

Geographic routing must not be assumed to behave like Priority routing.

---

## 24. Prove the application consequence

```powershell
curl.exe --max-time 10 http://az700-tm-md-87004.trafficmanager.net
```

Observed:

```text
curl: (28) Connection timed out after 10014 milliseconds
```

This proves:

```text
DNS steering can succeed
+
Traffic Manager can know the endpoint is degraded
+
application connectivity can still fail
```

Traffic Manager is not in the HTTP data path and cannot rescue that existing client connection.

---

## 25. Recover the application

```powershell
az container start `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea
```

HTTP validation:

```powershell
curl.exe --max-time 10 http://az700-tm-md-87004.trafficmanager.net
```

Returned the ACI welcome page.

Health validation:

```powershell
az network traffic-manager endpoint list `
  --resource-group rg-az700-tm-global `
  --profile-name tm-az700-global `
  --query "[].{Name:name,Health:endpointMonitorStatus,Status:endpointStatus,Target:target}" `
  -o table
```

Observed:

```text
ep-eus  Online  Enabled
ep-weu  Online  Enabled
ep-sea  Online  Enabled
```

The Southeast Asia ACI public IP after restart was observed as:

```text
20.197.126.249
```

This differed from the original `40.119.253.24`, reinforcing why Traffic Manager should target the ACI FQDN rather than a transient public IP.

---

# Part F — DNS TTL investigation

## 26. Inspect DNS records from the normal resolver path

```powershell
Resolve-DnsName az700-tm-md-87004.trafficmanager.net |
  Format-Table Name,Type,TTL,NameHost,IPAddress -AutoSize
```

Observed:

```text
Traffic Manager CNAME TTL: 60
ACI endpoint A record TTL: 300
```

But the profile was configured with TTL 30, so we did not assume Azure was wrong or that the command had failed. We isolated the layers.

---

## 27. Verify Azure configuration

```powershell
az network traffic-manager profile show `
  --resource-group rg-az700-tm-global `
  --name tm-az700-global `
  --query "{FQDN:dnsConfig.fqdn,ConfiguredTTL:dnsConfig.ttl}" `
  -o table
```

Observed:

```text
ConfiguredTTL = 30
```

---

## 28. Find authoritative Traffic Manager name servers

```powershell
Resolve-DnsName trafficmanager.net -Type NS |
  Format-Table Name,Type,NameHost -AutoSize
```

Observed name servers included:

```text
tm1.dns-tm.com
tm2.dns-tm.com
tm1.edgedns-tm.info
tm2.edgedns-tm.info
```

---

## 29. Query authoritative Traffic Manager DNS directly

```powershell
Resolve-DnsName az700-tm-md-87004.trafficmanager.net `
  -Server tm1.dns-tm.com |
  Format-Table Name,Type,TTL,NameHost,IPAddress -AutoSize
```

Observed:

```text
Traffic Manager CNAME TTL = 30
```

This proved Azure Traffic Manager authoritative DNS was returning exactly the configured value.

---

## 30. Query AdGuard directly

```powershell
Resolve-DnsName az700-tm-md-87004.trafficmanager.net `
  -Server 94.140.14.14 |
  Format-Table Name,Type,TTL,NameHost,IPAddress -AutoSize
```

Observed:

```text
Traffic Manager CNAME TTL = 60
ACI endpoint A record TTL = 300
```

Therefore the 60-second value was being introduced in the recursive-resolution path rather than by the Traffic Manager profile.

Precise lesson:

```text
Traffic Manager configured TTL = 30
Authoritative Azure response   = 30
Recursive resolver observed    = 60
```

Do not assume every recursive resolver will present the exact authoritative TTL to the client.

Also note that a DNS resolution chain can contain multiple records with different TTLs.

---

# Part G — Portal inspection

## 31. Overview page

Portal inspection of `tm-az700-global` confirmed:

```text
Location:       global
Status:         Enabled
Routing method: Geographic
Monitor status: Online
Endpoints:      3
DNS Name:       az700-tm-md-87004.trafficmanager.net
```

The `global` location reinforces that Traffic Manager itself is not a regional application proxy.

---

## 32. Configuration page

Portal configuration showed:

```text
Routing method:             Geographic
DNS TTL:                    30 seconds
Monitor protocol:           HTTP
Port:                       80
Path:                       /
Probing interval:           30 seconds
Tolerated number failures:  3
Probe timeout:              10 seconds
Expected status:            default 200
```

Two timers must remain mentally separate:

```text
DNS TTL        = DNS caching lifetime
Probe interval = Traffic Manager health-check cadence
```

---

## 33. Endpoints page

Portal showed all three endpoints as:

```text
Enabled
Online
External endpoint
```

The `ep-sea` edit pane visibly showed both mappings:

```text
Asia
Australia / Pacific
```

Portal also warns that endpoints behind firewalls/NSGs must allow Azure Traffic Manager health probes. In this lab the ACI endpoints were public, so no NSG rule was required.

---

# Part H — Manual teardown

## 34. Delete the manual environment

Because all manual resources were intentionally contained in one resource group, teardown used the RG boundary:

```powershell
az group delete `
  --name rg-az700-tm-global `
  --yes `
  --no-wait
```

No output was returned because `--no-wait` starts deletion asynchronously and returns control quickly.

The Azure Portal was checked and the resource group was no longer present.

---

## 35. Independent CLI clean-state verification

```powershell
az group exists --name rg-az700-tm-global
```

Observed:

```text
false
```

This is the required clean boundary before Terraform recreates the architecture.

---

# Part I — Final manual architecture

```text
                         DNS / control path

Australian client
      |
      v
Recursive DNS resolver
      |
      v
az700-tm-md-87004.trafficmanager.net
Azure Traffic Manager
Routing method: Geographic
DNS TTL: 30 authoritative seconds
Monitor: HTTP :80 /
      |
      +-------------------+-------------------+-------------------+
      |                   |                   |
      v                   v                   v
North America          Europe            Asia + Australia/Pacific
GEO-NA                 GEO-EU            GEO-AS + GEO-AP
      |                   |                   |
      v                   v                   v
ep-eus                ep-weu              ep-sea
      |                   |                   |
      v                   v                   v
East US ACI           West Europe ACI      Southeast Asia ACI
ci-az700-tm-eus       ci-az700-tm-weu      ci-az700-tm-sea

APPLICATION DATA PATH AFTER DNS:
Client -------------------------------------------------> selected ACI endpoint

Traffic Manager is NOT inline in that final HTTP connection.
```

---

# Part J — Key lessons to retain

1. Traffic Manager is DNS-based global steering, not an inline HTTP proxy.
2. Geographic routing uses explicit geography mappings; it does not mean "closest endpoint".
3. Recursive resolver geography matters because Traffic Manager makes its decision during DNS resolution.
4. An unmapped geography can receive no usable endpoint answer.
5. `GEO-AS` does not include Australia; Australia/Pacific required `GEO-AP`.
6. Endpoint administrative status and endpoint monitor health are different fields.
7. Geographic routing preserved the configured Australia/Pacific boundary even when the mapped endpoint became degraded; it did not automatically send users to Europe or North America.
8. DNS success does not guarantee the application is reachable.
9. Traffic Manager authoritative TTL and the TTL ultimately presented by a recursive resolver can differ.
10. Different records in one DNS chain can have independent TTLs.
11. ACI public IP changed after restart; stable FQDNs are better Traffic Manager targets than transient IPs.
12. Regional SKU availability does not guarantee subscription quota or live deployability.
13. When a create command appears to give no output, inspect real Azure state before blindly rerunning it.
14. Record real cloud constraints and architecture changes rather than hiding them.
15. Tear down the manual environment before Terraform to avoid unmanaged-resource collisions.

---

# Next phase

The next phase is to rebuild the same **ACI + Traffic Manager Geographic routing** architecture with Terraform, validate it independently, repeat meaningful failure/recovery tests, achieve a final no-change plan, produce the final visual assets and rebuild/practice PDF, and then destroy/verify the Terraform environment.
