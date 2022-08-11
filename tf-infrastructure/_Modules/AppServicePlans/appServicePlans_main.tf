################
# Module Start #
################
# App Service Plan Creation #
resource "azurerm_app_service_plan" "api" {
  name                = var.app_service_plan_name #${var.application_name}-apisp-${var.environment}
  location            = var.region
  resource_group_name = var.resource_group_name
  kind                = "Linux"
	reserved = true

  sku {
    tier = var.api_tier
    size = var.api_size
  }
  tags = {
    environment = var.environment
  }  
}

output "app_service_plan_name" {
  value = azurerm_app_service_plan.api.name
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.api.id
}