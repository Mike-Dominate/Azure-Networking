# Lab 02 — Terraform Rebuild

> **Terraform phase: COMPLETE**

## Purpose

Rebuild the manually understood Azure Traffic Manager architecture as Infrastructure as Code, then validate the live Azure service independently rather than treating `terraform apply` as proof of networking success.

## Architecture

```text
Azure Traffic Manager — Geographic
        |
+-------+-------+
|       |       |
GEO-NA  GEO-EU  GEO-AS + GEO-AP
|       |       |
ep-eus  ep-weu  ep-sea
|       |       |
ACI     ACI     ACI
East US West EU Southeast Asia
```

Traffic Manager performs DNS steering. After DNS resolution the client connects directly to the selected regional ACI endpoint.

## File structure

```text
terraform/
├── README.md
├── .terraform.lock.hcl
├── versions.tf
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── terraform.tfvars.example
```

## Provider baseline

```text
Terraform: >= 1.6.0
AzureRM constraint: ~> 4.0
Locked AzureRM version: 4.81.0
```

This deliberately matches Lab 01.

## Terraform design

`local.endpoints` describes East US, West Europe and Southeast Asia once. `for_each` creates repeated ACI and Traffic Manager External-endpoint instances with stable keys:

```text
regional["eus"]
regional["weu"]
regional["sea"]
```

Traffic Manager uses each ACI FQDN:

```hcl
target = azurerm_container_group.regional[each.key].fqdn
```

That reference selects the matching regional endpoint and creates an implicit dependency.

## Managed resource graph

```text
1 azurerm_resource_group
3 azurerm_container_group instances
1 azurerm_traffic_manager_profile
3 azurerm_traffic_manager_external_endpoint instances
= 8 resources
```

## Execution results

```text
terraform init       -> AzureRM 4.81.0 reused from lock file
terraform validate   -> Success
terraform plan       -> 8 to add, 0 change, 0 destroy
terraform apply      -> 8 added
terraform state list -> 8 resources
```

Outputs included:

```text
Traffic Manager: az700-tm-md-87004.trafficmanager.net
East US ACI:     az700-tm-eus-87004.eastus.azurecontainer.io
West Europe ACI: az700-tm-weu-87004.westeurope.azurecontainer.io
Southeast Asia:  az700-tm-sea-87004.southeastasia.azurecontainer.io
```

## Saved-plan PowerShell note

In the learner's environment this form failed with `Too many command line arguments`:

```powershell
terraform plan -out=lab02.tfplan
```

The working form was:

```powershell
terraform plan -out lab02.tfplan
terraform apply lab02.tfplan
```

## Independent validation

A successful apply was followed by real service tests:

```text
Azure CLI inventory -> all three regional ACI resources matched
Australian DNS      -> selected Southeast Asia via GEO-AP
HTTP through TM     -> ACI welcome page returned
```

`nslookup` plus `curl` mattered because all three containers served the same page; HTTP alone could not identify which geography DNS selected.

## Failure/recovery validation

The Terraform-created Southeast Asia ACI was stopped outside Terraform.

Observed:

```text
HTTP through Traffic Manager   -> failed
Traffic Manager ep-sea         -> initially Online, later Degraded
Endpoint administrative state  -> Enabled
Fresh Google DNS               -> still SEA for GEO-AP
```

After restarting the ACI, HTTP recovered.

The public IP happened to remain `40.90.191.16` in this Terraform test. The earlier manual stop/start had changed the Southeast Asia public IP. Therefore neither persistence nor change should be assumed; Traffic Manager correctly targets the ACI FQDN.

## Convergence

After recovery:

```powershell
terraform plan
```

returned:

```text
No changes. Your infrastructure matches the configuration.
```

This proves the desired configuration, Terraform state and live Azure resource configuration converged again.

## Git checkpoint

Terraform source and the provider lock file were committed and pushed as:

```text
7891fe65064620480e2e1125f062f6138b08d3f5
Complete Lab 02 Terraform Traffic Manager rebuild
```

State, `.terraform/`, local `.tfvars` and saved plan files remain ignored.

## Final cleanup

The final Terraform-managed environment was destroyed successfully:

```text
Destroy complete! Resources: 8 destroyed.
```

On every future repeat, independently verify the clean state after destroy:

```powershell
az group exists --name rg-az700-tm-global
terraform state list
```

Expected results are `false` for the resource group and no resource addresses from `terraform state list`.

The final chat did not separately capture those two outputs after the Terraform destroy, so they are not claimed as observed final evidence here.