################
# Data Imports #
################
data "azurerm_resource_group" "app" { #Insinuating that this already exists or is created elsewhere to be imported/called upon in this module 
  name = var.resource_group_name #Defined when calling the Module 
}

################
# Module Start #
################
# App Service Plan Creation #
resource "azurerm_app_service_plan" "api" {
  name                = var.app_service_plan_name #${var.application_name}-apisp-${var.environment}
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
  kind                = "Linux"
	reserved = true

  sku {
    tier = var.api_tier
    size = var.api_size
  }
  depends_on = [data.azurerm_resource_group.app]
}

output "app_service_plan_name" {
  value = azurerm_app_service_plan.api.name
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.api.id
}