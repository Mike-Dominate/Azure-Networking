# Unit 01 — Introduction

**Microsoft Learn Module 2:** Design and implement hybrid networking  
**BlueHarbor chapter:** Azure is an island  
**Status:** NOT STARTED

## Business event

BlueHarbor's Module 1 Azure VNets work, but Brisbane HQ, Perth Manufacturing and remote engineers have no private path into Azure.

## Problem to solve

Determine which connectivity model fits three different requirements:

- network-to-network connectivity for an office/factory;
- individual-device connectivity for remote staff;
- scalable connectivity when BlueHarbor grows to many sites.

## Mental model

```text
BlueHarbor sites/users
        X
     no path
        X
BlueHarbor Azure VNets
```

This unit establishes the hybrid requirements before any gateway is deployed. See `../PROJECT-STORY.md` for the full progressive scenario.
