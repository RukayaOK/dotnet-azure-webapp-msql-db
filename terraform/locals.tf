locals {
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE     = "true"
    WEBSITE_USE_PLACEHOLDER             = "0"
    AZURE_LOG_LEVEL                     = "info"
    APPINSIGHTS_INSTRUMENTATIONKEY      = azurerm_application_insights.main.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING : azurerm_application_insights.main.connection_string
  }

  app_insights_detection_rules = toset([
    "Degradation in dependency duration",
    "Degradation in server response time",
    //"Digest Mail Configuration",
    //"Abnormal rise in daily data volume (preview)",
    //"Canary extension",
    //"Abnormal rise in exception volume (preview)",
    //"Potential memory leak detected (preview)",
    //"Potential security issue detected (preview)",
    //"Degradation in trace severity ratio (preview)",
    "Long dependency duration",
    //"Migration To Alert Rules Completed",
    "Slow page load time",
    "Slow server response time"
  ])
}