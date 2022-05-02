#           ~ Vpc variables ~
variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "The cidr block of the vpc"
}

variable "vpc_name" {
    type = string
    description = "The name of this vpc"
}

# Internet Gateway
variable "igw_name" {
    type = string 
    description = "the name of the internet gateway"
}


#           ~ Subnets ~
#public
variable "subnet_public_availability_zones" {
    type = list(string)
    description = "the list of azs for the public subnets (one subnet per az will be provisioned)"
}

#private
variable "subnet_private_availability_zones"{
    type = list(string)
    description = "the list of azs for the private subnets (one subnet per az will be provisioned)"
}

#configuration arguments
variable "subnet_bits" {
    type = number
    default = 8
    description = "argument used in order to configure the subnets' subnetting"
}

#security groups
variable "sg_dmz_ports_ingress" {
    type = list(number)
    description = "the ingress ports allowed for the dmz sg"
}

variable "sg_dmz_protocol_ingress" {
    type = string
    description = "The protocol allowed for ingress traffic in the dmz"
}

variable "sg_rds_ports_ingress" {
    type = list(number)
    description = "The ports allowed for ingress traffic in the database sunets's sg"
}

variable "sg_rds_protocol_ingress" {
    type = string
    description = "The protocol allowed for ingress traffic in the database sg/subnet"
}