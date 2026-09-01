# Unit 03 — Design and implement Azure load balancer using the Azure portal

**BlueHarbor chapter:** Design the resilient regional telemetry service  
**Status:** REVIEW PENDING

## Business event

BlueHarbor approves a multi-backend service in Australia East.

## Architecture

```text
Clients
  |
Azure Load Balancer frontend
  |
backend pool
 /   |   \
VM1 VM2 VM3
```

## Design decisions

- Standard Load Balancer
- public versus internal frontend
- frontend IP
- backend pool membership
- load-balancing rule
- health-probe design
- outbound-connectivity behaviour
- NSG interaction

The first design question is who should be able to reach the frontend, not merely whether the Portal offers a public or internal option.
