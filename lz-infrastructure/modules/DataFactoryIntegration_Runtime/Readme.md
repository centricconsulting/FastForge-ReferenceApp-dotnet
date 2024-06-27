

The dataFactory Terraform module deploys an azure resource group with a Azure Data Factory

## Usage

```terraform
module "DataFactoryIntegration_Runtime" {
    source = "./modules/DataFactoryIntegration_Runtime"
    data_data_fact_IR_name  = "dataFactoryDevIR"
    
}

```

## Variables
| Variable          	| Description               	| Type   	| Default          	| Required 	|
|-------------------	|---------------------------	|--------	|------------------	|----------	|
| data_fact_IR_name 	| Integration Run time Name 	| String 	| dataFactoryDevIR 	| True     	|

## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.