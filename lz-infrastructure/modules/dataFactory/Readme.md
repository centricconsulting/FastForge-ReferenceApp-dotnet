

The dataFactory Terraform module deploys an azure resource group with a Azure Data Factory

## Usage

```terraform
module "dataFactory" {
    source = "./modules/dataFactory"
    data_factName      = "straz02004t"
    resource_group = "resource_group_dev"
    location       = "East US"
    factory_pipeline_name  = "factoryPipelineDev"
    factory_trigger_schedule_name = "factorySchedulerDev"
}

```

## Variables
| Variable                      	| Description              	| Type   	| Default             	| Required 	|
|-------------------------------	|--------------------------	|--------	|---------------------	|----------	|
| resource_group_name           	| Name of resource group   	| String 	| resource_group_dev  	| True     	|
| data_factName                 	| Name of data factory     	| String 	| dataFactoryDev        | True     	|
| location                      	| Location of the resource 	| String 	| East US             	| True     	|
| factory_pipeline_name         	| Name of Pipeline         	| string 	| factoryPipelineDev    | True     	|
| factory_trigger_schedule_name 	| Trigger Name             	| string 	| factorySchedulerDev 	| True     	|

## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.