output "id" {
  description = "The ID of the Azure Firewall."
  value       = azurerm_firewall.firewall.id
}

output "name" {
  description = "Name of the firewall"
  value       = azurerm_firewall.firewall.name
}

 output "resource_group_name" {
   value = var.resource_group_name
 }

output "ip_configuration" {
  description = "The Private IP address of the Azure Firewall."
  value       = azurerm_firewall.firewall.ip_configuration
}

output "virtual_hub" {
  description = "A virtual_hub block with private_ip_address and punlic_ip_addresses."
  value       = azurerm_firewall.firewall.virtual_hub
}