variable "container_registry_url" {
	description = "URL of the Container Registry"
    type        = string
}

variable "container_port" {
    description = "The port that the container is listening on"
    type        = number
    default     = 5000
}