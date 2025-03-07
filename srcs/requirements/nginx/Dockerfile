# Use the penultimate stable version of Debian
FROM debian:bullseye-slim

# Install NGINX and dependencies
RUN apt-get update && \
	apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

# Copy the custom NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates (generated using OpenSSL)
COPY tools/generate_ssl.sh /generate_ssl.sh
RUN chmod +x /generate_ssl.sh && /generate_ssl.sh

# Expose port 443 (HTTPS)
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
