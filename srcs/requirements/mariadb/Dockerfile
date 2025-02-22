# Use Alpine as the base image
FROM alpine:3.16

# Install MariaDB and dependencies
RUN apk update && \
	apk add --nocache \
	mariadb \
	mariadb-client \
	tzdata \
	&& rm -f /var/cache/apk/*

# Create directories for MariaDB
RUN mkdir -p /run/mysqld /var/lib/mysql

# Set permissions for MariaDB directories
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy the custom configuration file
COPY my.cnf /etc/my.cnf

# Set environment variables for MariaDB
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Expose the default MariaDB port
EXPOSE 3306

# Copy the initialization script
COPY init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

# Start MariaDB
CMD ["mysqld", "--user=mysql"]
