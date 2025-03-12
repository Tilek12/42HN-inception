# Use the penultimate stable version of Debian
FROM debian:bullseye-slim

# Install NGINX, OpenSSL and envsubst
RUN apt-get update && \
	apt-get install -y nginx openssl gettext-base && \
	rm -rf /var/lib/apt/lists/*

# Copy the custom NGINX configuration
COPY conf/custom-site /etc/nginx/sites-available/custom-site.template

# Copy the entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh

# Make the scripts executable
RUN chmod +x /entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
