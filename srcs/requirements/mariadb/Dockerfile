# Use Debian Slim as the base image
FROM debian:bullseye-slim

# Install MariaDB and dependencies
RUN apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

# Create directories for MariaDB
RUN mkdir -p /run/mysqld /var/lib/mysql

# Set permissions for MariaDB directories
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy the custom configuration file
COPY conf/my.cnf /etc/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Copy the initialization script
COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

# Start MariaDB
CMD ["mysqld", "--user=mysql"]
