#!/bin/bash
# This script installs WordPress on an Amazon Linux 2023 instance.
exec > >(tee -a /var/log/init.log) 2>&1
set -x

# Variables
# DBHOST="${db_host}"
# DBNAME="${db_name}"
# DBUSER="${db_user}"
# DBPASS="${db_pass}"
# MYSQL_ROOT_PASSWORD="${mysql_root_password}"
# EFS_ID="${efs_id}"

# Update system
dnf update -y

# Install packages
dnf install -y httpd php php-mysqlnd php-fpm php-json php-mbstring php-xml php-curl mariadb105-server
yum install -y amazon-efs-utils

# Start and enable services
systemctl start httpd
systemctl enable --now httpd
systemctl start mariadb
systemctl enable --now mariadb

# Wait 5 seconds for MariaDB to fully start
sleep 5

# Echo variables
echo "DBHOST: ${db_host}"
echo "DBNAME: ${db_name}"
echo "DBUSER: ${db_user}"
echo "DBPASS: ${db_pass}"
echo "MYSQL_ROOT_PASSWORD: ${mysql_root_password}"



# Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.zip
unzip -q latest.zip
rm -rf "/var/www/html/"*

# mount EFS in /var/www/html/ and ensure it persists across reboots
mkdir -p /var/www/html
mount -t efs ${efs_id}:/ /var/www/html
echo "${efs_id}:/ /var/www/html efs defaults,_netdev 0 0" >> /etc/fstab

# Copy WordPress files to the web root
cp -r "wordpress/"* /var/www/html/
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# Install WP CLI
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info

# 1. Create wp-config.php
wp config create \
  --dbname="${db_name}" \
  --dbuser="${db_user}" \
  --dbpass="${db_pass}" \
  --dbhost="${db_host}" \
  --path=/var/www/html \
  --allow-root


# 2. Add salts, debug, SSL, and site URL
wp config shuffle-salts --path=/var/www/html --allow-root

wp config set WP_DEBUG true --raw --path=/var/www/html --allow-root
wp config set WP_DEBUG_LOG true --raw --path=/var/www/html --allow-root
wp config set WP_DEBUG_DISPLAY true --raw --path=/var/www/html --allow-root
wp config set FORCE_SSL_ADMIN true --raw --path=/var/www/html --allow-root
wp config set WP_HOME 'https://www.terraformistas.cloud' --path=/var/www/html --allow-root
wp config set WP_SITEURL 'https://www.terraformistas.cloud' --path=/var/www/html --allow-root
sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i \
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n  \$_SERVER['HTTPS'] = 'on';\n}" wp-config.php


# 3. Finally, install WordPress
wp core install \
  --url='${wp_url}' \
  --title='${wp_title}' \
  --admin_user='${wp_admin_user}' \
  --admin_password='${wp_admin_password}' \
  --admin_email='${wp_admin_email}' \
  --path=/var/www/html \
  --allow-root

# 4. create multiple random posts using WP CLI
for i in {1..5}; do
  wp post create --post_type=post --post_title="Random Post $i" --post_content="This is the content of random post $i." --path=/var/www/html --allow-root
done

# Optional: Install phpMyAdmin (not hardened for production)
cd /var/www/html
curl -L https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -o phpmyadmin.zip
unzip -q phpmyadmin.zip
mv phpMyAdmin-*-all-languages phpmyadmin
rm phpmyadmin.zip
chown -R apache:apache phpmyadmin

# Create config file if not exists
CONFIG_FILE="/var/www/html/phpmyadmin/config.inc.php"
if [ ! -f "$CONFIG_FILE" ]; then
  cp /var/www/html/phpmyadmin/config.sample.inc.php "$CONFIG_FILE"
fi

# Generate blowfish secret
BLOWFISH=$(openssl rand -base64 32)

# Inject DB host and blowfish secret into config
sed -i "s|\(\$cfg\['blowfish_secret'\]\s*=\s*\).*|\1'$BLOWFISH';|" "$CONFIG_FILE"
sed -i "/\$cfg\['Servers'\]\[1\]\['host'\]/c\$cfg['Servers'][1]['host'] = '$db_host';" "$CONFIG_FILE"

# If host line doesn't exist, append it
grep -q "\['host'\]" "$CONFIG_FILE" || echo "\$cfg['Servers'][1]['host'] = '$db_host';" >> "$CONFIG_FILE"

echo "✅ phpMyAdmin installed and configured with DB host: $db_host"

# install GD library for image processing
sudo dnf install -y php-gd
sudo systemctl restart php-fpm
sudo systemctl restart httpd

# Create a file for the health check. Healthcheck.php will return a 200 OK response.
cat <<EOF > /var/www/html/healthcheck.php
<?php
http_response_code(200);
echo "OK";
EOF

# Restart Apache
systemctl restart httpd

echo "✅ WordPress installed. Visit your EC2 public IP in a browser to complete setup."
