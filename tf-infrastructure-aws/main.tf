terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "fastforge-build-artifacts"
    key    = "fastforge/terraform-backend"
    region = "us-east-2"
  }
}