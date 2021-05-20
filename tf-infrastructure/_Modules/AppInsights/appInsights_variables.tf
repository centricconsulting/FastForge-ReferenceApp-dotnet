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