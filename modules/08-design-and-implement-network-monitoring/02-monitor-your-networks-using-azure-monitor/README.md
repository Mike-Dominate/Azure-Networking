# Unit 02 — Monitor your networks using Azure Monitor

**BlueHarbor chapter:** Establish the central telemetry, flow and alerting platform  
**Status:** NOT STARTED

## Central workspace

Create:

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
```

Use one central Log Analytics workspace for appropriate diagnostic logs from both Australia East and Southeast Asia so a single investigation can correlate the full network/application path.

## VNet flow-log destinations

Use region-local Storage:

```text
AUE  st-bhi-flow-aue-<unique>
SEA  st-bhi-flow-sea-<unique>
```

Target all BlueHarbor VNets:

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

Enable VNet flow logs and Traffic Analytics to `law-bhi-netops-aue`.

Do not create new NSG flow logs.

## Traffic Analytics ownership guardrail

Terraform manages the BlueHarbor configuration that enables Traffic Analytics, but it does not attempt to manage Azure's service-created internal `NWTA*` DCR/DCE implementation objects.

## Diagnostic settings

Send current supported resource-specific logs to the central workspace for the Tier-1 network/application resources that produce useful diagnostics, including Azure Firewall, Application Gateway WAF, Front Door, active hybrid gateways/Virtual WAN components and ExpressRoute where live.

Re-query/revalidate supported categories at implementation time.

## Alerting

Create:

```text
ag-bhi-netops
```

Receiver details come from sensitive/ignored Terraform input.

Initial alert families should have explicit operational meaning, for example:

- Load Balancer backend/data-path health;
- Connection Monitor failure/latency/packet loss;
- key VPN/ExpressRoute/gateway health conditions;
- Azure Firewall critical health/service conditions;
- Application Gateway / Front Door origin availability;
- DDoS attack/mitigation signals;
- Resource Health for critical network resources.

Prefer a small explainable alert set to alert spam.
