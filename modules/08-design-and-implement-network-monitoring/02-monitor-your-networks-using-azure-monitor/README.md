# Unit 02 — Monitor your networks using Azure Monitor

**BlueHarbor chapter:** Establish the central telemetry, flow and alerting platform  
**Status:** NOT STARTED

## Central workspace

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
```

Use one workspace for appropriate diagnostic logs from AUE and SEA.

## VNet flow-log Storage

Storage names must contain only lowercase letters/numbers and use the project suffix:

```text
AUE  stbhiflowaue<global_suffix>
SEA  stbhiflowsea<global_suffix>
```

Target:

```text
AUE
bhi-vnet-core-aue
bhi-vnet-mfg-aue
bhi-vnet-connectivity-aue
bhi-vnet-partner-aue

SEA
bhi-vnet-research-sea
bhi-vnet-partner-sea
```

Enable VNet flow logs and Traffic Analytics to `law-bhi-netops-aue`. Do not create new NSG flow logs.

## Ownership guardrail

Terraform manages the flow-log/Traffic Analytics configuration but not Azure's service-created `NWTA*` DCR/DCE internals.

## Diagnostics

Send current supported resource-specific logs from Tier-1 network/application resources to the central workspace. Revalidate supported diagnostic categories at implementation time.

## Alerting

Create `ag-bhi-netops`; receiver details remain ignored/sensitive Terraform input.
