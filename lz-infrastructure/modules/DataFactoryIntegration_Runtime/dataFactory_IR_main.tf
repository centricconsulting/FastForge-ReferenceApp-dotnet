# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = ">=3.0.2"
#     }
#   }
# }

# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
# }

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group
}

data "azurerm_data_factory" "data_factory_name" {
  name                = var.data_fact_name
  resource_group_name = var.resource_group
}

resource "azurerm_data_factory_integration_runtime_azure_ssis" "test_azurerm_data_factory_integration_runtime_managed" {
  name            = var.data_fact_IR_test
  data_factory_id = data.azurerm_data_factory.data_factory_name.id
  location        = var.location

  node_size = "Standard_D8_v3"
}