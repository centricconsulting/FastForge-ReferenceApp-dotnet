# Static Variables #
variable "environment" {
	description = "Environment variable used to define scope of resource. Examples include, DEV, TEST, QA, PROD, etc."
}
variable "application_name" {
    description = "Name of application"
}
variable "region" { 
	description = "Azure region for resource"
} 
variable "api_tier" { 
	description = "API tier used to define sku tier for App Service Plan"
} 
variable "api_size" { 
	description = "API size used to define sku size for App Service Plan"
} 

# Shared Container Information #
variable "shared_container_registry_login_server" {
	description = "Registry Login for the Shared Container Server"
}
variable "shared_container_registry_admin_username" {
	description = "Admin Username for the Shared Container Server"	
}
variable "shared_container_registry_admin_password" {
	description = "Admin Password for the Shared Container Server"
}

#####################
# Optional Resource #
##################### # Uncomment any of the below as it pertains to your resource needs
# Cosmos DB Variables #
# variable "cosmosdb_account_kind" {
# 	description = "The Kind of CosmosDB to create"
# }
# variable "cosmosdb_account_failover_location" {
# 	description = "Failover location required for CosmosDB Accounts"
# }
# variable "cosmosdb_account_consistency_level" {
# 	description = "The Kind of CosmosDB to create"
# }
# variable "cosmosdb_account_backup_type" {
# 	description = "The backup type of the CosmosDB account"
# }
