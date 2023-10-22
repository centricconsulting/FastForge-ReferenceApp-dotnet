variable "db_name" {
  description = "The name of the database instance"
  type        = string
}

variable "db_username" {
  description = "The master user for the database instance"
  type        = string
}

variable "db_password" {
  description = "The password for the master user on the database instance"
  type        = string
}
