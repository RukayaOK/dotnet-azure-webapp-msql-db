##### VIRTUAL NETWORK #####
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
}

##### DATABASE SUBNET #####
resource "azurerm_network_security_group" "database" {
  name                = var.database_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "database" {
  name                 = var.database_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.database_subnet_address_space

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

##### WEBAPP SUBNET #####
resource "azurerm_network_security_group" "webapp" {
  name                = var.webapp_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "webapp" {
  name                 = var.webapp_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.webapp_subnet_address_space

  service_endpoints = ["Microsoft.Sql"]

  delegation {
    name = "vnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "webapp" {
  subnet_id                 = azurerm_subnet.webapp.id
  network_security_group_id = azurerm_network_security_group.webapp.id
}

##### PRIVATE ENDPOINT #####
resource "azurerm_network_security_group" "private_endpoint" {
  name                = var.private_endpoint_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}


resource "azurerm_subnet" "private_endpoint" {
  name                 = var.private_endpoint_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_endpoint_subnet_address_space

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}
