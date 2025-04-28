help: ## display this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## | @e "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s \033[37m%-18s\033[0m\n", $$1, $$2, ($$3 == "" ? "" : "("$$3")")}' $(MAKEFILE_LIST)

setup: ## setup project
	docker compose up -d
	docker compose exec main sh -c "composer install"
	make configuration
	docker compose exec main sh -c "php artisan key:generate"
	sleep 5 && make migrate

migrate: ## migrate & seed
	docker compose exec main sh -c "php artisan migrate:fresh"
	docker compose exec main sh -c "php artisan db:seed"

configuration: ## create .env
	docker compose exec main sh -c "cp .env.example .env"

up: ## docker compose up
	docker compose up -d

stop: ## docker compose stop
	docker compose stop

down: ## docker compose down
	docker compose down

ps: ## docker compose ps
	docker compose ps