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
data "azurerm_resource_group" "resource-group" {
    name = var.rg_name
}
data "azurerm_synapse_workspace" "synapse-workspace" {
  name                = var.synapse_name
  resource_group_name = data.azurerm_resource_group.resource-group.name
}

resource "azurerm_synapse_managed_private_endpoint" "private-endpoint" {
    for_each             = var.synapse_private_endpoint            
    synapse_workspace_id = data.azurerm_synapse_workspace.synapse-workspace.id
    name                 = each.value["spe_name"]           
    target_resource_id   = each.value["spe_target_id"]        
    subresource_name     = each.value["spe_subresource_name"] 
    lifecycle {
      ignore_changes = all
   }  
}