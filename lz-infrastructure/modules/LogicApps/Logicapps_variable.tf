######################
# General Attributes #
######################
variable "logic_app_name" {
  description = "Name of the Logic app"
  default = "lapp-temp"
}

variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}

