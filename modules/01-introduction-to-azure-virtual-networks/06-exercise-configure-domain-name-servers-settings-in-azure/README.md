# Unit 06 — Exercise: Configure domain name servers settings in Azure

**BlueHarbor chapter:** Build the internal directory  
**Status:** NOT STARTED

BlueHarbor implements the internal/private name-resolution design using the existing Terraform-managed VNets.

The practical must:

- extend the same `blueharbor/terraform/` root;
- create/link the required Azure-private DNS components;
- validate DNS using real queries;
- deliberately break at least one DNS path and recover it;
- finish with Terraform and Azure agreeing.

## Carry-forward

The resulting private DNS architecture remains deployed into Module 2.

Do not prematurely create a separate hybrid DNS solution here merely because DNS Private Resolver exists. When Brisbane/Perth need hybrid name resolution in Module 2, extend this design with the required resolver/forwarding path.
