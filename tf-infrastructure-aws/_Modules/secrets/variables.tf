variable "name" {
  description = "The name of the secret"
  type        = string
}

variable "secret_string" {
    description = "The secret value to protect"
    type        = string
    sensitive   = true
}

variable "recovery_window_in_days" {
  description = "The number of days to keep the secret before hard delete"
  type        = number
  default     = 0
}