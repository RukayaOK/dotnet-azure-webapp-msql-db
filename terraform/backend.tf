terraform {
  backend "azurerm" {
    resource_group_name  = "terra-rg"
    storage_account_name = "somesa1235"
    container_name       = "conttera1235"
    key                  = "tfstate"
  }
}