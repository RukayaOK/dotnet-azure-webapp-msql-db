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

  private_dns_zone_group {
    name = var.database_private_endpoint_name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.main.id
    ]
  }
}

resource "azurerm_sql_active_directory_administrator" "example" {
  server_name         = module.azuresql.azuresql_server.name
  resource_group_name = azurerm_resource_group.main.name
  login               = "sqladmin"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = "30e1ec8f-88a4-4c4d-91d4-91809fe93482" #"${data.azurerm_client_config.current.object_id}"
}