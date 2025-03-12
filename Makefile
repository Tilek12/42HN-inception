# Color codes
RED		= \033[0;31m
GREEN	= \033[0;32m
YELLOW	= \033[0;33m
BLUE	= \033[0;34m
VIOLET	= \033[0;35m
RESET	= \033[0m

# Variables
COMPOSE = docker-compose
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/tkubanyc/data

# Default target: build and run containers
all: build up

# Build Docker images
build:
	@echo "$(BLUE)Building Docker images...$(RESET)"
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
	$(COMPOSE) -f $(COMPOSE_FILE) build

# Start containers
up:
	@echo "$(BLUE)Running containers...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) up -d

# Stop and remove containers
down:
	@echo "$(RED)Removing containers...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) down

# Start stopped containers (without rebuilding)
start:
	@echo "$(GREEN)Starting containers...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) start

# Stop running containers (without removing them)
stop:
	@echo "$(VIOLET)Stopping containers...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) stop

# Clean everything (containers, volumes, network)
clean: down
	@echo "$(RED)Removing volumes...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) down -v --rmi all
	@echo "$(RED)Removing local data directories...$(RESET)"
	sudo rm -rf $(DATA_DIR)/mariadb
	sudo rm -rf $(DATA_DIR)/wordpress

# Full clean: remove everything (containers, images, volumes, networks)
fclean: clean
	@echo "$(RED)Removing all Docker images...$(RESET)"
	docker system prune -a -f
	@echo "$(RED)Removing all unused Docker networks...$(RESET)"
	docker network prune -f

# Rebuild and restart containers
re: clean build up

# Show container logs
logs:
	@echo "$(YELLOW)Showing logs...$(RESET)"
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

.PHONY: all build up down start stop clean fclean re logs
