# Use the penultimate stable version of Debian
FROM debian:bullseye-slim

# Install NGINX, OpenSSL, and envsubst
RUN apt-get update && \
	apt-get install -y nginx openssl gettext-base && \
	rm -rf /var/lib/apt/lists/*

# Create the SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy the custom NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf.template

# Copy the entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose port 443 (HTTPS)
EXPOSE 443

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
