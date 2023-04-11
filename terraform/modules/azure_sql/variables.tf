variable "resource_group_name" {
  type        = string
  description = "description"
}

variable "location" {
  type        = string
  description = "description"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

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