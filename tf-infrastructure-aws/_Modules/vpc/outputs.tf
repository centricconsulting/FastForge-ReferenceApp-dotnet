output "private_subnet_ids" {
    description = "List of the private subnet ids"
    value       = aws_subnet.private_subnets[*].id
}

output "private_subnet_cidr_blocks" {
    description = "List of the private subnet cidr blocks"
    value       = aws_subnet.private_subnets[*].cidr_block
}

output "public_subnet_ids" {
    description = "List of the public subnet ids"
    value       = aws_subnet.public_subnets[*].id
}

output "public_subnet_cidr_blocks" {
    description = "List of the public subnet cidr blocks"
    value       = aws_subnet.public_subnets[*].cidr_block
}

output "rds_db_subnet_group_name" {
    description = "The RDS DB Subnet Group Name"
    value       = aws_db_subnet_group.rds_db_sg.id
}

output "rds_db_subnet_group" {
    description = "Id of the DB Subnet Group" 
    value       = aws_subnet_group.rds_sg.id
}