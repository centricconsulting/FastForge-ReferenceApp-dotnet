/* terraform {
   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = ">=3.0.2"
     }
   }
 }
  Configure the Microsoft Azure Provider
 provider "azurerm" {
   features {}
 }*/

 /*resource "azurerm_resource_group" "resource_group"{
   name      = var.resource_group
   location  = var.location
 }*/

data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

 resource "azurerm_network_security_group" "nsg" {
   name                = var.nsg_name
   location            = var.location
   resource_group_name = data.azurerm_resource_group.resource_group.name
 }

 resource "azurerm_network_security_rule" "outbound_rules" {
   name                        = "outbound_rules"
   priority                    = 100
   direction                   = "Outbound"
   access                      = "Allow"
   protocol                    = "Tcp"
   source_port_range           = "*"
   destination_port_range      = "*"
   source_address_prefix       = "*"
   destination_address_prefix  = "*"
   resource_group_name         = data.azurerm_resource_group.resource_group.name
   network_security_group_name = azurerm_network_security_group.nsg.name
 }

 resource "azurerm_network_security_rule" "Inbound_rules" {
     name                       = "Inbound_rules"
     priority                   = 100
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "*"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
     resource_group_name        = data.azurerm_resource_group.resource_group.name
     network_security_group_name = azurerm_network_security_group.nsg.name
   }
