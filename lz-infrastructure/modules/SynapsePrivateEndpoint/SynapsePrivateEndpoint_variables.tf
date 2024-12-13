######################
# General Attributes #
######################
variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}
variable "synapse_name" {
  description = "Name of the Synapse Workspace"
  default     = "test"
}

# All defaults can be overwritten when the module is called in the primary "Main.tf" file
####################
# Private Endpoint #
####################
variable "synapse_private_endpoint" {
  description = "Looped Resource to create X Synapse private endpoints"
  default     = "temp"
}