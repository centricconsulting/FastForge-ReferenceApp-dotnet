# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = ">=3.0.2"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

#Import existing Resource Group

data "azurerm_resource_group" "resource_group" {
    name = var.rg_name
}
data "azurerm_synapse_workspace" "synapse_workspace" {
  name                = var.synapse_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_synapse_sql_pool" "pool" {
  synapse_workspace_id = data.azurerm_synapse_workspace.synapse_workspace.id
  name                 = var.synapse_sql_pool_name
  sku_name             = var.synapse_sql_sku_name 
  collation            = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  data_encrypted       = var.synapse_sql_pool_data_encrypted
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }  
  depends_on           = [data.azurerm_resource_group.resource_group]
}