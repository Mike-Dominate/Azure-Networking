# Lab 02 Visual Learning — Azure Traffic Manager

Visual learning is mandatory for Lab 02. The final assets must reflect the **actual lab implementation**, not the abandoned App Service source design.

Actual implementation:

```text
Azure Container Instances (ACI)
+ public ACI FQDNs
+ Traffic Manager External endpoints
+ Geographic routing
```

Required reusable PNG assets:

```text
Lab02-01-Traffic-Manager-DNS-Mental-Model.png
Lab02-02-Geographic-Routing-Flow.png
Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
Lab02-04-Final-Lab-Architecture.png
```

## Visual 01 — Traffic Manager DNS mental model

Must show **two distinct flows**:

```text
DNS / CONTROL FLOW
Client
  ↓
Recursive DNS resolver
  ↓
Traffic Manager profile
  ↓
DNS answer points to selected endpoint

APPLICATION DATA FLOW
Client
  ─────────────────────────────→ selected regional ACI endpoint
```

The image must explicitly state:

```text
Traffic Manager is NOT in the final HTTP/HTTPS data path.
```

Use the actual profile FQDN:

```text
az700-tm-md-87004.trafficmanager.net
```

## Visual 02 — Geographic routing flow

Show the tested final mapping:

```text
North America      (GEO-NA) -> ep-eus -> East US ACI
Europe             (GEO-EU) -> ep-weu -> West Europe ACI
Asia               (GEO-AS) -> ep-sea -> Southeast Asia ACI
Australia/Pacific  (GEO-AP) -> ep-sea -> Southeast Asia ACI
```

Also show the real failure discovered during the lab:

```text
Initial mapping omitted GEO-AP
Australian DNS lookup -> no eligible endpoint answer
```

Then show the correction:

```text
ep-sea geoMapping = GEO-AS + GEO-AP
Australian query -> Southeast Asia endpoint
```

Do not imply that Geographic routing means "closest endpoint".

## Visual 03 — Endpoint health and DNS behaviour

Must show three states:

### Healthy baseline

```text
ep-eus Online
ep-weu Online
ep-sea Online
Australia/Pacific -> ep-sea -> HTTP works
```

### Failure

```text
ci-az700-tm-sea stopped
        ↓
ep-sea Degraded
        ↓
Fresh DNS query STILL returns ep-sea for GEO-AP
        ↓
HTTP connection times out
```

This is critical: **do not draw cross-geography failover to Europe or North America.** The lab proved that Geographic routing preserved the configured geographic boundary.

### Recovery

```text
ci-az700-tm-sea started
        ↓
HTTP works
        ↓
ep-sea returns Online
```

Also distinguish:

```text
DNS TTL = DNS caching timer
Health probe interval = endpoint-monitoring timer
```

Lab observations:

```text
Traffic Manager configured TTL: 30s
Authoritative Traffic Manager CNAME TTL: 30s
AdGuard-presented Traffic Manager CNAME TTL: 60s
ACI A-record TTL observed: 300s
```

## Visual 04 — Final lab architecture

Use actual names and settings:

```text
Resource group: rg-az700-tm-global
Traffic Manager: tm-az700-global
Profile FQDN: az700-tm-md-87004.trafficmanager.net
Routing: Geographic
Configured DNS TTL: 30s
Health monitor: HTTP / port 80 / path /
Probe interval observed in Portal: 30s
Tolerated failures: 3
Probe timeout: 10s
```

Regional application endpoints:

```text
East US
  ci-az700-tm-eus
  az700-tm-eus-87004.eastus.azurecontainer.io
  ep-eus / GEO-NA

West Europe
  ci-az700-tm-weu
  az700-tm-weu-87004.westeurope.azurecontainer.io
  ep-weu / GEO-EU

Southeast Asia
  ci-az700-tm-sea
  az700-tm-sea-87004.southeastasia.azurecontainer.io
  ep-sea / GEO-AS + GEO-AP
```

The final architecture visual must show that ACI public IPs are not treated as stable identifiers; Traffic Manager targets the ACI FQDNs.

## Additional evidence images

Portal screenshots, DNS-query screenshots, or other images may be saved when they materially improve understanding. Avoid screenshots containing secrets, tokens, subscription IDs, tenant IDs, email addresses, or unrelated personal/company information.
