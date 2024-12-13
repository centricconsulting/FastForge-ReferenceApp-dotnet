
terraform {
    backend "azurerm" {
        resource_group_name  = "Test"
        storage_account_name = "straz02004t"
        container_name       = "ctraz02006t"
        key                  = "test-backend"
    }
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.9.0"
        }
    }
}

provider "azurerm" {
  features {}
}

data azurerm_resource_group "rg"{
    name = "test"
}

module "KeyVault" {
   source = "./modules/KeyVault"
   kv_name    = "vlt-${var.project}-${var.environment}" 
    rg_name    = data.azurerm_resource_group.rgname.name
  kv_skuname = "standard"
  kv_rbac_auth = "true"
}

data azurerm_resource_group "rgname"{
    name = "test"
}

module "LogicApps" {
  source = "./modules/LogicApps"
  logic_app_name    = "lapp-${var.project}-${var.environment}" 
 }


/*data azurerm_resource_group "rg_name"{
    name = "RSGAZ06002P"
}
 module "AusSouthEastVM"   {
    source = "./modules/AusSouthEastVM"
}*/

/*data azurerm_resource_group "resource_grp"{
    name = "test"
}*/

#Not Needed
/*module "load_balancers" {
     source = "./modules/Networking/load_balancers"
      rg_name    = data.azurerm_resource_group.rg.name
 }*/

/*data azurerm_resource_group "resorcergname"{
    name = "test"
}*/

/*module "blob" {
     source = "./modules/blob"
}*/

data azurerm_resource_group "resource_group" {
    name = "test"
}

module "network_security_group" {
     source = "./modules/network_security_group"
     rg_name    = data.azurerm_resource_group.resource_group.name
 }

# data "azurerm_resource_group" "resource_group" {
#   name = var.resource_group_name 
# }

module "Networking" {
     source               = "./modules/Networking/firewall"
 }

module "firewall_application_rules" {
     source = "./modules/firewall_application_rules"
 }

module "firewall_nat_rules" {
     source = "./modules/firewall_nat_rules"
 }

/*module "firewall_policy_rule_collection_group" {
     source = "./modules/Networking/firewall_policy_rule_collection_group"
 }*/

data azurerm_resource_group "rg_name" {
    name = "test"
}

/*module "StorageAccount" {
    source = "./modules/StorageAccount"
}*/

/*module "VnetPeering" {
     source = "./modules/VnetPeering"
     vnetA_name                = "vnetA-${var.project}-${var.environment}"
     vnetB_name                = "vnetB-${var.project}-${var.environment}"
     subA_address_space        = ["10.0.0.0/16"]
     subB_address_space        = ["10.0.0.0/16"]
     subA_dns_servers          = ["8.8.8.8", "8.8.4.4"]
     subB_dns_servers          = ["8.8.8.8", "8.8.4storage_account_name.4"]
      vnetPeering_subA          = "vnetPeering-${var.project}-${var.environment}A2B"
     vnetPeering_subB          = "vnetPeering-${var.project}-${var.environment}B2A"
 }*/

 /*module "vnet" {
     source = "./modules/vnet"
     rg_name             = data.azurerm_resource_group.rg.name 
     vnet_name           = "vnet-${var.application}-${var.environment}"
     address_space       = ["10.0.0.0/16"]
     dns_servers         = ["8.8.8.8", "8.8.4.4"]
     #subnets            =  ["Subnet_1","Subnet_2", "Subnet_3"]
 }

module "Synapse" {
    source = "./modules/Synapse"
    rg_name               = data.azurerm_resource_group.rg.name 
    sta_name              = module.storage_account.storage_account_name
    synapse_name          = "synw-${var.project}-${var.environment}-001" 
    admin_login           = "adminuser"
    admin_pw              = "St4o9gP@s5w0r4"
    managed_vnet_enabled  = true
    pub_network_enabled   = true #Default
    need_plinkhub         = true
    plhub_name         = "plhubsynw${var.project}${var.environment}001"
}

module "SynapseSQLPool" {
  source  = "./modules/SynapseSQLPool"
  rg_name                         = data.azurerm_resource_group.rg.name 
  synapse_name                    = module.iap_synapse.synapse_workspace_name
  synapse_sql_pool_name           = "synwsp_${var.project}-${var.environment}_001" #No dashes, underscores acceptable 
  synapse_sql_sku_name            = "DW100c" #Default
  synapse_sql_pool_data_encrypted = true 
}

module "SynapsePrivateEndpoint" {
    source = "./modules/SynapsePrivateEndpoint"
    rg_name                  = data.azurerm_resource_group.rg.name 
    synapse_name             = module.synapse.synapse_workspace_name
    synapse_private_endpoint = {
       storage_account_blob = {
        spe_name             = module.storage_account.storage_account_name
        spe_target_id        = module.storage_account.storage_account_id
        spe_subresource_name = "blob"
    }, 
    sql_db = {
      spe_name             = module.sqlserver.database_name["Sql_DB"]
      spe_target_id        = module.sqlserver.sql_id
      spe_subresource_name = "sqlServer"
    }
    key_vault = {
      spe_name             = module.keyvault.key_vault_name
      spe_target_id        = module.keyvault.key_vault_id
      spe_subresource_name = "vault"
    }
  }
 }*/
data "azurerm_resource_group" "resourceg_name" {
  name = var.rg_name 
}

module "windows_virtualMachines" {
    source = "./modules/windows_virtualMachines"
}

 module "Linux_virtualMachines" {
     source = "./modules/Linux_virtualMachines"
 }

/*module "Attach_managed_disks"{
    source = "./modules/ManagedDisks"
    number_of_disks =  2
    storage_account_type   = "Premium_LRS"
    disk_size_gb           = "250"
    caching                = "ReadWrite"
}*/

/*module "LoadBalancer" {
    source = "./modules/LoadBalancer"
}*/


module "dataFactory" {
    source = "./modules/dataFactory"
    rsg_name = data.azurerm_resource_group.resource_group.name
 }



module "SqlDatabase" {
    source = "./modules/SqlDatabase"
}

/*module "sqlmanagedinstance" {
    source = "./modules/sqlmanagedinstance"
    location = var.location
    resource_group = var.resource_group
}*/

data azurerm_resource_group "resorce_rg_name" {
    name = "test"
}

module "DataFactoryIntegration_Runtime" {
    source = "./modules/DataFactoryIntegration_Runtime"
}