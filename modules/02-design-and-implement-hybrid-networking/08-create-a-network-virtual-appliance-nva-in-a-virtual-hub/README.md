# Unit 08 — Create a network virtual appliance (NVA) in a virtual hub

**BlueHarbor chapter:** Integrate existing SD-WAN/security technology  
**Status:** NOT STARTED

## Business event

BlueHarbor already owns partner SD-WAN/security technology at some branches and wants to integrate that investment with the Azure WAN design.

## Architecture

```text
Branch
  |
existing SD-WAN / CPE
  |
Virtual WAN hub
  |
partner NVA
  |
Azure networks
```

## Concepts to master

- NVA deployment/integration in a virtual hub
- partner networking integration
- SD-WAN connectivity concepts
- traffic and route flow through the hub
- native Azure VPN versus partner-NVA trade-offs

## Practicality rule

Do not buy or deploy an unnecessary commercial appliance purely for lab completion. If cost/licensing makes deployment unreasonable, use architecture, configuration-object, route-flow and failure analysis as the practical evidence.
