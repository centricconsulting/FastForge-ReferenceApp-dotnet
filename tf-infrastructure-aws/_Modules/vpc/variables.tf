variable "vpc_cidr_block" {
  description = "The CIDR block to associate with the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "The number of public and private subnets"
  type        = map(number)
  default     = {
    public = 1,
    private = 2
  }
}

variable "public_subnet_cidr_blocks" {
  description = "The cidr blocks to use for the public subnet(s)"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "The cidr blocks to use for the private subnet(s)"
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
  ]
}


variable "tags" {
  description = "Tags to be attached to the database"
  type        = map(any)
}