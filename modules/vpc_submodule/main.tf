# VPC (Virtual Private Cloud) module
# Upon provision, this module will create all the infrastructure that will be necessary in order to host our application
# VPC provision
resource "aws_vpc" "vpc_main"{
    cidr_block = var.vpc_cidr_block           # VPC cidr block
    tags = {
        Name = var.vpc_name                   # VPC Name
    }

}

# Internet Gateway Provision
# The IGW is required in order to connect the infrastructure residing in the VPC with the internet
resource "aws_internet_gateway" "igw_wordpress" {
    vpc_id = aws_vpc.vpc_main.id                    # Connection of the igw and vpc
    tags = {
        Name = var.igw_name                         # The name of the internet gateway
    }
}


# Subnet provision
# PUBLIC SUBNET(S)
# Iteration setup, the counter will go through all of the az s provided in the list 
# -> (e.g. if we have 3, the loop will be iterated 3 times, creating one public subnet per az. This will create 3 public subnets, each residing in a different az)
resource "aws_subnet" "subnet_public" {
    count             = length(var.subnet_public_availability_zones)                 # Iterator assignation
    availability_zone = var.subnet_public_availability_zones[count.index]            # Assign the availability zone per iteration
    vpc_id            = aws_vpc.vpc_main.id                                          # Connect to vpc (the one previously created)

    # See documentation of the cidrsubnet function
    # Given thefact that in most cases the vps's have a mask similar to 10.0.0.0/16 it is best to set the subnet_bits variable(in this case, argument) to 8. This will leave us with subnets of this form 10.0.1.0/24 which I find easier to identify and manipulate
    cidr_block = cidrsubnet("${var.vpc_cidr_block}", "${var.subnet_bits}", "${count.index + 1}")     # assign cidr block based on iteration, a configuration parameter named "subnet_bits" and the network submask of the vpc

    tags = {
        Name = "subnet_public_${count.index + 1}" # The public subnet's name according to the iteration
    }
}


# PRIVATE SUBNET(S)
# Iteration setup, the counter will go through all of the az s provided in the list 
# -> (e.g. if we have 3, the loop will be iterated 3 times, creating one private subnet per az. This will create 3 public subnets, each residing in a different az)
resource "aws_subnet" "subnet_private" {
    count             = length(var.subnet_private_availability_zones)              # Iterator assignation
    availability_zone = var.subnet_private_availability_zones[count.index]         # Assign the availability zone per iteration
    vpc_id            = aws_vpc.vpc_main.id                                        # Connect to vpc (the one previously created)


    # See documentation of the cidrsubnet function
    # Given the fact that in most cases the vps's have a mask similar to 10.0.0.0/16 it is best to set the subnet_bits variable(in this case, argument) to 8. This will leave us with subnets of this form 10.0.101.0/24 which I find easier to identify, manipulate and differentiate from the public subnets
    cidr_block = cidrsubnet("${var.vpc_cidr_block}", "${var.subnet_bits}", "${count.index + 101}") # assign cidr block based on iteration, a configuration parameter named "subnet_bits" and the network submask of the vpc

     tags = {
        Name = "subnet_private_${count.index+1}" # The private subnet's name according to iteration
    }
}

# Route Tables
# Public RT - This route table manages traffic to the internet
resource "aws_route_table" "rt_public" {
    vpc_id = aws_vpc.vpc_main.id
       # This route is for outbound internet traffic
  route {
      # This route directs traffic for the internet through the internet gateway previousely provisioned
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_wordpress.id
  }
  
  route {
      # Internet traffic for ipv6 ips routed through the igw
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw_wordpress.id
  }

    tags = {
        Name = "rt_public"
    }

}

# Public subnet Routing table association 
# This will associate all of the public subnets with the internet gateway
 resource "aws_route_table_association" "association_rt_public" {
     # This section will go through each subnet ids and associate them with the public route table
     count          = length(var.subnet_public_availability_zones)         # Iterator setup
     subnet_id      = aws_subnet.subnet_public[count.index].id             # The iteration's public subnet id (this is necessary to know which subnet will be associated with the public route table)
     route_table_id = aws_route_table.rt_public.id                         # The associated route table (in this case, the public rt)
}

# Security Groups

# DMZ (Demilitarized Zone) security group
# This section will configure the dmz sg (The server's sg)
resource "aws_security_group" "sg_dmz" {
  name        = "sg_dmz"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_main.id       # vpc assignation

    #Ingress (inbound)
    # This dynamic block will go through each of the ports provided in the list "sg_dmz_ports_ingress" and create a rule to allow traffic on that port to the internet
    dynamic "ingress" {
    iterator = port                     # Iterator setup, this is used in the for_each funcion -> see terraform for_each documentation
    for_each = var.sg_dmz_ports_ingress # For each of the ports in the list
    content {
      from_port   = port.value                  # ingress from port
      to_port     = port.value                  # to the same port, meaning that'll enable only a port at a time, because they aren't always consecutive
      protocol    = var.sg_dmz_protocol_ingress # the protocol found in the variable, usually it's tcp
      cidr_blocks = ["0.0.0.0/0"]               #It is a dmz, therefore this traffic will be allowed on the internet
    }
    }


  #Egres (outbound) (allows all outbound traffic)
  egress {
    description      = "Allow all outbound traffic on all protocols"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"              # '-1' for the protocol means all the protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-dmz"
  }
}


# Private zone security group
# The purpose of this security group is to harden the infrastructure's security by allowing database trafic to flow only from and to the DMZ
# This will mitigate the risk of data leak and will make the communication between the DB and the server more secure 
resource "aws_security_group" "sg_rds" {
  name        = "sg_rds"
  description = "Allow db traffic inbound"
  vpc_id      = aws_vpc.vpc_main.id

    # Ingress (inbound)
    # This dynamic block will go through each of the ports provided in the list "sg_rds_ports_ingress" and create a rule to allow traffic on that port to the dmz zone's subnets' cird blocks
    dynamic "ingress" {
    iterator = port
    for_each = var.sg_rds_ports_ingress
    content {
      from_port   = port.value                              # ingress from port
      to_port     = port.value                              # to the same port, meaning that'll enable only a port at a time, because they aren't always consecutive
      protocol    = var.sg_rds_protocol_ingress             # the protocol found in the variable, usually it's tcp
      cidr_blocks = aws_subnet.subnet_public[*].cidr_block  # the cidr blocks of the public subnets
    }
    }

  #-----------------------------------------------------------------------------------------------------!-------------
  #Egress means outbound (allows outbound traffic to the public subnets only), this is a security measure to prevent egress and ingress traffic from the database to the internet
  egress {
    description      = "Allow database outbound traffic on all protocols and only to the cidr blocks of the public subnets in this vpc (the DMZ)"
    from_port        = 3306               # The port used for mysql
    to_port          = 3306               # The port used for mysql
    protocol         = "tcp"               # only tcp
    cidr_blocks      = aws_subnet.subnet_public[*].cidr_block
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-rds-to-dmz"
  }
}
