################
# Data Imports #
################
data "azurerm_resource_group" "app" { #Insinuating that this already exists or is created elsewhere to be imported/called upon in this module 
  name = var.resource_group_name #Defined when calling the Module 
}

resource "azurerm_storage_account" "web" {
  name                     = var.web_storage_account_name #"${random_pet.server.id}web${var.environment}"
  resource_group_name      = data.azurerm_resource_group.app.name
  location                 = data.azurerm_resource_group.app.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
	allow_blob_public_access = true

	static_website {
		index_document = "index.html"
	}	
}

output "web_app_url" {
  description = "WEB APP URL"
  value       = azurerm_storage_account.web.primary_web_endpoint
}