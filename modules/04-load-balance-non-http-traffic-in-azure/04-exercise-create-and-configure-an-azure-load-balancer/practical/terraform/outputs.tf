# Lab 01 Terraform outputs used for validation and operator access.

output "load_balancer_public_ip" {
  description = "Public IPv4 address of the Lab 01 Azure Load Balancer."
  value       = azurerm_public_ip.lb.ip_address
}

output "backend_private_ips" {
  description = "Private IPv4 addresses allocated to the three backend NICs."

  value = {
    for key, nic in azurerm_network_interface.web :
    key => nic.private_ip_address
  }
}
