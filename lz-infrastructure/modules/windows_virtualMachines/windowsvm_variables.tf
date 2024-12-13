######################
# General Attributes #
######################

variable "resource_group" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}

variable "location" {
  description = "(Required). Location"
  type        = string
  default     = "East US"
}

variable "winvm_subnet_name" {
  type          = string
  description   = "name of the subnet"
  default       = "kao_win_vm_Subnet"
}

variable "win_vnet_name" {
  type          = string
  description   = "name of the vnet"
  default       = "kao_test_winvnet"
}

variable "vmnic" {
  type          = string
  description   = "name of the network interface"
  default       = "test_winnic"
}


variable "vm_names" {
  description = "VM Names"
   default    = ["win_vm1","win_vm2","win_vm3","win_vm4","win_vm5","win_vm6","win_vm7","win_vm8","win_vm9","win_vm10","win_vm11","win_vm12","win_vm13","win_vm14","win_vm15","win_vm16","win_vm17"]
   type       = set(string)
}


variable "vm_sizes" {
  description  = "virtual Machines"
  type         = map
  default      =    {
  win_vm1       = {
                  name   =  "win_vm1"
                  size   =  "Standard_M32ls"
                  os_disk_size = "7340"
          }
  win_vm2       = {
                  name   =  "win_vm2"
                  size   =  "Standard_M128s_v2"
                  os_disk_size = "7850"
          }
   win_vm3       = {
                  name   =  "win_vm3"
                  size   =  "Standard_128_v2"
                  os_disk_size = "7910"
          }

   win_vm4       = {
                  name   =  "win_vm4"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "216"
          }

    win_vm5       = {
                  name   =  "win_vm5"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "250"
          }

    win_vm6       = {
                  name   =  "win_vm6"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "260"
           }

    win_vm7       = {
                  name   =  "win_vm7"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "216"
           }

    win_vm8       = {
                  name   =  "win_vm8"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "331"
          }

    win_vm9       = {
                  name   =  "win_vm9"
                  size   =  "Standard_D20ds_v4"
                  os_disk_size = "614"
              }

    win_vm10       = {
                  name   =  "win_vm10"
                  size   =  "Standard_D20ds_v4"
                  os_disk_size = "614"
          }

    win_vm11       = {
                  name   =  "win_vm11"
                  size   =  "Standard_M321s"
                  os_disk_size = "1120"
          }

    win_vm12       = {
                  name   =  "win_vm12"
                  size   =  "Standard_M321s"
                  os_disk_size = "1110"
          }

    win_vm13       = {
                  name   =  "win_vm13"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "211"
         }

    win_vm14       = {
                  name   =  "win_vm14"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "270"
         }

    win_vm15       = {
                  name   =  "win_vm15"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "250"
       }

    win_vm16       = {
                  name   =  "win_vm16"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "80"
      }

    win_vm17       = {
                  name   =  "win_vm17"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "226"
    }
  }
}
