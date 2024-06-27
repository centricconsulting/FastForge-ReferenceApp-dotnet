terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0.2"
    }
  }
}

#This is a vnet peering between new vnets created in existing Resource Groups in 2 Subscriptions.
provider "azurerm" {
    alias           = "SubA"
    client_id = var.vnetA_client_id
    tenant_id = var.vnetA_tenant_id
    client_secret = var.vnetA_client_secret
    subscription_id = var.vnetA_subscription_id

  features {}
}

data "azurerm resource_group_name" "rgSubA"{
    name = var.rgSubA_name
    location = var.RgSubA_location
}

provider "azurerm" {
  alias           = "SubB"
  client_id = var.vnetB_client_id
  tenant_id = var.vnetB_tenant_id
  client_secret = var.vnetB_client_secret
  subscription_id = var.vnetB_subscription_id

  features {}
}
data "resource_group_name" "rg_SubB"{
    name = var.rgSubB_name
    location = var.RgSubB_location
    }



# Create a virtual network within the resource group in SubA
resource "azurerm_virtual_network" "vnet_A" {
  name                = var.vnetA_name
  resource_group_name = data.resource_group.rgSubA.name
  location            = data.resource_group.rgSubA.location
  address_space       = var.subA_address_space
  dns_servers         = var.subA_dns_servers
  depends_on          = [data.resource_group.rgSubA]
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create a virtual network within the resource group in SubB
resource "azurerm_virtual_network" "vnet_B" {
  name                = var.vnetB_name
  resource_group_name = data.resource_group.rg_SubB.name
  location            = data.resource_group.rg_SubB.location
  address_space       = var.subB_address_space
  dns_servers         = var.subB_dns_servers
  depends_on          = [data.resource_group.rg_SubB]
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create a virtual network peering within the resource group
resource "azurerm_virtual_network_peering" "vnet_peering_A" {
  name                           = var.vnetPeering_subA
  resource_group_name            = data.resource_group.rgSubA.name
  virtual_network_name           = azurerm_virtual_network.vnet_A.name
  remote_virtual_network_id      = azurerm_virtual_network.vnet_B.id
  allow_virtual_network_access   = true
  allow_forwarded_traffic        = true
  depends_on                     = [data.resource_group.rg_SubB,data.resource_group.rgSubA,data.azurerm_virtual_network.vnet_A,data.azurerm_virtual_network.vnet_B]
  }

# Create a virtual network peering within the resource group
resource "azurerm_virtual_network_peering" "vnet_peering_B" {
  name                         = var.vnetPeering_subB
  resource_group_name          = data.resource_group.rg_SubB.name
  virtual_network_name         = azurerm_virtual_network.vnet_B.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_A.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = [data.resource_group.rg_SubB,data.resource_group.rgSubA,data.azurerm_virtual_network.vnet_A,data.azurerm_virtual_network.vnet_B]
  }