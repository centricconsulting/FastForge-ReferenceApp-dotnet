variable "db_name" {
  description = "The name of the database instance"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "ecr_uri" {
  description = "The URI of the ECR Container Repository"
  type        = string
}