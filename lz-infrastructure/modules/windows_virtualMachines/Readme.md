# **Azure Virtual Machines Terraform Module**
  
## Terraform module to deploy azure Windows virtual machines.

  ---
# Usage


```python
module "windows_virtualMachines" {
  source = "git::ssh://bitbucket.org/windows_virtualMachines"

  windows_virtual_machine  = "win_vm"
  resource_group           = "resource_group_dev"
  location                 = "East US"
  virtual_network          = "win_vnet"
  Subnet_name              = "win_subne"
  network_interface        = "win_net_interface"
  windows_virtual_machine  = "win_vm"
  network_security_group   = "win_NS"
}
```
---
# Arguments


Name                | Description | Type     | Default   | Required |
---------|--------- |----------|-----------|----------|
resource_group_name |The name of the Resource group where the new VM will be deployed.|  String | resource_group_dev| True|               |          | 
location           | The Azure Region where the VM will be deployed | String | East US | True |
vm_name            | The name to assign to the new Virtual machine | String     |  win_vm         |True    |       |         |       
subnet_id|The ID of the Azure Subnet where the main NIC of the VM will be created|String  | win_subnet  | True  |
vm_size     |The Virtual Machine SKU for the Virtual Machine | String |  Standard LRS  | False 
network_security_group | network security group for the virtual machine | String | vm_nsg | True 
network_interface | network interface card | String |  vm_net_interface | True
admin_username | 	The username for the Admin User Account | String  | adminuser | True |
admin_password | 	The password to assign to the Admin username | String | generate a password using a secure method| True |
storage_os_disk_config | 	A map object defining the system disk| map |  OsDisk_default |  false |
source_image_id   | An ID of a Custom Image if deploying a custom VM Image | string | false |
os_disk_caching | The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite| String | "ReadWrite" | True | 

## Deploying Multiple VMS Using for_each when calling the Module



```python
resource "azurerm_windows_virtual_machine" "win_vm" {
  for_each            = var.vm_sizes
  name                = each.key
  resource_group_name = var.resource_group
  location            = var.location
  size                = each.value
  admin_username      = "adminuser"
  admin_password      = "adminpassword
  network_interface_ids = [
    azurerm_network_interface.win_net_interface.id,
  ]

  os_disk {
    name                 = "Win_OsDisk_default" 
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
```

# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2