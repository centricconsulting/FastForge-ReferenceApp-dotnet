variable "azure_firewall_name" {
  description = "(Required) Specifies the name of the Firewall in which the Network Rule Collection should be created. Changing this forces a new resource to be created."
  type = string
  default = "az_firewall_test"
}

variable "rg_name" {
  type = string
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
  default = "test"
}

variable "location" {
  type = string
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
  default = "East US"
}

variable "rule_collections" {
  description = "(Required) One or more rules as defined https://www.terraform.io/docs/providers/azurerm/firewall_network_rule_collection.html"
  type = list
  default = ["10.0.0.1/24", "10.0.0.2/16"] 
}

/*variable "azurerm_firewall_application_rule_collection_definition" {}
variable "global_settings" {
  description = "Global settings object (see module README.md)"
}*/

variable "ip_groups" {
  default = {}
}