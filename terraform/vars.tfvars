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
    start_ip_address = "77.108.144.130"
    end_ip_address   = "77.108.144.130"
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
log_analytics_workspace_name              = "Central-LAW"
log_analytics_workspace_sku               = "PerGB2018"
log_analytics_workspace_retention_in_days = 30

app_insights_name             = "appInsights"
app_insights_application_type = "other"