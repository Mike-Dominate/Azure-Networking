# Unit 10 — Troubleshoot ExpressRoute connection issues

**BlueHarbor chapter:** Diagnose the production enterprise path systematically  
**Status:** NOT STARTED

## Troubleshooting chain

```text
application / destination
 -> Azure workload route
 -> Virtual Hub VNet connection / hub routing
 -> Virtual WAN ExpressRoute Gateway
 -> BGP learned route
 -> ExpressRoute private peering
 -> circuit state
 -> provider path
 -> BlueHarbor edge
```

Compare the existing VPN path when investigating route preference, failover, asymmetry or unexpected path selection.

## Failure candidates

- BGP session down;
- incorrect ASN/peering addressing;
- expected prefix not advertised;
- route filtering/propagation issue;
- provider provisioning problem;
- circuit/gateway connection issue;
- hub routing preference issue;
- asymmetric routing;
- provider/circuit failure.

Troubleshoot evidence-first rather than restarting components randomly.
