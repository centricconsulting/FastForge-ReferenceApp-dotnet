# Logic Apps Terraform Module

The Logic App manages a Logic App Workflow.

## Usage

```terraform
module "LogicApps" {
  source = "git::ssh://bitbucket.org//modules/LogicApps"

 resource "azurerm_logic_app_workflow" "logicapp" {
  name                = "logicapp1"
  location            = "eastus"
  resource_group_name = "resource_group_dev"
}
```

## Variables

|   Variable  | Description    |    Type    |   Required    |   DefaultValue    |
|---	|---	|---	|---	|---	|
|   name	|   name of the logic app workflow  |   string  |   yes |   logicapp1   |
|   resource_group	|   Name of the resource group  |   string  |   yes |   resource_group_dev  |
|   location	|   Azure Location    |    string  |   yes |   East US    |



# Requirements
Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2