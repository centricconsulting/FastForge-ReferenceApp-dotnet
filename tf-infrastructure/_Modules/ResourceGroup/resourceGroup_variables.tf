variable "rg_name" { 
  description = "Name of the Resource Group to be created"
  type        = string
  default     = "rg-temp"
}

variable "environment" {
  description = "Environment variable used by Terraform resources"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region variable used by Terraform resources"
  type        = string
  default     = "eastus2"
}