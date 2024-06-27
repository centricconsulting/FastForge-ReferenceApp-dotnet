output "synapse_workspace_name" {
    description = "synapse workspace name"
    value       = azurerm_synapse_workspace.synapse_workspace.name
}
output "synapse_workspace_id" {
    description = "synapse workspace id"
    value       = azurerm_synapse_workspace.synapse_workspace.id
}

output "private_link_id" {
    value = azurerm_synapse_private_link_hub.plhub[0].id
}

output "private_link_name" {
    value = azurerm_synapse_private_link_hub.plhub[0].name
}