######################
# General Attributes #
######################
variable "lb_name" {
  description = "Name of the Load Balancer"
  default = "Kao_LoadBalancer"
}

variable "resource_group" {
  description = "Name of the resource group"
  default = "test"
}

variable "location" {
  description = "location of the resource group"
  default = "East US"
}

