## Azure Firewall Terraform Module

Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources.

## Resources Supported

- Azure Firewall
- Azure Firewall Subnet
- Firewall Forced Tunneling
- Firewall Application Rule Collection
- Firewall NAT Rule Collection
- Firewall Network Rule Collection
---
## Module Usage

```python
provider "azurerm" {
  features {}
}
module "Networking" {
    source        = "./modules/Networking/firewall"
    resource_group = "resource_group_dev"
    azurerm_virtual_network       = "East US"
    azurerm_firewall = "firewall"
}
```
---
## Variables
| Variable                      	| Description              	| Type   	| Default             	| Required 	|
|-------------------------------	|--------------------------	|--------	|---------------------	|----------	|
| resource_group_name           	| Name of resource group   	| String 	| resource_group_dev  	| True     	|
|azurerm_firewall                 	| Name of firewall     	    | String 	| az_firewall           | True     	|
| location                      	| Location of the resource 	| String 	| East US             	| True     	|
|firewall_application_rule_collection| Name of Pipeline         | string 	| factoryPipelineDev    | True     	|


## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.
