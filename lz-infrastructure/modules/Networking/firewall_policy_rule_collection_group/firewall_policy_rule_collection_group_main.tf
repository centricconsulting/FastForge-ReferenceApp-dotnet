# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = ">=3.0.2"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

/*resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}*/

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name 
}


resource "azurerm_firewall_policy" "resource_group" {
  name                = "resource_group-fwpolicy"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
}

resource "azurerm_firewall_policy_rule_collection_group" "resource_group" {
  name               = "resource_group-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.resource_group.id
  priority           = 500
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "1000-2000"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }
}
