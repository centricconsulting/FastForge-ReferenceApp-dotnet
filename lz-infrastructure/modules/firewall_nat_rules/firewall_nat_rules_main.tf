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

/*data "azurerm_resource_name" "resource_group_name" {
  name = var.resource_group_name
}*/

resource "azurerm_virtual_network" "vnet_test" {
  name                = "testvnet_kao"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "az_subnet_test" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_test.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "az_ip_test" {
  name                = "testpip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "az_firewall_test" {
  name                = "testfirewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.az_subnet_test.id
    public_ip_address_id = azurerm_public_ip.az_ip_test.id
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection_test" {
  name                = "testcollection"
  azure_firewall_name = azurerm_firewall.az_firewall_test.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "testrule"

    source_addresses = [
      "10.0.0.0/16",
    ]

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      azurerm_public_ip.az_ip_test.ip_address
    ]

    translated_port = 53

    translated_address = "8.8.8.8"

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}