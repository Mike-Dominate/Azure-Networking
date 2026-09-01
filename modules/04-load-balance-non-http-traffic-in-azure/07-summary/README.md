# Unit 07 — Summary

**BlueHarbor chapter:** Service-availability architecture review  
**Status:** REVIEW PENDING

## Final architecture

```text
Client
  |
DNS query
  v
Traffic Manager
  |
regional endpoint selection
  |
+-----------+-----------+
|           |           |
Region A    Region B    Region C
|           |           |
LB          LB          LB
|           |           |
VMs         VMs         VMs
```

## Explain-back requirements

Be able to explain:

- connectivity versus application availability;
- frontend, backend pool, rule and health probe;
- internal versus public Load Balancer;
- what happens when one backend fails;
- why Traffic Manager is not an application proxy;
- health versus routing-policy eligibility;
- DNS TTL and failover timing;
- regional Layer 4 distribution versus global DNS-based endpoint selection;
- when Azure Load Balancer and Traffic Manager can solve different layers of the same availability problem.

Module 5 begins when BlueHarbor needs HTTP/HTTPS-specific routing, TLS-aware delivery and web application protection capabilities.
