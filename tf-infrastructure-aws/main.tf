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


####################
# Random Resources # 
####################
resource "random_password" "password" {
    length  = 16
    special = true
    override_special = "_%@"
}

resource "random_string" "random" {
    length  = 16
    special = true
    override_special = "/@£$"
}

module "rdm_user_secret" {
  source = "./_Modules/secrets"
  name = "${var.project_name}_rdm_admin_user"
  secret_string = random_string.random.result
}

module "rdm_user_password" {
  source = "./_Modules/secrets"
  name = "${var.project_name}_rdm_admin_password"
  secret_string = random_password.password.result
}

module "vpc" {
  source = "./_Modules/vpc"
  tags = {
    Project_name = var.project_name
  }       
}

module "rds" {
  source = "./_Modules/rds"
    db_name            = var.db_name
    subnet_group       = module.vpc.rds_db_subnet_group_name
    security_group_ids = [module.vpc.rds_db_security_group]
    db_username        = random_string.random.result
    db_password        = random_password.password.result
    tags = {
      Project_name = var.project_name
    }
    depends_on  = [module.rdm_user_secret, module.rdm_user_password]  
}

module "app" {
  source = "./_Modules/app_runner"
    name = "${var.project_name}_app_runner"
    ecr_uri = var.ecr_uri
    rds_subnets = module.vpc.private_subnet_ids
    rds_security_groups = [module.vpc.rds_db_security_group]
    tags = {
      Project_name = var.project_name
    }
}