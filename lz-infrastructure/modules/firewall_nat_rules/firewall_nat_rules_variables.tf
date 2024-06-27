variable "azure_firewall_name" {
  description = "(Required) Specifies the name of the Firewall in which the Network Rule Collection should be created. Changing this forces a new resource to be created."
  type = string
  default = "AZ_Firewall_test"
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
  type = string
  default = "test"
}

variable "location" {
  description = "(Required). Location"
  type = string
  default = "East US"
}

variable "rule_collections" {
  description = "(Required) One or more rules as defined https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html"
  type = list
  default = ["10.0.0.1/24", "10.0.0.2/16"]
}

/*variable "global_settings" {
  description = "Global settings object (see module README.md)"
  default
}*/

/*variable "ip_groups" {
  default = {}
}

variable "public_ip_addresses" {
  default = {}
}*/