# Synapse Private Endpoint Terraform Module

The Synapse Private Endpoint  Terraform module deploys the private endpoints for the azure synapse workspace and its resources in the resource group.

## Usage

```terraform
module "synapseprivateendpoint" {
  source = "git::ssh://bitbucket.org//modules/synapseprivateendpoint"

  synapse_name                       = "temp-synapse-workspace"
  resource_group                     = "resource_group_dev"
  location                           = "East US"
  synapse_private_endpoint           = "temp"
  spe_name                           = "spe1"
  spe_subresource_name               = "tempsre"
  
}

```

## Variables

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   synapse_name	|   Name of the Synapse Workspace  |   string  |   yes |   temp-synapse-workspace   |
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev  |
|   synapse_private_endpoint   |    Synapse private endpoints |   string  |   yes |   temp  |
|    location   |   Azure Location |    string  |   yes |   East US |
|   spe_name    |   private endpoint name   |   string  |   yes     |   spe1    |
|   spe_subresource_name     |   sub resource to connect   |   string  |   yes     |   tempsre    |


# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2