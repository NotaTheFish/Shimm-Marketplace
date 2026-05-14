# Ledger rules

Баланс пользователя не изменять напрямую. Только `LedgerJournal` + `LedgerLine` (double-entry), с уникальным `idempotency_key` и блокировками кошелька в транзакции.
