output "azuresql_server" {
  value       = module.azuresql.azuresql_server
  sensitive   = true
  description = "description"
}

output "azuresql_database" {
  value       = module.azuresql.azuresql_database
  sensitive   = true
  description = "description"
}
