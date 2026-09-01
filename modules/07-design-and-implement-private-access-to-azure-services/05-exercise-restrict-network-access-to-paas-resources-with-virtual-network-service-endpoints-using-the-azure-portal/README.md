# Unit 05 — Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal

**BlueHarbor chapter:** Apply the Manufacturing Storage restriction  
**Status:** NOT STARTED

Preserve the Microsoft exercise objective, but apply it to the existing Manufacturing data subnet.

## Terraform delta

```text
existing snet-mfg-data 10.20.2.0/24
  + Microsoft.Storage service endpoint

new Storage archive account
  + service-side network/VNet rule
  + approved snet-mfg-data access
  + service endpoint policy to approved Storage resource where supported
```

No replacement Manufacturing VNet is created.

## Plan guardrail

```text
previous BlueHarbor estate preserved
new Storage/private-access resources added
unexpected destroy/replace -> STOP
```

## Validation

```text
approved Manufacturing data workload -> Storage   ALLOW
unapproved source                     -> Storage   DENY
```

Deliberately misconfigure one subnet/service rule, prove the failure, then encode the permanent correction in Terraform.
