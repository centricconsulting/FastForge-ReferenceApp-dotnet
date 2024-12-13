# # Configure the Microsoft Azure Provider
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
# Key vault
#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" { 
  name                         = var.kv_name
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  location                     = data.azurerm_resource_group.resource_group.location
  sku_name                     = var.kv_skuname
  soft_delete_retention_days   = 7
  purge_protection_enabled     = false
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization =   var.kv_rbac_auth #We are taking default as true
   lifecycle {
    ignore_changes = [
      tags,
    ]
  }  

  depends_on = [data.azurerm_resource_group.resource_group]
}
output "kv_name" {
  value = azurerm_key_vault.key_vault.name
}
output "kv_id" {
  value = azurerm_key_vault.key_vault.id
}

  
