resource "aws_db_instance" "rds" {
  allocated_storage       = 5
  storage_type            = "gp2"
  engine                  = "sqlserver-ex"
  engine_version          = "15.0"

#   family                  = "sqlserver-ex-15.0" # DB parameter group
#   major_engine_version    = "15.00"             # DB option group

  instance_class          = "db.t2.micro"
  db_name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.sqlserver"
  backup_retention_period = 0
}