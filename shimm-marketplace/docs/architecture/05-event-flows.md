# Event flows

Webhook: приём → secret → `update_id` idempotency → очередь → 200 OK. Финансы: journal + lines, без прямого UPDATE баланса.
