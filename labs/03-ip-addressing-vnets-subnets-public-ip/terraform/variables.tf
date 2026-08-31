# -----------------------------------------------------------------------------
# Lab 03 - Input variables
# -----------------------------------------------------------------------------
# These variables keep environment-specific values out of main.tf and make the
# lab easier to reuse.  Defaults match the manual build completed in Australia
# East, so the lab can run without a separate terraform.tfvars file.

variable "location" {
  description = "Azure region for all regional Lab 03 resources."
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "Resource group that contains all Lab 03 Terraform resources."
  type        = string
  default     = "rg-az700-ip-aue"
}

variable "vnet_name" {
  description = "Name of the Lab 03 virtual network."
  type        = string
  default     = "vnet-az700-ip-aue"
}

variable "vnet_address_space" {
  description = "Primary address space for the Lab 03 VNet."
  type        = list(string)
  default     = ["10.30.0.0/16"]
}

variable "tags" {
  description = "Common tags applied where the Azure resource supports tags."
  type        = map(string)

  default = {
    lab         = "03"
    programme   = "azure-networking"
    environment = "learning"
    managed_by  = "terraform"
  }
}
