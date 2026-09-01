# Unit 04 — Exercise: Create and configure an Azure load balancer

**BlueHarbor chapter:** Prove one backend failure does not equal service failure  
**Status:** NOT STARTED

Preserve the Microsoft exercise objective, but implement BlueHarbor's persistent service through the existing `blueharbor/terraform/` stack.

Expected Terraform delta:

```text
existing snet-mfg-app
+ telemetry backend compute/NICs
+ minimal functional NSG
+ Standard public IP
+ Standard public Load Balancer
+ TCP/9000 backend pool/rule/probe
```

Do not build a fresh VNet or a separate Terraform root.

## Deliberate failure

```text
backend 01  UNHEALTHY
backend 02  HEALTHY
```

Validate that new service traffic continues through the healthy backend. Confirm backend-health evidence independently rather than accepting `terraform apply` as proof.
