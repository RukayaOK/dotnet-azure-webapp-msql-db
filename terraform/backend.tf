terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-test-app-rg"
    storage_account_name = "terratestapp468"
    container_name       = "tfstates"
    key                  = "test-app.tfstate"
  }
}