variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "temp-rg"
}

# CosmosDB Account Variables
variable "cosmosdb_account_name" { 
  description = "CosmosDB Account Name"
  type        = string
  default     = "temp-SQL-name"
}
variable "cosmosdb_account_kind" {
  description = "The Kind of CosmosDB Account to create"
  type        = string
  default     = "GlobalDocumentDB"
}
variable "cosmosdb_account_free_tier" {
  description = "Boolean value on whether or not to use a free tiered CosmosDB, this can only happen once per subscription"
  type        = string
  default     = "false"
}
variable "consistency_policy" {
  description = "Consistency level for the CosmosDB"
}
variable "failover_location" {
  description = "Failover priority of the region"
  type        = string
}
variable "backup" {
  description = "Backup type for the CosmosDB"
}

# CosmosDB Variables
variable "cosmosdb_name" {
  description = "CosmosDB Name"
  type        = string
  default     = "temp-db-name"
}
variable "cosmosdb_throughput" {
  description = "CosmosDB throughput"
  default     = 400
}

# CosmosDB SQL Container Variables 
variable "cosmosdb_container_name" {
  description = "CosmosDB SQL Container name"
}
variable "cosmosdb_container_partition_key_path" {
  description = "CosmosDB SQL Container partition key path"
  default     = "/definition/id"
}
variable "cosmosdb_container_partition_key_version" {
  description = "CosmosDB SQL Container partition key version. Possible values are 1 or 2. Set to 2 in order to use large partition keys"
  default     = 1
}
variable "cosmosdb_container_throughput" {
  description = "CosmosDB Container throughput"
  default     = 400
}

# Tag Variables
variable "environment" {
  description = "Environment variable used by Terraform resources"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region name"
  type        = string
  default     = "eastus"
}