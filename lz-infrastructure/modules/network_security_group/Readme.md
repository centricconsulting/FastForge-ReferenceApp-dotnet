## **Azure Network Security Group - Terraform Module**

## This module creates an Azure Network Security Group and allows you to manage multiple inbound and outbound rules
## **Usage** 

```python
provider "azurerm" {
  features {}
}
module "network_security_group" {
    source = "./modules/network_security_group"
}

azurerm_resource_group = "resource_group_dev"{
location               = "East US"
network_security_group = "nsg_name"
}

```
----
## Manages multiple outbound and inbound security rules. 

```python

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
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg.name

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
    resource_group_name         = azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
```
## Argument Reference

Name	   |Description   |	Type  |Default    |
---------|--------------------|---------------|-----------|
resource_group_name| The name of the resource group in which resources are created| 	string |	resource_group_dev |
location |The location of the resource group in which resources are created| string	| East US |
network_securuty_group |	The name of the network group	| string	|  nsg_name |
network_security_rule| Virtual Network inboud/outbound security rule| list	|  "*"  |

# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2

