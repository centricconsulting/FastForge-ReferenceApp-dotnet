output "azurerm_storage_account_name" {
  description = "storagev1"
  value       =azurerm_storage_account.storage_account.name

}

output "account_tier" {
  description = "the storage account tier"
  value       =azurerm_storage_account.storage_account.account_tier
  
}
output "account_replication_type" {
  description = "account replication type"
  value       =azurerm_storage_account.storage_account.account_replication_type
}