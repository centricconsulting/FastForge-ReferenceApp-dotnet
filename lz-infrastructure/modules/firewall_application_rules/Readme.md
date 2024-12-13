# firewall_application_rules

Firewall_application_rules Terraform module 

## Usage

```terraform
module "firewall_application_rules" {
    source                = "./modules/firewall_application_rules"
    azurerm_firewall      = "az_firewall"
    resource_group        = "resource_group_dev"
    location              = "East US"
    firewall_application_rule_collection  = "az_rule_collection"
}

```

## Variables
| Variable                      	| Description              	| Type   	| Default             	| Required 	|
|-------------------------------	|--------------------------	|--------	|---------------------	|----------	|
| resource_group_name           	| Name of resource group   	| String 	| resource_group_dev  	| True     	|
|azurerm_firewall                 	| Name of firewall     	    | String 	| az_firewall           | True     	|
| location                      	| Location of the resource 	| String 	| East US             	| True     	|
|firewall_application_rule_collection| Name of Pipeline         | string 	| factoryPipelineDev    | True     	|


## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.