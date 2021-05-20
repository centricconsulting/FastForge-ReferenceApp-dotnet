################
# Data Imports #
################
data "azurerm_resource_group" "app" { #Insinuating that this already exists or is created elsewhere to be imported/called upon in this module 
  name = var.resource_group_name #Defined when calling the Module 
}

resource "azurerm_sql_server" "dbserver" {
  name                         = var.sql_server_name
  resource_group_name          = data.azurerm_resource_group.app.name
  location                     = data.azurerm_resource_group.app.location
  version                      = "12.0"
  administrator_login          = var.keyVault_secret_dbLogin    #azurerm_key_vault_secret.DbLogin.value
  administrator_login_password = var.keyVault_secret_dbPassword #azurerm_key_vault_secret.DbPassword.value

  depends_on = [data.azurerm_resource_group.app]
}

resource "azurerm_sql_firewall_rule" "allowServiceConnectionsRule" {
  name                = var.sql_firewall_name #"FirewallRule-${var.environment}"
  resource_group_name = data.azurerm_resource_group.app.name
  server_name         = azurerm_sql_server.dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [azurerm_sql_server.dbserver]
}

resource "azurerm_sql_database" "db" {
  name                = var.sql_db_name #"${var.application_name}-db-${var.environment}"
  resource_group_name = data.azurerm_resource_group.app.name
  location            = data.azurerm_resource_group.app.location
  server_name         = azurerm_sql_server.dbserver.name

  tags = {
    environment = var.environment
  }
  depends_on = [azurerm_sql_server.dbserver]
}

output "connection_string" {
  description = "Connection string for the Azure SQL Database created."
  value       = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}