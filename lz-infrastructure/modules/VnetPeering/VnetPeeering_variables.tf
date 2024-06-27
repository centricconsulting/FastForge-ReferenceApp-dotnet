variable "environment" {
   description = "Name of the resource group to be imported"
    default     = "test"
}
variable "project" {
    description = "Name of the project"
    default     = "kao"
}
variable "owner" {
    description = "Name of the owner"
    default     = "KAO"
}
variable "location" {
    description = "Name of the resource group to be imported"
    default     = "eastus"
}

variable "rgSubA_name" {
    description = "Name of the resource group to be imported of SubA"
    default     = "rgSubA"
}

variable "rgSubB_name" {
    description = "Name of the resource group to be imported of SubB"
    default     = "rgSubB"
}

variable "RgSubA_location" {
    description = "Location of the resource group to be imported of SUBA"
    default     = "eastus"
}

variable "RgSubB_location" {
    description = "Location of the resource group to be imported of SUBB"
    default     = "eastus"
}

variable "vnetA_client_id" {
   description = "Client id of Subscription"
 }

 variable "vnetB_client_id" {
   description = "Client id of Subscription"
 }
 
 variable "vnetA_tenant_id" {
   description = "Tenant id of Subscription"
 }

 variable "vnetB_tenant_id" {
   description = "Tenant id of Subscription"
 }
 
 variable "vnetA_client_secret" {
   description = "Client secret of Subscription"
 }
 
 variable "vnetB_client_secret" {
   description = "Client id of Subscription"
 }
 
  variable "vnetA_subscription_id" {
   description = "Subscription ID for vnetA"
 }
 
 variable "vnetB_subscription_id" {
   description = "Subscription ID for vnetB"
 }

variable "vnetA_name" {
   description = "Name of the virtual network A"
    default     = "vnetA"
}

variable "vnetB_name" {
   description = "Name of the virtual network B"
    default     = "vnetB"
}

 variable "subA_address_space" {
    description = "Address space for the VNETA"
    default     = ["10.0.0.0/16"]
}

 variable "subB_address_space" {
    description = "Address space for the VNETB"
    default     = ["10.0.0.0/16"]
}

variable "subA_dns_servers" {
    description = "dns_servers for the VNETA"
    default     = []
}

variable "subB_dns_servers" {
    description = "dns_servers for the VNETB"
    default     = []
}

variable "vnetPeering_subA" {
   description = "name of the peering on VNETA"
    default     = "vnetAtoB"
}

variable "vnetPeering_subB" {
   description = "name of the peering on VNETB"
    default     = "vnetBtoA"
}