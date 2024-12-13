output "id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The network security group configuration ID."
}

output "name" {
  value       = azurerm_network_security_group.nsg.name
  description = "The name of the network security group."
}

output "resource_group_name" {
  value       = azurerm_network_security_group.nsg.resource_group_name
  description = "The name of the resource group in which to create the network security group."
}

