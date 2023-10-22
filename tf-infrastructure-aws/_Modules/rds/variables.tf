variable "db_name" {
  description = "The name of the database instance"
  type        = string
}

variable "tags" {
  description = "Tags to be attached to the database"
  type        = map(any)
}

variable "db_username" {
    description = "The master db username"
    type        = "string"
}

variable "db_password" {
    description = "The master db password"
    type        = "string"
}