# Initital setup
 provider "aws" {
    region  = "us-east-1"
    profile = "default"
}


module "vpc-wordpress" {
    source = "./modules/vpc_submodule"
    # VPC setup
    vpc_name                            = var.input_vpc_name        # Name of the vpc
    vpc_cidr_block                      = var.input_vpc_cidr_block  # cidr block of the vpc

    #IGW setup
    igw_name                            = var.input_igw_name        # internet gateway name

    #SUBNETS setup
    subnet_public_availability_zones    = var.input_subnet_public_availability_zones    # public subnets' availability zones
    subnet_private_availability_zones   = var.input_subnet_private_availability_zones   # private subnets' availability zones
    subnet_bits                         = var.input_subnet_bits

    #SG setup
    sg_dmz_ports_ingress                = var.input_sg_dmz_ports_ingress      # ports allowed for ingress traffic in the dmz
    sg_dmz_protocol_ingress             = var.input_sg_dmz_protocol_ingress   # protocol allowed for ingress traffic in the dmz
    sg_rds_ports_ingress                = var.input_sg_rds_ports_ingress      # ports allowed for ingress traffic in the rds/private subnets
    sg_rds_protocol_ingress             = var.input_sg_rds_protocol_ingress   # protocol allowed for ingress traffic in the rds/private subnets
}

# EC2 setup (server setup and configuration)
module "ec2" {
    # Dependency lock
    # This will 
    depends_on = [
      module.vpc-wordpress, #VPC module must execute before this module (ec2)
      module.rds            #RDS module must execute before this module (ec2)
    ]
    source = "./modules/ec2_submodule"
    instance_ec2_ami                            = var.input_instance_ec2_ami                            # Instance's ami
    instance_ec2_type                           = var.input_instance_ec2_type                           # Instance's type
    instance_ec2_key                            = var.input_instance_ec2_key                            # Instance's ssh key
    instance_ec2_subnet_id                      = module.vpc-wordpress.subnet_public_id[0]              # Instance's residing subnet (In this case is the first subnet created in the vpc module. If you want multiple instances accross more than one subnetyou may consider changing the 0 to 1 and iterate multiple installments of this module)
    instance_ec2_sg_ids                         = ["${module.vpc-wordpress.sg_dmz_id}"]                 # Instance's security group (Demilitarized zone)
    instance_ec2_name                           = var.input_instance_ec2_name                           # Instance's name
    instance_ec2_associate_public_ip_address    = var.input_instance_ec2_associate_public_ip_address    # Associatiote a public ip address to the instance. In this case it's set to true, because the instance will need a public ip address in order to be accessible through the internet
    instance_ec2_create_eip_address             = var.input_instance_ec2_create_eip_address             # Provisionandassign an elastic ip address to the instance !!! See comments !!!
    # Database LINK
    # These variabes will be forwarded to the script that will bootstrap the server and sync it with the database
    ec2_database_user           =  var.input_db_username    # Database username
    ec2_database_name           = var.input_db_name         # Database name
    ec2_database_endpoint       = module.rds.db_endpoint    # Database endpoint
    ec2_database_password       = var.input_db_password     # Database password
}

module "rds" {
    # Dependency lock
    depends_on =[
        module.vpc-wordpress # The vpc module will need to be provisioned before
    ]
    source = "./modules/rds_submodule"
    db_name_identifier          = var.input_db_name_identifier                      # DB Name tag
    db_subnet_group             = module.vpc-wordpress.subnet_private_id            # The subnet group assigned to this database
    db_allocated_storage        = var.input_db_allocated_storage                    # The database's allocated storage
    db_engine                   = var.input_db_engine                               # The engine that the database is running (mysql, postgresql, etc)
    db_engine_version           = var.input_db_engine_version                       # The engine version of the database
    db_instance_class           = var.input_db_instance_class                       # The database class
    db_name                     = var.input_db_name                                 # The database's name (!Note! is used in the instance's link with the database) 
    db_username                 = var.input_db_username                             # The username of the database (!Note! is used in the instance's link with the database) 
    db_password                 = var.input_db_password                             # The database's password (!Note! is used in the instance's link with the database) 
    db_skip_final_snapshot      = var.input_db_skip_final_snapshot                  # Parameterrelated to the creation of the snapshot (can either be true or false)
    db_vpc_security_group_ids   = ["${module.vpc-wordpress.sg_rds_id}"]             # The security group ids           
    db_availability_zone        = var.input_subnet_private_availability_zones[0]    # the availability zone of the database                                           
}

# Generate a console output of the instance's public ip address for a more convenient website test 
output "server_public_ip_for_connect" {
    value = module.ec2.instance_ec2_public_ip
}

output "server_elastic_ip_address_for_connect" {
    value = module.ec2.eip
}