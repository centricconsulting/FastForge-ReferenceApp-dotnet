output "vnet-01_id" {
  description = "The id of the newly created vnet-01"
  value       = azurerm_virtual_network.vnet-01.id
}

output "vnet-01_name" {
  description = "The Name of the newly created vnet-01"
  value       = azurerm_virtual_network.vnet-01.name
}

output "vnet-01_location" {
  description = "The location of the newly created vnet-01"
  value       = azurerm_virtual_network.vnet-01.location
}

output "vnet-01_address_space" {
  description = "The address space of the newly created vnet-01"
  value       = azurerm_virtual_network.vnet-01.address_space
}

output "vnet-02_id" {
  description = "The id of the newly created vnet-02"
  value       = azurerm_virtual_network.vnet-02.id
}

output "vnet-02_name" {
  description = "The Name of the newly created vnet-02"
  value       = azurerm_virtual_network.vnet-02.name
}

output "vnet-02_address_space" {
  description = "The address space of the newly created vnet-02"
  value       = azurerm_virtual_network.vnet-02.address_space
}
