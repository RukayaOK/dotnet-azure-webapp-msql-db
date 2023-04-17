##### RESOURCE GROUP #####
variable "resource_group_name" {
  type        = string
  description = "description"
}

variable "location" {
  type        = string
  description = "description"
}

##### NETWORK #####
variable "vnet_name" {
  type        = string
  description = "description"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "database_nsg_name" {
  type        = string
  description = "description"
}

variable "webapp_nsg_name" {
  type        = string
  description = "description"
}

variable "private_endpoint_nsg_name" {
  type        = string
  description = "description"
}

variable "database_subnet_name" {
  type        = string
  description = "description"
}

variable "database_subnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "webapp_subnet_name" {
  type        = string
  description = "description"
}

variable "webapp_subnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "private_endpoint_subnet_name" {
  type        = string
  description = "description"
}

variable "private_endpoint_subnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "private_dns_link_name" {
  type        = string
  description = "description"
}

##### DATABASE #####
variable "server_version" {
  type        = string
  description = "Server Version"
}

variable "administrator_login" {
  type        = string
  description = "Enter Administrator name for the database"
}

variable "administrator_login_password" {
  type        = string
  description = "Enter administrator password for the database"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Enter database name"
}

variable "database_collation" {
  type        = string
  description = "Enter database name"
}

variable "database_license_type" {
  type        = string
  description = "Enter database name"
}

variable "sku_name" {
  type        = string
  description = "Enter SKU"
}
variable "license_type" {
  type        = string
  description = "Enter license type"
}
variable "vcores" {
  type        = number
  description = "Enter number of vCores you want to deploy"
}
variable "storage_size_in_gb" {
  type        = number
  description = "Enter storage size in GB"
}

variable "server_name" {
  type        = string
  description = "Server name"
}

variable "firewall_rules" {
  type        = map(any)
  description = "Server name"
}

variable "database_private_endpoint_name" {
  type        = string
  description = "description"
}

variable "database_private_service_connection" {
  type        = string
  description = "description"
}

##### APP SERVICE #####
variable "app_service_plan_name" {
  type        = string
  description = "description"
}

variable "app_name" {
  type        = string
  description = "description"
}

variable "app_settings" {
  type        = map(any)
  description = "description"
}

variable "app_minimum_tls_version" {
  type        = string
  description = "description"
}

# variable "app_dotnet_version" {
#   type        = string
#   description = "description"
# }

variable "app_identity_type" {
  type        = string
  description = "description"
}

variable "app_permitted_inbound_ips" {
  type        = list(any)
  description = "description"
}
##### APP INSIGHTS #####
variable "log_analytics_workspace_name" {
  type        = string
  description = "description"
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "description"
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "description"
}

variable "app_insights_name" {
  type        = string
  description = "description"
}

variable "app_insights_application_type" {
  type        = string
  description = "description"
}

variable "app_diagnostic_setting_name" {
  type        = string
  description = "description"
}

variable "log_analytics_log_categories" {
  type        = list(string)
  description = "description"
}
