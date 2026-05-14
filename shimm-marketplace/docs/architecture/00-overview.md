# Обзор системы

Три контура Telegram: клиентский бот, admin-бот, deal-room (sub-bot). Backend API для Mini App, PostgreSQL, Redis, BullMQ workers, cron scheduler. Критичные действия: серверная RBAC, audit, idempotency, callback TTL+nonce, деньги только через double-entry ledger.
