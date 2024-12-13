variable "location" {
    type=string
    default = "East US"
}

variable "resource_group" {
    type=string
    default = "test"
}

variable "win_subnet_name" {
    type = string
    description = "win subnet name"
    default = "Subnet01"
}

variable "win_vnet_name" {
    type = string
    description = "win vnet name"
    default = "VNT01"
}

variable "project" {
    type = string
    description = "name of the  project"
    default = "KAO"
}

variable "environment" {
    type = string
    description = "enviroment name"
    default = "test"
}


variable "application" {
    type = string
    description = "application name"
    default = "test"
}

variable "rg_name" {
    type   = string
    default = "test"
}