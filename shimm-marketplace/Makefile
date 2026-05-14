.PHONY: install dev db-up db-down migrate
install:
	pnpm install

dev:
	pnpm dev

db-up:
	docker compose -f docker-compose.yml up -d postgres redis

db-down:
	docker compose -f docker-compose.yml down

migrate:
	pnpm db:migrate
