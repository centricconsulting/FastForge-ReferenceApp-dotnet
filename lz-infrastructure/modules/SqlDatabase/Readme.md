The StorageAccount Terraform module deploys an azure resource group with a simple assocaited storage account.

## Usage

```terraform
module "SqlDatabase" {
    source = "./modules/SqlDatabase"
    name     = "sqlserver"
    resource_group = "resource_group_dev"
    location       = "East US"
}

```

## Variables

| Variable             	| Description            	| Type    	| Default            	| Required 	|
|----------------------	|------------------------	|---------	|--------------------	|----------	|
| resource_group_name  	| Name of resource group 	| String  	| resource_group_dev 	| True     	|
| azurerm_mssql_server 	| SQL Server Name        	| String  	| sqlserver          	| True     	|
| location             	| Location               	| String  	| East US            	| True     	|
| admin_username       	| Admin User Name        	| String  	| AdminUser          	| True     	|
| admin_password       	| Admin password         	| String  	| NULL               	| True     	|
| database_name        	| Name of SQL Database   	| String  	| db01               	| True     	|
| firewall_rules       	| Firewall Rules         	| List    	| NULL               	| True     	|
## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.