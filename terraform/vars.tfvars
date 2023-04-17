##### RESOURCE GROUP #####
resource_group_name = "test-app-rg"
location            = "uksouth"

##### NETWORK #####
vnet_name          = "test-app-vnet"
vnet_address_space = ["10.7.0.0/27"]

database_nsg_name             = "database-nsg"
database_subnet_name          = "database-subnet"
database_subnet_address_space = ["10.7.0.0/28"]

webapp_nsg_name             = "webapp-nsg"
webapp_subnet_name          = "webapp-subnet"
webapp_subnet_address_space = ["10.7.0.16/29"]

private_endpoint_nsg_name             = "private-endpoint-nsg"
private_endpoint_subnet_name          = "private-endpoint-subnet"
private_endpoint_subnet_address_space = ["10.7.0.24/29"]

private_dns_link_name = "test-app-vnet-link"
##### DATABASE #####
license_type       = "BasePrice"
sku_name           = "S0" #"GP_Gen5"
vcores             = 4
storage_size_in_gb = 32

server_name    = "test-app-dev-sql-server-468"
server_version = "12.0"

database_name         = "test-app-dev-sql-database-468"
database_collation    = "SQL_Latin1_General_CP1_CI_AS"
database_license_type = "LicenseIncluded"

firewall_rules = {
  MY_IP1 = {
    name             = "MY_IP1"
    start_ip_address = "86.3.69.12"
    end_ip_address   = "86.3.69.12"
  }
}

database_private_endpoint_name      = "database-private-endpoint"
database_private_service_connection = "sqldbprivatelink-primary"

##### APP SERVICE #####
app_service_plan_name = "testappServicePlan"

app_name                = "testApp468"
app_settings            = {}
app_dotnet_version      = "6.0"
app_minimum_tls_version = "1.2"
app_identity_type       = "SystemAssigned"

##### APP INSIGHTS #####
app_diagnostic_setting_name  = "AppDiagnosticSettings"
log_analytics_log_categories = ["AppServiceHTTPLogs", "AppServiceConsoleLogs", "AppServiceAppLogs", "AppServiceAuditLogs", "AppServiceIPSecAuditLogs", "AppServicePlatformLogs"]

log_analytics_workspace_name              = "Central-LAW"
log_analytics_workspace_sku               = "PerGB2018"
log_analytics_workspace_retention_in_days = 30

app_insights_name             = "appInsights"
app_insights_application_type = "other"

app_permitted_inbound_ips = [
  {
    "ipAddress" : "8.8.8.8/32",
    "action" : "Deny",
    "tag" : "Default",
    "priority" : 100,
    "name" : "DenyRule1",
    "description" : ""
  },
  {
    "ipAddress" : "8.8.8.9/32",
    "action" : "Deny",
    "tag" : "Default",
    "priority" : 150,
    "name" : "DenyRule2",
    "description" : ""
  },
  {
    "ipAddress" : "86.3.69.12/32",
    "action" : "Allow",
    "tag" : "Default",
    "priority" : 200,
    "name" : "AllowRule1",
    "description" : ""
  }
]