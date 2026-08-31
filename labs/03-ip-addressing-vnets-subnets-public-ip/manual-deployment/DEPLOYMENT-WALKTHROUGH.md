# Lab 03 Manual Deployment Walkthrough

## Scope

This file records the manually validated Azure CLI build for Lab 03 before the Terraform rebuild.

## Azure context

```text
Subscription: Azure subscription 1
Region: australiaeast
Resource group: rg-az700-ip-aue
```

## 1. Resource group

```powershell
az group create `
  --name rg-az700-ip-aue `
  --location australiaeast
```

Observed state: `Succeeded`.

## 2. VNet

```powershell
az network vnet create `
  --resource-group rg-az700-ip-aue `
  --name vnet-az700-ip-aue `
  --location australiaeast `
  --address-prefixes 10.30.0.0/16
```

The VNet was intentionally created without subnets first to reinforce the hierarchy: VNet address space is the parent; subnets are carved from it afterward.

## 3. Workload subnets

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-web `
  --address-prefixes 10.30.10.0/26

az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-app `
  --address-prefixes 10.30.20.0/27

az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-db `
  --address-prefixes 10.30.30.0/27

az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-management `
  --address-prefixes 10.30.40.0/28
```

Independent list validation showed all four in `Succeeded` state.

## 4. Special Azure infrastructure subnets

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name GatewaySubnet `
  --address-prefixes 10.30.100.0/27

az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name AzureFirewallSubnet `
  --address-prefixes 10.30.101.0/26

az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name AzureBastionSubnet `
  --address-prefixes 10.30.102.0/26
```

These are dedicated/special-purpose Azure subnets and were not delegated.

## 5. Delegated subnet

```powershell
az network vnet subnet create `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --name snet-postgres `
  --address-prefixes 10.30.50.0/27 `
  --delegations Microsoft.DBforPostgreSQL/flexibleServers
```

Observed delegation:

```text
Microsoft.DBforPostgreSQL/flexibleServers
Microsoft.Network/virtualNetworks/subnets/join/action
```

## 6. Consolidated subnet validation

```powershell
az network vnet subnet list `
  --resource-group rg-az700-ip-aue `
  --vnet-name vnet-az700-ip-aue `
  --query "[].{Name:name,Prefix:addressPrefix,Delegation:delegations[0].serviceName,State:provisioningState}" `
  -o table
```

Validated eight subnets total: four workload, one delegated, three special Azure infrastructure subnets.

## 7. Dynamic private IP NIC

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-web-dynamic `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-web
```

Observed:

```text
privateIPAddress: 10.30.10.4
privateIPAllocationMethod: Dynamic
```

This demonstrates the first normal usable IP after Azure-reserved addresses.

## 8. Static private IP NIC

```powershell
az network nic create `
  --resource-group rg-az700-ip-aue `
  --name nic-lab03-app-static `
  --vnet-name vnet-az700-ip-aue `
  --subnet snet-app `
  --private-ip-address 10.30.20.10
```

Observed:

```text
privateIPAddress: 10.30.20.10
privateIPAllocationMethod: Static
```

Static describes allocation method; it does not mean public.

## 9. Standard regional Public IP

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-web-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static
```

Observed:

```text
IP: 4.196.200.103
SKU: Standard
Tier: Regional
Allocation: Static
Zones: null
```

## 10. Explicit zone-redundant Public IP

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-zr-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static `
  --zone 1 2 3
```

Observed:

```text
IP: 20.227.26.52
Zones: 1,2,3
```

## 11. Public IP Prefix

```powershell
az network public-ip prefix create `
  --resource-group rg-az700-ip-aue `
  --name pipprefix-lab03-aue `
  --location australiaeast `
  --length 30 `
  --sku Standard `
  --zone 1 2 3
```

Observed prefix:

```text
4.237.111.112/30
```

## 12. Public IP allocated from the prefix

```powershell
az network public-ip create `
  --resource-group rg-az700-ip-aue `
  --name pip-lab03-from-prefix-aue `
  --location australiaeast `
  --sku Standard `
  --allocation-method Static `
  --public-ip-prefix pipprefix-lab03-aue
```

Observed:

```text
IP: 4.237.111.112
Prefix: pipprefix-lab03-aue
Zones: 1,2,3
```

## 13. Public IP association/detachment proof

Association:

```powershell
az network nic ip-config update `
  --resource-group rg-az700-ip-aue `
  --nic-name nic-lab03-web-dynamic `
  --name ipconfig1 `
  --public-ip-address pip-lab03-web-aue
```

The NIC retained private IP `10.30.10.4` while gaining a reference to the standalone Public IP resource.

Detachment:

```powershell
az network nic ip-config update `
  --resource-group rg-az700-ip-aue `
  --nic-name nic-lab03-web-dynamic `
  --name ipconfig1 `
  --remove publicIPAddress
```

After detachment:

```text
NIC private IP remained: 10.30.10.4
Public IP remained: 4.196.200.103
```

This proves separate lifecycles for the NIC private address and the Public IP resource.

## 14. Top-level resource inventory

```powershell
az resource list `
  --resource-group rg-az700-ip-aue `
  --query "[].{Name:name,Type:type,Location:location}" `
  -o table
```

Validated seven top-level resources. Subnets are VNet child resources.

## 15. Portal checkpoint

Portal inspection confirmed:

- all eight subnets
- PostgreSQL delegation on `snet-postgres`
- 58 available IPs on `snet-web` after one NIC allocation
- 26 available IPs on `snet-app` after one NIC allocation
- 27 available IPs on unused `snet-db`
- 11 available IPs on unused `snet-management`
- all seven top-level resources in the resource group

## Current state

The manual environment remains live until the documentation/evidence checkpoint is synchronized locally. Do not destroy it before that point.
