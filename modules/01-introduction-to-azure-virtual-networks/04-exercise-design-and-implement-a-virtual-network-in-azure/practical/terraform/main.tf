# =============================================================================
# Lab 03 - IP Addressing, VNets, Subnets & Public IP Architecture
# =============================================================================
#
# This configuration rebuilds the VALIDATED MANUAL END-STATE from Lab 03.
# It deliberately does not recreate the temporary failure-test resources.
#
# Architecture:
#
#   rg-az700-ip-aue
#   |
#   +-- vnet-az700-ip-aue 10.30.0.0/16
#   |   +-- snet-web             10.30.10.0/26
#   |   +-- snet-app             10.30.20.0/27
#   |   +-- snet-db              10.30.30.0/27
#   |   +-- snet-management      10.30.40.0/28
#   |   +-- snet-postgres        10.30.50.0/27 (delegated)
#   |   +-- GatewaySubnet        10.30.100.0/27
#   |   +-- AzureFirewallSubnet  10.30.101.0/26
#   |   +-- AzureBastionSubnet   10.30.102.0/26
#   |
#   +-- nic-lab03-web-dynamic    dynamic private IPv4 on snet-web
#   +-- nic-lab03-app-static     static 10.30.20.10 on snet-app
#   +-- pip-lab03-web-aue        Standard regional static Public IP
#   +-- pip-lab03-zr-aue         Standard zone-redundant Public IP
#   +-- pipprefix-lab03-aue      /30 zone-redundant Public IP Prefix
#   +-- pip-lab03-from-prefix-aue Public IP allocated from that prefix
#
# Important design lesson:
# Terraform is not merely "creating resources".  References between resources
# encode dependency relationships.  For example, a subnet references the VNet
# ID, and a NIC IP configuration references a subnet ID. Terraform uses those
# references to construct the dependency graph automatically.
# =============================================================================

# -----------------------------------------------------------------------------
# Resource group
# -----------------------------------------------------------------------------
# The resource group is the lifecycle boundary for this lab.  Destroying the
# Terraform configuration will ultimately remove this group and everything it
# contains.
resource "azurerm_resource_group" "lab03" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Virtual network
# -----------------------------------------------------------------------------
# A VNet is the overall private address-space boundary.  The /16 gives us
# 65,536 addresses of address space to carve into deliberately sized subnets.
# Most of the /16 is intentionally unused so future connectivity and workloads
# have room to grow without renumbering the network.
resource "azurerm_virtual_network" "lab03" {
  name                = var.vnet_name
  location            = azurerm_resource_group.lab03.location
  resource_group_name = azurerm_resource_group.lab03.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Ordinary workload subnets
# -----------------------------------------------------------------------------
# These subnets have no service delegation.  Their sizes were chosen from the
# expected workload count plus growth headroom, rather than defaulting every
# subnet to /24.

resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.10.0/26"]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.20.0/27"]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.30.0/27"]
}

resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.40.0/28"]
}

# -----------------------------------------------------------------------------
# Delegated service subnet
# -----------------------------------------------------------------------------
# A delegated subnet grants a specific Azure platform service permission to
# integrate with and manage service-specific networking behaviour in the subnet.
#
# This is different from a specially named subnet such as AzureFirewallSubnet.
# "Dedicated/special" and "delegated" are related design concepts, but they are
# not the same Azure mechanism.
resource "azurerm_subnet" "postgres" {
  name                 = "snet-postgres"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.50.0/27"]

  delegation {
    name = "postgres-flexible-server-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# -----------------------------------------------------------------------------
# Azure infrastructure/service subnets
# -----------------------------------------------------------------------------
# These names are meaningful to Azure services.  The lab creates only the
# subnet placeholders; it does NOT deploy a VPN gateway, Azure Firewall, or
# Azure Bastion.  Later labs will deploy those services when they are the topic.

resource "azurerm_subnet" "gateway" {
  # Azure VPN/ExpressRoute gateways require the exact name GatewaySubnet.
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.100.0/27"]
}

resource "azurerm_subnet" "firewall" {
  # Azure Firewall requires the exact name AzureFirewallSubnet.
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.101.0/26"]
}

resource "azurerm_subnet" "bastion" {
  # Azure Bastion requires the exact name AzureBastionSubnet.
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.lab03.name
  virtual_network_name = azurerm_virtual_network.lab03.name
  address_prefixes     = ["10.30.102.0/26"]
}

# -----------------------------------------------------------------------------
# Dynamic private-IP NIC
# -----------------------------------------------------------------------------
# Azure allocates a usable address from snet-web. During the manual build this
# became 10.30.10.4, the first usable address after Azure's first four reserved
# addresses.  We intentionally do NOT force the exact dynamic value here:
# "Dynamic" means Azure chooses the available address.
resource "azurerm_network_interface" "web_dynamic" {
  name                = "nic-lab03-web-dynamic"
  location            = azurerm_resource_group.lab03.location
  resource_group_name = azurerm_resource_group.lab03.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}

# -----------------------------------------------------------------------------
# Static private-IP NIC
# -----------------------------------------------------------------------------
# Here Terraform requests a specific private IPv4 address.  Azure validates that
# the address belongs to snet-app, is not in its reserved range, and is not
# already allocated to another NIC.
resource "azurerm_network_interface" "app_static" {
  name                = "nic-lab03-app-static"
  location            = azurerm_resource_group.lab03.location
  resource_group_name = azurerm_resource_group.lab03.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.30.20.10"
  }
}

# -----------------------------------------------------------------------------
# Standard regional Public IP - deliberately not attached to a NIC
# -----------------------------------------------------------------------------
# This models the final manual state after we detached the Public IP from the
# web NIC.  That exercise proved a Public IP is a separate Azure resource with
# its own lifecycle; removing the association did not delete either resource.
#
# No `zones` value is supplied here. This models a regional Standard Public IP
# without an explicit zone assignment.  We validate the resulting Azure `zones`
# property after apply rather than assuming CLI/provider defaults.
resource "azurerm_public_ip" "web" {
  name                = "pip-lab03-web-aue"
  resource_group_name = azurerm_resource_group.lab03.name
  location            = azurerm_resource_group.lab03.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Explicit zone-redundant Standard Public IP
# -----------------------------------------------------------------------------
# zones 1,2,3 expresses an explicit resilience intent in a zonal Azure region.
# It is still ONE Public IP address; it does not create three separate addresses.
resource "azurerm_public_ip" "zone_redundant" {
  name                = "pip-lab03-zr-aue"
  resource_group_name = azurerm_resource_group.lab03.name
  location            = azurerm_resource_group.lab03.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Zone-redundant Public IP Prefix
# -----------------------------------------------------------------------------
# A /30 Public IP Prefix reserves a contiguous block of four public IPv4
# addresses for Public IP resources.  The Azure subnet rule of "five reserved
# addresses" does NOT apply to Public IP Prefixes; that rule is about VNet
# subnets, not public-prefix allocation.
resource "azurerm_public_ip_prefix" "lab03" {
  name                = "pipprefix-lab03-aue"
  resource_group_name = azurerm_resource_group.lab03.name
  location            = azurerm_resource_group.lab03.location
  prefix_length       = 30
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Public IP allocated from the Public IP Prefix
# -----------------------------------------------------------------------------
# The reference to azurerm_public_ip_prefix.lab03.id gives Terraform an implicit
# dependency: the prefix must exist before this Public IP can be allocated.
resource "azurerm_public_ip" "from_prefix" {
  name                = "pip-lab03-from-prefix-aue"
  resource_group_name = azurerm_resource_group.lab03.name
  location            = azurerm_resource_group.lab03.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  zones               = ["1", "2", "3"]
  public_ip_prefix_id = azurerm_public_ip_prefix.lab03.id
  tags                = var.tags
}
