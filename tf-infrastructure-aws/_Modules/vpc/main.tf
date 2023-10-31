resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

# resource "aws_subnet" "public" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/25"

#   tags = var.tags
# }

resource "aws_subnet" "public_subnets" {
  count              = var.subnet_count.public
  
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.public_subnet_cidr_blocks[count.index]
  availability_zones = data.aws_availability_zones.available.names[count.index]
  tags = var.tags
}

# resource "aws_subnet" "private" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.2.0/25"

#   tags = var.tags
# }

resource "aws_subnet" "private_subnets" {
  count              = var.subnet_count.private

  vpc_id             = aws_vpc.main.id
  cidr_block         = var.private_subnet_cidr_blocks[count.index]
  availability_zones = data.aws_availability_zones.available.names[count.index]
  tags = var.tags
}

resource "aws_route_table" "public_rt" {
  vpc_id             = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = var.subnet_count.public

  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table" "private_rt" {
  vpc_id           = aws_vpc.main.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = var.subnet_count.private

  route_table_id = aws_route_tabel.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for the API."
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ingress_api.id

  //cidr_ipv4                    = "0.0.0.0/0"
  from_port                    = 1433
  ip_protocol                  = "tcp"
  to_port                      = 1433

  tags = var.tags
}


resource "aws_security_group" "api_sg" {
  name        = "ingress-api"
  description = "Allow ingress to API"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.api_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "api" {
  security_group_id = aws_security_group.api_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5000
  ip_protocol = "tcp"
  to_port     = 5000

  tags = var.tags
}

resource "aws_db_subnet_group" "rds_db_sg" {
  name = "db_subnet_group"
  description = "DB Subnet Group for RDS DB"

  subnet_ids  = [for subnet in aws_subnet.private_subnets : subnet.id]
}
