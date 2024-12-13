
/*variable "vm_sizes" {
    type        = map(any)
    default = {
        lx_vm_01 =  "Standard_M32ls"
        lx_vm_02 = "Standard_M128s_v2"
        lx_vm_03 =  "Standard_128_v2"
        lx_vm_04 = "Standard_D4ds_v4"
        lx_vm_05 = "Standard_D16ds_v4"
        lx_vm_06 = "Standard_D16ds_v4"
        Lx_vm_07 = "Standard_D4ds_v4"
        lx_vm_08 = "Standard_D16ds_v4"
        lx_vm_09 = "Standard_D20ds_v4"
        lx_vm_10 = "Standard_E20ds_v4"
        lx_vm_11 = "Standard_M321s"
        lx_vm_12 = "Standard_M321s"
        lx_vm_13 =  "Standard_D4ds_v4"
        lx_vm_14 =  "Standard_D4ds_v4"
        lx_vm_15 =  "Standard_D4ds_v4"
        lx_vm_16 =  "Standard_D4ds_v4"
        lx_vm_17 =  "Standard_D4ds_v4"
    }
}*/

variable "rg_name" {  
    description = "Name of the resource group to be imported"
    default     = "test"
}

variable "location" {
  description = "(Required). Location"
  type        = string
  default     = "East US"
}

variable "lxvm_subnet_name" {
  type          = string
  description   = "name of the subnet"
  default       = "Subnet02"
}

variable "virtual_network_name" {
  type          = string
  description   = "name of the vnet"
  default       = "test_vnet"
}

variable "vmnic" {
  type          = string
  description   = "name of the network interface"
  default       = "test_nic"
}


variable "vm_names" {
  description = "VM Names"
   default    = ["lx_vm1","lx_vm2","lx_vm3","lx_vm4","lx_vm5","lx_vm6","lx_vm7","lx_vm8","lx_vm9","lx_vm10","lx_vm11","lx_vm12","lx_vm13","lx_vm14","lx_vm15","lx_vm16","lx_vm17"]
   type       = set(string)
}


variable "vm_sizes" {
  description  = "virtual Machines"
  type         = map
  default      =  {
  lx_vm1       = {
                  name   =  "lx_vm1"
                  size   =  "Standard_M32ls"
                  os_disk_size = "7340"
              }
  lx_vm2       = {
                  name   =  "lx_vm2"
                  size   =  "Standard_M128s_v2"
                  os_disk_size = "7850"
              }
   lx_vm3       = {
                  name   =  "lx_vm3"
                  size   =  "Standard_128_v2"
                  os_disk_size = "7910"
              }

   lx_vm4       = {
                  name   =  "lx_vm4"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "216"
              }

    lx_vm5       = {
                  name   =  "lx_vm5"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "250"
              }

    lx_vm6       = {
                  name   =  "lx_vm6"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "260"
              }

    lx_vm7       = {
                  name   =  "lx_vm7"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "216"
              }

    lx_vm8       = {
                  name   =  "lx_vm8"
                  size   =  "Standard_D16ds_v4"
                  os_disk_size = "331"
              }

    lx_vm9       = {
                  name   =  "lx_vm9"
                  size   =  "Standard_D20ds_v4"
                  os_disk_size = "614"
              }

    lx_vm10       = {
                  name   =  "lx_vm10"
                  size   =  "Standard_D20ds_v4"
                  os_disk_size = "614"
              }

    lx_vm11       = {
                  name   =  "lx_vm11"
                  size   =  "Standard_M321s"
                  os_disk_size = "1120"
              }

    lx_vm12       = {
                  name   =  "lx_vm12"
                  size   =  "Standard_M321s"
                  os_disk_size = "1110"
              }

    lx_vm13       = {
                  name   =  "lx_vm13"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "211"
              }

    lx_vm14       = {
                  name   =  "lx_vm14"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "270"
              }

    lx_vm15       = {
                  name   =  "lx_vm15"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "250"
              }

    lx_vm16       = {
                  name   =  "lx_vm16"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "80"
              }

    lx_vm17       = {
                  name   =  "lx_vm17"
                  size   =  "Standard_D4ds_v4"
                  os_disk_size = "226"
              }
  }
}
