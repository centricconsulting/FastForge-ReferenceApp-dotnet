/*locals {
  vm_sizes {
    "Test_01" = "Standard_M32ls",
    "Test_02" = "Standard_M128s_v2"
  }
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  for_each            = local.vm_sizes
  name                = each.key
  resource_group_name = "resource_group_dev"
  location            = "East US"
  size                = each.value
  admin_username      = "azadm001"
  admin_password      = "Az@050322Az@"
  network_interface_ids = [
    azurerm_network_interface.win_net_interface.id,
  ]

  os_disk {
    name                 = "SAZ02CM001P_OsDisk_0" 
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}*/
