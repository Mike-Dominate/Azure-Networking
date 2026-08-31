# Lab 03 Terraform Validation Checkpoint

Terraform rebuild validation completed on 2026-08-31.

## Toolchain

```text
Terraform: local installed version used by learner
AzureRM provider: 4.81.0
Provider constraint: ~> 4.0
Lock file: .terraform.lock.hcl committed
```

## Configuration validation

```text
terraform fmt -recursive
-> outputs.tf formatted

terraform init
-> AzureRM v4.81.0 installed
-> .terraform.lock.hcl created
-> initialization successful

terraform validate
-> Success! The configuration is valid.
```

## Saved plan

The successful command in this Windows PowerShell environment was:

```powershell
terraform plan -out lab03.tfplan
```

Plan result:

```text
Plan: 16 to add, 0 to change, 0 to destroy.
Saved the plan to: lab03.tfplan
```

The earlier `-out=lab03.tfplan` form returned `Too many command line arguments` in this environment and made no Azure changes.

## Apply

```text
terraform apply "lab03.tfplan"

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
```

Terraform outputs after apply:

```text
nic_private_ips
  app_static  = 10.30.20.10
  web_dynamic = 10.30.10.4

public_ip_addresses
  from_prefix      = 20.11.118.4
  regional_unzoned = 4.196.170.206
  zone_redundant   = 4.237.190.4

public_ip_prefix = 20.11.118.4/30
resource_group_name = rg-az700-ip-aue
vnet = vnet-az700-ip-aue / 10.30.0.0/16
```

## Terraform state inventory

`terraform state list` contained exactly 16 managed resources:

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

## Independent Azure top-level inventory

Azure CLI independently returned 7 top-level resources:

```text
pip-lab03-web-aue
pip-lab03-zr-aue
vnet-az700-ip-aue
pipprefix-lab03-aue
pip-lab03-from-prefix-aue
nic-lab03-web-dynamic
nic-lab03-app-static
```

This is correct because the eight subnets are VNet child resources rather than separate top-level resource-group items.

## Independent subnet validation

```text
AzureBastionSubnet   10.30.102.0/26  Succeeded
AzureFirewallSubnet  10.30.101.0/26  Succeeded
snet-db              10.30.30.0/27   Succeeded
snet-postgres        10.30.50.0/27   Succeeded  Microsoft.DBforPostgreSQL/flexibleServers
snet-web             10.30.10.0/26   Succeeded
snet-management      10.30.40.0/28   Succeeded
snet-app             10.30.20.0/27   Succeeded
GatewaySubnet        10.30.100.0/27  Succeeded
```

## Independent NIC validation

```text
nic-lab03-app-static
  private IP: 10.30.20.10
  allocation: Static
  subnet: snet-app

nic-lab03-web-dynamic
  private IP: 10.30.10.4
  allocation: Dynamic
  subnet: snet-web
```

The web NIC was also independently checked and returned:

```text
PublicIP: null
```

This proves the Terraform desired state matches the final manual end-state where `pip-lab03-web-aue` exists independently but is not attached to the NIC.

## Independent Public IP validation

```text
pip-lab03-from-prefix-aue  20.11.118.4    Standard  Regional  Static
pip-lab03-web-aue          4.196.170.206  Standard  Regional  Static
pip-lab03-zr-aue           4.237.190.4    Standard  Regional  Static
```

Zone/prefix checks:

```text
pip-lab03-from-prefix-aue
  prefix: pipprefix-lab03-aue
  zones: 1,2,3

pip-lab03-web-aue
  prefix: none
  zones: null

pip-lab03-zr-aue
  prefix: none
  zones: 1,2,3
```

Azure returned the zone array in the order `2,3,1`; ordering is not meaningful because the intended set is zones 1,2,3.

## Independent Public IP Prefix validation

```text
Name: pipprefix-lab03-aue
Prefix: 20.11.118.4/30
Length: 30
SKU: Standard
Tier: Regional
Zones: 1,2,3
State: Succeeded
```

The child Public IP `20.11.118.4` is the first address allocated from the new `/30` Public IP Prefix.

## Convergence proof

Final command:

```powershell
terraform plan
```

Result:

```text
No changes. Your infrastructure matches the configuration.
```

Therefore all three layers agree:

```text
Terraform configuration
        =
Terraform state
        =
Live Azure environment
```

## Current status

```text
Terraform configuration authored     COMPLETE
terraform fmt                         COMPLETE
terraform init                        COMPLETE
terraform validate                    COMPLETE
saved plan                            COMPLETE
terraform apply                       COMPLETE
Terraform state validation            COMPLETE
independent Azure validation          COMPLETE
final no-change plan                  COMPLETE
provider lock committed/pushed        COMPLETE
final documentation/visual/PDF        PENDING
final Terraform destroy               PENDING
post-destroy Azure/state verification PENDING
```
