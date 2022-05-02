#!/bin/bash
# This will create a .txt file that contains all the exit codes of all commands, so you will know if anything does not work as intended
# The commands after #, ex: echo "File created with exit code: $?" >> /home/ec2-user/wordpress-deploy-status.txt are just for checking if that operation executed successfully
# 0 means successfull and 1 means failed

touch /home/ec2-user/wordpress-deploy-status.txt
touch /var/www/html/wordpress-deploy-status.html
echo "Status file created with exit code: $?" >> /home/ec2-user/wordpress-deploy-status.txt

# Variables that are going to be used in order to connect our wordpress website to the database
db_username=${db_username}                &&    echo "Variable db_username created with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                             &&    echo "Variable db_username created with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
db_user_password=${db_user_password}      &&    echo "Variable db_user_password created wit exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                         &&    echo "Variable db_user_password created wit exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
db_name=${db_name}                        &&    echo "Variable db_name created with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                 &&    echo "Variable db_name created with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html                      
db_RDS=${db_RDS}                          &&    echo "Variable db_RDS created with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                  &&    echo "Variable db_RDS created with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html



# Update and upgrade the machine
sudo yum update -y                        &&    echo "Update operation exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                              &&    echo "Update operation exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
sudo yum upgrade -y                       &&    echo "Upgrade operation exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                             &&    echo "Upgrade operation exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

# Install apache server engine and mysql client
sudo yum install -y httpd                 &&    echo "HTTPD (Apache) daemon/engine provisioned and installed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                   &&    echo "HTTPD (Apache) daemon/engine provisioned and installed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
sudo yum install -y mysql                 &&    echo "MySql daemon/engine/client provisioned and installed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                     &&    echo "MySql daemon/engine/client provisioned and installed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

# Starting the apache server daemon service 
sudo systemctl start httpd                &&    echo "HTTPD (Apache webserver inititalized with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                     &&    echo "HTTPD (Apache webserver inititalized with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
sudo touch /var/www/html/server_health.html                                               #creates a file named ops_health.html in /var/www/html/
sudo bash -c 'echo web-server successfully deployed /n > /var/www/html/ops_health.txt' #confirmation that everything until now works as intended

# Enable php repository on the machine (is necessary so that our server would be able to host a wordpress website)
sudo amazon-linux-extras enable php7.4    &&    echo "Amazon php repo enabled with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                  &&    echo "Amazon php repo enabled with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
sudo yum clean metadata                   &&    echo "Metadata cleared with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                                                                         &&    echo "Metadata cleared with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
# Install php and its packages
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}  &&    echo "PHP packages installed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                     &&    echo "PHP packages installed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

# Install imagick extension
# This will substantially improve the quality of the images hosted on your wordpress website
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl       &&    echo "ImageMagick installed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
pecl install imagick                                                    &&    echo "Imagick installed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
chmod 755 /usr/lib64/php/modules/imagick.so                             &&    echo "Rights of the Imagick software changed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
echo "Imagick.ini configuration operation exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
#Restart the php engine 
systemctl restart php-fpm.service                                       &&    echo "PHP-FPM service restart finished with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                           &&    echo "PHP-FPM service restart finished with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

#start the httpd (apache daemon) 
systemctl start  httpd                                                  &&    echo "---> HTTPD service start operation executed exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                     &&    echo "---> HTTPD service start operation executed exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

# Change OWNER and permission of directory /var/www
usermod -a -G apache ec2-user                                           &&    echo "apache usermod command executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
chown -R ec2-user:apache /var/www                                       &&    echo "apache ownership set to /var/wwwdirectory execution with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
find /var/www -type d -exec chmod 2775 {} \;                            &&    echo "/var/www chmod command type d executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt
find /var/www -type f -exec chmod 0664 {} \;                            &&    echo "/var/www chmod command type f executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt

#**********************Installing Wordpress using WP CLI********************************* 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar         &&    echo "WP command line interface package downloaded with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                     # Downloads the Wordpress cli package
chmod +x wp-cli.phar                                                                      &&    echo "wordpress cli execution rights eecuted with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                           # Gives execution rights to the wp cli 
mv wp-cli.phar /usr/local/bin/wp                                                          &&    echo "Move the cli in the bin directory executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                       # Moves the package in /usr/local/bin/wp -> after this step is complete now ititpossible to run the wp-cli commands
wp core download --path=/var/www/html --allow-root                                        &&    echo "Core WP package download executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                # Downloads the core package of wordpress in /var/www/html

# The following command links the wordpress website to the database
# !NOTE! If the database is not provisioned this step will not be executed because the variables do not have any value
wp config create --dbname=$db_name --dbuser=$db_username --dbpass=$db_user_password --dbhost=$db_RDS --path=/var/www/html --allow-root --extra-php <<PHP
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '128M');
PHP
echo "---> DATABASE LINK executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt    &&echo "---> DATABASE LINK executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt

# Change permission of /var/www/html/
chown -R ec2-user:apache /var/www/html                                                    &&    echo "chown command on the apache @ /var/www/html executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt 
chmod -R 774 /var/www/html                                                                &&    echo "chmod command on /var/www/html executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt

#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf                                                                                                                                && echo "override of /var/www executed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

#Make apache  autostart and restart apache
systemctl enable  httpd.service                                                           &&    echo "HTTPD daemon enable command executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                           &&    echo "HTTPD daemon enable command executed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html
systemctl restart httpd.service                                                           &&    echo "HTTPD Service restart executed with exit code: $? <br>" >> /home/ec2-user/wordpress-deploy-status.txt                                                 &&    echo "HTTPD Service restart executed with exit code: $? <br>" >> /var/www/html/wordpress-deploy-status.html

# This is used just for checking if all the configuration commands listed before were done correctly
echo 'WordPress Installed successfully' >> /home/ec2-user/wordpress-deploy-status.txt           && echo 'WordPress Installed successfully' >> /var/www/html/wordpress-deploy-status.html
#cp /home/ec2-user/wordpress-deploy-status.txt /var/www/html/wordpress-deploy-status.html 