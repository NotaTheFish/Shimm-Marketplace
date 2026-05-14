# Shimm Marketplace (shimm-marketplace)

Монорепозиторий Telegram marketplace (клиентский бот, admin-бот, deal-room бот, Mini App, API, workers, scheduler) по структуре `skillet.txt` и ТЗ `ShimmBot_ТЗ_ПОЛНОЕ.txt`.

## Важно (архитектура)

Этот проект **запрещено** писать как один огромный файл Telegram-бота. Любой модуль должен быть изолирован. Любое критическое действие должно проходить через service layer, RBAC, audit log, rate limit и idempotency.

## Быстрый старт

1. Скопируйте `.env.example` в `.env` и заполните переменные (минимум `DATABASE_URL`; токены ботов — для локального polling).
2. `pnpm install`
3. `docker compose up -d` (PostgreSQL + Redis)
4. `pnpm db:migrate` или `pnpm db:push`
5. `pnpm build` — сборка всех пакетов через Turborepo

## Сервисы

| Сервис | Описание |
|--------|----------|
| `apps/api` | HTTP API, webhooks `/webhook/client`, `/webhook/admin`, `/webhook/deal` (Блок 31) |
| `apps/client-bot` | Клиентский бот (grammy) |
| `apps/admin-bot` | Админ-бот, `OWNER_TELEGRAM_IDS` |
| `apps/deal-room-bot` | Sub-bot чатов сделок |
| `apps/mini-app` | React + Vite Mini App |
| `services/workers` | Очереди BullMQ (заготовка) |
| `services/scheduler` | Cron по расписанию ТЗ |
| `services/webhook-gateway` | Опциональный edge health |

## Документация

Каркас разделов в `docs/` (architecture, product, database, security, legal, runbooks). Полное ТЗ — исходный файл `ShimmBot_ТЗ_ПОЛНОЕ.txt` (корень `Market/` или копия в `docs/product/final-tz.md`).

## Ориентиры для Cursor

- `docs/product/final-tz.md` — указатель на ТЗ и этапы
- `docs/architecture/00-overview.md`
- `docs/architecture/03-state-machines.md`
- `docs/security/rbac.md` (RBAC)
- `docs/database/ledger-rules.md`

## Ветки Git

`main` (production), `develop` (staging), `feature/*`, `bugfix/*`, `hotfix/*`, `release/*` — см. `skillet.txt`.

## Лицензия

MIT — см. `LICENSE`.
