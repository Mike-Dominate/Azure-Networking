# Unit 05 — Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal

**BlueHarbor chapter:** Apply the Manufacturing Storage restriction  
**Status:** NOT STARTED

## Microsoft objective, BlueHarbor implementation

Preserve the Microsoft exercise objective but implement the persistent BlueHarbor change through the existing Terraform root.

Expected incremental change:

```text
existing Manufacturing subnet
        +
Azure Storage
        +
service endpoint configuration
        +
service-side network restriction
        +
service endpoint policy where justified
```

Do **not** create a replacement Manufacturing VNet.

## Plan expectation

```text
previous BlueHarbor infrastructure: preserved
new PaaS/service-endpoint resources: added
unexpected destroy/replace: STOP AND INVESTIGATE
```

## Validation

Prove both outcomes:

```text
approved Manufacturing source -> Storage   ALLOW
unapproved source              -> Storage   DENY
```

A successful `terraform apply` is not sufficient evidence.

## Deliberate failure

Misconfigure the approved subnet or service-side network rule, diagnose the mismatch, then encode the permanent correction in Terraform before completing the unit.
