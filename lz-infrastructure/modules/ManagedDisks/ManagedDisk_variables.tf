######################
# General Attributes #
######################
variable "vm_name" {
  description = "Name of the Virtual machine"
  default = "test_vm_01"
}

variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}


variable "number_of_disks" {  
    description = "Number of disks needed"
    default     = "2"
}

variable "storage_account_type" {  
    description = "type of storage to use for the managed disk" 
    default     = "Standard_LRS"
}


variable "disk_size_gb" {  
    description = "Specifies the size of the managed disk to create in gigabytes"
    default     = "100"
}

variable "caching" {  
    description = "pecifies the caching requirements for this Data Disk" 
    default     = "ReadWrite"
}


