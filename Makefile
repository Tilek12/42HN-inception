# Variables
COMPOSE = docker-compose
COMPOSE_FILE = docker-compose.yml

# Default target: build and run containers
all: up

# Start containers
up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

# Stop and remove containers
down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

# Clean everything (containers, volumes, network)
clean: down
	$(COMPOSE) -f $(COMPOSE_FILE) down -v --rmi all

# Rebuild everything from scratch
re: clean up

# Show logs from containers
logs:
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

# Stop running containers
stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

# Start stopped containers
start:
	$(COMPOSE) -f $(COMPOSE_FILE) start
