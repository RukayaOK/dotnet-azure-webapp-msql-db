resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention_in_days
}

resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = var.app_insights_application_type
  workspace_id        = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_application_insights_smart_detection_rule" "rule" {
  for_each                = local.app_insights_detection_rules
  name                    = each.value
  application_insights_id = azurerm_application_insights.main.id
  enabled                 = true
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = var.app_diagnostic_setting_name
  target_resource_id         = azurerm_windows_web_app.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  dynamic "log" {
    iterator = entry
    for_each = var.log_analytics_log_categories
    content {
      category = entry.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
      days    = 30
    }
  }
}