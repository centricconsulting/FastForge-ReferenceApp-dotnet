variable "resource_group_name" {
  type = string
  default = "test"
}

variable "location" {
  type = string
  description = "Location for the deployment"
 default = "East US"
}



variable "sqlserver_name" {
  type = string
  description = "SQL server Name"
  default     = "sqlserver_kao_test"
}

variable "admin_username" {
  description = "The administrator login name for the new SQL Server"
  default     = "Kaosqladmin"
}

variable "admin_password" {
  description = "The password associated with the admin_username user"
  default     = "dog1234$"
}

variable "keyVault_secret_login" { 
    description = "Administrative Login username"
    default     = "temp"
}
variable "keyVault_secret_pw" { 
    description = "Administrative Login Password"
    default     = "temp-Password"
}

variable "database_name" {
  description = "The name of the database"
  default     = "db01"
}

variable "sql_database_edition" {
  description = "The edition of the database to be created"
  default     = "Standard"
}



variable "firewall_rules" {
  description = "Range of IP addresses to allow firewall connections."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

