variable "nsg_name" {
  type        = string
  description = "The name of the network security group."
  default     = "nsg_kao"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the network security group."
  default     = "test"
}

variable "location" {
  type        = string
  description = "The location/region where the network security group is created. "
  default     = "East US"
}

