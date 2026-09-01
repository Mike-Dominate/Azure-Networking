# Unit 10 — Implement a Web Application Firewall

**BlueHarbor chapter:** Protect Partner Hub at the edge and regional origin boundaries  
**Status:** NOT STARTED

Module 5 created real public HTTP(S) delivery resources. Harden those exact resources.

## Approved evolution

```text
Front Door Standard
 -> Front Door Premium
 -> waf-partner-edge

appgw-partner-aue Standard_v2
 -> WAF_v2
 -> regional WAF policy

appgw-partner-sea Standard_v2
 -> WAF_v2
 -> regional WAF policy
```

Inspect Terraform plan before applying SKU/tier changes; current provider behaviour determines whether each change is in-place or requires controlled replacement/migration.

## Detection -> Prevention

Use Detection mode where useful for initial rule observation/tuning, then move the production intent to Prevention once expected traffic is understood.

## Front Door origin bypass protection

WAF does not help if arbitrary Internet clients can bypass Front Door and directly use the public Application Gateway origins.

Harden each origin using the current supported mechanisms:

1. restrict HTTPS origin traffic to the Azure Front Door backend service-tag path while preserving required Application Gateway infrastructure traffic;
2. validate BlueHarbor's unique `X-Azure-FDID` header/value at the regional origin/WAF layer.

Mental model:

```text
ALLOWED
user -> Front Door Premium/WAF -> App Gateway WAF_v2 -> Partner backend

BLOCKED
user -------------------------> App Gateway public origin directly
```

Exact service-tag, NSG and header-validation rules are verified against current Azure documentation during implementation.
