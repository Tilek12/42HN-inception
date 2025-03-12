#!/bin/bash

# Exit immediately if any command fails
set -e

# Set WordPress credentials
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_REGULAR_PASSWORD=$(cat /run/secrets/wp_password)
WORDPRESS_PATH="/var/www/html/wordpress"
PHP_FPM_SOCKET_PATH="/run/php"

# Function to create directories
create_directory() {
	local dir_path="$1"
	echo "Ensuring directory exists: $dir_path"
	mkdir -p "$dir_path"
	chown -R www-data:www-data "$dir_path"
	chmod -R 755 "$dir_path"
}

# Ensure required directories exist
create_directory "$WORDPRESS_PATH"
create_directory "$PHP_FPM_SOCKET_PATH"

# Switch to WordPress directory
cd ${WORDPRESS_PATH}

# Download and install WordPress if not installed
if ! wp core is-installed --allow-root > /dev/null 2>&1; then
	echo "WordPress is not installed..."

	# Download WordPress
	wp core download --allow-root

	# Create wp-config.php
	echo "Creating wp-config.php..."
	wp config create \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--path="${WORDPRESS_PATH}" \
		--allow-root

	# Install WordPress with Admin user
	wp core install \
		--url="${DOMAIN_NAME}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--skip-email \
		--allow-root

	# Create regular user
	wp user create \
		"${WORDPRESS_REGULAR_USER}" \
		"${WORDPRESS_REGULAR_EMAIL}" \
		--user_pass="${WORDPRESS_REGULAR_PASSWORD}" \
		--role=author \
		--allow-root

else
	echo "WordPress is already installed..."
fi

# Set WordPress to listen on port 9000
echo "Update PHP-FPM to listen on port 9000"
sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Check if WordPress settings are correct
echo "Validating PHP-FPM configuration..."
php-fpm7.4 -t

# Start WordPress
echo "Starting PHP-FPM..."
php-fpm7.4 -F
