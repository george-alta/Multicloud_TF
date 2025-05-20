#!/bin/bash
# This script installs WordPress on an Amazon Linux 2023 instance.
exec > >(tee -a /var/log/init.log) 2>&1
set -x

# Variables
#  DBNAME="${db_name}"
# DBUSER="${db_user}"
# DBPASS="${db_pass}"
# MYSQL_ROOT_PASSWORD="${mysql_root_password}"

# Update system
dnf update -y

# Install packages
dnf install -y httpd php php-mysqlnd php-fpm php-json php-mbstring php-xml php-curl mariadb105-server wget unzip curl

# Start and enable services
systemctl start httpd
systemctl enable --now httpd
systemctl start mariadb
systemctl enable --now mariadb

# Wait 5 seconds for MariaDB to fully start
sleep 5


# --- Run the secure SQL setup ---
mysql -u root <<EOF
-- Set root password 
ALTER USER 'root'@'localhost' IDENTIFIED BY '${mysql_root_password}';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disallow remote root login
UPDATE mysql.user SET Host='localhost' WHERE User='root';

-- Remove test database
DROP DATABASE IF EXISTS test;

-- Remove privileges on test DBs
DELETE FROM mysql.db WHERE Db LIKE 'test%';

-- Apply all changes
FLUSH PRIVILEGES;


-- Create WordPress DB and user

CREATE DATABASE IF NOT EXISTS ${db_name};
CREATE USER IF NOT EXISTS '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.zip
unzip -q latest.zip
rm -rf /var/www/html/*
mkdir -p /var/www/html/
cp -r wordpress/* /var/www/html/
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# Configure WordPress
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_pass}/" wp-config.php

# Add unique salts
curl -s https://api.wordpress.org/secret-key/1.1/salt/ | tee -a wp-config.php > /dev/null

# Optional: Install phpMyAdmin (not hardened for production)
cd /var/www/html
curl -L https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -o phpmyadmin.zip
unzip -q phpmyadmin.zip
mv phpMyAdmin-*-all-languages phpmyadmin
rm phpmyadmin.zip
chown -R apache:apache phpmyadmin

# Restart Apache
systemctl restart httpd

echo "✅ WordPress installed. Visit your EC2 public IP in a browser to complete setup."
