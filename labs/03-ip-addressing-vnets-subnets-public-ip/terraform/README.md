# Lab 03 Terraform Rebuild

This directory rebuilds the validated manual Lab 03 architecture with Terraform.

## What Terraform manages

```text
1   Resource Group
1   Virtual Network
8   Subnets
2   Network Interfaces
3   Public IP Addresses
1   Public IP Prefix
-----------------------
16  Terraform resources
```

The temporary invalid resources used during manual failure testing are intentionally **not** represented in Terraform. The IaC configuration models the desired valid end-state.

## Files

```text
versions.tf              Terraform and AzureRM version requirements
providers.tf             AzureRM provider configuration
variables.tf             reusable inputs and defaults
main.tf                  complete Azure architecture
outputs.tf               useful post-apply inspection values
terraform.tfvars.example optional variable override example
```

The HCL is deliberately heavily commented. Read `main.tf` later as a study guide mapping Terraform constructs back to the manual Azure networking exercises.

## Authentication

The provider contains no credentials. Use the existing Azure CLI login:

```powershell
az account show --query "{Subscription:name,SubscriptionId:id,TenantId:tenantId,IsDefault:isDefault}" -o table
```

Confirm the intended subscription is selected before applying.

## Standard workflow

Run from this directory:

```powershell
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=lab03.tfplan
terraform apply lab03.tfplan
```

Then validate with both Terraform and Azure CLI rather than trusting the apply message alone.

Useful Terraform checks:

```powershell
terraform state list
terraform output
terraform plan
```

A final `terraform plan` after successful deployment should report **No changes**.

## Independent Azure validation

Resource inventory:

```powershell
az resource list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,Type:type,Location:location}" `
  -o table
```

Subnets and delegation:

```powershell
az network vnet subnet list `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --query "[].{Name:name,Prefix:addressPrefix,Delegation:delegations[0].serviceName,State:provisioningState}" `
  -o table
```

NIC private IPs:

```powershell
az network nic list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,PrivateIP:ipConfigurations[0].privateIPAddress,Allocation:ipConfigurations[0].privateIPAllocationMethod}" `
  -o table
```

Public IP properties should be checked with JSON when inspecting zones because table output may omit array values:

```powershell
az network public-ip list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,IP:ipAddress,SKU:sku.name,Tier:sku.tier,Allocation:publicIPAllocationMethod,Zones:zones,Prefix:publicIPPrefix.id}" `
  -o json
```

## Important architecture notes

### Dynamic private IP

`nic-lab03-web-dynamic` uses `private_ip_address_allocation = "Dynamic"`. We do not hard-code `10.30.10.4` in Terraform because the architectural intent is dynamic allocation. Azure chooses an available address from `snet-web`.

### Static private IP

`nic-lab03-app-static` explicitly requests `10.30.20.10`, reproducing the manual static allocation exercise.

### Public IP lifecycle

`pip-lab03-web-aue` deliberately remains **unattached**. During the manual build we attached it to the dynamic NIC and detached it again to demonstrate that a Public IP is an independent resource. Terraform represents the final desired state, not every temporary learning action.

### Zones and provider/API behaviour

The zone-redundant Public IP, Public IP Prefix, and prefix-backed Public IP explicitly request zones `1`, `2`, and `3`.

The first regional Public IP deliberately has no `zones` argument. After apply, inspect Azure's actual `zones` property. Defaults can evolve across Azure CLI/provider/API versions, so validation is more reliable than assuming an undocumented or changing default.

## Destroy workflow

Do not destroy until Terraform evidence, documentation, outputs, and any required visual/PDF material have been captured.

When ready:

```powershell
terraform destroy
```

Then independently verify both Azure and Terraform are empty:

```powershell
az group exists --name rg-az700-ip-aue
terraform state list
```

Required final result:

```text
Azure resource group exists: false
Terraform state list:          empty
```
