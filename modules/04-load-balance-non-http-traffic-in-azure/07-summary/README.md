# Unit 07 — Summary

**BlueHarbor chapter:** Two layers of non-HTTP service availability  
**Status:** NOT STARTED

## Final mental model

```text
GLOBAL
client DNS
 -> Traffic Manager Priority/health decision
 -> regional endpoint answer

REGIONAL
client TCP/9000
 -> Standard Public Load Balancer
 -> healthy telemetry backend
```

Azure Load Balancer handles backend/instance availability inside a region.

Traffic Manager handles DNS-based selection between regional service endpoints.

## Cumulative dependencies

Module 4 reuses:

- `bhi-vnet-mfg-aue` and `snet-mfg-app`;
- the Module 1 NAT-managed outbound path for AUE telemetry backends;
- `bhi-vnet-research-sea` for the SEA DR subnet;
- Module 1 DNS concepts;
- all Module 2/3 hybrid and ExpressRoute architecture unchanged.

## Handoff to Module 5

The telemetry service remains non-HTTP(S). The next module introduces a distinct Partner Hub web application requiring HTTP(S)-aware delivery, TLS, host/path routing and global web-edge capabilities.
