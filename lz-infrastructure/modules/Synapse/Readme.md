# Synapse Terraform Module

The Synapse Terraform module deploys an azure synapse workspace and its resources in the resource group.

## Usage

```terraform
module "synapse" {
  source = "git::ssh://bitbucket.org//modules/Synapse"

  synapse_name                       = "temp-synapse-workspace"
  resource_group                     = "resource_group_dev"
  location                           = "East US"
  sql_administrator_login            = "tempadminlogin"
  sql_administrator_login_password   = "temp$3cr3t123!"
  
}

```

## Variables

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   synapse_name	|   Name of the Synapse Workspace  |   string  |   yes |   temp-synapse-workspace   |
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev  |
|   sql_administrator_login	|   admin account for SQL pool    |    string  |   yes |   tempadminlogin    |
|    sql_administrator_login_password   |    Admin Password for SQL Pool |   string  |   yes |   temp$3cr3t123!  |
|    location   |   Azure Location |    string  |   yes |   East US |


# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2