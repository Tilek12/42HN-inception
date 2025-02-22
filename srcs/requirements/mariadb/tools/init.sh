#!/bin/sh

# Initialize the database
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start MariaDB temporarily to run SQL commands
mysql_safe --user=mysql --datadir=/var/lib/mysql &
sleep 5

# Create the database and user
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $MYSQL_DATABASE;"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER '$MYSQL_USER''@''%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVELEGES;"

# Stop the temporary MariaDB instance
mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown
