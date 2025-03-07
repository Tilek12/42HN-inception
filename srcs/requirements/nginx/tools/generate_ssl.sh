#!/bin/bash

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/private.key \
	-out /etc/nginx/ssl/certificate.crt \
	-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=<your-login>.42.fr"
