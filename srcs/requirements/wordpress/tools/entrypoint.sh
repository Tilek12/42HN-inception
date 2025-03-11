#!/bin/bash

# Exit immediately if any command fails
set -e

# Set WordPress credentials
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_REGULAR_PASSWORD=$(cat /run/secrets/wp_password)
WORDPRESS_PATH="/var/www/html/wordpress"
PHP_FPM_SOCKET_PATH="/run/php"

# Create WordPress directory and set permissions if doesn't exist
if [ ! -d ${WORDPRESS_PATH} ]; then
	echo "Creating directory: ${WORDPRESS_PATH}..."
	mkdir -p ${WORDPRESS_PATH}
	chown -R www-data:www-data ${WORDPRESS_PATH}
	chmod -R 755 ${WORDPRESS_PATH}
fi

# Create PHP-FPM socket directory and set permissions if doesn't exist
if [ ! -d ${PHP_FPM_SOCKET_PATH} ]; then
	echo "Creating directory: ${PHP_FPM_SOCKET_PATH}..."
	mkdir -p ${PHP_FPM_SOCKET_PATH}
	chown -R www-data:www-data ${PHP_FPM_SOCKET_PATH}
	chmod -R 755 ${PHP_FPM_SOCKET_PATH}
fi

# Change to WordPress directory
cd ${WORDPRESS_PATH}

# Download and install WordPress if not installed
if ! wp core is-installed --path=${WORDPRESS_PATH} --allow-root > /dev/null 2>&1; then
	echo "WordPress is not installed..."

	# Download WordPress
	wp core download --path=${WORDPRESS_PATH} --allow-root

	# Create wp-config.php
	echo "Creating wp-config.php..."
	wp config create \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${WORDPRESS_DB_PASSWORD} \
		--dbhost=${WORDPRESS_DB_HOST} \
		--path=${WORDPRESS_PATH} \
		--allow-root

	# Install WordPress with Admin user
	wp core install --url=${DOMAIN_NAME} \
					--title="${WORDPRESS_TITLE}" \
					--admin_user=${WORDPRESS_ADMIN} \
					--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
					--admin_email=${WORDPRESS_ADMIN_EMAIL} \
					--skip-email \
					--allow-root

	# Create regular user
	wp user create ${WORDPRESS_REGULAR_USER} ${WORDPRESS_REGULAR_EMAIL} \
					--user_pass=${WORDPRESS_REGULAR_PASSWORD} \
					--role=author \
					--allow-root

	echo "Wordpress is successfully installed..."

else
	echo "WordPress is already installed..."
fi

echo "Starting php-fpm..."

# Execute the command passed via CMD
exec "$@"
