resource "aws_db_instance" "rds" {
  apply_immediately       = true
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  engine                  = var.engine
  engine_version          = var.engine_version

#   family                  = "sqlserver-ex-15.0" # DB parameter group
#   major_engine_version    = "15.00"             # DB option group

  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = var.subnet_group
  vpc_security_group_ids  = var.security_group_ids 
  parameter_group_name    = aws_db_parameter_group.rds_parameter_group.id
  option_group_name       = aws_db_option_group.rds_option_group.id
  backup_retention_period = 0
  skip_final_snapshot     = true
}

resource "aws_db_option_group" "rds_option_group" {
  engine_name    = var.engine
  major_engine_version = var.major_engine_version

  #TODO - Dynamic section for RDS Options
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  family  = var.family

  #TODO - Dynamic section for RDS Parameters

  lifecycle {
    create_before_destroy = true
  }
}