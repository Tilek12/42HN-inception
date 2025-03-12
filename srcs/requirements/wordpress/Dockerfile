# Use Debian Bullseye as the base image
FROM debian:bullseye-slim

# Install PHP, php-fpm and WordPress dependencies
RUN apt-get update && \
	apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	default-mysql-client \
	netcat \
	&& rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Copy the custom entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /var/www/html

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
