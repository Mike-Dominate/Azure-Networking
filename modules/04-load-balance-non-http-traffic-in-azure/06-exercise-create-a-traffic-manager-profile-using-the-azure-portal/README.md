# Unit 06 — Exercise: Create a Traffic Manager profile using the Azure portal

**BlueHarbor chapter:** Prove regional DNS failover  
**Status:** NOT STARTED

Preserve the Microsoft exercise objective, but add Traffic Manager to the existing cumulative Terraform state only after both regional telemetry services exist.

Approved BlueHarbor profile:

```text
tm-telemetry-global
  |
  +-- Priority 1 -> Australia East public telemetry endpoint
  +-- Priority 2 -> Southeast Asia public telemetry endpoint

monitor: TCP/9000
```

The regional public-IP endpoints use valid unique DNS labels as required; Terraform parameterizes/generates the final globally unique labels.

## Two failure levels

```text
one AUE backend fails
 -> AUE Load Balancer keeps regional service alive
 -> Traffic Manager should still see AUE service healthy

entire AUE regional service fails
 -> Traffic Manager marks AUE endpoint unhealthy according to monitoring
 -> DNS selection moves to SEA according to Priority policy
```

Observe DNS TTL/resolver/client caching rather than expecting instantaneous client failover.
