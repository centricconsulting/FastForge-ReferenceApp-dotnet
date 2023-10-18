variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "app_insights_name" { 
  description = "Application Insights Name"
  type        = string
  default     = "temp-app-insights-name"
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