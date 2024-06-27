#Import existing Resource Group
data "azurerm_resource_group" "resource_group" {
    name = var.rg_name
}
data "azurerm_storage_account" "storage_account" {
    name                = var.sta_name
    resource_group_name = data.azurerm_resource_group.resource_group.name
}

####################
# Synapse Services #
####################
resource "azurerm_synapse_workspace" "synapse_workspace" {
    resource_group_name                  = data.azurerm_resource_group.resource_group.name
    location                             = data.azurerm_resource_group.resource_group.location
    storage_data_lake_gen2_filesystem_id = var.filesystem_id 
    name                                 = var.synapse_name
    sql_administrator_login              = var.admin_login 
    sql_administrator_login_password     = var.admin_pw
    managed_virtual_network_enabled      = var.managed_vnet_enabled 
    public_network_access_enabled        = var.pub_network_enabled 
    linking_allowed_for_aad_tenant_ids   = []
    tags                                 = var.tags
    lifecycle {
        ignore_changes = [
            tags,
        ]
    }  
    identity {
    type = "SystemAssigned"
  } 
    depends_on                           = [data.azurerm_resource_group.resource_group, data.azurerm_storage_account.storage_account]
}

resource "azurerm_synapse_firewall_rule" "allow_all_azure" { #Used to allow access for this Synapse workspace to all Windows Azure IPs
    name                 = "AllowAllWindowsAzureIps"
    synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
    start_ip_address     = "0.0.0.0"
    end_ip_address       = "0.0.0.0"
    depends_on           = [azurerm_synapse_workspace.synapse_workspace]
}

############################
# Synapse Private Link Hub #
############################
resource "azurerm_synapse_private_link_hub" "plhub" {
    count               = var.need_plinkhub ? 1 : 0         #Default is false. 
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location            = data.azurerm_resource_group.resource_group.location
    name                = var.plhub_name
    tags                = var.tags
    depends_on          = [data.azurerm_resource_group.resource_group]
    lifecycle {
        ignore_changes = [
            tags,
        ]
    }  
}