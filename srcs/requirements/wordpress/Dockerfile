# Use Debian Bullseye as the base image
FROM debian:bullseye-slim

# Install PHP, php-fpm, and WordPress dependencies
RUN apt-get update && \
	apt-get install -y \
	php7.4-fpm \
	php7.4-mysql \
	curl \
	unzip \
	default-mysql-client \
	&& rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Create the /var/www/html directory
RUN mkdir -p /var/www/html

# Create the /run/php directory for PHP-FPM
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Download and extract WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
	tar -xzf /tmp/wordpress.tar.gz -C /var/www/html && \
	rm /tmp/wordpress.tar.gz

# Copy the WordPress configuration file
COPY conf/wp-config.php /var/www/html/wordpress/wp-config.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html/wordpress

# Expose port 9000 (php-fpm)
EXPOSE 9000

# Copy the custom entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start php-fpm in the foreground
CMD ["php-fpm7.4", "-F"]
