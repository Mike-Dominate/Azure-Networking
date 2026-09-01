# Lab 01 - Azure Standard Load Balancer
#
# Terraform implementation of the completed manual deployment.
#
# Architecture:
# - Resource group in Australia East
# - VNet 10.200.0.0/16
# - Web subnet 10.200.1.0/24
# - Subnet-level NSG allowing inbound HTTP/80
# - Standard zone-redundant public IP
# - Standard Azure Load Balancer
# - HTTP health probe on port 80
# - TCP/80 load-balancing rule
# - Explicit Load Balancer outbound SNAT rule
# - Three backend Linux VMs distributed across Availability Zones 1, 2 and 3
# - Apache installed by cloud-init
#
# Note:
# Azure capacity can vary by availability zone. During this lab,
# Standard_B2als_v2 was unavailable in Zone 3, so the Zone 3 backend uses
# Standard_B2ls_v2.

locals {
  backends = {
    az1 = {
      zone     = "1"
      nic_name = "nic-web-az1"
      vm_name  = "vm-web-az1"
      vm_size  = "Standard_B2als_v2"
    }

    az2 = {
      zone     = "2"
      nic_name = "nic-web-az2"
      vm_name  = "vm-web-az2"
      vm_size  = "Standard_B2als_v2"
    }

    az3 = {
      zone     = "3"
      nic_name = "nic-web-az3"
      vm_name  = "vm-web-az3"
      vm_size  = "Standard_B2ls_v2"
    }
  }
}

resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-az700-lb-aue"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet" "web" {
  name                            = "snet-web"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = azurerm_virtual_network.lab.name
  address_prefixes                = var.web_subnet_prefixes
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "web" {
  name                = "nsg-az700-web-aue"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_public_ip" "lb" {
  name                = "pip-az700-lb-aue"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_lb" "web" {
  name                = "lb-az700-aue"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "fe-public"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "be-web"
  loadbalancer_id = azurerm_lb.web.id
}

resource "azurerm_lb_probe" "http" {
  name                = "probe-http"
  loadbalancer_id     = azurerm_lb.web.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
  probe_threshold     = 1
}

resource "azurerm_lb_rule" "http" {
  name                           = "rule-http"
  loadbalancer_id                = azurerm_lb.web.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "fe-public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
  probe_id                       = azurerm_lb_probe.http.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "web" {
  name                     = "outbound-web"
  loadbalancer_id          = azurerm_lb.web.id
  protocol                 = "All"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.web.id
  allocated_outbound_ports = 10000

  frontend_ip_configuration {
    name = "fe-public"
  }
}

resource "azurerm_network_interface" "web" {
  for_each = local.backends

  name                = each.value.nic_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "web" {
  for_each = local.backends

  network_interface_id    = azurerm_network_interface.web[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

resource "azurerm_linux_virtual_machine" "web" {
  for_each = local.backends

  name                = each.value.vm_name
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = each.value.vm_size
  zone                = each.value.zone
  admin_username      = var.admin_username

  depends_on = [
    azurerm_lb_outbound_rule.web,
    azurerm_network_interface_backend_address_pool_association.web
  ]
  network_interface_ids = [
    azurerm_network_interface.web[each.key].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(
    file("${path.module}/../manual-deployment/cloud-init.yaml")
  )
}
