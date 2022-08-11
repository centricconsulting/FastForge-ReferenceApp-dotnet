variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "app_service_plan_id" {
  description = "ID of the app service plan to be imported."
  type        = string
  default     = "temp-id"
}

variable "shared_container_registry_login_server" {
  description = "Shared Container registry login"
  type        = string
  default     = "temp-value"
}

variable "application_name" { 
  description = "Application Name"
  type        = string
  default     = "temp-app-name"
}

variable "cosmosdb_name" { 
  description = "Optional CosmosDB Name"
  type        = string
  default     = "temp-cosmosdb-name"
}

variable "cosmosdb_account_key" { 
  description = "Optional CosmosDB primary account key"
  type        = string
  default     = "tempkey"
}

variable "sqldb" { 
  description = "True or False boolean on if the app service is using a sqldb"
  type        = string
  default     = "false"
}

variable "shared_container_registry_admin_username" {
  description = "Shared Container registry admin username"
  type        = string
  default     = "temp-username"
}

variable "shared_container_registry_admin_password" {
  description = "Shared Container admin password"
  type        = string
  default     = "temp-password"
}

variable "app_insights_key" {
  description = "Key of the app insights to be imported."
  type        = string
  default     = "temp-app-insights"
}

variable "connection_string" {
  description = "Connection String for App Service"
  type        = string
  default     = "value"
}

variable "performance_alert_id" { 
  description = "Performance Alert ID from the Monitor Action Group"
  type        = string
  default     = "temp-value"
}

variable "environment" {
  description = "Environment variable used by Terraform resources"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region name"
  type        = string
  default     = "eastus"
}