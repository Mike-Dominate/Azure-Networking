# Unit 03 — Deploy Azure DDoS Protection by using the Azure portal

**BlueHarbor chapter:** Protect the public-IP attack surface that actually exists  
**Status:** NOT STARTED

Create one BlueHarbor DDoS Network Protection plan and associate it with eligible VNets containing public-IP-backed services.

Primary candidates already exist:

```text
bhi-vnet-mfg-aue        -> public telemetry Load Balancer
bhi-vnet-research-sea   -> public telemetry Load Balancer
bhi-vnet-partner-aue    -> public Application Gateway
bhi-vnet-partner-sea    -> public Application Gateway
```

Evaluate the classic connectivity VNet/public gateway against the current DDoS service eligibility when the unit is implemented; do not assume unsupported coverage.

Azure Front Door is not attached to this VNet plan. Treat Front Door's platform DDoS model separately while protecting eligible origin VNets.

Do not attach the VNet DDoS plan to Virtual WAN secured hubs.

```text
DDoS Protection = network/infrastructure availability
WAF             = HTTP(S) application-request protection
```

The plan is part of the cumulative Terraform state; no routine teardown follows.
