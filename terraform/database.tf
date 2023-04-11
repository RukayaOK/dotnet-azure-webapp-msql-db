##### DATABASE #####
module "azuresql" {
  source = "./modules/azure_sql"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.location
  subnet_id                    = azurerm_subnet.database.id
  server_version               = var.server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  database_name                = var.database_name
  database_collation           = var.database_collation
  database_license_type        = var.database_license_type
  sku_name                     = var.sku_name
  license_type                 = var.license_type
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
  server_name                  = var.server_name
  firewall_rules               = var.firewall_rules
}

resource "azurerm_private_endpoint" "database_private_endpoint" {
  name                = var.database_private_endpoint_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = var.database_private_service_connection
    is_manual_connection           = false
    private_connection_resource_id = module.azuresql.azuresql_server.id
    subresource_names              = ["sqlServer"]
  }
}