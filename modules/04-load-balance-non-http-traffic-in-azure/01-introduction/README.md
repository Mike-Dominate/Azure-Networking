# Unit 01 — Introduction

**Microsoft Learn Module 4:** Load balance non-HTTP(S) traffic in Azure  
**BlueHarbor chapter:** The network is up, but the application is down  
**Status:** REVIEW PENDING

## Business event

A BlueHarbor telemetry backend fails while VPN/ExpressRoute, VNets, routes and DNS remain healthy.

## Core lesson

```text
Network reachability != application availability
```

## Problem to solve

Remove the single-backend failure dependency and build a service that can continue when an individual backend becomes unhealthy.

This unit establishes the availability problem before introducing a load-balancing service.
