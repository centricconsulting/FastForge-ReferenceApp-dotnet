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
  name = var.rg_name
}

data "azurerm_virtual_machine" "vm" {
  name = var.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group
}


resource "azurerm_managed_disk" "managed_disk" {
  count                        = var.number_of_disks
  name                         = "${data.azurerm_virtual_machine.vm.name}-disk${count.index+1}"
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  location                     = data.azurerm_resource_group.resource_group.location
  storage_account_type         = var.storage_account_type
  create_option                = "Empty"
  disk_size_gb                 = var.disk_size_gb
  depends_on = [data.azurerm_resource_group.resource_group, data.azurerm_virtual_machine.vm]
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach_disk" {
  count              = var.number_of_disks
  managed_disk_id    = azurerm_managed_disk.managed_disk[count.index].id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = "${10+count.index}"
  caching            = var.caching

   lifecycle {
    ignore_changes = [
      tags,
    ]
  }  

  depends_on = [data.azurerm_resource_group.resource_group, data.azurerm_virtual_machine.vm, azurerm_managed_disk.managed_disk]
}

/*
output "managed_disk_name" {
  value = azurerm_managed_disk.managed_disk.name
}
output "managed_disk_id" {
  value = azurerm_managed_disk.managed_disk.id
}
*/