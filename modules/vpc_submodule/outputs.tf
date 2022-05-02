output "vpc_id" {
    value = aws_vpc.vpc_main.id
    description = "The VPC's id"
}

output "vpc_cidr_block" {
    value = aws_vpc.vpc_main.cidr_block
    description = "The VPC's cidr block"
}

output "subnet_public_id"{
    value = aws_subnet.subnet_public[*].id
    description = "The public subnets' ids !Note it's of the list type"
}

output "subnet_private_id"{
    value = aws_subnet.subnet_private[*].id
    description = "The private subnets' ids !Note it's of the list type"
}

output "subnet_public_cidr"{
    value = aws_subnet.subnet_public[*].cidr_block
    description = "The public subnets' cidr blocks !Note it's of the list type"
}
output "subnet_private_cidr"{
    value = aws_subnet.subnet_private[*].cidr_block
    description = "The private subnets' cidr blocks !Note it's of the list type"
}

output "igw_id" {
    value = aws_internet_gateway.igw_wordpress.id
    description = "The internet gateway id"
}

output "rt_public_id" {
    value = aws_route_table.rt_public.id
    description = "The public route table id"
}

output "sg_dmz_id" {
    value = aws_security_group.sg_dmz.id
    description = "The demilitarized zone security group id"
}

output "sg_dmz_name" {
    value = aws_security_group.sg_dmz.name
    description = "The demilitarized zone security group name"
}

output "sg_rds_id" {
    value = aws_security_group.sg_rds.id
    description = "The private (database) security group id"
}

