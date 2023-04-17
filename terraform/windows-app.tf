resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "main" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  app_settings        = merge(local.app_settings, var.app_settings)
  site_config {
    minimum_tls_version = var.app_minimum_tls_version
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  identity {
    type = var.app_identity_type
  }


}

resource "azurerm_app_service_virtual_network_swift_connection" "maiin" {
  app_service_id = azurerm_windows_web_app.main.id
  subnet_id      = azurerm_subnet.webapp.id
}
