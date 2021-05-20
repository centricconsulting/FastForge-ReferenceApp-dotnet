variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "app_service_name" {
  description = "Name of the app service plan to be imported."
  type        = string
  default     = "temp-asp"
}

variable "app_service_plan_id" {
  description = "ID of the app service plan to be imported."
  type        = string
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
}

variable "performance_alert_id" { 
  description = "Performance Alert ID from the Monitor Action Group"
  type        = string
}