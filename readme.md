Title: Aws wordpress_website terraform infrastructure  <br />
Creator: Vladut-Andrei Adochitei  <br />
Description:  <br />
  
-> AWS terraform infrastructure code  <br />
-> Module oriented architecture  <br />
-> With the current setup the code creates the following resources  <br />
      -> 1 vpc  <br />
      -> 1 internet gateway  <br />
      -> 1 public subnet  <br />
      -> 2 private subnets (aws_rds requires at least 2 subnets)  <br />
      -> 1 public rt  <br />
      -> 2 security groups,1 for the dmz and 1 for the db subnets  <br />
      -> 1 ec2 instance  <br />
      -> 1 database  <br />
      -> 1 elastic ip address  <br />
      -> 1 subnet group <br /> 
      -> 1 rt association  <br />
  <br />
-> Every module and variable is documented in the code, so feel free to configure the infrastructure as you want. <br /> 
  <br />
->The shell script incorporates an execution status file for easy debug,to access it go to:  <br />
      /home/ec2-user/wordpress-deploy-status.txt file in the ec2 instance  <br />
-> Another way of verifying the deployment exit codes of all the commands execution on the server isto access the server via:  <br />
      http://${server-ip}/wordpress-deploy-status.html  <br />
  <br />
Before you run this code:  <br />
+ make sure you have aws cli installed  <br />
<code>sudo apt install awscli<code>  <br />
<code>aws configuration<code>  <br />
and insertyour access key and the secret access key  <br />
  <br />
+ make sure you have terraform installed on your machine:  <br />
<code>sudo apt(/yum/pacman/whatever) terraform><code>  <br />
<code>git clone https//github.com/VladAdochitei/aws-terraform-wordpress<code> <br /> 
<code>terraform init <code> -> make sure you execute this command in the root folder of the terraform  <br />
<code>terraform get <code>  <br />
<code>terraform plan <code>  <br />
<code>terraform apply <code>  <br />
  <br />
!!! Also make sure you configure yoour terraform code to suit your needs !!! <br /> 
  <br />
NOTE regarding the files:<br />  
      ROOT:  <br />
       main.tf                      -> terraform script  <br />
       variables.tf                 -> declaration of variables <br /> 
       terraform.tfvars             -> variable values      {This is the file you will need to access in order to change the variables' value} <br />  
       init.tpl                     -> shell script of the server config  <br />
       modules:  <br />
            ec2_submodule: <br /> 
                  main.tf           -> terraform script <br /> 
                  outputs.tf        -> declaration of variables <br /> 
                  variables.tf      -> variable values  <br />
            rds_submodule:  <br />
                  main.tf           -> terraform script  <br />  
                  outputs.tf        -> declaration of variables  <br />  
                  variables.tf      -> variable values  <br />
            vpc_submodule:  <br />
                  main.tf           -> terraform script  <br />
                  outputs.tf        -> declaration of variables  <br />  
                  variables.tf      -> variable values  <br />
             <br />
<br />
