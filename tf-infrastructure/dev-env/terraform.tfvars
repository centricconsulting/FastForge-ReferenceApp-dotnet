# Static Variables #
environment      = "dev" 
application_name = "t3strrr" #Update to reflect app name. Must be no more than 15 characters
region           = "westus2" #Update to be consistent across resources
api_tier         = "Standard"
api_size         = "S1"

shared_container_registry_login_server   = "!__REGISTRY_LOGIN_SERVER__!"  
shared_container_registry_admin_username = "!__REGISTRY_USERNAME__!" 
shared_container_registry_admin_password = "!__REGISTRY_PASSWORD__!"


#####################
# Optional Resource #
##################### # Uncomment any of the below as it pertains to your resource needs

# ~COSMOS DATABASE EXAMPLE~ #
# cosmosdb_account_kind              = "GlobalDocumentDB" #Update and choose GlobalDocumentDB or MongoDB
# cosmosdb_account_consistency_level = "Strong"
# cosmosdb_account_backup_type       = "Periodic"
# cosmosdb_account_failover_location = "westus"
