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
COPY conf/50-server.cnf etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the initialization script
COPY tools/init.sh /init.sh

# Copy the custom entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /init.sh /entrypoint.sh

# Expose the default MariaDB port
EXPOSE 3306

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start MariaDB
CMD ["mysqld", "--user=mysql"]
