# Security model

Сервер не доверяет клиенту: initData, callback_data, роли — только после проверки в БД. OWNER_TELEGRAM_IDS в env. Админ-действия журналируются. Критичные операции с `idempotency_key`.
