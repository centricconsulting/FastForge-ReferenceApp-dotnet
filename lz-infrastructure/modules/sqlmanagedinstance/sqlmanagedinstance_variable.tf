## mandatory variables ##
#########################
variable "resource_group" {  
    description = "Name of the resource group to be imported"
     default = "resource_group_dev"
}
variable "sta_name" {
    description = "Name of the Storage Account to be imported"
    default     = "dev-sta"
}
variable "tags" {
    description = "The tags to associate with your resource(s)"
    type        = map(string)
    default = {
    }
}

/*variable "sqlmi_name" {
  description = "sql managed instance name"
  type        = string
  default = "sqlmi"
}*/

variable "vnet_name" {
    description = "sql managed instance vnet name on which to generate subnet for integration"
    type        = string
    default = "vnet_name"
}

variable "nsg_name" {
    description = "sql managed instance network security group name"
    type        = string
    default = "minsg"
}


variable "minsg" {
    type        = string
    default = "minsg"
}

variable "location" {
    type = string
    default = "East US"
}

variable "address_prefixes" {
    type = list
    default = ["10.1.1.0/16"]
}

variable "address_space_test" {
    type = list
    default = ["10.0.0.0/24"]
}