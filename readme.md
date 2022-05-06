Title: Aws wordpress_website terraform infrastructure
Creator: Vladut-Andrei Adochitei
Description:

-> AWS terraform infrastructure code
-> Module oriented architecture
-> With the current setup the code creates the following resources
      -> 1 vpc
      -> 1 internet gateway
      -> 1 public subnet
      -> 2 private subnets (aws_rds requires at least 2 subnets)
      -> 1 public rt
      -> 2 security groups,1 for the dmz and 1 for the db subnets
      -> 1 ec2 instance
      -> 1 database
      -> 1 elastic ip address
      -> 1 subnet group
      -> 1 rt association

-> Every module and variable is documented in the code, so feel free to configure the infrastructure as you want.

->The shell script incorporates an execution status file for easy debug,to access it go to:
      /home/ec2-user/wordpress-deploy-status.txt file in the ec2 instance
-> Another way of verifying the deployment exit codes of all the commands execution on the server isto access the server via: 
      http://${server-ip}/wordpress-deploy-status.html 

Before you run this code:
+ make sure you have aws cli installed
<code>sudo apt install awscli<code>
<code>aws configuration<code> 
and insertyour access key and the secret access key

+ make sure you have terraform installed on your machine: 
<code>sudo apt(/yum/pacman/whatever) terraform><code>
<code>git clone https//github.com/VladAdochitei/aws-terraform-wordpress<code>
<code>terraform init <code> -> make sure you execute this command in the root folder of the terraform
<code>terraform get <code>
<code>terraform plan <code>
<code>terraform apply <code>

!!! Also make sure you configure yoour terraform code to suit your needs !!!

NOTE regarding the files:
      ROOT:
       main.tf                      -> terraform script
       variables.tf                 -> declaration of variables
       terraform.tfvars             -> variable values      {This is the file you will need to access in order to change the variables' value}
       init.tpl                     -> shell script of the server config
       modules:
            ec2_submodule:
                  main.tf           -> terraform script
                  outputs.tf        -> declaration of variables
                  variables.tf      -> variable values
            rds_submodule:
                  main.tf           -> terraform script
                  outputs.tf        -> declaration of variables
                  variables.tf      -> variable values
            vpc_submodule:
                  main.tf           -> terraform script
                  outputs.tf        -> declaration of variables
                  variables.tf      -> variable values
             
