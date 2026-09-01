# Unit 03 — Deploy Azure DDoS Protection by using the Azure portal

**BlueHarbor chapter:** Protect public network availability  
**Status:** NOT STARTED

## Business event

The BlueHarbor Partner Hub and public IP services create an Internet attack surface. Security now considers network-layer denial-of-service resilience.

## Layer distinction

```text
DDoS Protection
= network/infrastructure availability protection

WAF
= HTTP(S) application-request protection
```

## Concepts to master

- DDoS attack/mitigation purpose
- protected public-service context
- VNet/public IP relationship at the level required by the current Azure service model
- monitoring/telemetry expectations
- what DDoS Protection does not replace

## Cost rule

Verify current pricing and deployment behaviour before the practical. Do not leave a billable protection configuration running only to preserve lab state.
