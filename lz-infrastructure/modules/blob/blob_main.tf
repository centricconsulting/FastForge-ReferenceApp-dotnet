# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = ">=3.0.2"
#     }
#   }
# }

# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
# }

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_grp
  location = var.blob_location
}

#create a container and blod
# Here we are creating a storage account.

data "azurerm_storage_account" "storage_account" {
  name                     = var.storageaccount
  resource_group_name      = var.resource_grp
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Here we are creating a container in the storage account
resource "azurerm_storage_container" "blob_storage_container_name" {
  name                  = var.blob_storage_container_name
  storage_account_name  = var.blob_storage_account_name
  container_access_type = "private"
}

# This is used to upload a local file onto the container
resource "azurerm_storage_blob" "blobstg" {
  name                   = "blobstg.txt"
  storage_account_name   = var.blob_storage_account_name
  storage_container_name = var.blob_storage_container_name
  type                   = "Block"
  source                 = "blobstg.txt"
}