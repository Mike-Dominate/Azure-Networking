# -----------------------------------------------------------------------------
# Lab 03 - Azure provider configuration
# -----------------------------------------------------------------------------
# Authentication is intentionally not hard-coded here.
# Terraform will use the Azure identity already authenticated in the local shell
# (for example via `az login`) unless you later choose a different auth method.

provider "azurerm" {
  features {}
}
