variable "resource_group_name" {
  type = string
  default = "test"
}

variable "location" {
  type = string
  description = "Location for the deployment"
  default = "East US"
}

variable "public_ip_id" {
  type = string
  description = "(Optional) Public IP address identifier. IP address must be of type static and standard."
  default     = "firewall_publicIp"
}
/*variable "global_settings" {
  description = "Global settings object (see module README.md)"
}

variable "name" {
  description = "(Required) Name of the Azure Firewall to be created"
  default = ""
}

variable "tags" {
  description = "(Required) Tags of the Azure Firewall to be created"
}

variable "subnet_id" {
  description = "(Required) ID for the subnet where to deploy the Azure Firewall"
  default     = null
}

variable "diagnostics" {
  default = {}
}
variable "settings" {}

variable "diagnostic_profiles" {
  default = {}
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

variable "public_ip_addresses" {

}

variable "public_ip_keys" {
  default = {}
}

variable "virtual_wans" {
  default = {}
}

variable "virtual_hubs" {
  default = {}
}

variable "virtual_networks" {

}

variable "client_config" {
  default = {}
}

variable "firewall_policy_id" {
  default = null
}*/