# Unit 04 — Integrate private endpoint with Domain Name Service

**BlueHarbor chapter:** Extend the existing DNS architecture so private paths are actually used  
**Status:** NOT STARTED

Private Endpoint provisioning is not enough. Clients must resolve the service name to the intended private IP.

## Canonical private zones/names

```text
Azure SQL
privatelink.database.windows.net

App Service Private Endpoint
privatelink.azurewebsites.net

BlueHarbor-owned telemetry PLS consumer
services.blueharbor.internal
```

Link the required private DNS zones to the VNets that must resolve them, including Partner AUE and Core according to the final design.

## Hybrid DNS path

Reuse the Core DNS Private Resolver. Do not build another DNS server.

For Azure SQL hybrid resolution, configure on-premises DNS forwarding for the appropriate public service namespace, for example:

```text
database.windows.net
```

toward the BlueHarbor/Azure resolver path so Azure DNS can follow the service CNAME to `privatelink.database.windows.net`.

## Failure model

```text
PE exists + route works + DNS returns public target
 -> wrong network path

Azure workload resolves private + Brisbane resolves public
 -> hybrid DNS forwarding/link issue
```

Troubleshoot name resolution separately from routing and endpoint health.
