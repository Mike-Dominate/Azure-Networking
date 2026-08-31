# Lab 03 Rebuild Guide — IP Addressing, VNets, Subnets & Public IP Architecture

Use this guide to rebuild Lab 03 from scratch without relying on the original mentoring session.

The lab is intentionally split into two implementations:

```text
Part A — Manual Azure CLI build
Part B — Terraform rebuild of the same validated design
```

The manual phase teaches the Azure networking behaviour. The Terraform phase proves the same design can be expressed as repeatable desired state.

---

## 1. Learning objectives

By the end of the rebuild you should be able to explain and prove:

- why RFC1918 address planning matters before connectivity is introduced
- how a VNet address space differs from a subnet
- how CIDR size affects usable Azure addresses
- why Azure reserves five IPv4 addresses in every subnet
- why workload, delegated and Azure service-specific subnets are different
- dynamic vs static private IP allocation
- why a Public IP is a separate Azure resource from a NIC private IP
- Standard Regional Public IP behaviour
- zone-redundant Public IP behaviour
- Public IP Prefix behaviour
- subnet overlap and invalid IP failure modes
- how to validate Terraform against live Azure rather than trusting only `apply`

---

## 2. Prerequisites

Use Windows PowerShell in VS Code.

Confirm Azure context:

```powershell
az account show --query "{Subscription:name,SubscriptionId:id,TenantId:tenantId,IsDefault:isDefault}" -o table
```

Expected lab context:

```text
Subscription: Azure subscription 1
Region:       australiaeast
```

Confirm tools:

```powershell
az version
terraform version
git --version
```

---

## 3. Address plan

VNet:

```text
vnet-az700-ip-aue
10.30.0.0/16
```

Subnets:

```text
10.30.10.0/26    snet-web          59 usable Azure addresses
10.30.20.0/27    snet-app          27 usable Azure addresses
10.30.30.0/27    snet-db           27 usable Azure addresses
10.30.40.0/28    snet-management   11 usable Azure addresses
10.30.50.0/27    snet-postgres     delegated
10.30.100.0/27   GatewaySubnet
10.30.101.0/26   AzureFirewallSubnet
10.30.102.0/26   AzureBastionSubnet
```

Delegation:

```text
snet-postgres
-> Microsoft.DBforPostgreSQL/flexibleServers
```

Mental model:

```text
VNet       = parent address/network boundary
Subnet     = smaller functional IP/policy/routing boundary
Private IP = identity inside the VNet
Public IP  = separate Internet-routable Azure resource
```

Azure reserves the first four and final IPv4 address of every subnet.

Example:

```text
10.30.10.0/26
.0   network address
.1   reserved by Azure
.2   reserved by Azure
.3   reserved by Azure
.63  reserved by Azure

first normally assignable address = 10.30.10.4
```

---

# Part A — Manual Azure CLI Build

## 4. Create the resource group

```powershell
az group create `
  --name rg-az700-ip-aue `
  --location australiaeast
```

Expected provisioning state: `Succeeded`.

---

## 5. Create the VNet

```powershell
az network vnet create `
  --resource-group rg-az700-ip-aue `
  --name vnet-az700-ip-aue `
  --location australiaeast `
  --address-prefixes 10.30.0.0/16
```

The VNet is created first so the hierarchy remains clear: subnets are carved from the VNet address space.

---

## 6. Create workload subnets

### Web

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-web `
  --address-prefixes 10.30.10.0/26
```

### App

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-app `
  --address-prefixes 10.30.20.0/27
```

### DB

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-db `
  --address-prefixes 10.30.30.0/27
```

### Management

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-management `
  --address-prefixes 10.30.40.0/28
```

---

## 7. Create Azure service-specific subnets

These subnets have Azure-defined names but are not the same thing as delegated subnets.

### GatewaySubnet

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name GatewaySubnet `
  --address-prefixes 10.30.100.0/27
```

### AzureFirewallSubnet

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name AzureFirewallSubnet `
  --address-prefixes 10.30.101.0/26
```

### AzureBastionSubnet

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name AzureBastionSubnet `
  --address-prefixes 10.30.102.0/26
```

---

## 8. Create the delegated PostgreSQL subnet

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-postgres `
  --address-prefixes 10.30.50.0/27 `
  --delegations Microsoft.DBforPostgreSQL/flexibleServers
```

Expected delegation:

```text
Microsoft.DBforPostgreSQL/flexibleServers
```

Validate all eight subnets:

```powershell
az network vnet subnet list `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --query "[].{Name:name,Prefix:addressPrefix,Delegation:delegations[0].serviceName,State:provisioningState}" `
  -o table
```

---

## 9. Dynamic private IP exercise

Create a NIC without specifying a private IP:

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-web-dynamic `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-web
```

Expected behaviour:

```text
private IP allocation: Dynamic
likely first address: 10.30.10.4
```

The exact address is selected by Azure from available addresses. In the validated build Azure assigned `10.30.10.4`.

---

## 10. Static private IP exercise

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-app-static `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-app `
  --private-ip-address 10.30.20.10
```

Expected:

```text
private IP: 10.30.20.10
allocation: Static
```

`Static` describes allocation behaviour. It does not mean public.

---

## 11. Standard Regional Public IP

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-web-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static
```

Inspect actual Azure properties rather than assuming defaults:

```powershell
az network public-ip show `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-web-aue `
  --query "{Name:name,IP:ipAddress,SKU:sku.name,Tier:sku.tier,Allocation:publicIPAllocationMethod,Zones:zones}" `
  -o json
```

In the validated manual run, `Zones` was `null`.

---

## 12. Zone-redundant Public IP

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-zr-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static `
  --zone 1 2 3
```

Expected zones are the set `1,2,3`. Azure may display the array in a different order.

---

## 13. Public IP Prefix

Create a zone-redundant `/30` Standard Public IP Prefix:

```powershell
az network public-ip prefix create `
  --resource-group rg-az700-ip-aue `
  --name pipprefix-lab03-aue `
  --location australiaeast `
  --length 30 `
  --sku Standard `
  --zone 1 2 3
```

A `/30` Public IP Prefix contains four public addresses. Do not apply the VNet-subnet five-address reservation rule to Public IP Prefixes.

---

## 14. Allocate a Public IP from the prefix

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-from-prefix-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static `
  --public-ip-prefix pipprefix-lab03-aue
```

Validate:

```powershell
az network public-ip show `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-from-prefix-aue `
  --query "{Name:name,IP:ipAddress,Prefix:publicIPPrefix.id,Zones:zones,Allocation:publicIPAllocationMethod,State:provisioningState}" `
  -o json
```

---

## 15. Prove Public IP and private IP lifecycles are separate

Attach `pip-lab03-web-aue` to the dynamic web NIC:

```powershell
az network nic ip-config update `
  --resource-group rg-az700-ip-aue `
  --nic-name nic-lab03-web-dynamic `
  --name ipconfig1 `
  --public-ip-address pip-lab03-web-aue
```

Validate that the private IP remains present.

Then detach the Public IP:

```powershell
az network nic ip-config update `
  --resource-group rg-az700-ip-aue `
  --nic-name nic-lab03-web-dynamic `
  --name ipconfig1 `
  --remove publicIPAddress
```

Expected final state:

```text
NIC private IP still exists
Public IP resource still exists
NIC PublicIP reference = null
```

---

# Part A Troubleshooting Exercises

## 16. Failure test — overlapping subnet

Existing:

```text
snet-web = 10.30.10.0/26
```

Attempt:

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-overlap-test `
  --address-prefixes 10.30.10.32/27
```

Expected error:

```text
NetcfgSubnetRangesOverlap
```

Then verify the failed subnet does not exist.

---

## 17. Failure test — Azure-reserved private IP

Attempt to use `10.30.30.1` in `10.30.30.0/27`:

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-reserved-test `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-db `
  --private-ip-address 10.30.30.1
```

Expected:

```text
PrivateIPAddressInReservedRange
```

Verify the NIC was not partially created.

---

## 18. Failure test — duplicate private IP

Existing static address:

```text
10.30.20.10
```

Attempt a second NIC with the same address:

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-duplicate-test `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-app `
  --private-ip-address 10.30.20.10
```

Expected:

```text
PrivateIPAddressIsAllocated
```

---

## 19. Failure test — IP inside VNet but outside subnet

`snet-app` is `10.30.20.0/27`.

Attempt:

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-outside-test `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-app `
  --private-ip-address 10.30.21.10
```

Expected:

```text
PrivateIPAddressNotInSubnet
```

Important rule:

```text
Inside the parent VNet is not enough.
The private IP must be inside the exact assigned subnet.
```

---

## 20. Manual validation checkpoint

Top-level resources:

```powershell
az resource list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,Type:type,Location:location}" `
  -o table
```

Expect seven top-level resources:

```text
1 VNet
2 NICs
3 Public IPs
1 Public IP Prefix
```

Subnets remain VNet child resources.

NICs:

```powershell
az network nic list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,PrivateIP:ipConfigurations[0].privateIPAddress,Allocation:ipConfigurations[0].privateIPAllocationMethod,Subnet:ipConfigurations[0].subnet.id}" `
  -o table
```

Public IPs:

```powershell
az network public-ip list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,IP:ipAddress,Zones:zones,PublicIPPrefix:publicIPPrefix.id}" `
  -o json
```

---

## 21. Manual teardown

Only tear down after evidence has been captured.

```powershell
az group delete `
  --name rg-az700-ip-aue `
  --yes `
  --no-wait
```

Independent checks:

```powershell
az group show --name rg-az700-ip-aue
az group exists --name rg-az700-ip-aue
```

Required final boolean:

```text
false
```

---

# Part B — Terraform Rebuild

## 22. Enter the Terraform directory

From the repository root:

```powershell
cd labs\03-ip-addressing-vnets-subnets-public-ip\terraform
```

The committed Terraform files are:

```text
versions.tf
providers.tf
variables.tf
main.tf
outputs.tf
terraform.tfvars.example
README.md
.terraform.lock.hcl   after initialization/commit
```

The HCL models the valid final architecture only. Temporary invalid troubleshooting resources are intentionally excluded.

---

## 23. Format and initialize

```powershell
terraform fmt -recursive
terraform init
```

Validated provider selection:

```text
hashicorp/azurerm v4.81.0
```

The repository constrains AzureRM to:

```text
~> 4.0
```

---

## 24. Validate Terraform configuration

```powershell
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## 25. Create a saved Terraform plan

In the validated Windows PowerShell environment, use:

```powershell
terraform plan -out lab03.tfplan
```

Expected plan:

```text
Plan: 16 to add, 0 to change, 0 to destroy.
```

Expected resources:

```text
1 Resource Group
1 Virtual Network
8 Subnets
2 Network Interfaces
3 Public IP Addresses
1 Public IP Prefix
--------------------
16 Terraform resources
```

Note: in the validated environment, `terraform plan -out=lab03.tfplan` produced `Too many command line arguments`. The space-separated form worked.

---

## 26. Apply the saved plan

```powershell
terraform apply "lab03.tfplan"
```

Expected:

```text
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
```

Public IP values will normally differ between rebuilds because Azure allocates new addresses when the previous resources have been destroyed.

---

## 27. Validate Terraform state

```powershell
terraform state list
```

Expect exactly 16 managed resource addresses.

Key entries include:

```text
azurerm_network_interface.app_static
azurerm_network_interface.web_dynamic
azurerm_public_ip.from_prefix
azurerm_public_ip.web
azurerm_public_ip.zone_redundant
azurerm_public_ip_prefix.lab03
azurerm_resource_group.lab03
azurerm_subnet.app
azurerm_subnet.bastion
azurerm_subnet.db
azurerm_subnet.firewall
azurerm_subnet.gateway
azurerm_subnet.management
azurerm_subnet.postgres
azurerm_subnet.web
azurerm_virtual_network.lab03
```

---

## 28. Independently validate live Azure

Do not treat Terraform state as proof of Azure reality.

Top-level resources:

```powershell
az resource list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,Type:type,Location:location}" `
  -o table
```

Subnets/delegation:

```powershell
az network vnet subnet list `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --query "[].{Name:name,Prefix:addressPrefix,Delegation:delegations[0].serviceName,State:provisioningState}" `
  -o table
```

NICs:

```powershell
az network nic list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,PrivateIP:ipConfigurations[0].privateIPAddress,Allocation:ipConfigurations[0].privateIPAllocationMethod,Subnet:ipConfigurations[0].subnet.id}" `
  -o table
```

Public IPs:

```powershell
az network public-ip list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,IP:ipAddress,SKU:sku.name,Tier:sku.tier,Allocation:publicIPAllocationMethod}" `
  -o table
```

Zones and prefix relationships:

```powershell
az network public-ip list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,IP:ipAddress,Zones:zones,PublicIPPrefix:publicIPPrefix.id}" `
  -o json
```

Public IP Prefix:

```powershell
az network public-ip prefix show `
  --resource-group rg-az700-ip-aue `
  --name pipprefix-lab03-aue `
  --query "{Name:name,Prefix:ipPrefix,Length:prefixLength,SKU:sku.name,Tier:sku.tier,Zones:zones,State:provisioningState}" `
  -o json
```

Web NIC final Public IP relationship:

```powershell
az network nic show `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-web-dynamic `
  --query "{NIC:name,PrivateIP:ipConfigurations[0].privateIPAddress,Allocation:ipConfigurations[0].privateIPAllocationMethod,PublicIP:ipConfigurations[0].publicIPAddress.id}" `
  -o json
```

Expected final Terraform end-state:

```text
PrivateIP: 10.30.10.4 or another Azure-selected dynamic address
Allocation: Dynamic
PublicIP: null
```

In the validated Terraform run, Azure again selected `10.30.10.4`.

---

## 29. Prove Terraform convergence

```powershell
terraform plan
```

Required result:

```text
No changes. Your infrastructure matches the configuration.
```

This is the desired relationship:

```text
Terraform configuration
        =
Terraform state
        =
Live Azure environment
```

---

## 30. Final Terraform teardown

Only run this after final evidence, visual-learning material and rebuild documentation have been captured.

```powershell
terraform destroy
```

Approve the destroy when prompted.

Then verify Azure independently:

```powershell
az group exists --name rg-az700-ip-aue
```

Required:

```text
false
```

Verify Terraform state:

```powershell
terraform state list
```

Required:

```text
no output
```

Do not mark the lab COMPLETE until both checks pass.

---

# 31. Fast troubleshooting checklist

When an Azure private-IP deployment fails, ask in this order:

```text
1. Is the requested IP inside the exact subnet?
2. Is the subnet CIDR valid and non-overlapping?
3. Is the requested IP one of Azure's reserved addresses?
4. Is the requested IP already allocated?
5. Does the subnet have the correct Azure-defined name or delegation?
6. Is the Terraform state consistent with the live Azure environment?
```

---

# 32. Explain-back checklist

You should be able to answer these without reading the guide:

1. Why can two RFC1918 networks still fail to connect if their ranges overlap?
2. Why does a `/26` Azure subnet provide 59 usable addresses rather than 64?
3. What is the difference between `GatewaySubnet` and a delegated subnet?
4. Why did the dynamic web NIC receive `.4` in the validated build?
5. Why is `10.30.21.10` invalid for `snet-app` even though it is inside `10.30.0.0/16`?
6. Why does a server needing outbound Internet access not automatically require its own Public IP?
7. What problem does a Public IP Prefix solve?
8. Why can the Public IP remain after being detached from a NIC?
9. Why do we validate Azure independently after Terraform apply?
10. What does a final Terraform `No changes` result prove?

---

## 33. Lab 03 retained mental model

```text
Address plan first.
Connectivity later.

VNet     = address boundary
Subnet   = functional boundary
NSG      = permission
Route    = path
Private IP = private identity
Public IP  = separate Internet identity/resource

ordinary subnet
!= delegated subnet
!= Azure service-specific subnet

Terraform configuration
!= proof by itself

Configuration + state + live Azure must agree.
```
