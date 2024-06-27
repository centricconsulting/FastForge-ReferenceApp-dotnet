# Vnet Peering Terraform Module

The Vnet Peering Terraform module generates vnet peering between two Virtual networks which can be on separate subscriptions.


  ---
# Usage


```terraform
module "vnetPeering" {
  source = "git::ssh://bitbucket.org/vnetpeering"

  resource "azurerm_virtual_network" "vnet-01" {
  name                = "vnet01"
  resource_group_name = "resource_group_dev
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  }

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet-02" {
    name                = "vnet02"
  resource_group_name = "resource_group_dev1"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
}

# Create a virtual network peering within the resource group
resource "azurerm_virtual_network_peering" "vnet-peering-01" {
  name                      = "vnet1to2"
  resource_group_name       = "resource_group_dev"
  virtual_network_name      = azurerm_virtual_network.vnet-01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-02.id
}

# Create a virtual network peering within the resource group
resource "azurerm_virtual_network_peering" "vnet-peering-02" {
  name                      = "vnet2to1"
  resource_group_name       = "resource_group_dev1"
  virtual_network_name      = azurerm_virtual_network.vnet-02.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-01.id
}
```
---
# Arguments

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev\resource_group_dev1  |
|   location	|   Azure Location    |    string  |   yes |   East US    |
|    virtual_network_name   |    name of the virtual networks  |   string  |   yes |   vnet1\vnet2  |
|   address_space	|   address space that is used the vnets    |    string  |   yes |   ["10.0.0.0/16"]    |  
|   dns_servers	|   list of ip addresses of DNS servers   |    string  |   yes |   ["8.8.8.8", "8.8.4.4"]   |      



# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2