# Unit 02 — Explain virtual network service endpoints

**BlueHarbor chapter:** Restrict Manufacturing access to Azure Storage  
**Status:** NOT STARTED

## Business event

The existing Manufacturing application subnet must write production archives to Azure Storage, but Security wants access restricted to approved BlueHarbor network sources.

## Mental model

```text
existing Manufacturing subnet
        |
service endpoint
        |
        v
supported Azure service
```

A service endpoint does not create a private endpoint NIC or assign the service a private IP inside the subnet. It enables supported Azure services to recognise/trust the approved VNet/subnet path so service-side network restrictions can be applied.

## Design question

```text
"Only approved subnet identity may access the service"
        -> consider service endpoint

"The service must be represented by a private IP in our network"
        -> consider Private Endpoint
```

## Study-guide depth

Cover service endpoint policies inside this unit where required. Do not create a separate curriculum branch.

## Terraform rule

When implemented in Unit 05, extend the existing Manufacturing subnet definition in the cumulative Terraform stack rather than building another VNet.
