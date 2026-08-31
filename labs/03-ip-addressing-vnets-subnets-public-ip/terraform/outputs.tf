# -----------------------------------------------------------------------------
# Lab 03 - Useful outputs
# -----------------------------------------------------------------------------
# Outputs are not required for resource creation.  They exist to make the
# resulting architecture easy to inspect after `terraform apply` and to give us
# fast comparison points against Azure CLI validation.

output "resource_group_name" {
  description = "Lab 03 resource group name."
  value       = azurerm_resource_group.lab03.name
}

output "vnet" {
  description = "Lab 03 VNet name and address space."
  value = {
    name          = azurerm_virtual_network.lab03.name
    address_space = azurerm_virtual_network.lab03.address_space
  }
}

output "subnet_prefixes" {
  description = "Subnet names mapped to their configured address prefixes."
  value = {
    snet_web             = azurerm_subnet.web.address_prefixes
    snet_app             = azurerm_subnet.app.address_prefixes
    snet_db              = azurerm_subnet.db.address_prefixes
    snet_management      = azurerm_subnet.management.address_prefixes
    snet_postgres        = azurerm_subnet.postgres.address_prefixes
    GatewaySubnet        = azurerm_subnet.gateway.address_prefixes
    AzureFirewallSubnet  = azurerm_subnet.firewall.address_prefixes
    AzureBastionSubnet   = azurerm_subnet.bastion.address_prefixes
  }
}

output "nic_private_ips" {
  description = "Private IPv4 addresses allocated to the two demonstration NICs."
  value = {
    web_dynamic = azurerm_network_interface.web_dynamic.private_ip_address
    app_static  = azurerm_network_interface.app_static.private_ip_address
  }
}

output "public_ip_addresses" {
  description = "Allocated Standard Public IP addresses. Values are known after apply."
  value = {
    regional_unzoned = azurerm_public_ip.web.ip_address
    zone_redundant   = azurerm_public_ip.zone_redundant.ip_address
    from_prefix      = azurerm_public_ip.from_prefix.ip_address
  }
}

output "public_ip_prefix" {
  description = "CIDR allocated to the /30 Public IP Prefix."
  value       = azurerm_public_ip_prefix.lab03.ip_prefix
}
