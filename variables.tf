#--------------------------------------------------------------------------------------------------------------------------------------->vpc variables
variable "input_vpc_name" {
    type = string
    description = "The name of the vpc"
} 

variable "input_vpc_cidr_block" {
    type = string
    description = "The cidr block of the vpc"
}

#----------------------------------------------------------------------------------------------------------------------------------> subnets variables
#------------------------------------------------------------------------------------------------> public_subnets
variable "input_subnet_public_availability_zones" {
    type = list(string)
    description =  "the list of azs for the public subnets (one subnet per az will be provisioned)"
}

variable "input_subnet_bits" {
    type = number
    default = 8
    description = "argument used to configure the subnets' subnetting"
}
#------------------------------------------------------------------------------------------------> private_subnets
variable "input_subnet_private_availability_zones" {
    type = list(string)
    description = "the list of azs for the private subnets (one subnet per az will be provisioned)"
}


variable "input_igw_name" {
    type = string
    description = "the name of the internet gateway"
}

#------------------------------------------------------------------------------------------------------------------------------------> security groups
variable "input_sg_dmz_ports_ingress" {
    type = list(number)
    description = "the ingress ports allowed for the dmz sg"
}

variable "input_sg_dmz_protocol_ingress" {
    type = string
    description = "the ingress protocol allowed for traffic on the dmz sg"
}


variable "input_sg_rds_ports_ingress" {
    type = list(number)
    description = "the ingress ports allowed for the rds sg"
}

variable "input_sg_rds_protocol_ingress" {
    type = string
    description = "the ingress protocol allowed for traffic through the rds sg"
}


#---------------------------------------------------------------------------------------------------------------------------------------> ec2 instance
variable "input_instance_ec2_ami" {
    type = string
    description = "The ami(amazon machine image of our machine)"
}

variable "input_instance_ec2_type" {
    type = string
    description = "type of instance"
}


variable "input_instance_ec2_key" {
    type = string
    description = "key used to connect to our machine, make sure to have said key in your account"
}

variable "input_instance_ec2_name" {
    type = string
    description = "The name of the ec2 instance"
}

variable "input_instance_ec2_associate_public_ip_address" {
    type = bool  
    description = "Configuration parameter that will allow or deny the provision of a public ip address that will be assigned to the instance"
}

# To provision the Elastic IP set the variable "instance_ec2_create_eip_address" to false, in the main(root) variables folder
# Note that unassigned Elastic Ip addresses can generate costs on your account
# Note that you can have a maximum of 5 elastic ip addresses
variable "input_instance_ec2_create_eip_address" {
    type = bool
    default = false
    description = "True if you want to provision an elastic IP address"
}

#-------------------------------------------------------------------------------------------------------------------------------------------> database
variable "input_db_allocated_storage" {
    type = number
    description = "storage allocated (GiB)"
}

variable "input_db_engine" {
    type = string
    description = "The database engine"
}

variable "input_db_engine_version" {
    type = string
    description = "The database engine version"
}

variable "input_db_instance_class" {
    type = string
    description = "type of instance, it's performance, etc"
}

variable "input_db_name" {
    type = string
    description = "The database's name, !NOT name tag !will be used by the server to connect to the database"
}

variable "input_db_username" {
    type = string
    description = "The database's username !will be used by the server to connect to the database"
}

variable "input_db_password" {
    type = string
    description = "The database's password !will be used by the server to connect to the database"
}

variable "input_db_skip_final_snapshot" {
    type = bool
    default = true
    description = "Configuration argument that will skip or notskipthe final snapshot"
}

variable "input_db_name_identifier" {
    type = string
    description = "The Nametag of the database"
}
