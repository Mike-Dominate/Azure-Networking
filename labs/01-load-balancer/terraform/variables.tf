variable "location" {
  description = "Azure region used for Lab 01. Choose at execution time based on availability-zone and VM SKU support."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for the Lab 01 environment."
  type        = string
  default     = "rg-az700-lb"
}

variable "vnet_address_space" {
  description = "Address space for the Lab 01 virtual network."
  type        = list(string)
  default     = ["10.200.0.0/16"]
}

variable "web_subnet_prefixes" {
  description = "Address prefixes for the web subnet."
  type        = list(string)
  default     = ["10.200.1.0/24"]
}

variable "admin_username" {
  description = "Administrative username for the Linux backend VMs."
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key used for Linux VM authentication."
  type        = string
}
