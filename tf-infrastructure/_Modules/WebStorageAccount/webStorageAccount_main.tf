resource "azurerm_storage_account" "web" {
  name                     = var.web_storage_account_name 
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  blob_properties {
    versioning_enabled = true	  
  }
  static_website {
    index_document = "index.html"
  }	
  tags = {
    environment = var.environment
  }  
}

output "web_app_url" {
  description = "WEB APP URL"
  value       = azurerm_storage_account.web.primary_web_endpoint
}
