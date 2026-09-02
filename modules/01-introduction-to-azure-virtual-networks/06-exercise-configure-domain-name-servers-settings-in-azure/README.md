# Unit 06 — Exercise: Configure domain name servers settings in Azure

**BlueHarbor chapter:** Build the internal directory  
**Status:** NOT STARTED

BlueHarbor implements internal/private name resolution using the existing Terraform-managed VNets.

## Canonical private namespace

```text
blueharbor.internal
```

This is the parent Azure Private DNS zone for BlueHarbor-owned internal names throughout the programme.

Later records such as:

```text
telemetry.services.blueharbor.internal
```

remain records beneath this zone rather than forcing a second arbitrary private DNS namespace.

Microsoft service-owned Private Link zones introduced later remain separate.

## Practical requirements

- extend the same `blueharbor/terraform/` root;
- create `blueharbor.internal` and the required VNet links;
- validate DNS with real queries;
- deliberately break at least one DNS path and recover it;
- finish with Terraform and Azure agreeing.

## Carry-forward

Do not prematurely build a separate hybrid DNS solution. Module 2 adds DNS Private Resolver/forwarding only when Brisbane/Perth require hybrid name resolution.
