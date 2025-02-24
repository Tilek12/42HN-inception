# Use Debian as the base image
FROM debian:bullseye-slim

# Install PHP, php-fpm, and WordPress dependencies
RUN apt-get update && \
	apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

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

# Start php-fpm
CMD ["php-fpm7.4", "-F"]
