# Use Debian Slim as the base image
FROM debian:bullseye-slim

# Install MariaDB and dependencies
RUN apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

# Copy the custom configuration file
COPY conf/50-server.cnf etc/mysql/mariadb.conf.d/50-server.cnf

# Copy scripts for entrypoint and initialization
COPY tools/entrypoint.sh /entrypoint.sh
COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh

# Make scripts executable
RUN chmod +x /entrypoint.sh /docker-entrypoint-initdb.d/init.sh

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
