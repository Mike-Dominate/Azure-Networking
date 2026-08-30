# Lab 02 — Terraform Rebuild

## Purpose

Rebuild the understood Azure Traffic Manager architecture as Infrastructure as Code after completing the manual Azure CLI deployment first.

The manual phase established the networking behaviour before automation: Traffic Manager performs DNS steering, endpoint health is monitored separately, and the client connects directly to the selected regional endpoint.

## Architecture

```text
Azure Traffic Manager
  tm-az700-global
        |
        | Geographic routing
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

Traffic Manager is not an inline HTTP proxy. After DNS resolution, the client connects directly to the selected regional ACI endpoint.

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

Lab 02 deliberately uses the same Terraform provider baseline as Lab 01:

```text
Terraform: >= 1.6.0
AzureRM constraint: ~> 4.0
Locked AzureRM version: 4.81.0
```

The lock file is committed so later rebuilds use the same provider build unless it is deliberately upgraded.

## Regional design

| Key | Azure region | Traffic Manager geography |
|---|---|---|
| `eus` | East US | `GEO-NA` |
| `weu` | West Europe | `GEO-EU` |
| `sea` | Southeast Asia | `GEO-AS`, `GEO-AP` |

`GEO-AP` is required for Australia/Pacific. During the manual lab, mapping Southeast Asia only to `GEO-AS` left the Australian DNS path without an eligible Geographic endpoint.

## Backend implementation

The original reference scenario used Azure App Service. The subscription had insufficient App Service quota, so Azure Container Instances were deliberately substituted as lightweight regional HTTP endpoints.

Each ACI uses:

```text
Image: mcr.microsoft.com/azuredocs/aci-helloworld
OS: Linux
CPU: 0.5
Memory: 0.5 GB
Port: TCP/80
```

Traffic Manager targets each ACI FQDN rather than a hard-coded public IP.

## Terraform design

The three regional endpoints are described once in `local.endpoints` and reused with `for_each`.

Example Terraform resource addresses:

```text
azurerm_container_group.regional["eus"]
azurerm_container_group.regional["weu"]
azurerm_container_group.regional["sea"]
```

Traffic Manager endpoints reference both the profile and the matching ACI FQDN. Terraform therefore derives the dependency graph automatically from references rather than file order.

## Standard workflow

```powershell
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

A saved execution plan can be used when the exact reviewed plan should be applied:

```powershell
terraform plan -out lab02.tfplan
terraform apply lab02.tfplan
```

The repository `.gitignore` excludes `*.tfplan`, `.terraform/`, and Terraform state files.

## Validation principle

A successful `terraform apply` is not sufficient. Lab 02 must also be validated independently using Azure CLI and real network tests:

- verify the regional ACI resources in Azure
- resolve the Traffic Manager FQDN
- confirm Geographic routing returns the expected endpoint
- perform an HTTP request through the Traffic Manager DNS name
- simulate a regional endpoint failure
- observe Traffic Manager health state
- test DNS behaviour while the endpoint is degraded
- recover the endpoint
- run a final Terraform convergence plan

## Verified DNS and application behaviour

From the Australian test path, DNS resolution returned the Southeast Asia endpoint:

```text
az700-tm-md-87004.trafficmanager.net
        -> az700-tm-sea-87004.southeastasia.azurecontainer.io
```

An HTTP request to the Traffic Manager FQDN successfully reached the Azure Container Instances welcome page.

This proves both parts of the design:

```text
DNS steering -> selected regional endpoint
HTTP request -> direct application reachability
```

## Failure test result

The Southeast Asia ACI was deliberately stopped outside Terraform.

Observed behaviour:

```text
Application request -> failed
Traffic Manager ep-sea -> eventually Degraded
Administrative state -> remained Enabled
Fresh Google DNS query -> still returned SEA
```

In this lab configuration, Geographic routing did not automatically cross-fail the Australian geography to Europe or North America.

This behaviour should be treated as an observed lab result rather than assuming Geographic routing behaves like Priority routing.

## Recovery

After restarting the Southeast Asia ACI, the HTTP path recovered successfully.

The ACI public IP happened to remain unchanged during the Terraform failure test. ACI public IP persistence across stop/start should not be assumed, which is why Traffic Manager targets the ACI FQDN.

## Convergence

After recovery:

```powershell
terraform plan
```

returned:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms that the Terraform configuration, Terraform state, and Azure environment had converged again.

## Cleanup

When all documentation and evidence have been completed:

```powershell
terraform destroy
```

Then independently verify Azure cleanup:

```powershell
az group exists --name rg-az700-tm-global
```

Expected result:

```text
false
```

Finally verify Terraform state contains no managed resources:

```powershell
terraform state list
```
