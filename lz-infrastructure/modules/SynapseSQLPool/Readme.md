# Synapse SQL Pool Terraform Module

This Terraform module deploys and manages Synapse SQL Pool.

## Usage

```terraform
module "SynapseSQLPool" {
resource "azurerm_synapse_sql_pool" "pool" {
  name                 = "synapsesqlpool"
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  sku_name             = "DW100c"
  collation            = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

```

## Variables

| Variable             	| Description              	| Type   	| Default            	| Required 	|
|----------------------	|--------------------------	|--------	|--------------------	|----------	|
|   name  	            |   Name of SQL Pool   	    | String 	|    synapsesqlpool 	| True     	|
| sku_name           	| sku of Synapse SQL pool  	| String 	|     DW100c           	| True     	|
| location             	| Location of the resource 	| String 	|     East US          	| True     	|


## Contributing
Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.