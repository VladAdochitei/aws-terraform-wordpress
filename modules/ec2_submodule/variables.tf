#---------- Variables related to the ec2-instance initial aws configuration and setup
variable "instance_ec2_ami" {
    type = string
    description = "The ami (amazon machine image) of our instance"
}

variable "instance_ec2_type" {
    type = string
    description = "The instance's type"
    default = "t2.micro"
}

#!!!!! You must change this with a key that is stored in your account !!!!!#
variable "instance_ec2_key" {
    type = string
    description = "The key pair that will be used in order to log into the instance, select one stored in your aws account. You can find them under the ec2 section ->key pairs"
}
#!!!!!!!!!!!!!

variable "instance_ec2_name" {
    type = string
    description = "The name of the ec2 instance"
}

variable "instance_ec2_sg_ids"{
    type = list
    description = "The ids of the security groups that will be assigned to the instance"
}


variable "instance_ec2_subnet_id" {
    type = string
    description = "The subnet ID of the instance's host subnet"
}

variable "instance_ec2_associate_public_ip_address" {
    type = bool
    description = "Configuration parameter that will allow or deny the provision of a public ip address that will be assigned to the instance"
}

#---------- Variables related to the scripts that must run on our ec2-instance

variable "ec2_database_user" {
    type = string
    description = "The database user of the database instance"
}

variable "ec2_database_password" {
    type = string
    description = "The database password of the database instance"
}

variable "ec2_database_name" {
    type = string
    description = "The database name of the database instance"
}

variable "ec2_database_endpoint" {
    type = string
    description = "The database endpoint"
}

#---------- Variables related to the elastic ip address creation and assignation
variable "instance_ec2_create_eip_address" {
    type = bool
    default = false
    description = "True if you want to provision an elastic IP address"
}


