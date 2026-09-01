variable "resource_group_name" {
  description = "Resource group name for the Lab 02 Traffic Manager environment."
  type        = string
  default     = "rg-az700-tm-global"
}

variable "resource_group_location" {
  description = "Azure region used to store the resource group metadata."
  type        = string
  default     = "australiaeast"
}

variable "dns_suffix" {
  description = "Suffix used to create unique Traffic Manager and ACI DNS names."
  type        = string
  default     = "87004"
}

variable "container_image" {
  description = "Container image used by the three regional ACI web endpoints."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/aci-helloworld"
}