The StorageAccount Terraform module deploys an azure resource group with a simple assocaited storage account.

## Usage

```terraform
module "StorageAccount" {
    source = "./modules/StorageAccount"
    key_vault      = "straz02004t"
    resource_group = "resource_group_dev"
    location       = "East US"
}

```

## Variables

| Variable             	| Description              	| Type   	| Default            	| Required 	|
|----------------------	|--------------------------	|--------	|--------------------	|----------	|
| resource_group_name  	| Name of resource group   	| String 	| resource_group_dev 	| True     	|
| storage_account_name 	| Name of Storage account  	| String 	| straz02004t        	| True     	|
| location             	| Location of the resource 	| String 	| East US            	| True     	|


## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.