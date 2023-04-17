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

resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_windows_web_app.main.id
  subnet_id      = azurerm_subnet.webapp.id
}


resource "azurerm_template_deployment" "main" {
  name                = "${azurerm_windows_web_app.main.name}-network-restrictions"
  resource_group_name = azurerm_resource_group.main.name
  template_body       = <<JSON
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "variables": {
     "_force_terraform_to_always_redeploy": "${timestamp()}"
  },
  "resources": [{
     "type": "Microsoft.Web/sites/config",
         "apiVersion": "2022-09-01",
         "name": "${azurerm_windows_web_app.main.name}/web",
         "location": "${azurerm_windows_web_app.main.name}",
         "properties": {
            "ftpsState": "Disabled",
            "ipSecurityRestrictions": [
               {
                  "ipAddress": "8.8.8.8/32",
                  "action": "Deny",
                  "tag": "Default",
                  "priority": 100,
                  "name": "DenyRule1",
                  "description": ""
               },
               {
                  "ipAddress": "8.8.8.9/32",
                  "action": "Deny",
                  "tag": "Default",
                  "priority": 150,
                  "name": "DenyRule2",
                  "description": ""
               },
               {
                  "ipAddress": "86.3.69.12/32",
                  "action": "Allow",
                  "tag": "Default",
                  "priority": 200,
                  "name": "AllowRule1",
                  "description": ""
               }
            ]
         }
    }
  ]
}
JSON
  deployment_mode     = "Incremental"
}


resource "null_resource" "az_webapp_config" {

  triggers = {
    resource_group_name = azurerm_resource_group.main.name
    webapp_name         = azurerm_windows_web_app.main.name
    vnet_connection     = azurerm_app_service_virtual_network_swift_connection.main.id
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/az_webapp_config.sh"
    interpreter = ["/bin/bash"]

    environment = {
      RESOURCE_GROUP = self.triggers.resource_group_name
      WEBAPP_NAME    = self.triggers.webapp_name
    }
  }

  depends_on = [azurerm_app_service_virtual_network_swift_connection.main]
}
