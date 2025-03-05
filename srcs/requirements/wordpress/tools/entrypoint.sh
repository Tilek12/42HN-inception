#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysql -h${WORDPRESS_DB_HOST} -u${WORDPRESS_DB_USER} -p$(cat /run/secrets/db_password) -D${WORDPRESS_DB_NAME} -e "SELECT 1"; do
	echo "MariaDB is not ready yet. Retrying in 10 seconds..."
	sleep 10
done

echo "MariaDB is ready. Checking if WordPress is installed..."

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html/wordpress; then
	echo "WordPress is not installed. Installing WordPress..."

	# Install WordPress
	wp core install \
		--path=/var/www/html/wordpress \
		--url=https://${DOMAIN_NAME} \
		--title="My WordPress Site" \
		--main_user=${WORDPRESS_MAIN_USER} \
		--main_password=${WORDPRESS_MAIN_PASSWORD} \
		--main_email=${WORDPRESS_MAIN_EMAIL} \
		--skip-email
else
    echo "WordPress is already installed."
fi

echo "Starting php-fpm..."
exec php-fpm7.4 -F
