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