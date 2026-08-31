# -----------------------------------------------------------------------------
# Lab 03 - Terraform and provider version requirements
# -----------------------------------------------------------------------------
#
# Keep this baseline aligned with Labs 01 and 02 so the learning programme uses
# one consistent Terraform/AzureRM toolchain.  The constraint "~> 4.0" allows
# AzureRM 4.x updates but prevents an automatic jump to a future 5.x major
# version, where breaking schema changes could alter the lab unexpectedly.
#
# `terraform init` will create/update .terraform.lock.hcl locally.  The lock file
# should then be committed so repeated rebuilds use the exact provider version
# selected during this lab.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
