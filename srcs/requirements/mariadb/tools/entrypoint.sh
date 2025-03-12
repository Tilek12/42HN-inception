#!/bin/bash

# Exit immediately on error
set -e

# Create necessary directories and set proper permissions
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Check if the database has already been initialized
if [ ! -f "/var/lib/mysql/initialized" ]; then
	echo "Database not initialized. Running initialization script..."
	/docker-entrypoint-initdb.d/init.sh
	touch /var/lib/mysql/initialized
else
	echo "Database already initialized. Skipping initialization."
fi

# Start MariaDB in the foreground
echo "Starting MariaDB..."
exec mysqld --user=mysql
