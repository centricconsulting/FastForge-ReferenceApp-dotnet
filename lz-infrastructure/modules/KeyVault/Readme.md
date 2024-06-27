# KeyVault Terraform Module

The KeyVault Terraform module deploys an azure resource group with a simple assocaited KeyVault.

## Usage

```terraform
module "KeyVault" {
  source = "git::ssh://bitbucket.org//modules/KeyVault"

  key_vault      = "azureKeyVault"
  resource_group = "resource_group_dev"
  location       = "East US"
  sku_name       = "standard"
}

```

## Variables

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   key_vault	|   Name of the Key Vault   |   string  |   yes |   azureKeyVault   |
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev  |
|   location	|   Azure Location    |    string  |   yes |   East US    |
|    sku_name   |    Sku of KeyVault |   string  |   yes |   standard\premium  |
|    location   |   Azure Location |    string  |   yes |   East US|


# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2