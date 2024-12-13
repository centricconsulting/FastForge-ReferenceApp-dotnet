######################
# General Attributes #
######################
variable "kv_name" {
  description = "Name of the Key Vault"
  default = "temp-kv"
}
variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}
variable "kv_skuname" {  
    description = "sku name for the Key vault"
    default     = "standard"
}

variable "kv_rbac_auth" {  
    description = "Enable RBAC Authorization for the Key vault"
    default     = "true"
}