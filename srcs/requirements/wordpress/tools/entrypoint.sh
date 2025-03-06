#!/bin/bash

# Set a timeout for the database check (e.g., 5 minutes)
TIMEOUT=300
START_TIME=$(date +%s)

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."

# Loop until the database is ready or the timeout is reached
while true; do
	# Use mysqladmin to check if the database is ready
	if mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"$(cat /run/secrets/db_password)" --silent; then
		echo "MariaDB is ready."
		break
	fi

	# Check if the timeout has been reached
	CURRENT_TIME=$(date +%s)
	ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
	if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
		echo "Error: Timeout reached while waiting for MariaDB to be ready."
		exit 1
	fi

	echo "MariaDB is not ready yet. Retrying in 10 seconds..."
	sleep 10
done

echo "MariaDB is ready. Checking if WordPress is installed..."

# Read the WordPress admin password from the secret file
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/db_password)

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html/wordpress --allow-root; then
	echo "WordPress is not installed. Installing WordPress..."

	# Install WordPress
	wp core install \
		--path=/var/www/html/wordpress \
		--url=https://${DOMAIN_NAME} \
		--title="42 Heilbronn - Inception" \
		--admin_user=${WORDPRESS_ADMIN} \
		--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL} \
		--skip-email \
		--allow-root
else
	echo "WordPress is already installed."
fi

echo "Starting php-fpm..."
exec php-fpm7.4 -F
