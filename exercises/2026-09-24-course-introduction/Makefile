ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
COMPOSE := docker compose -f $(ROOT)src/docker-compose.yaml

ATTEMPTS ?= 10
INTERVAL ?= 3
SCENARIO ?= random

.DEFAULT_GOAL := help

.PHONY: help build up down restart logs status ssh-test shell chaos-next chaos-scenario chaos-log clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

build: ## Build the container image
	$(COMPOSE) build

up: build ## Build and start the container in the background
	$(COMPOSE) up -d

down: ## Stop and remove the container
	$(COMPOSE) down

restart: down up ## Restart the container

logs: ## Follow the container logs
	$(COMPOSE) logs -f

status: ## Show container status
	$(COMPOSE) ps

ssh-test: up ## Test SSH connection/disconnection with the dummy key
	ATTEMPTS=$(ATTEMPTS) INTERVAL=$(INTERVAL) $(ROOT)scripts/ssh_test.sh

shell: ## Open a shell inside the running container
	$(COMPOSE) exec server bash

chaos-next: ## Advance chaos to the next scenario (after manual repair)
	@CID=$$($(COMPOSE) ps -q server); \
	if [ -z "$$CID" ]; then echo "conteneur 'server' non démarré (make up)"; exit 1; fi; \
	docker exec "$$CID" touch /run/chaos/next; \
	echo "signal envoyé — chaos.sh restaure et tire le scénario suivant"

chaos-scenario: ## Recreate with a forced scenario: make chaos-scenario SCENARIO=change_port
	CHAOS_SCENARIO=$(SCENARIO) $(COMPOSE) up -d --force-recreate

chaos-log: ## Follow the chaos server logs
	$(COMPOSE) logs -f server

clean: down ## Stop, remove container and delete the built image
	-docker rmi src-server:latest
