# Unit 05 — Exercise: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal

**BlueHarbor chapter:** Apply the Manufacturing Storage restriction  
**Status:** NOT STARTED

Preserve Microsoft's exercise objective but apply it to the existing Manufacturing data subnet.

## Terraform delta

```text
existing snet-mfg-data 10.20.2.0/24
  + Microsoft.Storage service endpoint

new Manufacturing archive Storage account
  + valid globally unique name: stbhimfgarchive<global_suffix>
  + service-side network/VNet restriction
  + approved snet-mfg-data access
  + service endpoint policy where supported
```

No replacement Manufacturing VNet is created.

## Route expectation

The Storage service endpoint creates an intentional direct service route for the approved Storage path. This flow is not expected to traverse the central Azure Firewall egress path.

Do not troubleshoot the absence of a Firewall hop as though it were a routing failure.

## Validation

```text
approved Manufacturing data workload -> approved Storage  ALLOW
unapproved source                     -> Storage           DENY
```

Also verify the route/effective path so the learner can explain **why** the Storage traffic bypasses the generic firewall egress path.

Deliberately misconfigure one subnet/service rule, prove the failure, then encode the permanent correction in Terraform.
