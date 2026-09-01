# Unit 04 — Exercise: Design and implement a virtual network in Azure

**BlueHarbor chapter:** Build the approved network foundation  
**Status:** NOT STARTED

Complete Microsoft's VNet exercise objective using the BlueHarbor architecture approved in Units 01–03.

## Persistent implementation rule

Create the canonical BlueHarbor VNets/subnets through:

```text
blueharbor/terraform/
```

This is not a disposable Terraform rebuild after a manual lab. It is the first major persistent infrastructure checkpoint in the cumulative project.

After `terraform apply`, independently inspect the Azure objects with Azure CLI/Portal and prove that names, regions, address spaces and subnets match the approved contract.

Later units modify this same code/state rather than copy it into new lab folders.
