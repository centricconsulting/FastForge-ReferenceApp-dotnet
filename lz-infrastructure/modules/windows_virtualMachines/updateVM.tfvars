#global
win_subnet_name = "subnet_win-01"
resource_group = "resource_group_test"

#Security Protocols
direction = "Outbound"
protocol = "Tcp"
source_address_prefix = "[10.0.0.0/24]"

#storage
storage_account_type = "Standard_Blob_Storage"
#disk_size_gb = "2048"
win_disk_size_gb = "2048"