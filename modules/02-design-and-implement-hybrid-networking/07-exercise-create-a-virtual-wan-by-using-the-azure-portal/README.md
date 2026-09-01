# Unit 07 — Exercise: Create a Virtual WAN by using the Azure portal

**BlueHarbor chapter:** Add the approved Virtual WAN evolution to the same estate  
**Status:** NOT STARTED

Preserve Microsoft's Virtual WAN exercise objective, but persistent BlueHarbor infrastructure is implemented through the cumulative Terraform stack.

## Rule

Do not destroy/recreate the Module 1 estate or the classic Module 2 VPN edge merely to obtain a clean Virtual WAN exercise.

Before connecting an existing workload VNet to the Virtual Hub, verify current Azure gateway/remote-gateway constraints and document the intentional Terraform change required.

The exercise must end with one coherent state lineage and a clear explanation of which connectivity model currently owns which workload/site paths.
