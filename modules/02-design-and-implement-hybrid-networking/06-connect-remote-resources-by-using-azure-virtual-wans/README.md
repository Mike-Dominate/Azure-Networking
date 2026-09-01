# Unit 06 — Connect remote resources by using Azure Virtual WANs

**BlueHarbor chapter:** The company outgrows a few individual tunnels  
**Status:** NOT STARTED

## Business event

BlueHarbor adds more branches, factories, remote users and Azure regions. Managing every connectivity relationship independently is becoming operationally complex.

## Problem to solve

Create a scalable WAN model for branches, users and Azure networks.

## Architecture evolution

```text
Few sites:
site -> VPN relationship -> Azure

Growth:
many sites/users -> Virtual WAN hub -> Azure networks
```

## Concepts to master

- Azure Virtual WAN
- Virtual Hub
- sites
- hub VNet connections
- hub routing
- branch connectivity
- S2S and P2S integration
- transitive connectivity concepts

Virtual WAN is introduced because BlueHarbor has reached a scale where a central connectivity model has a clear operational purpose.
