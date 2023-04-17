terraform {
  backend "azurerm" {
    resource_group_name  = "dotnet-test-rg"
    storage_account_name = "dotnettestsa468"
    container_name       = "tfstatecont"
    key                  = "tfstate"
  }
}