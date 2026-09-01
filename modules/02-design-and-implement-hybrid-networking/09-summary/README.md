# Unit 09 — Summary

**BlueHarbor chapter:** Hybrid-network architecture review  
**Status:** NOT STARTED

## Architecture-board challenge

Explain the complete hybrid path without relying on the Portal.

### Scenario 1 — Site-to-Site

```text
Brisbane server
 -> on-prem VPN device
 -> IPsec/IKE tunnel
 -> Azure VPN Gateway
 -> Azure route
 -> private workload
```

Explain what the Local Network Gateway represents, where encryption begins/ends and why this is network-to-network connectivity.

### Scenario 2 — Point-to-Site

```text
Remote laptop
 -> authentication
 -> client VPN tunnel
 -> client VPN address
 -> Azure route
 -> permitted private workload
```

Explain authentication, client addressing, route/DNS behaviour and why only one device is connected.

### Scenario 3 — Scale

Explain why BlueHarbor might move from individually managed branch/user connectivity to Virtual WAN, and where an NVA/SD-WAN integration can fit.

## Module 2 exit condition

The learner can design, trace and troubleshoot the gateway, tunnel, route and endpoint involved in each hybrid scenario.

The next story question is whether mission-critical BlueHarbor connectivity requires a private enterprise circuit rather than Internet-based VPN as the primary path. That begins Module 3 — ExpressRoute.
