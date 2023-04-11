resource "azurerm_mssql_firewall_rule" "example" {
  for_each         = try(var.firewall_rules, {})
  name             = each.value.name
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}