## **terraform-azure-loadbalancer**

## A terraform module to provide load balancers in Azure with the following characteristics:

Ability to specify public or private loadbalancer using: var.type. Default is public. Specify subnet to use for the loadbalancer: frontend_subnet_id For private loadbalancer, specify the private ip address using frontend_private_ip_address Specify the type of the private ip address with frontend_private_ip_address_allocation, Dynamic or Static , default is Dynamic


```python

provider "azurerm" {
  features {}
}
module "LoadBalancer" {
    source = "./modules/LoadBalancer"
}
resource_group     = resource_group_dev
Location           = East US 
load_balancer_name = lb_name 

```
----

# Variable 
- Public IP
- Private IP
- Load Balancer
- Backend Address Pool
- Nat Rule
- Load Balancer Probe
- Load Balancer Rule
- Load Balancer backend address pool
- Network interface pool
---
# Argument 
Name	   |Description   |	Type  |Default    |
---------|--------------------|---------------|-----------|
resource_group_name| The name of the resource group in which resources are created| 	string |	resource_group_dev |
location |The location of the resource group in which resources are created| string	| East US |
loadbalancer_name|	The name of the load balancer| string	|  lb_name  |
loadbalancer probe |	Virtual Network address space to be used	| list	|  []  |
frontend_name	| (Required) Specifies the name of the frontend ip configuration | string |	PublicIPAddress |
lb_probe  |	Protocols to be used for lb health probes. Format as [protocol, port, request_path] | map(any)	|  {}  | 

# Outputs 

Name   | Description |
-------|-----------|
azurerm_lb_backend_address_pool_id   |	the id for the azurerm_lb_backend_address_pool resource
azurerm_lb_frontend_ip_configuration |	the frontend_ip_configuration for the azurerm_lb resource
azurerm_lb_id	                     |the id for the azurerm_lb resource
azurerm_lb_nat_rule_ids	             |the ids for the azurerm_lb_nat_rule resources
azurerm_lb_probe_ids	             |the ids for the azurerm_lb_probe resources
azurerm_public_ip_address	         |the ip address for the azurerm_lb_public_ip resource
azurerm_public_ip_id	             |the id for the azurerm_lb_public_ip resource


# Requirements

Name     | Version
---------|--------
terraform| >=1.2.8
azurerm	 | >=3.0.2