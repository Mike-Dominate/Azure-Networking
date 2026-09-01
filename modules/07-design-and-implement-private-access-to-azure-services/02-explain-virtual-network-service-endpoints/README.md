# Unit 02 — Explain virtual network service endpoints

**BlueHarbor chapter:** Restrict Manufacturing archive access to Azure Storage  
**Status:** NOT STARTED

## Business event

The controlled Manufacturing data service introduced in Module 6 must write archives/backups to Azure Storage.

Use:

```text
bhi-vnet-mfg-aue
  snet-mfg-data 10.20.2.0/24
        |
Microsoft.Storage service endpoint
        |
Azure Storage archive account
```

Do **not** use the public telemetry subnet for this scenario.

## Mental model

A service endpoint does not create a private endpoint NIC or private service IP in the subnet.

It extends supported subnet identity to the service so the service-side network policy can trust only approved network sources.

## BlueHarbor policy

Add a Storage service endpoint policy where the current service/API supports it so `snet-mfg-data` can be constrained to the approved archive Storage resource rather than arbitrary Storage destinations.

## Decision rule

```text
approved subnet identity + service restriction
 -> Service Endpoint

private IP representing the target service
 -> Private Endpoint
```
