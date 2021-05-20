variable "rg_name" { 
  description = "Name of the Resource Group to be created"
  type        = string
  default     = "rg-temp"
}

variable "region" {
  description = "Region variable used by Terraform resources"
  type        = string
  default     = "eastus2"
}