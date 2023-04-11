resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  enabled             = true
  https_only          = true
  app_settings        = merge(local.app_settings, var.app_settings)
  site_config {
    minimum_tls_version = var.app_minimum_tls_version
    #worker_count        = 1
    application_stack {
      dotnet_version = var.app_dotnet_version
    }
  }
  //logs {}
  identity {
    type = var.app_identity_type
  }

  #   lifecycle {
  #     ignore_changes = [tags]
  #   }
}

resource "azurerm_app_service_virtual_network_swift_connection" "maiin" {
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = azurerm_subnet.webapp.id
}
