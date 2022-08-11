resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name #"${var.application_name}vault${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.region
  sku_name            = "standard"
  tenant_id           = var.tenant_id #data.azurerm_client_config.current.tenant_id

	access_policy {
    tenant_id = var.tenant_id #data.azurerm_client_config.current.tenant_id
    object_id = var.object_id #data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", 
      "manageissuers", "purge", "recover", "restore", "setissuers", "update"
    ]

    key_permissions = [
      "backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapkey", "update",
      "update", "verify", "wrapkey"
    ]

    secret_permissions = [
      "backup", "delete", "get", "list", "purge", "recover", "restore", "set"
    ]
  }

	tags = {
    environment = var.environment 
  }
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
  sensitive   = true
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
  sensitive   = true
}
