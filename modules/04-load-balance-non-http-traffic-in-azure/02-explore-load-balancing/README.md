# Unit 02 — Explore load balancing

**BlueHarbor chapter:** Multiple telemetry receivers need one service identity  
**Status:** NOT STARTED

The telemetry pilot evolves to multiple TCP/9000 backends.

Mental model:

```text
client
  |
service frontend
  |
  +-- healthy backend
  +-- healthy backend
```

Learn frontend IP, backend pool, health probe, rule and Layer 4 flow selection.

Keep the distinction explicit:

```text
Azure Load Balancer = Layer 4 flow distribution
not HTTP host/path-aware routing
```
