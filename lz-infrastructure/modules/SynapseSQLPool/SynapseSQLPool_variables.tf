######################
# General Attributes #
######################
variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}
variable "synapse_name" {
  description = "Name of the Synapse Workspace"
  default     = "temp-synapse-workspace"
}

# All defaults can be overwritten when the module is called in the primary "Main.tf" file
####################
# Synapse SQL Pool #
####################
variable "synapse_sql_pool_name" {
  description = "Name of the Synapse SQL Pool"
  default     = "temp"
}
variable "synapse_sql_sku_name" {
  description = "SKU of the Synapse SQL Pool"
  default     = "DW100c"
}
variable "synapse_sql_pool_data_encrypted" {
  description = "Boolean call on whether or not transparent data is encrypted"
  default     = false
}