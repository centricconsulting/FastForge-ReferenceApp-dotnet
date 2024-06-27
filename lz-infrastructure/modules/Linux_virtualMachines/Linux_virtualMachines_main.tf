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


/*resource "azurerm_resource_group" "resourcegrp_name" {
  name      = var.resource_group
  location  = var.location
}*/

data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}


resource "azurerm_virtual_network" "lxvm_vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "lxvm_subnet" {
  name                 = var.lxvm_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.rg_name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lxvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "lx_vm" {
  for_each            = toset(var.vm_names)
  name                = each.value
  resource_group_name = var.rg_name
  location            = var.location
  size                = each.value
  admin_username      = "azadm001"
  admin_password      = "Az@050322Az@"
  network_interface_ids = [
    azurerm_network_interface.nic[each.value].id,
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

/*resource "azurerm_network_security_group" "lxvm_NSG" {
  name                = "NSG01"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "Win_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}*/

/*resource "azurerm_managed_disk" "lxvm_disk" {
  for_each            = toset(var.vm_names)
  name                 = "SAZ02CM004T_DataDisk_0"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.linux_disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux_data_disk" {
  for_each           =  var.vm_sizes
  managed_disk_id    = azurerm_managed_disk.lxvm_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.lx_vm[each.key].id
  lun                = "10"
  caching            = "ReadWrite"
}*/

