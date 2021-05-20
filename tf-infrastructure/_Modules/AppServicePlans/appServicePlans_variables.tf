variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "app_service_plan_name" { 
  description = "App Service Plan Name"
  type        = string
  default     = "temp-asp-name"
}

variable "api_tier" {
  description = "API Tier"
  type        = string
  default     = "Standard"
}

variable "api_size" {
  description = "API Size"
  type        = string
  default     = "S1"
}