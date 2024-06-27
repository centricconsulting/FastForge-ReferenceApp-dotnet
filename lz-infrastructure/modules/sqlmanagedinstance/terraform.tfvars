# Modify this file to customize the Azure SQL Managed Instance network configuration for your specific environment

# General 
resource_prefix = "sqlmi-test" # Change this to a prefix that complies with your resource naming conventions
sta_name = "stage-sta"

location = "East US" # Change this to the region you want to deploy 

/*tags = {
  environment = "test"
  costcenter  = "unknown"
  project     = "Azure SQL Managed Instance pre-production testing"
}*/ # Change this to the tags you want to use for your resources

# Virtual network 
address_space = ["10.0.0.0/16"] # Change this to the address space you want to use, make sure it does not conflict with other VNets

//dns_servers = [] # Change this if you require custom DNS settings for hybrid connectivity to your on-premises network

# Subnets
//sqlmi_name = "sqltestmi"

vnet_name = "vnet_test"

nsg_name = "nsg_test"

minsg = "minsg_test"

address_prefixes = ["10.0.0.0/24"]


