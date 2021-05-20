variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

variable "web_storage_account_name" { 
  description = "Web Storage Account Name"
  type        = string
  default     = "temp-sa-name"
}