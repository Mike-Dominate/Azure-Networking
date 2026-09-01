# Module 4 — Load balance non-HTTP(S) traffic in Azure

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/load-balancing-non-https-traffic-azure/  
**BlueHarbor project:** Make Device Telemetry Ingest resilient regionally and globally  
**Status:** NOT STARTED

Module 4 starts from the exact Module 1–3 Terraform code, state and deployed Azure estate. It does **not** start a new Load Balancer lab environment.

## New business workload

BlueHarbor Manufacturing introduces its first explicit production non-HTTP service:

```text
BlueHarbor Device Telemetry Ingest
Protocol: TCP
Service port: 9000
```

Field/customer equipment sends telemetry to BlueHarbor over the Internet. The first pilot uses a single backend and exposes a new problem:

> The network path is healthy, but one application backend fails and the service becomes unavailable.

## Progressive architecture

```text
existing Module 1–3 network
        -> add AUE telemetry backends to existing snet-mfg-app
        -> add Public Standard Load Balancer on TCP/9000
        -> prove one backend failure does not equal service failure
        -> add a Southeast Asia DR instance in existing bhi-vnet-research-sea
        -> add second Public Standard Load Balancer
        -> add Traffic Manager only after both regional endpoints exist
        -> use Priority routing: AUE primary, SEA recovery
        -> prove regional service failure causes DNS steering to SEA
```

## Australia East placement

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
       |
       +-- telemetry-aue backends
       |
       +-- existing Module 1 NAT outbound path
```

Module 4 adds the telemetry compute/NICs, a minimal functional NSG, Standard public IP and Standard public Load Balancer. The existing NAT association is reused for backend-initiated outbound connectivity.

## Southeast Asia DR placement

Reuse the existing Research VNet and add one new subnet:

```text
bhi-vnet-research-sea   10.30.0.0/16
  |
  +-- snet-telemetry-dr  10.30.3.0/24
```

This is an additive subnet change inside the existing VNet; no new regional VNet is created.

## Global availability

Traffic Manager endpoints map to the **real regional public-IP / Load Balancer services** created earlier in the module:

```text
Traffic Manager
Priority 1 -> Australia East public telemetry endpoint
Priority 2 -> Southeast Asia public telemetry endpoint
Monitoring -> TCP/9000
```

Traffic Manager is DNS based and is not in the application data path after the client receives the selected endpoint.

## Microsoft Learn units

1. Introduction
2. Explore load balancing
3. Design and implement Azure load balancer using the Azure portal
4. Exercise: Create and configure an Azure load balancer
5. Explore Azure Traffic Manager
6. Exercise: Create a Traffic Manager profile using the Azure portal
7. Summary

Persistent infrastructure is implemented through the same `blueharbor/terraform/` root. CLI/Portal/protocol tools independently validate and troubleshoot it.
