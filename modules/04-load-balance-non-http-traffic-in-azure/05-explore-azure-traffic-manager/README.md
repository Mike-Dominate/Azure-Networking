# Unit 05 — Explore Azure Traffic Manager

**BlueHarbor chapter:** The complete Australia East service now needs regional recovery  
**Status:** NOT STARTED

## New requirement

BlueHarbor now asks what happens if the whole Australia East telemetry service becomes unavailable.

Build the second regional service deliberately in the existing Southeast Asia VNet:

```text
bhi-vnet-research-sea   10.30.0.0/16
  |
  +-- snet-telemetry-dr   10.30.3.0/24
       +-- vm-telemetry-sea-01
       +-- vm-telemetry-sea-02
       +-- public Standard Load Balancer service on TCP/9000
```

No regional endpoint may appear without being created in the story/Terraform first.

## Traffic Manager mental model

```text
DNS query
 -> Traffic Manager policy + health
 -> selected endpoint answer

application traffic
 -> selected endpoint directly
```

Teach all Microsoft routing methods. BlueHarbor chooses **Priority**:

```text
Priority 1 = Australia East
Priority 2 = Southeast Asia
```

A Southeast Asia endpoint can be healthy and enabled but remain unselected while Australia East is healthy.
