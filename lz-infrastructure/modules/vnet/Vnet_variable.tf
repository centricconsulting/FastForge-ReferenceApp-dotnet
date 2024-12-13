variable "environment" {
   description = "Name of the resource group to be imported"
    default     = "test"
}
variable "project" {
    description = "Name of the project"
    default     = "kao"
}
variable "owner" {
    description = "Name of the owner"
    default     = "KAO"
}
variable "location" {
    description = "Name of the resource group to be imported"
    default     = "eastus"
}

variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}

variable "vnet_name" {
   description = "Name of the virtual network"
    default     = "vnet"
}
variable "address_space" {
    description = "Address space for the VNET"
    default     = ["10.0.0.0/16"]
}
variable "dns_servers" {
    description = "dns_servers for the VNET"
    default     = []
}
variable "subnets" {
  type=map(any)
  default = {
    subnet_1 = {
        name="subnet_1"
        address_prefixes=["10.0.1.0/24"]
    }
    subnet_2={
        name="subnet_2"
        address_prefixes=["10.0.2.0/24"]
    }
    subnet_3={
        name="subnet_3"
        address_prefixes=["10.0.3.0/24"]
    }
  }
}

