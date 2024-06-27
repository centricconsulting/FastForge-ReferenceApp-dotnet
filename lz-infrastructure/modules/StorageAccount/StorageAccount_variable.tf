

variable "resource_group_name" {
  type = string
  default = "test"
}

variable "location" {
  type = string
  description = "Location for the deployment for storage account"
 default = "East US"
}

variable "storage_account_name" {
  type = string
  description = "Name of Storage account to be created"
  default = "straz02004t"
} 



