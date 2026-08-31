# Lab 02 Visual Learning — Azure Traffic Manager

> **Status: COMPLETE**

The final visual set reflects the actual tested Lab 02 implementation: Azure Container Instances, Traffic Manager External endpoints, Geographic routing, Terraform validation, failure/recovery and teardown.

## Visual assets

```text
Lab02-01-Traffic-Manager-DNS-Mental-Model.png
Lab02-02-Geographic-Routing-Flow.png
Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
Lab02-04-Final-Lab-Architecture.png
Lab02-05-Engineering-Validation-and-Closeout.png
```

## Visual 01 — DNS mental model

Separates the two flows that must not be confused:

```text
DNS/control flow:
Client -> recursive resolver -> Traffic Manager -> DNS answer

Application data flow:
Client ----------------------------------------> selected ACI endpoint
```

Traffic Manager is not in the final HTTP data path.

## Visual 02 — Geographic routing

```text
GEO-NA -> ep-eus -> East US
GEO-EU -> ep-weu -> West Europe
GEO-AS -> ep-sea -> Southeast Asia
GEO-AP -> ep-sea -> Southeast Asia
```

It records the real `GEO-AP` discovery: `GEO-AS` alone did not provide an eligible endpoint for the Australian test path. Geographic routing is explicit mapping, not “closest endpoint”.

## Visual 03 — Endpoint health and DNS behaviour

Shows healthy, failed and recovered states without inventing a Europe/North-America cross-failover path.

It also records the ACI identity nuance:

```text
Manual stop/start:    public IP changed
Terraform stop/start: public IP retained
Conclusion: do not depend on either result; target the stable FQDN
```

Observed DNS/health timers are included:

```text
Traffic Manager configured/authoritative CNAME TTL: 30s
AdGuard-presented CNAME TTL:                         60s
ACI A-record TTL:                                   300s
Health probe interval:                               30s
Tolerated failures:                                   3
Probe timeout:                                       10s
```

## Visual 04 — Final validated architecture

Shows the actual resource names, three regional ACI endpoints, Traffic Manager settings, Geographic mappings and the eight-resource Terraform model.

## Visual 05 — Engineering validation and closeout

Summarizes the complete lifecycle:

```text
manual Azure CLI
-> Terraform rebuild
-> independent Azure/DNS/HTTP tests
-> failure injection
-> recovery
-> no-change convergence
-> Git checkpoint
-> terraform destroy
-> documentation closeout
```

## Key settings represented

```text
Resource group: rg-az700-tm-global
Traffic Manager: tm-az700-global
FQDN: az700-tm-md-87004.trafficmanager.net
Routing: Geographic
Configured DNS TTL: 30s
Health monitor: HTTP / port 80 / path /
Probe interval: 30s
Tolerated failures: 3
Timeout: 10s
```

The source generator is `generate_visuals.py`.