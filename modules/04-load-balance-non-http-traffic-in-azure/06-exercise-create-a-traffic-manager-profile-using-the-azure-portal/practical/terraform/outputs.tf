# =============================================================================
# LAB 02 - TERRAFORM OUTPUTS
# =============================================================================
#
# Outputs expose useful values from the completed deployment.
#
# They do not create Azure resources.
# They simply read attributes Terraform already knows about.
#
# =============================================================================


# Traffic Manager's public DNS name.
#
# Expected format:
#
# az700-tm-md-87004.trafficmanager.net
#
output "traffic_manager_fqdn" {
  description = "Public FQDN of the Azure Traffic Manager profile."
  value       = azurerm_traffic_manager_profile.global.fqdn
}


# Return all three regional ACI FQDNs as a map.
#
# Expected shape:
#
# {
#   eus = "az700-tm-eus-87004.eastus.azurecontainer.io"
#   sea = "az700-tm-sea-87004.southeastasia.azurecontainer.io"
#   weu = "az700-tm-weu-87004.westeurope.azurecontainer.io"
# }
#
output "regional_aci_fqdns" {
  description = "Public FQDNs of the three regional Azure Container Instances."

  value = {
    for key, container_group in azurerm_container_group.regional :
    key => container_group.fqdn
  }
}


# Public IPs are useful for observation and troubleshooting.
#
# However, Traffic Manager does NOT target these addresses directly.
# It targets the stable ACI FQDNs.
#
# During the manual lab we observed that an ACI public IP can change
# following a stop/start operation.
#
output "regional_aci_public_ips" {
  description = "Current public IP addresses assigned to the regional ACI endpoints."

  value = {
    for key, container_group in azurerm_container_group.regional :
    key => container_group.ip_address
  }
}