#!/bin/bash

# Update any pre-installed software components
sudo yum update -y

# Install required software components
sudo yum install -y httpd
sudo amazon-linux-extras install -y php7.3
sudo yum install -y mysql
sudo yum install -y nfs-utils

# Prepare the EFS mount
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${EFS_MOUNT}":/   /var/www/html
echo "${EFS_ID}:/ /var/www/html nfs4 defaults,_netdev 0 0" >> /etc/fstab

# Set the appropriate permissions on /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;

# Create a php test page
sudo printf "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# Download and install the wordpress installation files
cd /tmp || exit
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i s/database_name_here/wordpress/ wordpress/wp-config.php
sed -i s/username_here/wordpress_user/ wordpress/wp-config.php
sed -i s/password_here/wordpress_password/ wordpress/wp-config.php
sed -i s/localhost/"${WP_DB_HOST}"/ wordpress/wp-config.php
cp -r wordpress/* /var/www/html/

# Configure mysql
mysql -u root -p"${ROOT_PWD}" -h "${DB_HOST}" -e "CREATE USER 'wordpress_user'@'%' IDENTIFIED BY 'wordpress_password';"
mysql -u root -p"${ROOT_PWD}" -h "${DB_HOST}" -e 'GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress_user"@"%";'
mysql -u root -p"${ROOT_PWD}" -h "${DB_HOST}" -e "FLUSH PRIVILEGES;"

# Start the required services
sudo systemctl start httpd
sudo systemctl enable httpd
