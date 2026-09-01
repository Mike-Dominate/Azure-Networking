# Unit 09 — Exercise: Secure your Virtual Hub using Azure Firewall Manager

**BlueHarbor chapter:** Turn the existing Virtual WAN hub into a security boundary  
**Status:** NOT STARTED

## Progressive-story link

Module 2 introduced Virtual WAN to solve scalable connectivity. Module 6 returns to the same hub because BlueHarbor now requires central security enforcement.

## Architecture

```text
branches / sites / remote users
        |
        v
Virtual WAN Hub
        |
secured-hub design
        |
Azure Firewall
        |
central policy
        |
Core / Manufacturing / Research
```

## Concepts to master

- secured virtual hub
- Azure Firewall in Virtual WAN
- Firewall Manager policy
- route/traffic-path reasoning
- central inspection versus distributed NSG segmentation

## Critical lesson

The secured hub only enforces policy for traffic that the topology actually sends through the intended firewall path.
