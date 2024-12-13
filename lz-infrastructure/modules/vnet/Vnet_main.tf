# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }
# import resource group

data "azurerm_resource_group" "resource_group" {
    name = var.rg_name
    location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location            = data.azurerm_resource_group.resource_group.location
    address_space       = var.address_space
    dns_servers         = var.dns_servers
    tags = {
      environment = var.environment
      source      = "Terraform"
      owner       = var.owner
      project     = var.project
    }
    lifecycle {
      ignore_changes = [
        tags,
      ]
    
  }
   depends_on = [data.azurerm_resource_group.resource_group]
    
  }
   

# Create a Subnet within the resource group
resource "azurerm_subnet" "subnet" {
  for_each            = var.subnets
  depends_on          = [data.azurerm_resource_group.resource_group,azurerm_virtual_network.vnet]
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  name                = each.value["name"]
  address_prefixes    = each.value["address_prefixes"]
}

# Create Public IP Prefix within the resource group
resource "azurerm_public_ip_prefix" "ip_prefix" {
  depends_on          = [data.azurerm_resource_group.resource_group,azurerm_subnet.subnet]
  name                = "nat-ip-prefix-${var.environment}-${var.project}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  prefix_length       = 30
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create NAT Gateway within the resource group
resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = "nat-gateway${var.environment}-${var.project}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  #public_ip_prefix_ids    = [azurerm_public_ip_prefix.ip_prefix.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  depends_on              = [data.azurerm_resource_group.resource_group,azurerm_public_ip_prefix.ip_prefix]
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Associate NAT with Subnet
resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  depends_on     = [data.azurerm_resource_group.resource_group,azurerm_nat_gateway.nat-gateway]
  for_each       = var.subnets
  nat_gateway_id = azurerm_nat_gateway.nat-gateway[each.key].id
  subnet_id      = azurerm_subnet.subnet[each.key].id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "naat_ip_prefix_assoc" {
  nat_gateway_id      = azurerm_nat_gateway.nat-gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.ip_prefix.id
}

# Create a Network Security Group
resource "azurerm_network_security_group" "nsg" {
  depends_on          = [data.azurerm_resource_group.resource_group,azurerm_subnet.subnet]
  name                = "nsg-${var.environment}-${var.project}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

}
#create network security Rules

resource "azurerm_network_security_rule" "allow_management_inbound" {
    name                        = "allow_management_inbound"
    priority                    = 106
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  
  resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
    name                        = "allow_health_probe_inbound"
    priority                    = 300
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "AzureLoadBalancer"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  resource "azurerm_network_security_rule" "allow_tds_inbound" {
    name                        = "allow_tds_inbound"
    priority                    = 1000
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  resource "azurerm_network_security_rule" "deny_all_inbound" {
    name                        = "deny_all_inbound"
    priority                    = 4096
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  resource "azurerm_network_security_rule" "allow_management_outbound" {
    name                        = "allow_management_outbound"
    priority                    = 102
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges     = ["80", "443", "12000"]
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
    name                        = "allow_misubnet_outbound"
    priority                    = 200
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
  
  resource "azurerm_network_security_rule" "deny_all_outbound" {
    name                        = "deny_all_outbound"
    priority                    = 4096
    direction                   = "Outbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource_group.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }

# Associate Network Security Group with Subnet
resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  depends_on                = [data.azurerm_resource_group.resource_group, azurerm_network_security_group.nsg]
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id

}

# Create Route Table for Subnet
resource "azurerm_route_table" "rt" {
  depends_on          = [data.azurerm_resource_group.resource_group,azurerm_subnet.subnet]
  name                = "rt-${var.environment}-${var.project}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  disable_bgp_route_propagation = false


  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}



# Associate Subnets with  Route table
resource "azurerm_subnet_route_table_association" "rtassoc" {
  depends_on     = [azurerm_route_table.rt]
  for_each      = var.subnets
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rt.id
}