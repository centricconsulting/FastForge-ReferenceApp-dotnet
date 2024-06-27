

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

/*resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}*/

/*resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}
*/

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name 
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "sqldbstoragekao"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_mssql_server" "app_sqlserver" {
  name                         = var.sqlserver_name
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  location                     = var.location 
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  #administrator_login          = var.keyVault_secret_login   #in case we want to use the username in KeyuVault secret.
  #administrator_login_password = var.keyVault_secret_pw     #in case we want to use the Password in KeyuVault secret.
}

resource "azurerm_mssql_database" "sqldb" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.app_sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
   depends_on = [
     azurerm_mssql_server.app_sqlserver
   ]
}

resource "azurerm_mssql_firewall_rule" "app_server_firewall_rule" {
  name                = "sqlfirewall_rule_kao"
  server_id           = azurerm_mssql_server.app_sqlserver.id
  start_ip_address    = "10.0.0.0"
  end_ip_address      = "10.0.0.10"
   depends_on = [
     azurerm_mssql_server.app_sqlserver
   ]
}

