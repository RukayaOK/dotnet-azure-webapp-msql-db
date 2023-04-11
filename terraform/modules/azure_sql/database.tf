resource "azurerm_mssql_database" "main" {
  name         = var.database_name
  server_id    = azurerm_mssql_server.main.id
  collation    = var.database_collation
  license_type = var.database_license_type
  #max_size_gb    = 4
  #read_scale     = true
  sku_name = var.sku_name
  #zone_redundant = true
}