output "azuresql_server" {
  value       = azurerm_mssql_server.main
  sensitive   = true
  description = "description"
}

output "azuresql_database" {
  value       = azurerm_mssql_database.main
  sensitive   = true
  description = "description"
}
