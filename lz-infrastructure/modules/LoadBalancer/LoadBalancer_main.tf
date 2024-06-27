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
  name     = var.resource_group
  location = var.location
}

# create azurerm load balancer 

resource "azurerm_lb" "lb_name" {
  name                = "Kao_LoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_name.id
  }
}

resource "azurerm_public_ip" "az_ip_lb" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}


resource "azurerm_lb_probe" "az_lb_probe" {
  loadbalancer_id = azurerm_lb.az_lb_probe.id
  name            = "ssh-running-probe"
  port            = 22
}
# create azurerm lb backend address pool

resource "azurerm_lb_backend_address_pool" "az_lb" {
  name                = "BackEndAddressPool"
  loadbalancer_id     = azurerm_lb.az_lb.id
}

# create lb nat_rule

resource "azurerm_lb_nat_rule" "lb_nat" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb_nat.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_nat_rule" "az_lb1" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb_nat.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port_start            = 3000
  frontend_port_end              = 3389
  backend_port                   = 3389
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_nat.id
  frontend_ip_configuration_name = "PublicIPAddress"
}

# create load balancer rule 
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb_rule.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

