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

data "azurerm_resource_group" "resource_group" {
  name = var.rsg_name
}

resource "azurerm_data_factory" "data_factory_name" {
  name                = var.data_factName
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_data_factory_pipeline" "data_fact_pipeline" {
  name            = var.factory_pipeline_name
  data_factory_id = azurerm_data_factory.data_factory_name.id
}

resource "azurerm_data_factory_trigger_schedule" "factory_trigger_schedule" {
  name            = var.factory_trigger_schedule_name
  data_factory_id = azurerm_data_factory.data_factory_name.id
  pipeline_name   = azurerm_data_factory_pipeline.data_fact_pipeline.name

  interval  = 5
  frequency = "Day"
}

