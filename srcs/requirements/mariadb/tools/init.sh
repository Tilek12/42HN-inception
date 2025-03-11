#!/bin/bash

# Check if the data directory is empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
	echo "Data directory is empty. Initializing MariaDB database..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
	echo "Data directory is not empty. Skipping initialization."
fi

# Start MariaDB temporarily to run SQL commands
echo "Starting MariaDB temporarily..."
mysqld_safe --user=mysql --datadir=/var/lib/mysql &
sleep 5

# Create the WordPress database
echo "Creating database $MYSQL_DATABASE..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" \
	  -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# Create the WordPress user and grant privileges
echo "Creating user $MYSQL_USER..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" \
	  -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';" #\
	#   || exit 1
mysql -uroot -p"$(cat /run/secrets/db_root_password)" \
	  -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" #\
	#   || exit 1

# Change the root password
echo "Changing root password..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" \
	  -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';" #\
	#   || exit 1

# Flush privileges
echo "Flushing privileges..."
mysql -uroot -p"$(cat /run/secrets/db_root_password)" \
	  -e "FLUSH PRIVILEGES;" #\
	#   || exit 1

# Stop the temporary MariaDB instance
echo "Stopping temporary MariaDB instance..."
mysqladmin -uroot -p"$(cat /run/secrets/db_root_password)" shutdown #\
			# || exit 1

echo "Initialization complete."
