# Unit 07 — Summary

**BlueHarbor chapter:** Private-access architecture review  
**Status:** NOT STARTED

## Final mental model

```text
Service Endpoint
-> approved VNet/subnet identity can access a supported Azure service

Private Endpoint
-> a supported service is represented by a private IP in a VNet

Private Link
-> private-connectivity technology used by private endpoints

Private Link Service
-> publish an eligible BlueHarbor-owned service privately

App Service VNet Integration
-> supported App Service outbound connectivity into a VNet path
```

## Cumulative architecture

By this point the private-access design must use infrastructure created earlier:

```text
existing DNS
existing VNets/subnets
existing hybrid connectivity
existing Module 4 Load Balancer
existing Partner Hub
existing security controls
        |
        + service endpoints
        + private endpoints
        + private DNS integration
        + VNet integration
        + Private Link Service where appropriate
```

All remain in the same `blueharbor/terraform/` state lineage.

## Explain-back requirements

Be able to explain:

- service endpoint versus private endpoint;
- Private Link versus Private Link Service;
- why DNS is a dependency of private endpoint designs;
- how hybrid/on-premises clients reach and resolve private endpoints;
- why private endpoint does not automatically mean all public access is disabled;
- App Service VNet Integration versus Private Endpoint;
- how the existing Load Balancer can participate in Private Link Service;
- how to isolate DNS, routing, endpoint and service-policy failures.

## Handoff

Operations now has to observe a very large cumulative environment. Module 8 adds monitoring to **this exact estate** rather than creating a toy monitoring environment.
