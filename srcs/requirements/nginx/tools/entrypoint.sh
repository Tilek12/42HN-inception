#!/bin/bash

# Create SSL directory if it doesn't exist
mkdir -p /etc/nginx/ssl

# Generate SSL certificates if they don't exist
if [ ! -f /etc/nginx/ssl/certificate.crt ] || [ ! -f /etc/nginx/ssl/private.key ]; then
	echo "Generating SSL certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/private.key \
		-out /etc/nginx/ssl/certificate.crt \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
else
	echo "SSL certificates already exist. Skipping generation."
fi

# Replace ${DOMAIN_NAME} in the NGINX configuration template
echo "Configuring NGINX..."
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start NGINX in the foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"
