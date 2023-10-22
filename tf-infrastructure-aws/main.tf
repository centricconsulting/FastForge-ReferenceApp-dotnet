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

module "rds" {
    source = "./_Modules/rds"
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
}

