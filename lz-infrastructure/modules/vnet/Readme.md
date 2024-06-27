# **terraform-azurerm-vnet**
  
## Terraform Module to create Azure virtual network with NSG, Subnet, nat Gateway and route table association.
  ---
# **Type of resources are supported**

  - Virtual Network
  - Subnets
  - Subnet Service Delegation
  - Subnet nat gateway/ association
  - Virtual network route table
  - Virtual Network service endpoints
  - virtual network peering
  - Private Link service/Endpoint network policies on Subnet
  - network interface 
  - Network Security Groups
  
### By default, this module will not create a resource group, proivde the name here to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = true`. Location will be same as existing RG.

# Usage

```python
provider "azurerm" {
  features {}
}
module "vnet" {
    source = "./modules/vnet"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "resource_group_dev"
  location = "East US"
}

  resource_group                  = "resource_group_dev"
  location                        = "East US"
  azurerm_virtual_network         = "vnet-01 vnet-02"
  address_space                   = ["10.0.0.0/16"]
  subnet_prefixes                 = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names                    = ["public-subnet", "private-subnet"]
  dns_servers                     = ["8.8.8.8", "8.8.4.4"]
  azurerm_virtual_network_peering = "vnet1to2"
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
```
---
# Arguments

Name	   |Description   |	Type  |Default    |
---------|--------------------|---------------|-----------|
resource_group_name| The name of the resource group in which resources are created| 	string |	resource_group_dev |
location |The location of the resource group in which resources are created| string	| East US |
vnetwork_name|	The name of the virtual network	| string	|  vnet |
vnet_address_space |	Virtual Network address space to be used	| list	|  []  |
dns_servers	| List of DNS servers to use for virtual network | list |	[] |
subnets  |	For each subnet, create an object that contain fields	 | object	|  {}  | 
subnet_name | 	A name of subnets inside virtual network  | 	object  | 	{}  |
subnet_address_prefix | A list of subnets address prefixes inside virtual network | list	| {}  |
gateway_subnet_address_prefix	| The address prefix to use for the gateway subnet | list | 	null |
service_endpoints	| service endpoints for the virtual subnet |	object |	{} |
nsg_inbound_rule	| network security groups settings NSG is created for each subnet	| object | 	{} |
nsg_outbound_rule	| network security groups settings NSG is created for each subnet| object|	{}| 
Tags	| A map of tags to add to all resources	 | map	| {}  |


# Example adding a route table

```python
# Create Route Table for Public Subnet
resource "azurerm_route_table" "public-rt" {
  depends_on                    = [azurerm_subnet.public-subnet]
  name                          = "${var.environment}-${var.project}-public-rt"
  location                      = var.location
  resource_group_name           = var.resource_group
  disable_bgp_route_propagation = false


  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}
```
----
# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2



