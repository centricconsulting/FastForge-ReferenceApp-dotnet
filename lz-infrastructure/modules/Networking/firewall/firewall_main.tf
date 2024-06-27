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
  name     = var.resource_group
  location = var.location
}*/

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name 
}


resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "firewall_subnet"
  resource_group_name  = var.resource_group_name 
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewall_public_ip" {
  name                = var.public_ip_id
  location            = var.location
  resource_group_name = var.resource_group_name 
  allocation_method   = "Static"
}

resource "azurerm_firewall" "firewall" {
  name                = "azure_firewall"
  location            =  var.location
  resource_group_name = var.resource_group_name 
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}