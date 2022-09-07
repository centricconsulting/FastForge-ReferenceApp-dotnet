terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.59.0" #Required for CosmosDB use. Newer versions are continuously created. Use the best version for your organization
        }
    }
    backend "azurerm" {
    }
}

provider "azurerm" {
  features {} 
#   GitHub Actions must have these 4 values defined. (Stored as a repository secret). Remove/comment them out for Azure DevOps deployments
#   subscription_id = "!__subscription_id__!"
#   client_id       = "!__client_id__!"
#   client_secret   = "!__client_secret__!"
#   tenant_id       = "!__tenant_id__!"
}
  
#######################
# Resource References # 
#######################
data "azurerm_client_config" "current" {
}

####################
# Random Resources # 
####################
resource "random_password" "password" {
    length  = 16
    special = true
    override_special = "_%@"
}

resource "random_string" "random" {
    length  = 16
    special = true
    override_special = "/@£$"
}

###########################################################################
# Module examples ~ Templates used to create all the modules listed below #
###########################################################################

# ~RESOURCE GROUP EXAMPLE~ #
module "resource_group" {
  source   = "./_Modules/ResourceGroup"
  rg_name     = "${var.application_name}-${var.environment}-RG"
  region      = var.region #In every other module, you can specify this region variable or utilize the output variable produced from the Resource Group Module
  environment = var.environment
}

# ~APP SERVICE PLAN EXAMPLE~ #
module "asp" {
  source   = "./_Modules/AppServicePlans" 
  resource_group_name   = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  region                = module.resource_group.rg_location
  app_service_plan_name = "${var.application_name}-${var.environment}-apisp"
  api_tier              = var.api_tier 
  api_size              = var.api_size
  environment           = var.environment

  depends_on  = [module.resource_group]
}

# ~APP INSIGHTS EXAMPLE~ #
module "appInsights" {
  source   = "./_Modules/AppInsights" 
  resource_group_name = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  region              = module.resource_group.rg_location
  app_insights_name   = "${var.application_name}-${var.environment}-appinsights"
  environment         = var.environment

  depends_on  = [module.resource_group] 
}

# ~KEY VAULT EXAMPLE~ #
module "keyVault" {
  source   = "./_Modules/KeyVault" 
  resource_group_name        = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  region                     = module.resource_group.rg_location
  key_vault_name             = "${var.application_name}-${var.environment}-kv01" #Must be within 3-24 lower case characters with dashes and numbers allowed. No Spaces 
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = data.azurerm_client_config.current.object_id
  keyVault_secret_dbLogin    = random_string.random.result
  keyVault_secret_dbPassword = random_password.password.result
  environment                = var.environment

  depends_on  = [module.resource_group]
}

# ~SQL DATABASE EXAMPLE~ #
module "sqldb" {
  source   = "./_Modules/SQLDatabase" 
  resource_group_name        = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  region                     = module.resource_group.rg_location
  sql_server_name            = "${var.application_name}-${var.environment}-dbserver"
  sql_firewall_name          = "FirewallRule-${var.environment}"
  sql_db_name                = "${var.application_name}-db-${var.environment}"
  keyVault_secret_dbLogin    = module.keyVault.key_vault_login_value
  keyVault_secret_dbPassword = module.keyVault.key_vault_login_password_value
  environment                = var.environment

  ### variables default to serverless Gen Purpose Gen v5.  To make provisioned change desired sku_name and 
  ### set min_capacity and auto_pause_delay_in_minutes to null
  # sku_name                   = "GP_Gen5_2"
  # min_capacity               = null
  # auto_pause_delay_in_minutes = null

  depends_on  = [module.resource_group, module.keyVault]
}

# ~APP SERVICE EXAMPLE~ #
module "appservice" {
  source   = "./_Modules/AppService"
  resource_group_name                      = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  region                                   = module.resource_group.rg_location
  app_service_plan_id                      = module.asp.app_service_plan_id #References ID defined in another module
  app_insights_key                         = module.appInsights.instrumentation_key
  application_name                         = "${var.application_name}-${var.environment}-app"
  #cosmosdb_name                            = "${var.application_name}-${var.environment}-cosmosdb" #Include line 111-112 if CosmosDB is used instead of SQLDB
  #cosmosdb_account_key                     = module.cosmosdb.cosmosdb_account_key
  sqldb                                    = true #Remove/Comment out lines 113-114 if CosmosDB is used instead of SQLDB
  connection_string                        = module.sqldb.connection_string
  performance_alert_id                     = module.appInsights.monitor_action_group_performance_alert_id
  shared_container_registry_login_server   = var.shared_container_registry_login_server 
  shared_container_registry_admin_username = var.shared_container_registry_admin_username
  shared_container_registry_admin_password = var.shared_container_registry_admin_password
  environment                              = var.environment
  image_name                               = "referenceapp.api"

  depends_on  = [module.resource_group, module.!__dbtype__!, module.asp, module.appInsights] #This module requires information from other Modules to properly run. Force organized deployments with Depends_on function
}

# ~WEB STORAGE ACCOUNT EXAMPLE~ #
module "web_storage_account" {
  source   = "./_Modules/WebStorageAccount"
  resource_group_name      = module.resource_group.rg_name
  region                   = module.resource_group.rg_location
  web_storage_account_name = "${var.application_name}web${var.environment}"
  environment              = var.environment

  depends_on  = [module.resource_group]
}

######################
# Optional resources #
###################### # Uncomment any of the below as it pertains to your resource needs
# ~COSMOS DATABASE EXAMPLE~ #
# module "cosmosdb" {
#   source   = "./_Modules/CosmosDB" 
#   resource_group_name = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
#   region                      = module.resource_group.rg_location
#   cosmosdb_account_name       = "${var.application_name}-${var.environment}-cosmosdb"
#   cosmosdb_account_kind       = var.cosmosdb_account_kind
#   #cosmosdb_account_free_tier  = true #This value can only be set to true once per subscription. Setting this to true essentially provides cost savings for the first CosmosDB Account
#   failover_location           = var.cosmosdb_account_failover_location
#   consistency_policy  = [{
#     consistency_level = var.cosmosdb_account_consistency_level
#   }]  
#   backup = [{
#     type = var.cosmosdb_account_backup_type 
#   }]
#   cosmosdb_name           = "${var.application_name}-${var.environment}-cosmosdb"
#   cosmosdb_container_name = "${var.application_name}-${var.environment}-cosmosdb-container"
#   environment             = var.environment

#   depends_on  = [module.resource_group]
# }
