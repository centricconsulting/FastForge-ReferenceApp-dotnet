resource "azurerm_resource_group" "app" {
  name     = var.rg_name #"${var.application_name}_${var.environment}"
  location = var.region
}
output "rg_name" {
  value    = azurerm_resource_group.app.name
}

output "rg_location" {
  value    = azurerm_resource_group.app.location
}