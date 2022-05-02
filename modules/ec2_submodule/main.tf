# EC2 (Elastic Compute) module
# Upon provision, this module will generate an ec2 instance incorporating a predefined set of instructionsthat will connect it to a database (database which must be provisioned before this module)
# The following block wil provision the instance
resource "aws_instance" "web_server" {
    ami                             = var.instance_ec2_ami                            # The ami of the instance  
    instance_type                   = var.instance_ec2_type                           # The type of instance
    key_name                        = var.instance_ec2_key                            # The key pair used to log into the instance, You can use whatever key you have in your account, just be aware that you need acces to it
    vpc_security_group_ids          = var.instance_ec2_sg_ids                         # The ids of the security groups that this instance wil be assigned, must be written as a list although you may assign it to only one sg 
    subnet_id                       = var.instance_ec2_subnet_id                      # The subnet id that will host the instance
    associate_public_ip_address     = var.instance_ec2_associate_public_ip_address    # Boolean, will associate a public ip address to the machine or not, depending on its value

    # The following segment will tell terraform what commands to run in order to bootstrap the instance
    user_data                       = data.template_file.user_data.rendered           # This is the file that contains all the necessary data

    tags = {
        Name = "${var.instance_ec2_name}"
    }
}
# File that will be used in order to configure the ec2 instance with all prerequisites
# This file holds some variables that will be used to connect the wordpress website to the databaseinstance
# All o the variablesthat come with this template_file will be knwn ONLY AFTER the database is provisioned, therefore, this module will depend on the database module (rds-submodule)
data "template_file" "user_data" {
  template = file("./init.tpl")           # !Note! You have to input the path from the root module, not this submodule
  vars = {
    db_username      = var.ec2_database_user            #database user
    db_user_password = var.ec2_database_password        #database password
    db_name          = var.ec2_database_name            #database name
    db_RDS           = var.ec2_database_endpoint        #database endpoint
  }
}

# This segment of code provisions and assigns an elastic ip address (You might consider creating one if you want to assign a domain to this website)
# The eip will be provisioned and assigned conditionally.
# To provision the Elastic IP set the variable "instance_ec2_create_eip_address" to false, in the main(root) variables folder
resource "aws_eip" "elastic_ip_wordpress" {
  count = var.instance_ec2_create_eip_address ? 1 : 0 # 
  instance = aws_instance.web_server.id
  vpc = true

  tags = {
    Name = "eip_wordpress"
  }
}