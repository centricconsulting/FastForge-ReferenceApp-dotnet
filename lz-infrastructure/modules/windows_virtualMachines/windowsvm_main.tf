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

#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group 
}

resource "azurerm_virtual_network" "win_vnet" {
  name                = var.win_vnet_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "winvm_subnet" {
  name                 = var.winvm_subnet_name
  virtual_network_name = var.win_vnet_name
  resource_group_name  = var.resource_group
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "win_nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-win_nic"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.winvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  for_each            = toset(var.vm_names)
  name                = each.value
  resource_group_name = var.resource_group
  location            = var.location
  size                = each.value
  admin_username      = "azadm001"
  admin_password      = "Az@050322Az@"
  network_interface_ids = [
    azurerm_network_interface.win_nic[each.value].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
