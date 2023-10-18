variable "name" {
  description = "The bucket name"
  type        = string
}

variable "tags" {
  description = "Tags to be attached to the S3 Bucket"
  type        = map(any)
}

variable "acl" {
    description = "Canned ACL value for accessing the S3 bucket"
    type        = "string"
    default     = "private"
}
