

variable "firewall_policy_id" {
  description = "(Required) The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist. Changing this forces a new Firewall Policy Rule Collection Group to be created."
}

variable "ip_groups" {
  description = "(Optional) Specifies a map of source IP groups."
  default     = {}
}

variable "public_ip_addresses" {
  description = "(Optional) A map of destination IP addresses (including CIDR)."
  default     = {}
}

variable "resource_group_name " {
  type = string
  default = "test"
}

variable "location" {
  type = string
  description = "Location for the deployment"
  default = "East US"
}
