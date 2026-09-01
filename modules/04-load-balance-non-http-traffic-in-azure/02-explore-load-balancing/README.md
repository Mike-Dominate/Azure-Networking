# Unit 02 — Explore load balancing

**BlueHarbor chapter:** Give multiple servers one service front door  
**Status:** REVIEW PENDING

## Business event

BlueHarbor adds multiple telemetry backends, but clients should not need to track which server is currently healthy.

## Mental model

```text
Clients
  |
frontend service address
  |
Load Balancer
 /   |   \
VM1 VM2 VM3
```

## Concepts to master

- frontend IP
- backend pool
- health probe
- load-balancing rule
- regional Layer 4 TCP/UDP distribution
- public versus internal frontend design
- health versus reachability

A Load Balancer does not repair an unhealthy server; it changes backend selection according to health and configuration.
