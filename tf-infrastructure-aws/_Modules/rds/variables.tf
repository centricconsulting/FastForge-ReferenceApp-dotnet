variable "db_name" {
  description = "The name of the database instance"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage in GBs to allocate for the DB"
  type        = number
  default     = 20
}

variable "family" {
  description = "The family of the RDS Parameter Gruop"
  type        = string
  default     = "sqlserver-ex-15.0"
}

variable "engine" {
  description = "The database engine to use with RDS"
  type        = string
  default     = "sqlserver-ex"
}

variable "major_engine_version" {
  description = "The database major engine version to use with RDS Option Group"
  type        = string
  default     = "15.00"
}

variable "engine_version" {
  description = "The database engine version to use with RDS"
  type        = string
  default     = "15.00.4316.3.v1"
}

variable "instance_class" {
  description = "The instance type to use with RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "tags" {
  description = "Tags to be attached to the database"
  type        = map(any)
}

variable "db_username" {
    description = "The master db username"
    type        = string
}

variable "db_password" {
    description = "The master db password"
    type        = string
}

variable "subnet_group" {
  description = "The id of the Subnet Group for RDS"
  type        = string
}

variable "security_group_ids" {
  description = "A list of the VPC security group ids for RDS"
  type        = list(string)
}