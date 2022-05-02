# Variables that are going to be used in the deployment and configurationof all infrastructure

input_vpc_name                          = "vpc-wordpress"                       # Input the name of the vpc
input_vpc_cidr_block                    = "10.0.0.0/16"                         # VPC's cidr block
input_igw_name                          = "igw_wordpress"                       # The name of the internet gateway
input_subnet_public_availability_zones  = ["us-east-1a"]                        # list of availability zones you want public subnets in (one per az)
input_subnet_private_availability_zones = ["us-east-1a", "us-east-1b"]          # list of availability zones you want private subnets in (one per az)
input_subnet_bits                       = 8                                     # number of bits used for configuring the subnet's cidr blocks !see cidrsubnet!
input_sg_dmz_ports_ingress              = [443, 80, 22, 3306]                   # list of ports for ingress for public sg
input_sg_dmz_protocol_ingress           = "tcp"                                 # protocol for ingress for public sg
input_sg_rds_ports_ingress              = [3306]                                # list of ports for ingress for private sg
input_sg_rds_protocol_ingress           = "tcp"                                 # protocol for ingress for private sg

input_instance_ec2_ami                         = "ami-0f9fc25dd2506cf6d"        # Specify the ami(Amazon Machine Image) of our instance
input_instance_ec2_type                        = "t2.micro"                     # Type of instance
input_instance_ec2_key                         = "key"                          # The key for our instance - check available keys on your account
input_instance_ec2_name                        = "server-wordpress"             # Name of the instance
input_instance_ec2_associate_public_ip_address = true                           # type true or false whether or not you want to associate a public ip (dynamic) to your instance
# If you want to assign a web domain to the web_server instance you might want to consider provisioning an elastic ip address by setting the variable (boolean) underneath to true(if you want to provision an eip) or false(if you do not wantto provision an eip)
input_instance_ec2_create_eip_address          = true                           # This boolean allows or does not allow the assignation of an elastic (which in fact is a static ip address) ip address to the instance

input_db_allocated_storage          = 10                                        # The allocated storage (GB) of the DataBase
input_db_name_identifier            = "db-wordpress"                            # The name tag of the database instance
input_db_engine                     = "mysql"                                   # The database engine
input_db_engine_version             = "5.7"                                     # The database engine version
input_db_instance_class             = "db.t3.micro"                             # The database instance class (processing power)
# It's best practice to keep these variables in a separate file
input_db_name                       = "db_wordpress"                            # The name of the database (resource name)
input_db_username                   = "administrator"                           # Database username
input_db_password                   = "parola1234"                              # Database password 
input_db_skip_final_snapshot        = true                                      # Boolean that selects whether or not final snapshot creation must be skipped or not
