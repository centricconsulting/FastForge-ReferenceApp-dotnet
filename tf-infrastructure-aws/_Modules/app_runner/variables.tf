variable "name" {
  description = "The name of the app runner"
  type        = string
}

variable "ecr_uri" {
  description = "The URI of the ECR Repository"
  type        = string
}

variable "port" {
  description = "The port that the application listens on"
  type        = string
  default     = "5000"
}

variable "tags" {
  description = "Tags to be attached to the app runner"
  type        = map(any)
}

variable "auto_deployments_enabled" {
  description = "Enable automatic application deployment on image push"
  type        = bool
  default     = true
}

variable "rds_subnets" {
  description = "RDS private subnet(s)"
  type        = list(string)
}

variable "rds_security_groups" {
  description = "RDS security group(s)"
  type        = list(string)
}

variable "min_size" {
  description = "Miniumum number of instances to scale down"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances to scale up"
  type        = number
  default     = 1
}

variable "maximum_concurrent_requests" {
  description = "The maximum number of concurrent requests that forces a scale up"
  type        = number
  default     = 100
}

variable "cpu_units" {
  description = "The number of CPU units reserved for each instance - 256|512|1024|2048|4096|(0.25|0.5|1|2|4) vCPU"
  type        = string
  default     = "1 vCPU"
}

variable "memory_in_gb" {
  description = "The amount of RAM reserved for each instance (0.5, 1, 2, 3, 4, 6, 8, 10, 12) GB"
  type        = string
  default     = "2 GB"
}