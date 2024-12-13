# Managed Disks Terraform Module

The managed disks module in terraform will attach managed disks in an existing VM.

## Usage

```terraform
module "managedDisks" {
  source = "git::ssh://bitbucket.org//modules/ManagedDisks"

resource "azurerm_managed_disk" "managed_disk" {
  name                         = "vm-managed-disk01"
  location                     = "eastus"
  resource_group_name          = "resource_group_dev"
  storage_account_type         = "Standard_LRS"
  create_option                = "empty"
  disk_size_gb                 = 10
  }

resource "azurerm_virtual_machine_data_disk_attachment" "attach_disk" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = data.azurerm_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"

## Variables

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   name	|   name of the managed disk  |   string  |   yes |   vm-managed-disk01   |
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev  |
|   location	|   Azure Location    |    string  |   yes |   East US    |
|   create_option	|   method to use when creating the managed disk    |    string  |   yes |  empty    |
|   storage_account_type	|   type of the storage account    |    string  |   yes |   East US    |
|   disk_size_gb	|   size of the managed disk to create in gigabytes    |    string  |   yes |  10    |
|   lun         	|   The Logical Unit Number of the Data Disk           |    string  |   yes |  10    |
|   caching     	|Specifies the caching requirements for this Data Disk |    string  |   yes |  ReadWrite    |



# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2