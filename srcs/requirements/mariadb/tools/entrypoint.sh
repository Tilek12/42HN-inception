#!/bin/bash

# Check if the database has already been initialized
if [ ! -f /var/lib/mysql/initialized ]; then
	echo "Database not initialized. Running initialization script..."
	/init.sh
	touch /var/lib/mysql/initialized
else
	echo "Database already initialized. Skipping initialization."
fi

# Start MariaDB in the foreground
echo "Starting MariaDB..."
exec mysqld --user=mysql --console
