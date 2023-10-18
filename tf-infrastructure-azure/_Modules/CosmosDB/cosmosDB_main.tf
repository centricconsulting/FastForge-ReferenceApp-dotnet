# Create the CosmosDB Account
resource "azurerm_cosmosdb_account" "account" {
  name                = var.cosmosdb_account_name
  resource_group_name = var.resource_group_name
  location            = var.region
  offer_type          = "Standard"
  kind                = var.cosmosdb_account_kind

  enable_automatic_failover = true
  enable_free_tier          = var.cosmosdb_account_free_tier

  dynamic "consistency_policy" {
    for_each = var.consistency_policy
    content {
      consistency_level       = consistency_policy.value.consistency_level
      max_interval_in_seconds = consistency_policy.value.consistency_level == "BoundedStaleness" ? lookup(consistency_policy.value, "max_interval_in_seconds", 300) : null
      max_staleness_prefix    = consistency_policy.value.consistency_level == "BoundedStaleness" ? lookup(consistency_policy.value, "max_staleness_prefix", 100000) : null
    }
  }
  dynamic "backup" {
    for_each = var.backup
    content {
      type                = backup.value.type
      interval_in_minutes = backup.value.type == "Periodic" ? lookup(backup.value, "interval_in_minutes", 240) : null
      retention_in_hours  = backup.value.type == "Periodic" ? lookup(backup.value, "retention_in_hours", 8) : null
    }
  }
  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }
  geo_location {
    location          = var.region
    failover_priority = 0
  }
  tags = {
    environment = var.environment
  }  
}

output "cosmosdb_account_key" {
    value = azurerm_cosmosdb_account.account.primary_key
    sensitive   = true 
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.cosmosdb_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
  throughput          = var.cosmosdb_throughput

  depends_on = [azurerm_cosmosdb_account.account]
}

resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = var.cosmosdb_container_name
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.account.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = var.cosmosdb_container_partition_key_path 
  partition_key_version = var.cosmosdb_container_partition_key_version 
  throughput            = var.cosmosdb_container_throughput 
  depends_on = [azurerm_cosmosdb_account.account, azurerm_cosmosdb_sql_database.db]  
}
