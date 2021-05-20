variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "key_vault_name" {
  description = "Name of the key vault"
  type        = string
  default     = "temp-kv"
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
  default     = "eastus2"
}

variable "object_id" {
  description = "Object ID"
  type        = string
  default     = "eastus2"
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