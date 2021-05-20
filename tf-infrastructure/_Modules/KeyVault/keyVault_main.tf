################
# Data Imports #
################
data "azurerm_resource_group" "app" { #Insinuating that this already exists or is created elsewhere to be imported/called upon in this module 
  name = var.resource_group_name #Defined when calling the Module 
}

resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name #"${var.application_name}vault${var.environment}"
  resource_group_name = data.azurerm_resource_group.app.name
  location            = data.azurerm_resource_group.app.location
  sku_name            = "standard"
  tenant_id           = var.tenant_id #data.azurerm_client_config.current.tenant_id

	access_policy {
    tenant_id = var.tenant_id #data.azurerm_client_config.current.tenant_id
    object_id = var.object_id #data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }

	tags = {
    environment = var.environment 
  }
  depends_on = [data.azurerm_resource_group.app]
}

resource "azurerm_key_vault_secret" "DbLogin" {
  name         = "dbLogin"
  value        = var.keyVault_secret_dbLogin #random_string.random.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
  depends_on = [azurerm_key_vault.kv]
}

output "key_vault_login_value" {
  value = azurerm_key_vault_secret.DbLogin.value
}

resource "azurerm_key_vault_secret" "DbPassword" {
  name         = "dbPassword"
  value        = var.keyVault_secret_dbPassword #random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
  depends_on = [azurerm_key_vault.kv]
}

output "key_vault_login_password_value" {
  value = azurerm_key_vault_secret.DbPassword.value
}
