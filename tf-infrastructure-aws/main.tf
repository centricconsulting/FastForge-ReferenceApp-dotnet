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

module "ecs_fargate" {
    source = "./_Modules/ecs"
    container_registry_url = "382999077194.dkr.ecr.us-east-2.amazonaws.com/fastforge-container-registry"
}