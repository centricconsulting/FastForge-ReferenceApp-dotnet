# Not touching this module as it looks like it was commented out. Not entirely sure on the reasoning yet. 

# resource "azurerm_container_registry" "acr" {
#   name                     = var.shared_container_registry_name
#   resource_group_name      = azurerm_resource_group.sharedrg.name
#   location                 = azurerm_resource_group.sharedrg.location
#   sku                      = "Basic"
#   admin_enabled            = true
#   # admin_username            = random_string.random.result
#   # admin_password            = random_password.password.result
#   # georeplication_locations = ["East US"]	
# }

# output "login_server" {
# 	description = "Login Server for the Azure Container Registry"
#   value = azurerm_container_registry.acr.login_server
# }