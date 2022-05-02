# RDS (Relational database service) module
# Upon provision, this module will provision an aws managed database (which, in this configuration, will be connected to an ec2 instance and subsequently to the wordpress website)

# Subnet group provision
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.db_subnet_group                      # Create a subnet group for the database (aws's managed rds requires at least 2 az's in order to work)
}                                                       # It is best to have at least 2 subnets that reside in different azs 

# The database provision
resource "aws_db_instance" "db-wordpress" {
  # Initial configuration
  allocated_storage    = var.db_allocated_storage       # Storage capacity of the db
  engine               = var.db_engine                  # The db's engine e.g.(sql, mariadb, postgresql, etc)
  engine_version       = var.db_engine_version          # The db's engine version
  instance_class       = var.db_instance_class          # The db's instance class (ram, cpu, etc)
  name                 = var.db_name                    # The db's name
  username             = var.db_username                # db username used to acces it
  password             = var.db_password                # db password used in combination with the username in order to connect to it 
  skip_final_snapshot  = var.db_skip_final_snapshot     # whether or not skip the creation of a snapshot 

  # In depth setup
  vpc_security_group_ids  = var.db_vpc_security_group_ids             # The id's of the security groups associated to the database
  availability_zone       = var.db_availability_zone                  # The database's residing availability zone (The database will be provisioned in this az)
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name  # The database's subnet group

  tags = {
    Name = var.db_name_identifier       # Database's Name tag
  }
} 