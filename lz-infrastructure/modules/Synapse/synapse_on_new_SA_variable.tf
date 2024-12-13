######################
# General Attributes #
######################
variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}
variable "sta_name" {
    description = "Name of the Storage Account to be imported"
    default     = "temp-sta"
}
variable "tags" {
    description = "The tags to associate with your resource(s)"
    type        = map(string)
    default = {
    }
}

variable "account_tier" {
  description = "Account Tier of the Storage Account"
  default     = "Standard"
}
variable "account_replication_type" {
  description = "Account Replciation Type of the Storage Account"
  default     = "LRS"
}
variable "account_kind" {
  description = "Account Kind of the Storage Account"
  default     = "StorageV2"
}
variable "is_hns_enabled" {
  description = "Boolean if Hierarchical Namespace is enabled on the Storage Account. Only applicable for Gen 2 Data Lake Storage"
  default     = "true"
}
variable "min_tls_version" {
  description = "Supported minimum TLS version for the Storage Account"
  default     = "TLS1_2"
}

##############################
# Storage Account Filesystem #
##############################
variable "filesystems" {
  description = "Looping variable for X number of filesystems (containers)"
  default = {
  }
}

# All defaults can be overwritten when the module is called in the primary "Main.tf" file
####################
# Synapse Services #
####################
variable "synapse_name" {
  description = "Name of the Synapse Workspace"
  default     = "temp-synapse-workspace"
}
variable "filesystem_id" {
  description = "ID of the Filesystem created in the Storage Account"
  default     = "temp-filesystem-id"
}
variable "admin_login" {
  description = "SQL Admin username login"
  default     = "tempadminlogin"
}
variable "admin_pw" {
  description = "SQL Admin password login"
  default     = "temp$3cr3t123!"
}
variable "managed_vnet_enabled" {
  description = "Will the synapse resource need a managed vnet?"
  default     = false
}
variable "pub_network_enabled" {
  description = "Public Network Access enabled by default?"
  default     = true
}

############################
# Synapse Private Link Hub #
############################
variable "need_plinkhub" {
    description = "Boolean call on whether or not a private link hub is needed"
    default     = false
}
variable "plhub_name" {
  description = "Name of the Synapse Private Link Hub Resource"
  default     = "tempname"
}