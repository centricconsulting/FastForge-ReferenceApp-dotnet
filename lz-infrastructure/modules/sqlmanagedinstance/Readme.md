
## **Terraform-azurerm-sqlmi**


## The terraform script is used to provision the SQL Managed Instance along with the required network resouces to comply with networking requirements.

 **Type of resources are supported**

  -  resource-group
  - Subnets
  - Subnet Service Delegation
  - network
  - managed-instance
  ----
**Deployment duration**

## SQL Managed Instance deployment can take up to 4 plus hours deployment durations.

**Virtual Network Parameters**

## Below are the parameters required for the network

python
- resource_group_name
- location
- nsg_name
- vnet_name
- subnet_name
- route_table_name
- subnet_address_space

# Usage 

```python
provider "azurerm" {
  features {}
}
module "sqlmanagedinstance" {
    source = "./modules/sqlmanagedinstance"
}
resource_group         = resource_group_dev
location               = "East US"
network_security_group = minsg
virtual_network        = vnet
subnet                 = subnet-mi

```
**SQL Managed Instance Parameters** 

## Below are the required parameters for Managed Instance: - resource_group_name - location - sql_mi_name - administrator_login - administrator_login_password

- license_type
- sku_name
- vcores
- storage_size_in_gb
---
## **Variables**

Variable |Description |	Type  |Default |
---------|------------|--------------|-----------|
resource_group_name| The name of the resource group in which resources are created| 	string |	resource_group_dev |
location |The location of the resource group in which resources are created| string	| East US |
mssql_managed_instance_name | sql managed instance name| string | sqlmi 
vnetwork_name|	sql managed instance vnet name on which to generate subnet for integration	| string	|  vnet_name |
nsg_name |	sql managed instance network security group name	| string	|  minsg  | 
subnet_name | 	A name of subnets for sqlmanagedinstance  | 	object  | 	{}  |


----


## Contributing

Pull requests welcome. If changes/added funtionality are needed please open a PR. Do NOT copy the repo elsewhere. It defeats the purpose of a centralized registry.
