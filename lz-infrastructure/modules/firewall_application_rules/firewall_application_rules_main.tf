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
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

resource "azurerm_virtual_network" "azure_vnet" {
  name                = "kao_testvnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "az_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "az_pub_ip" {
  name                = "testpip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "az_firewall" {
  name                = "testfirewall"
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.az_subnet.id
    public_ip_address_id = azurerm_public_ip.az_pub_ip.id
  }
}

resource "azurerm_firewall_application_rule_collection" "az_rule_collection" {
  name                = "testcollection"
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "testrule"

    source_addresses = [
      "10.0.0.0/16",
    ]

    target_fqdns = [
      "*.google.com",
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
}