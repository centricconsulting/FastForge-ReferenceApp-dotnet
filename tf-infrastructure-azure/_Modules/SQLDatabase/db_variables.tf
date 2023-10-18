variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "sql_server_name" { 
  description = "SQL server Name"
  type        = string
  default     = "temp-SQL-name"
}

variable "sql_firewall_name" { 
  description = "SQL firewall Name"
  type        = string
  default     = "temp-fw-name"
}

variable "sql_db_name" { 
  description = "SQL db Name"
  type        = string
  default     = "temp-db-name"
}

variable "environment" {
  description = "Environment variable used by Terraform resources"
  type        = string
  default     = "dev"
}

variable "keyVault_secret_dbLogin" { 
  description = "DB Login"
  type        = string
  default     = "temp"
}

variable "keyVault_secret_dbPassword" { 
  description = "DB Password"
  type        = string
  default     = "temp-Password"
}

variable "region" {
  description = "Region name"
  type        = string
  default     = "eastus"
}

variable "auto_pause_delay_in_minutes" {
  description = "Number of minutes of inactivity before serverless database is paused"
  type        = number
  default     = 60 # must be in the range (60 - 10080) and divisible by 10 or -1
}

variable "min_capacity" {
  description = "Minimum vCPU capacity of the serverless database"
  type        = number
  default     = 0.5 
}

variable "sku_name" {
  description = "Valid Azure MSSQL Sku"
  type        = string
  default     = "GP_S_Gen5_2"
}
