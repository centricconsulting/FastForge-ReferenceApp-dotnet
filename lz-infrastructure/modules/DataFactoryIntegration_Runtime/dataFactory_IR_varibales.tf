variable "data_fact_IR_test" {
  type = string
  description = "datafactory Integration run time name"
  default = "dataFactorytestIR"
}

variable "data_fact_name" {
  type = string
  description = "data factory name"
  default = "dataFactorykaotest"
}

variable "resource_group" {
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
  type = string
  default = "test"
}

variable "location" {
  description = "Location name"
  default     = "East US"
}