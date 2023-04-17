terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}